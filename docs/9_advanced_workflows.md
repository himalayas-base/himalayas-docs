# Zoom and Non-Biological Workflows

This page collects two advanced patterns used in the example notebooks.

## Cluster Zoom Analysis

A common pattern is to zoom into one cluster, re-run clustering and enrichment, and then plot a higher-resolution view. The same pattern also supports a union of multiple clusters.

1. Subset the results to one cluster (`results.subset(...)`) or multiple clusters (`results.subset_clusters(...)`).
2. Rebind annotations to the subset matrix.
3. Cut the subset dendrogram at a different threshold.
4. Re-run enrichment with the original matrix as the background (see [Nested Zooms](#nested-zooms)).

Repeat the analysis at different dendrogram cut thresholds to explore threshold-dependent enrichment.

Subset reruns are often smaller than the full matrix. Keep the default annotation term-size floor (`min_term_size=2`) unless you have a specific exploratory reason to change it.

For API details on `subset(...)` and `subset_clusters(...)`, see [Results and Filtering](6_results.md).

```python
def run_zoom_analysis(
    *,
    results,
    cluster_id,
    annotations,
    linkage_threshold,
    background,
    min_cluster_size=6,
    min_overlap=2,
    fdr_scope="global",
    qval_cutoff=0.05,
):
    """Recluster a single cluster, re-run enrichment, and return zoomed results."""
    zoom_view = results.subset(cluster=cluster_id)
    zoom_matrix = zoom_view.matrix
    zoom_annotations = annotations.rebind(zoom_matrix)
    zoom_analysis = (
        Analysis(zoom_matrix, zoom_annotations)
        .cluster(
            linkage_method="ward",
            linkage_metric="euclidean",
            linkage_threshold=linkage_threshold,
            min_cluster_size=min_cluster_size,
        )
        .enrich(min_overlap=min_overlap, background=background)
        .finalize(col_cluster=True, fdr_scope=fdr_scope)
    )
    zoom_results = zoom_analysis.results
    zoom_results_sig = zoom_results.filter(f"qval <= {qval_cutoff}")
    return zoom_matrix, zoom_results, zoom_results_sig
```

**Why pass a `background`?** It keeps the enrichment universe fixed so zoomed p-values remain comparable to the full analysis.
By default, subset reruns use the subset matrix as the local enrichment universe; pass the original matrix explicitly via `background` to anchor enrichment to the full universe.
q-values may still differ between master and subset reruns because FDR correction depends on the tested hypothesis family.

### Single-Cluster Example

Choose a cluster and a tighter cut, then run the zoom:

```python
example_cluster = int(results.clusters.unique_clusters[0])
zoom_threshold = 6
FDR_SCOPE = "global"

zoom_matrix, zoom_results, zoom_results_sig = run_zoom_analysis(
    results=results,
    cluster_id=example_cluster,
    annotations=annotations,
    linkage_threshold=zoom_threshold,
    background=matrix,
    fdr_scope=FDR_SCOPE,
)
```

Then plot the zoomed matrix with the same `Plotter` pipeline:

```python
plotter = (
    Plotter(zoom_results)
    .plot_dendrogram()
    .plot_matrix(cmap="RdBu_r", center=0)
    .plot_cluster_labels(rank_by="q", label_mode="top_term", label_fields=("label", "q", "fe"))
)

plotter.show()
```

### Multi-Cluster Example (Union View)

Use the same zoom pipeline, but subset a union of parent clusters:

```python
cluster_ids = [2, 7, 9]
zoom_threshold = 6
FDR_SCOPE = "global"

zoom_view = results.subset_clusters(clusters=cluster_ids)
zoom_matrix = zoom_view.matrix
zoom_annotations = annotations.rebind(zoom_matrix)
zoom_analysis = (
    Analysis(zoom_matrix, zoom_annotations)
    .cluster(
        linkage_method="ward",
        linkage_metric="euclidean",
        linkage_threshold=zoom_threshold,
        min_cluster_size=6,
    )
    .enrich(min_overlap=2, background=matrix)
    .finalize(col_cluster=True, fdr_scope=FDR_SCOPE)
)

zoom_results = zoom_analysis.results
zoom_results_sig = zoom_results.filter("qval <= 0.05")
```

Then plot with the same `Plotter` pipeline used above.

### Nested Zooms

To zoom into a cluster of a zoomed result, keep passing the original matrix as `background`, not the matrix of the zoom you are leaving. A zoom's `results.matrix` holds only that zoom's labels, so using it as the background shrinks the universe at every level and p-values stop being comparable with the full analysis.

The example below uses the yeast matrix with `linkage_method="ward"`, `linkage_metric="euclidean"`, `linkage_threshold=16`, `min_cluster_size=30`, and the default `optimal_ordering=False`, where cluster 3 has 52 genes. Cluster ids depend on `optimal_ordering`, so check `results.clusters.cluster_sizes` for your own run.

```python
# First zoom, from the full analysis: cluster 3 (52 genes).
zoom_matrix, zoom_results, _ = run_zoom_analysis(
    results=results,
    cluster_id=3,
    annotations=annotations,
    linkage_threshold=5,
    background=matrix,
)

# Second zoom, from the first zoom. Keep the original matrix as the background.
inner_cluster = int(zoom_results.clusters.unique_clusters[0])
inner_matrix, inner_results, inner_results_sig = run_zoom_analysis(
    results=zoom_results,
    cluster_id=inner_cluster,
    annotations=annotations,
    linkage_threshold=2.5,
    background=matrix,  # not zoom_results.matrix
)
```

In the yeast example, the second zoom keeps a 21-gene cluster. Tested against the 52 genes of the first zoom (`N = 52`), its strongest p-value is near `8e-3`. Tested against the full matrix (`N = 1053`), it is near `5e-16`.

## Cluster the Columns Instead

Enrichment is always tested on the rows. To test the columns, build a matrix from the transpose and use annotations that name the columns:

```python
matrix_t = Matrix(matrix.df.T)
annotations_t = Annotations(term_to_columns, matrix_t)

analysis_t = (
    Analysis(matrix_t, annotations_t)
    .cluster(linkage_method="ward", linkage_metric="euclidean", linkage_threshold=16)
    .enrich(min_overlap=2)
    .finalize()
)
```

This matters most for a square matrix, such as a correlation or interaction matrix, where rows and columns are both items your annotations name. Column labels must be unique, because they become the row labels of the new matrix. To keep only one block, zoom into clusters of one side, transpose, and zoom into clusters of the other.

## Non-Biological Example

HiMaLAYAS supports biological and non-biological domains. In Supplementary Figure S4, the non-biological example uses the 2014 World Input-Output Database (WIOD) country-sector input-output matrix and annotates dendrogram-defined clusters with native country metadata.

Key steps:

- Preprocess the WIOD source table into a log1p-scaled intermediate-flow matrix suitable for hierarchical clustering.
- Keep country-sector row labels that can be mapped back to WIOD country metadata.
- Build a country-to-country-sector mapping from the metadata.
- Run enrichment testing and render significant annotations alongside clusters.

```python
country_to_sectors = (
    country_sector_metadata
    .groupby("country_name")["country_sector_id"]
    .apply(list)
    .to_dict()
)

matrix = Matrix(wiod_log1p_intermediate_flow_matrix)
annotations = Annotations(country_to_sectors, matrix)

analysis = (
    Analysis(matrix, annotations)
    .cluster(
        linkage_method="ward",
        linkage_metric="euclidean",
        linkage_threshold="auto",
        min_cluster_size=20,
    )
    .enrich(min_overlap=2)
    .finalize(col_cluster=True, fdr_scope="global")
)

results = analysis.results
results_sig = results.filter("qval <= 0.05")
cluster_labels = results_sig.cluster_labels(rank_by="q", label_mode="top_term")
```

For the complete reproducible publication workflow, see `supp_fig_4.ipynb` in the `himalayas-publication` repository.
