# Results and Filtering

`Results` holds the enrichment table and attached context (matrix, clusters, layout). It is passed to `Plotter` for visualization.

## Common Attributes

| Attribute | Type | Description |
| --- | --- | --- |
| `results.df` | `pd.DataFrame` | Enrichment table (`cluster`, `term`, `k`, `K`, `n`, `N`, `pval`, and optional `qval`). |
| `results.method` | `str` | Method identifier for the result object (for example, `"hypergeom"` after enrichment or `"subset"` after `results.subset(...)`). |
| `results.params` | `dict[str, Any]` | Analysis metadata attached to results (for example, `linkage_threshold` when available). |
| `results.matrix` | `Matrix \| None` | Matrix attached to the result object, useful for zoom workflows and background reuse. |
| `results.clusters` | `Clusters \| None` | Cluster assignments and dendrogram metadata attached to the result object. |
| `results.clusters.unique_clusters` | `np.ndarray` | Sorted cluster ids present in the result context (when clusters are attached). |
| `results.clusters.cluster_sizes` | `dict[int, int]` | Mapping from cluster id to cluster size (when clusters are attached). |
| `results.clusters.cluster_to_labels` | `dict[int, set[Any]]` | Mapping from cluster id to member labels (when clusters are attached). |
| `results.clusters.label_to_cluster` | `dict[Any, int]` | Mapping from label to cluster id (when clusters are attached). |

## Common Methods

```python
Results.filter(expr: str, **kwargs: Any) -> Results
Results.subset(cluster: int) -> Results
Results.cluster_labels(
    term_col: str = "term",
    cluster_col: str = "cluster",
    weight_col: str = "pval",
    *,
    label_mode: str = "top_term",
    label_col: str | None = "term_name",
    max_words: int = 6,
) -> pd.DataFrame
```

## `filter`

```python
Results.filter(expr: str, **kwargs: Any) -> Results
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `expr` | `str` | required | `pandas.DataFrame.query` expression applied to `results.df`. |
| `**kwargs` | `Any` | `{}` | Additional keyword arguments forwarded to `DataFrame.query`. |

## `subset`

```python
Results.subset(cluster: int) -> Results
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cluster` | `int` | required | Cluster id to subset. Returns a new `Results` view with a subset matrix attached. |

## `cluster_labels`

```python
Results.cluster_labels(
    term_col: str = "term",
    cluster_col: str = "cluster",
    weight_col: str = "pval",
    *,
    label_mode: str = "top_term",
    label_col: str | None = "term_name",
    max_words: int = 6,
) -> pd.DataFrame
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `term_col` | `str` | `"term"` | Stable term identifier column. |
| `cluster_col` | `str` | `"cluster"` | Cluster id column. |
| `weight_col` | `str` | `"pval"` | Weight/p-value column used for ranking/summarization. |
| `label_mode` | `str` | `"top_term"` | One of `"top_term"` or `"compressed"`. |
| `label_col` | `str | None` | `"term_name"` | Optional display-name column; falls back to `term_col` when unavailable. |
| `max_words` | `int` | `6` | Maximum words for compressed labels. |

Returns one row per cluster with columns `["cluster", "label", "pval", "n", "term"]`.

`Results.cluster_labels(...)` is an optional post-hoc helper for inspecting, exporting, or reusing one-label-per-cluster summaries. You do not need to pass its output into `Plotter.plot_cluster_labels(...)` or `plot_dendrogram_condensed(...)`; both generate labels internally from the attached `Results`.

## Examples

Filter to significant annotation terms:

```python
results_sig = results.filter("qval <= 0.05")
```

Subset to a single cluster (for zoom analysis):

```python
zoom_view = results.subset(cluster=7)
zoom_matrix = zoom_view.matrix
```

Build optional cluster labels for inspection/export:

```python
cluster_labels = results.cluster_labels(label_mode="top_term")
```

Inspect cluster membership and sizes:

```python
display(results.clusters.cluster_sizes)
example_cluster = int(sorted(results.clusters.cluster_sizes)[0])
display(sorted(results.clusters.cluster_to_labels[example_cluster])[:10])
example_label = sorted(results.matrix.labels)[0]
display(results.clusters.label_to_cluster[example_label])
```

## Key Columns in `results.df`

- `cluster`: Cluster id.
- `term`: Term id.
- `k`: Overlap between cluster and term.
- `K`: Term size in background.
- `n`: Cluster size.
- `N`: Background size.
- `pval`: Hypergeometric p-value.
- `qval`: Adjusted p-value used for significance filtering (if present).
