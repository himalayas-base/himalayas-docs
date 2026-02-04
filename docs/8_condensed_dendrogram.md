# Condensed Dendrogram

The condensed dendrogram provides a cluster-level summary that preserves the master dendrogram order and branch heights. It is useful for a high-level overview and pairs naturally with zoom workflows.

## Basic Usage

```python
from himalayas.plot import plot_dendrogram_condensed

plot_dendrogram_condensed(
    results,
    cluster_labels,
    figsize=(6, 10),
    sigbar_min_logp=2.0,
    sigbar_max_logp=10.0,
    label_fields=("label", "n", "p"),
    wrap_text=True,
    wrap_width=34,
)
```

Key params: `sigbar_min_logp`, `sigbar_max_logp`, `label_fields`, `wrap_text`, `wrap_width`,
`max_words`, `label_left_pad`, `dendrogram_color`, `dendrogram_lw`, `figsize`.

## With Zoom Results

After a zoom analysis, you can summarize the zoomed hierarchy with the same plotter:

```python
plot_dendrogram_condensed(
    zoom_results,
    zoom_cluster_labels,
    figsize=(4, 8),
    sigbar_min_logp=0.0,
    sigbar_max_logp=30.0,
    label_fields=("label", "n"),
    wrap_text=True,
    wrap_width=30,
)
```
