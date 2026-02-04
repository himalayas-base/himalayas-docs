# Results and Filtering

`Results` holds the enrichment table and attached context (matrix, clusters, layout). It is passed to `Plotter` for visualization.

## Common Methods

```python
Results.filter(expr: str, **kwargs) -> Results
Results.subset(cluster: int) -> Results
Results.with_qvalues(pval_col: str = "pval", qval_col: str = "qval") -> Results
```

## Quick Examples

Filter to significant terms:

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
- `qval` BH-FDR q-value (only present after `with_qvalues()` or `finalize(add_qvalues=True)`)
