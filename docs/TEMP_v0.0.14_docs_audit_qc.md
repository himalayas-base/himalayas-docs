# v0.0.14 Docs Audit QC Draft

This temp file compiles all proposed Markdown edits from the v0.0.14 docs audit.
Source docs are unchanged.

---

## docs/3_annotation_input.md

### Replace opening paragraph

Annotations map categorical terms to labels present in your matrix. HiMaLAYAS filters labels to the matrix universe, then applies overlap-size constraints to retain terms.

### Replace `Signature`

```python
Annotations(
    term_to_labels: dict[str, Iterable[str]],
    matrix: Matrix,
    *,
    min_term_size: int = 2,
    max_term_size: int | None = None,
)
```

### Replace `Parameters` table

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `term_to_labels` | `dict[str, Iterable[str]]` | required | Mapping from term to labels (genes, recipes, proteins). |
| `matrix` | `Matrix` | required | Provides the label universe. |
| `min_term_size` | `int` | `2` | Minimum number of matrix-overlapping labels a term must have to be retained. |
| `max_term_size` | `int | None` | `None` | Maximum number of matrix-overlapping labels a term may have to be retained. `None` disables the upper bound. |

### Add to `Notes`

- Terms are filtered by matrix overlap and optional size bounds (`min_term_size`, `max_term_size`).
- Keep `min_term_size=2` as the default floor for analysis-ready runs.

### Add to `Common Errors`

- `Labels for term ... must be an iterable of labels` if a term maps to a string.
- `No annotation terms overlap matrix labels` if no terms remain after filtering.

---

## docs/5_enrichment.md

### Replace `finalize` signature block

```python
Analysis.finalize(
    *,
    col_cluster: bool = False,
    fdr_scope: str = "global",
) -> Analysis
```

### Replace `finalize` parameters table

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `col_cluster` | `bool` | `False` | Computes a dendrogram-based column order for plotting using the same `linkage_method`, `linkage_metric`, and `optimal_ordering` set in `Analysis.cluster(...)`. |
| `fdr_scope` | `str` | `"global"` | BH-FDR correction scope. `"global"` applies one correction across all cluster-term tests; `"per_cluster"` applies correction independently within each cluster. |

### Replace `FDR Correction` section

HiMaLAYAS uses Benjamini-Hochberg (BH) FDR for q-values. Set scope in `Analysis.finalize(...)`.

- `fdr_scope="global"` (default): applies BH across all cluster-term tests in the run.
- `fdr_scope="per_cluster"`: applies BH independently within each cluster.

```python
analysis_global = Analysis(matrix, annotations).cluster(...).enrich(...).finalize(fdr_scope="global")
analysis_per_cluster = Analysis(matrix, annotations).cluster(...).enrich(...).finalize(fdr_scope="per_cluster")
```

See [Results and Filtering](6_results.md) for q-value filtering examples.

### Add to `Notes`

- `fdr_scope="per_cluster"` is useful for within-cluster ranking or control.

---

## docs/6_results.md

### Replace `Common Methods` code block

```python
Results.filter(expr: str, **kwargs: Any) -> Results
Results.subset(cluster: int) -> Results
Results.subset_clusters(clusters: Iterable[int]) -> Results
Results.with_effect_sizes(fe_col: str = "fe") -> Results
Results.with_qvalues(*, method: str = "global") -> Results
Results.cluster_labels(
    *,
    rank_by: str = "p",
    label_mode: str = "top_term",
    max_words: int = 6,
) -> pd.DataFrame
```

### Replace `Common Methods` table

| Method | Description |
| --- | --- |
| `results.filter(...)` | Returns a new `Results` filtered by a query expression on `results.df`. |
| `results.subset(...)` | Returns a single-cluster zoom view with a subset matrix attached (for rerunning analysis). |
| `results.subset_clusters(...)` | Returns a multi-cluster zoom view with a subset matrix attached (for rerunning analysis). |
| `results.with_effect_sizes(...)` | Returns a new `Results` with fold enrichment column(s) added. |
| `results.with_qvalues(...)` | Returns a new `Results` with BH-FDR q-values added using global or per-cluster scope. |
| `results.cluster_labels(...)` | Builds one label per cluster for inspection or export. |

### Replace `subset` short description

Returns a single-cluster zoom view with a subset matrix attached.

Use this view to rerun `Analysis(...)` on the subset.

### Replace `subset_clusters` short description

Returns a multi-cluster zoom view (union of selected clusters) with a subset matrix attached.

Use this view to rerun `Analysis(...)` on the subset.

### Add new section: `with_effect_sizes`

## `with_effect_sizes`

```python
Results.with_effect_sizes(fe_col: str = "fe") -> Results
```

Returns a new `Results` with fold enrichment added as `fe_col`.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `fe_col` | `str` | `"fe"` | Output column name for fold enrichment. |

Behavior details:

- Uses `FE = (k / n) / (K / N) = (k * N) / (n * K)`.
- Requires columns `k`, `K`, `n`, and `N`.

### Add new section: `with_qvalues`

## `with_qvalues`

```python
Results.with_qvalues(*, method: str = "global") -> Results
```

Returns a new `Results` with BH-FDR q-values added as `qval`.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `method` | `str` | `"global"` | Correction scope: `"global"` or `"per_cluster"`. |

Behavior details:

- `method="global"`: BH across all rows in `results.df`.
- `method="per_cluster"`: BH independently within each cluster.
- Requires `pval`; `method="per_cluster"` also requires `cluster`.

### Add to `Examples`

```python
# Recompute q-values with per-cluster FDR scope on an existing results table.
results_per_cluster_q = results.with_qvalues(method="per_cluster")

# Add or rename fold enrichment output column.
results_fe = results.with_effect_sizes(fe_col="fold_enrichment")
```

---

## docs/7_plotting.md

### Replace `label_prefix` row in `plot_cluster_labels` parameter table

| `label_prefix` | `str | None` | `None` | Optional prefix mode for display labels. Supported values are `None`, `"cid"`, and `"alpha"`. |

### Replace behavior note

- `label_prefix="cid"` or `label_prefix="alpha"` can prefix labels even when `"label"` is omitted from `label_fields`.

### Add behavior note after the above line

- `label_prefix="alpha"` uses Excel-style indexing (`A.`, `B.`, ..., `Z.`, `AA.`, ...).

---

## docs/8_condensed_dendrogram.md

### Replace `label_prefix` row in parameters table

| `label_prefix` | `str | None` | `None` | Optional prefix mode for display labels. Supported values are `None`, `"cid"`, and `"alpha"`. |

### Replace behavior note

- `label_prefix="cid"` or `label_prefix="alpha"` can prefix labels even when `"label"` is omitted from `label_fields`.

### Add behavior note after the above line

- `label_prefix="alpha"` uses Excel-style indexing (`A.`, `B.`, ..., `Z.`, `AA.`, ...).

### Replace final `Notes` bullet

- `label_prefix` supports `None`, `"cid"`, and `"alpha"`.

---

## docs/9_advanced_workflows.md

### Replace step 2 in `Cluster Zoom Analysis`

2. Rebuild annotations for the subset (and tune term-size filters if needed).

### Add paragraph after the numbered list

Subset reruns are often smaller than the full matrix. Keep `min_term_size=2` by default when rebuilding `Annotations(...)`.

### Replace helper function signature and annotation line

```python
def run_zoom_analysis(
    *,
    results,
    cluster_id,
    go_bp,
    linkage_threshold,
    min_cluster_size=6,
    min_overlap=2,
    min_term_size=2,
    qval_cutoff=0.05,
):
    """Recluster a single cluster, re-run enrichment, and return zoomed results."""
    zoom_view = results.subset(cluster=cluster_id)
    zoom_matrix = zoom_view.matrix
    zoom_annotations = Annotations(go_bp, zoom_matrix, min_term_size=min_term_size)
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

### Replace annotation construction in multi-cluster example

```python
zoom_annotations = Annotations(go_bp, zoom_matrix, min_term_size=2)
```

---

## docs/10_faq.md

### Add new FAQ section after the q-value comparability section

## How do I choose between `global` and `per_cluster` q-values?

Set FDR scope in `Analysis.finalize(fdr_scope=...)`:

- `fdr_scope="global"` (default): one BH correction across all cluster-term tests in the run.
- `fdr_scope="per_cluster"`: BH correction run independently within each cluster.

Use `"global"` for run-wide interpretation and `"per_cluster"` for within-cluster interpretation.

### Add new FAQ section near annotation troubleshooting

## Annotation terms were dropped unexpectedly

HiMaLAYAS filters term labels to matrix labels, then applies size constraints in `Annotations(...)`.

- Terms with overlap `< min_term_size` are dropped.
- Terms with overlap `> max_term_size` are dropped when `max_term_size` is set.

For release analyses, keep `min_term_size=2` unless you are doing an exploratory pass.

---

## Optional consistency edits (low-risk polish)

These are optional but improve cross-page discoverability:

- In `docs/index.md` step 4, change `Analysis.finalize()` to `Analysis.finalize(..., fdr_scope=...)` in prose.
- In `docs/5_enrichment.md`, add one cross-link sentence to `docs/10_faq.md` for q-value comparability guidance.
