# Zoom and Non-Biological Workflows

This page collects two advanced patterns used in the example notebooks.

## Cluster Specific Zoom Analysis

A common pattern is to zoom into a single cluster, re-run clustering and enrichment, and then plot a higher resolution view. The key steps are:

1. Subset the results to a single cluster.
2. Rebuild annotations for the subset.
3. Re-run `Analysis` with a background matrix.

```python
def run_zoom_analysis(
    *,
    results,
    cluster_id,
    go_bp,
    go_id_to_name,
    linkage_threshold,
    min_cluster_size=6,
    min_overlap=2,
    qval_cutoff=0.05,
):
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
        .finalize(col_cluster=True, add_qvalues=True)
    )

    zoom_results = zoom_analysis.results
    zoom_results.df["term_name"] = (
        zoom_results.df["term"].map(go_id_to_name).fillna(zoom_results.df["term"])
    )

    zoom_results_sig = zoom_results.filter(f"qval <= {qval_cutoff}")
    zoom_cluster_labels = summarize_clusters(
        zoom_results_sig.df,
        label_mode="top_term",
        label_col="term_name",
    )
    return zoom_matrix, zoom_results, zoom_results_sig, zoom_cluster_labels
```

## Non-Biological Example (Recipes)

HiMaLAYAS is domain agnostic. The recipe example builds an ingredient by recipe matrix and annotates clusters by country of origin (world-wide recipe dataset).

Key steps:

- Clean and canonicalize ingredient tokens.
- Build a sparse binary matrix.
- Filter low frequency ingredients and very small recipes.
- Map countries to recipe IDs and run enrichment.

```python
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
    .finalize(col_cluster=True, add_qvalues=True)
)

results = analysis.results
results_sig = results.filter("qval <= 0.05")
cluster_labels = summarize_clusters(results_sig.df, label_mode="top_term")
```

## Contracted Dendrogram View

For a cluster level overview, use `plot_term_hierarchy_contracted` to render a condensed dendrogram from the master linkage.

```python
from himalayas.plot import plot_term_hierarchy_contracted

plot_term_hierarchy_contracted(
    results,
    cluster_labels,
    fontsize=9,
    sigbar_min_logp=2.0,
    sigbar_max_logp=10.0,
)
```

Next: [API Reference](11_api_reference.md)
