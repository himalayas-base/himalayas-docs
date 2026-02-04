# API Reference

This page is a concise reference to the public API used in the documentation and notebooks.

## Core

### Matrix

```python
Matrix(df: pd.DataFrame, *, axis: str = "rows")
```

Parameters:

- `df`: numeric `pd.DataFrame` with unique row labels.
- `axis`: `"rows"` by default; reserved for column-labeled workflows.

- `himalayas.Matrix(df, axis="rows")`
  - Validates numeric matrix and unique row labels.
- `himalayas.Annotations(term_to_labels, matrix)`
  - Filters terms to labels present in `matrix`.
- `himalayas.Analysis(matrix, annotations)`
  - `.cluster(...)` hierarchical clustering.
  - `.enrich(...)` hypergeometric enrichment.
  - `.finalize(...)` compute layout and optional q values.
- `himalayas.Results(df, method, ...)`
  - `.filter(expr)` filter rows by pandas query expression.
  - `.subset(cluster)` subset to a cluster and return a new view.
  - `.with_qvalues(pval_col="pval", qval_col="qval")` add BH FDR.
  - `.cluster_layout()` and `.cluster_spans()`

## Plotting

- `himalayas.plot.Plotter(results)`
  - `.plot_matrix(...)`, `.plot_dendrogram(...)`, `.plot_cluster_labels(...)`
  - `.plot_cluster_bar(...)`, `.plot_gene_bar(...)`
  - `.add_colorbar(...)`, `.plot_colorbars(...)`
  - `.set_label_track_order(...)`, `.set_background(...)`
  - `.show()` and `.save(path)`

- `himalayas.plot.plot_dendrogram_condensed(results, cluster_labels, ...)`
  - Condensed dendrogram view aligned to cluster labels.

## Text Helpers

- `himalayas.text.summarize_terms(words, weights=None, max_words=6)`
- `himalayas.text.summarize_clusters(df, label_mode="compressed", label_col="term_name")`
