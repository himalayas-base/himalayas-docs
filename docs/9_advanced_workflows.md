# Zoom and Non-Biological Workflows

This page collects two advanced patterns used in the example notebooks.

## Cluster-Specific Zoom Analysis

A common pattern is to zoom into a single cluster, re-run clustering and enrichment, and then plot a higher-resolution view. The key steps are:

1. Subset the results to a single cluster.
2. Rebuild annotations for the subset.
3. Cut the subset dendrogram at a lower depth.
4. Re-run enrichment with a background (parent) matrix.

Repeat the analysis at different dendrogram depths to explore depth-dependent enrichment.

```python
def run_zoom_analysis(
    *,
    results,
    cluster_id,
    go_bp,
    linkage_threshold,
    min_cluster_size=6,
    min_overlap=2,
    qval_cutoff=0.05,
):
    """Recluster a single cluster, re-run enrichment, and return zoomed results."""
    zoom_view = results.subset(cluster=cluster_id)
    zoom_matrix = zoom_view.matrix
    zoom_annotations = Annotations(go_bp, zoom_matrix)
    zoom_analysis = (
        Analysis(zoom_matrix, zoom_annotations)
        .cluster(
            linkage_method="ward",
            linkage_metric="euclidean",
            linkage_threshold=linkage_threshold,
            min_cluster_size=min_cluster_size,
        )
        .enrich(min_overlap=min_overlap, background=results.matrix)
        .finalize(col_cluster=True)
    )
    zoom_results = zoom_analysis.results
    zoom_results_sig = zoom_results.filter(f"qval <= {qval_cutoff}")
    return zoom_matrix, zoom_results, zoom_results_sig
```

**Why `background=results.matrix`?** It keeps the enrichment universe fixed so zoomed p-values remain comparable to the full analysis.
By default, subset reruns use the subset matrix as the local enrichment universe; pass the parent matrix explicitly via `background` to anchor enrichment to the parent universe.
q-values may still differ between master and subset reruns because FDR correction depends on the tested hypothesis family.

### Example

Choose a cluster and a tighter cut, then run the zoom:

```python
example_cluster = int(results.clusters.unique_clusters[0])
zoom_threshold = 6

zoom_matrix, zoom_results, zoom_results_sig = run_zoom_analysis(
    results=results,
    cluster_id=example_cluster,
    go_bp=go_bp,
    linkage_threshold=zoom_threshold,
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

For a cluster-level summary of the zoomed result, see [Condensed Dendrogram](8_condensed_dendrogram.md).

## Non-Biological Example (Recipes)

HiMaLAYAS supports biological and non-biological domains. The recipe example builds an ingredient-by-recipe matrix and annotates clusters by country of origin using a worldwide recipe dataset.

Key steps:

- Clean and merge near-duplicate ingredient tokens.
- Build a sparse binary matrix.
- Filter low-frequency ingredients and very small recipes.
- Map countries to recipe IDs and run enrichment.

```python
country_to_recipes = {
    "India": ["r_001", "r_003"],
    "Nigeria": ["r_002"],
    "Mexico": ["r_004", "r_005"],
}

matrix = Matrix(ingredient_matrix)
annotations = Annotations(country_to_recipes, matrix)

analysis = (
    Analysis(matrix, annotations)
    .cluster(
        linkage_method="ward",
        linkage_metric="euclidean",
        linkage_threshold=7.5,
        min_cluster_size=15,
    )
    .enrich(min_overlap=2)
    .finalize(col_cluster=True)
)

results = analysis.results
results_sig = results.filter("qval <= 0.05")
cluster_labels = results_sig.cluster_labels(rank_by="q", label_mode="top_term")
```
