# Clustering and Layout

HiMaLAYAS uses hierarchical clustering to organize matrix rows and columns into contiguous regions of related observations. Clusters are defined by cutting the dendrogram at a user-defined depth (distance threshold).

## Signature

```python
Analysis.cluster(
    linkage_method: str = "ward",
    linkage_metric: str = "euclidean",
    linkage_threshold: float | str = 0.7,
    *,
    optimal_ordering: bool = False,
    min_cluster_size: int = 1,
    merge_small_clusters: bool = True,
) -> Analysis
```

## Parameters

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `linkage_method` | `str` | `"ward"` | Hierarchical linkage method. Common: `ward`, `average`, `complete`, `single`. |
| `linkage_metric` | `str` | `"euclidean"` | Distance metric. Common: `euclidean`, `correlation`, `cosine`, `cityblock`. |
| `linkage_threshold` | `float \| str` | `0.7` | Dendrogram cut threshold (depth). Lower gives more clusters, higher gives fewer. Pass `"auto"` to automatically select a threshold instead of specifying one (see [Notes](#notes)). |
| `optimal_ordering` | `bool` | `False` | Enables optimal leaf ordering in linkage output. Often improves visual ordering, but can be slower. |
| `min_cluster_size` | `int` | `1` | Minimum cluster size floor. Values <= 1 disable the floor. See `merge_small_clusters` for how the floor is enforced. |
| `merge_small_clusters` | `bool` | `True` | If `True`, merges clusters smaller than `min_cluster_size` upward along the dendrogram (historical behavior). If `False`, preserves small dendrogram-cut clusters structurally; `min_cluster_size` is still applied, but by excluding clusters below it from enrichment reporting rather than merging them away. |

## Example

```python
analysis = Analysis(matrix, annotations).cluster(
    linkage_method="ward",
    linkage_metric="euclidean",
    linkage_threshold=16,
    min_cluster_size=30,
)
```

Sweep linkage thresholds on one `Analysis` object:

```python
analysis = Analysis(matrix, annotations)

# First run: computes and caches row linkage for these linkage settings.
analysis.cluster(
    linkage_method="average",
    linkage_metric="cosine",
    linkage_threshold=0.6,
    optimal_ordering=False,
    min_cluster_size=30,
)

# Second run: same linkage settings, new threshold.
# Reuses cached row linkage and only re-cuts clusters.
analysis.cluster(
    linkage_method="average",
    linkage_metric="cosine",
    linkage_threshold=1.0,
    optimal_ordering=False,
    min_cluster_size=30,
)
```

After clustering, cluster assignments are attached as:

| Attribute | Type | Description |
| --- | --- | --- |
| `analysis.clusters` | `Clusters` | Dendrogram, per-label cluster IDs, and cluster membership mappings. |

## Notes

- Any method or metric supported by SciPy `linkage` is valid (see the [SciPy linkage docs](https://docs.scipy.org/doc/scipy/reference/generated/scipy.cluster.hierarchy.linkage.html)).
- `linkage_metric="correlation"` requires every row to have non-zero variance, and `linkage_metric="cosine"` requires every row to have a non-zero L2 norm. Rows that violate this (constant rows for `correlation`, zero vectors for `cosine`) raise a `ValueError`; remove or preprocess the offending rows before clustering.
- When `optimal_ordering=False`, HiMaLAYAS uses `fastcluster` if installed and otherwise falls back to SciPy linkage.
- `linkage_threshold="auto"` scores candidate dendrogram cuts and picks the best one, balancing cluster quality against cluster-size diversity; it does not tune `linkage_method` or `linkage_metric`. If `min_cluster_size > 1` and `merge_small_clusters=False` leave fewer than 2 reportable clusters, selection falls back to the cut with the best reportable coverage and diversity. A `ValueError` is raised if no threshold is usable.
- `min_cluster_size` sets a size floor for dendrogram-cut clusters; `merge_small_clusters` controls whether clusters below it are merged upward (default) or excluded from enrichment reporting instead.
- With `Analysis.finalize(col_cluster=True)`, HiMaLAYAS reuses cached column order for the current linkage settings (`linkage_method`, `linkage_metric`, `optimal_ordering`).
- For large matrices, reuse a single `Analysis` object when sweeping linkage thresholds.
- For fixed linkage settings (`linkage_method`, `linkage_metric`, `optimal_ordering`), `Analysis.cluster(...)` reuses cached row linkage.
- Creating a new `Analysis(matrix, annotations)` starts with empty caches.
