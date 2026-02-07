# API Reference

This page is a compact map of the public API. Detailed behavior and examples live in the topic pages.

## Core Objects

- `himalayas.Matrix(df: pd.DataFrame, *, axis: str = "rows")`
  - Numeric matrix container with validated labels.
  - See: [Matrix Input](2_matrix_input.md)

- `himalayas.Annotations(term_to_labels: dict[str, Iterable[str]], matrix: Matrix)`
  - Annotation mapping aligned to matrix labels.
  - See: [Annotation Input](3_annotation_input.md)

- `himalayas.Analysis(matrix: Matrix, annotations: Annotations)`
  - Pipeline methods: `.cluster(linkage_method: str = "ward", linkage_metric: str = "euclidean", linkage_threshold: float = 0.7, *, min_cluster_size: int = 1)`, `.enrich(*, min_overlap: int = 1, background: Matrix | None = None)`, `.finalize(*, add_qvalues: bool = True, col_cluster: bool = False, **kwargs)`.
  - See: [Clustering and Layout](4_clustering.md), [Enrichment and FDR](5_enrichment.md)

- `himalayas.Results(df: pd.DataFrame, method: str, ...)`
  - Result utilities: `.filter(expr: str, **kwargs: Any) -> Results`, `.subset(cluster: int) -> Results`, `.with_qvalues(pval_col: str = "pval", qval_col: str = "qval") -> Results`, `.cluster_layout(*, strict: bool = True) -> ClusterLayout`, `.cluster_spans(*, strict: bool = True) -> list[tuple[int, int, int]]`.
  - See: [Results and Filtering](6_results.md)

## Plotting API

- `himalayas.plot.Plotter(results: Results)`
  - Main layered plotting interface.
  - See: [Plotting](7_plotting.md)

- `himalayas.plot.plot_dendrogram_condensed(results: Results, cluster_labels: pd.DataFrame, ...)`
  - Condensed cluster-level dendrogram view.
  - See: [Condensed Dendrogram](8_condensed_dendrogram.md)
