# Clustering and Layout

HiMaLAYAS uses hierarchical clustering to organize matrix rows. Clusters are defined by cutting the dendrogram at a user-defined depth (distance threshold).

## Signature

```python
Analysis.cluster(
    linkage_method: str = "ward",
    linkage_metric: str = "euclidean",
    linkage_threshold: float = 0.7,
    *,
    min_cluster_size: int = 1,
) -> Analysis
```

## Parameters

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `linkage_method` | `str` | `"ward"` | Hierarchical linkage method. Common: `ward`, `average`, `complete`, `single`. |
| `linkage_metric` | `str` | `"euclidean"` | Distance metric. Common: `euclidean`, `correlation`, `cosine`, `cityblock`. |
| `linkage_threshold` | `float` | `0.7` | Dendrogram cut threshold (depth). Lower gives more clusters, higher gives fewer. |
| `min_cluster_size` | `int` | `1` | Merge small clusters upward until size is met. Values <= 1 disable. |

## Quick Example

```python
analysis = Analysis(matrix, annotations).cluster(
    linkage_method="ward",
    linkage_metric="euclidean",
    linkage_threshold=16,
    min_cluster_size=30,
)
```

## Notes

- Any method or metric supported by SciPy `linkage` is valid.
- `min_cluster_size` preserves hierarchy by merging undersized clusters into their parent cluster.
