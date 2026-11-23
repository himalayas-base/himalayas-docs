# Enrichment and FDR

HiMaLAYAS tests enrichment across clusters and categorical annotations using a one-sided hypergeometric test. Multiple testing across cluster-term tests is controlled with Benjamini-Hochberg FDR.

## Common Methods

| Method | Description |
| --- | --- |
| `analysis.enrich(...)` | Runs one-sided hypergeometric enrichment over clustered labels and annotations. |
| `analysis.finalize(...)` | Attaches plotting layout, fold enrichment (`fe`), and BH-FDR q-values to produce a plotting-ready `Results`. |

## `enrich`

Runs one-sided hypergeometric enrichment over clustered labels and annotations.

```python
Analysis.enrich(
    *,
    min_overlap: int = 1,
    background: Matrix | None = None,
) -> Analysis
```

### Parameters

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `min_overlap` | `int` | `1` | Minimum overlap k to report. Increase to reduce weak hits. |
| `background` | `Matrix | None` | `None` | Optional background universe. If provided, must contain all matrix labels. |

### Term-Size Filtering

Without an explicit background, enrichment uses the visible annotation terms after matrix filtering. With an explicit background, `min_term_size` and `max_term_size` are reapplied to original source memberships intersected with that background. Supplying `background=matrix` therefore retains the same size-filtered terms as the default. A larger background can admit a term below the local minimum, or exclude one above the global maximum. Rebinding limits candidates to terms visible before that rebind while preserving their original memberships for global counts. These size limits are separate from `min_overlap`; overlap and FDR rules are unchanged.

## `finalize`

Attaches plotting layout, fold enrichment (`fe`), and BH-FDR q-values to produce a plotting-ready `Results`. Call this before using `Plotter`.

```python
Analysis.finalize(
    *,
    col_cluster: bool = False,
    col_dendrogram: bool = False,
    fdr_scope: str = "global",
) -> Analysis
```

### Parameters

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `col_cluster` | `bool` | `False` | Computes a dendrogram-based column order for plotting using the same `linkage_method`, `linkage_metric`, and `optimal_ordering` set in `Analysis.cluster(...)`. |
| `col_dendrogram` | `bool` | `False` | Also keeps the column linkage on the layout so `Plotter.plot_col_dendrogram(...)` can draw the column tree. Requires `col_cluster=True`; otherwise `ValueError`. The column order is identical with or without it. |
| `fdr_scope` | `str` | `"global"` | FDR scope. Use `"global"` for full-run correction or `"per_cluster"` for within-cluster correction. |

## Example

`enrich()` computes raw hypergeometric p-values. `finalize()` adds BH-adjusted q-values; filter the finalized results afterward. The following is an API sketch; replace `...` with your clustering settings.

```python
analysis = (
    Analysis(matrix, annotations)
    .cluster(...)
    .enrich(min_overlap=2)
    .finalize(fdr_scope="global")
)

results = analysis.results
results_sig = results.filter("qval <= 0.05")
```

After running enrichment, the primary output is attached as:

| Attribute | Type | Description |
| --- | --- | --- |
| `analysis.results` | `Results` | Enrichment results table and attached context used for filtering, inspection, and plotting. |

## FDR Correction

HiMaLAYAS uses Benjamini-Hochberg (BH) FDR for q-values.

Set scope with `Analysis.finalize(fdr_scope=...)`:

- `"global"` (default): BH across the retained tested cluster-term pairs in that run, after annotation-size, cluster-size and minimum-overlap constraints. Untested pairs are not added to the correction family.
- `"per_cluster"`: BH independently over the retained tested pairs within each cluster; this does not control FDR across the full run.

See [Results and Filtering](6_results.md) for examples of filtering on q-values.

## Background Universe

By default, the universe is the current matrix's row labels. A suitable universe represents the observations eligible for selection or measurement. For an assay, this may be all measured genes rather than only a selected subset. A full-genome background is available when all genes were eligible; it is not automatically a better choice. Background labels must contain every analysis label and use the same identifiers as the annotations.

This self-contained example analyzes four genes from a six-gene measured universe. Only the background's row labels define the universe; its values are not used in the enrichment test.

```python
import pandas as pd
from himalayas import Analysis, Annotations, Matrix

background = Matrix(pd.DataFrame(
    {"signal": [0.0, 0.1, 4.0, 4.1, 8.0, 8.1]},
    index=["a", "b", "c", "d", "e", "f"],
))
matrix = Matrix(background.df.loc[["a", "b", "c", "d"]])
annotations = Annotations(
    {"term A": ["a", "b", "e"], "term B": ["c", "d", "f"]}, matrix
)
analysis = (
    Analysis(matrix, annotations)
    .cluster(linkage_threshold=1.0, min_cluster_size=2)
    .enrich(min_overlap=2, background=background)
    .finalize(fdr_scope="global")
)
results = analysis.results
results_sig = results.filter("qval <= 0.05")
```

For zooms of this analysis, keep passing `background=background` to retain the six-gene universe. For a full-matrix analysis using the default universe, save that original matrix and pass it explicitly on every zoom. See [Cluster Zoom Analysis](9_advanced_workflows.md#cluster-zoom-analysis) for single and nested zoom examples. Holding the universe fixed preserves N and each shared term's K; q-values can still change because the tested family changes.

## Notes

- If no terms pass filtering, the results table is empty.
- `analysis.enrich(...)` recomputes enrichment each time it is called.
- Each call updates `analysis.results`; save per-run snapshots (for example, `res_06`, `res_10`) during threshold sweeps.
- Providing `background=...` keeps the enrichment universe (`N`, `K`) consistent across full and zoomed analyses, so p-values remain comparable.
- q-values may still differ across runs because Benjamini-Hochberg FDR is applied to the hypothesis family tested in each run.
- `fdr_scope="per_cluster"` supports within-cluster interpretation.
- `min_overlap` is applied independently at three stages: filtering terms by universe-intersected size, filtering clusters by size, and suppressing individual cluster-term pairs by measured overlap.
- Genes with multiple term annotations are tested independently for each term; HiMaLAYAS does not perform Gene Ontology graph-aware redundancy filtering (e.g. parent/child term collapsing or semantic-similarity clustering), so multiple significant terms for a cluster may be hierarchically or semantically related. To hide near-duplicate terms by label overlap, use [`Results.drop_redundant(...)`](6_results.md#drop_redundant).
