# Enrichment and FDR

HiMaLAYAS performs one-sided hypergeometric enrichment for each cluster and term. P-values are computed as P(X >= k), and multiple testing is controlled with Benjamini-Hochberg FDR.

## Signature

```python
Analysis.enrich(
    *,
    min_overlap: int = 1,
    background: Matrix | None = None,
) -> Analysis
```

## Parameters

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `min_overlap` | `int` | `1` | Minimum overlap k to report. Increase to reduce weak hits. |
| `background` | `Matrix | `None` | Optional background universe. If provided, must contain all matrix labels. |

## Example

```python
analysis = (
    Analysis(matrix, annotations)
    .cluster(...)
    .enrich(min_overlap=2)
    .finalize(add_qvalues=True)
)
```

## FDR Correction

HiMaLAYAS uses Benjamini-Hochberg (BH) FDR across cluster-term tests.

See [Results and Filtering](6_results.md) for examples of filtering on q-values.

## Notes

- If no terms pass filtering, the results table is empty.
