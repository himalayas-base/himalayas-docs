# Results and Filtering

`Results` holds the enrichment table and attached context (matrix, clusters, layout). It is passed to `Plotter` for visualization.

## Common Attributes

| Attribute | Type | Description |
| --- | --- | --- |
| `results.df` | `pd.DataFrame` | Enrichment table (`cluster`, `term`, `k`, `K`, `n`, `N`, `pval`), plus `fe` and `qval` after `Analysis.finalize(...)`. |
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
Results.subset_clusters(clusters: Iterable[int]) -> Results
Results.cluster_labels(
    *,
    rank_by: str = "p",
    label_mode: str = "top_term",
    max_words: int = 6,
) -> pd.DataFrame
```

| Method | Description |
| --- | --- |
| `results.filter(...)` | Returns a new `Results` filtered by a query expression on `results.df`. |
| `results.subset(...)` | Returns a single-cluster view for zoom workflows (with subset matrix attached). |
| `results.subset_clusters(...)` | Returns a multi-cluster view for zoom workflows by taking the union of selected cluster labels. |
| `results.cluster_labels(...)` | Builds one label per cluster for inspection or export. |

## `filter`

```python
Results.filter(expr: str, **kwargs: Any) -> Results
```

Returns a new `Results` filtered by a query expression on `results.df`.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `expr` | `str` | required | `pandas.DataFrame.query` expression applied to `results.df`. |
| `**kwargs` | `Any` | `{}` | Additional keyword arguments forwarded to `DataFrame.query`. |

## `subset`

```python
Results.subset(cluster: int) -> Results
```

Returns a single-cluster view for zoom workflows (with subset matrix attached).

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cluster` | `int` | required | Cluster id to subset. Returns a new `Results` view with a subset matrix attached. |

## `subset_clusters`

```python
Results.subset_clusters(clusters: Iterable[int]) -> Results
```

Returns a multi-cluster view for zoom workflows by taking the union of selected cluster labels.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `clusters` | `Iterable[int]` | required | Cluster ids to subset. Returns one combined `Results` view with a subset matrix attached. |

## `cluster_labels`

```python
Results.cluster_labels(
    *,
    rank_by: str = "p",
    label_mode: str = "top_term",
    max_words: int = 6,
) -> pd.DataFrame
```

Builds one label per cluster for inspection or export.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `rank_by` | `str` | `"p"` | Ranking statistic for representative terms. Must be `"p"` or `"q"` (`ValueError` otherwise). |
| `label_mode` | `str` | `"top_term"` | One of `"top_term"` or `"compressed"`. |
| `max_words` | `int` | `6` | Maximum words for compressed labels. |

Behavior details:

- Uses canonical input columns `term` and `cluster`; `term_name` is used as an optional display fallback.
- Returns one row per cluster with columns `["cluster", "label", "pval", "qval", "score", "n", "term", "fe"]`.
- `score` is the statistic selected by `rank_by` (`pval` for `"p"`, `qval` for `"q"`).
- Both `label_mode="top_term"` and `label_mode="compressed"` require the selected score column (`pval` for `rank_by="p"`, `qval` for `rank_by="q"`).
- Representative-term selection is deterministic: selected score (`pval` or `qval`), then `pval` (if present), then lexical `term`.
- In `label_mode="compressed"`, HiMaLAYAS uses NLTK normalization when available and falls back to regex tokenization otherwise.

`Results.cluster_labels(...)` is an optional post hoc utility for inspection, export, or external workflows. You do not need to pass its output into `Plotter.plot_cluster_labels(...)` or `plot_dendrogram_condensed(...)`; both generate labels internally from the attached `Results`.

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

Subset to multiple clusters (union view):

```python
zoom_view_multi = results.subset_clusters(clusters=[2, 7, 9])
zoom_matrix_multi = zoom_view_multi.matrix
```

Build optional cluster labels for inspection or export:

```python
cluster_labels = results.cluster_labels(rank_by="q", label_mode="top_term")
compressed_labels = results.cluster_labels(rank_by="p", label_mode="compressed", max_words=5)

display(cluster_labels[["cluster", "label", "pval", "qval", "score", "n", "term", "fe"]].head())
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
- `fe`: Fold enrichment effect size, computed as `(k / n) / (K / N)`.
- `qval`: Adjusted p-value used for significance filtering (if present).
