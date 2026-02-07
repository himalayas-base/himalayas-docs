# Results and Filtering

`Results` holds the enrichment table and attached context (matrix, clusters, layout). It is passed to `Plotter` for visualization.

## Common Methods

```python
Results.filter(expr: str, **kwargs: Any) -> Results
Results.subset(cluster: int) -> Results
Results.with_qvalues(pval_col: str = "pval", qval_col: str = "qval") -> Results
Results.cluster_layout(*, strict: bool = True) -> ClusterLayout
Results.cluster_spans(*, strict: bool = True) -> list[tuple[int, int, int]]
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

## `with_qvalues`

```python
Results.with_qvalues(pval_col: str = "pval", qval_col: str = "qval") -> Results
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pval_col` | `str` | `"pval"` | Column containing p-values in `results.df`. |
| `qval_col` | `str` | `"qval"` | Name for the added BH-adjusted q-value column. |

## `cluster_layout` and `cluster_spans`

```python
Results.cluster_layout(*, strict: bool = True) -> ClusterLayout
Results.cluster_spans(*, strict: bool = True) -> list[tuple[int, int, int]]
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `strict` | `bool` | `True` | Requires contiguous cluster spans in the attached layout. |

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

Add q-values after the fact:

```python
results = results.with_qvalues()
```

## Key Columns in `results.df`

- `cluster` cluster id
- `term` term id
- `k` overlap between cluster and term
- `K` term size in background
- `n` cluster size
- `N` background size
- `pval` hypergeometric p-value
- `qval` adjusted p-value used for significance filtering (if present)
