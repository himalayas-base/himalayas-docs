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

## `finalize`

Attaches plotting layout, fold enrichment (`fe`), and BH-FDR q-values to produce a plotting-ready `Results`. Call this before using `Plotter`.

```python
Analysis.finalize(
    *,
    col_cluster: bool = False,
    fdr_scope: str = "global",
) -> Analysis
```

### Parameters

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `col_cluster` | `bool` | `False` | Computes a dendrogram-based column order for plotting using the same `linkage_method`, `linkage_metric`, and `optimal_ordering` set in `Analysis.cluster(...)`. |
| `fdr_scope` | `str` | `"global"` | FDR scope. Use `"global"` for full-run correction or `"per_cluster"` for within-cluster correction. |

## Example

```python
analysis = (
    Analysis(matrix, annotations)
    .cluster(...)
    .enrich(min_overlap=2)
    .finalize(fdr_scope="global")
)

results = analysis.results
```

After running enrichment, the primary output is attached as:

| Attribute | Type | Description |
| --- | --- | --- |
| `analysis.results` | `Results` | Enrichment results table and attached context used for filtering, inspection, and plotting. |

## FDR Correction

HiMaLAYAS uses Benjamini-Hochberg (BH) FDR for q-values.

Set scope with `Analysis.finalize(fdr_scope=...)`:

- `"global"` (default): BH across all cluster-term tests in the run.
- `"per_cluster"`: BH independently within each cluster.

See [Results and Filtering](6_results.md) for examples of filtering on q-values.

## Notes

- If no terms pass filtering, the results table is empty.
- `analysis.enrich(...)` recomputes enrichment each time it is called.
- Each call updates `analysis.results`; save per-run snapshots (for example, `res_06`, `res_10`) during threshold sweeps.
- Providing `background=...` keeps the enrichment universe (`N`, `K`) consistent across full and zoomed analyses, so p-values remain comparable.
- q-values may still differ across runs because Benjamini-Hochberg FDR is applied to the hypothesis family tested in each run.
- `fdr_scope="per_cluster"` supports within-cluster interpretation.
- `min_overlap` is applied independently at three stages: filtering terms by universe-intersected size, filtering clusters by size, and suppressing individual cluster-term pairs by measured overlap.
- Genes with multiple term annotations are tested independently for each term; HiMaLAYAS does not perform Gene Ontology graph-aware redundancy filtering (e.g. parent/child term collapsing or semantic-similarity clustering), so multiple significant terms for a cluster may be hierarchically or semantically related.
