# Plotting

HiMaLAYAS uses a layered plotting system. You declare layers in order, then call `show()` or `save()`.

## Minimal Plot

```python
from himalayas.plot import Plotter

plotter = (
    Plotter(results)
    .plot_dendrogram()
    .plot_matrix(cmap="RdBu_r", center=0)
    .plot_cluster_labels(cluster_labels)
)

plotter.show()
```

## Common Layers and Parameters

### `plot_matrix`

```python
plotter.plot_matrix(
    cmap="RdBu_r",
    center=0,
    vmin=-vlim,
    vmax=vlim,
    outer_lw=0,
)
```

Key params: `cmap`, `center`, `vmin`, `vmax`, `outer_lw`, `figsize`, `subplots_adjust`.

### `plot_dendrogram`

```python
plotter.plot_dendrogram(
    axes=[0.06, 0.16, 0.09, 0.79],
    data_pad=0.35,
    color="#888888",
    linewidth=0.75,
)
```

Key params: `axes`, `data_pad`, `color`, `linewidth`.

### `plot_cluster_labels`

```python
plotter.plot_cluster_labels(
    cluster_labels,
    label_fields=("label", "p"),
    wrap_text=True,
    wrap_width=40,
    fontsize=16,
    axes=[0.62, 0.16, 0.36, 0.79],
)
```

Key params: `label_fields`, `wrap_text`, `wrap_width`, `fontsize`, `color`, `axes`, `overrides`.

### `plot_cluster_bar`

```python
from matplotlib.colors import Normalize

plotter.plot_cluster_bar(
    norm=Normalize(0, 30),
    name="sigbar",
    title="Enrichment",
    values=cluster_labels,
    pval_col="pval",
    width=0.04,
    left_pad=0.06,
    right_pad=0.01,
)
```

Key params: `norm`, `width`, `left_pad`, `right_pad`, `title`.

### Colorbars

```python
plotter.add_colorbar(
    name="matrix",
    cmap="RdBu_r",
    norm=Normalize(-vlim, vlim),
    label="Similarity",
    ticks=[-vlim, 0, vlim],
)

plotter.plot_colorbars(ncols=2, height=0.045, gap=0.05)
```

## Notes

- `Plotter` expects `Results` with an attached layout from `Analysis.finalize()`.
- Use percentile scaling for robust heatmaps.
