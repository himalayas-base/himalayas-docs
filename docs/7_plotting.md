# Plotting

HiMaLAYAS uses a layered plotting system. Declare layers in order, then render with `show()` or `save()`.

## Signature

```python
Plotter(results: Results) -> Plotter
```

## Parameters

| Parameter | Type | Description |
| --- | --- | --- |
| `results` | `Results` | Results with a matrix and layout from `Analysis.finalize()`. |

## Example

```python
from matplotlib.colors import Normalize
from himalayas.plot import Plotter

plotter = (
    Plotter(results)
    .set_background(color="white")
    .plot_title("HiMaLAYAS - Yeast GI Matrix", fontsize=17)
    .plot_dendrogram(axes=[0.06, 0.16, 0.09, 0.79], linewidth=0.75, color="#888888")
    .plot_matrix(cmap="RdBu_r", center=0, vmin=-vlim, vmax=vlim, outer_lw=0)
    .plot_matrix_axis_labels(xlabel="Gene", ylabel="Gene", fontsize=16)
    .plot_cluster_labels(
        cluster_labels,
        label_fields=("label", "p"),
        wrap_text=True,
        wrap_width=40,
        axes=[0.62, 0.16, 0.36, 0.79],
    )
    .plot_cluster_bar(
        name="sigbar",
        values=cluster_labels,
        pval_col="pval",
        norm=Normalize(0, 30),
        width=0.04,
        left_pad=0.02,
    )
    .plot_gene_bar(
        name="essentiality",
        values=gene_essential_map,
        mode="categorical",
        colors=gene_essential_colors,
        width=0.04,
        left_pad=0.06,
    )
    .plot_bar_labels(font="Helvetica", fontsize=14, rotation=90)
    .set_label_track_order(("sigbar", "essentiality"))
    .add_colorbar(name="matrix", cmap="RdBu_r", norm=Normalize(-vlim, vlim), label="Similarity")
    .plot_colorbars(ncols=1, height=0.045, gap=0.05)
)

plotter.show()
```

## Core Layers

Layers render in declaration order. Later layers draw on top of earlier ones.

### `plot_matrix`

```python
Plotter.plot_matrix(
    *,
    cmap: str = "viridis",
    center: float | None = None,
    vmin: float | None = None,
    vmax: float | None = None,
    show_minor_rows: bool = True,
    minor_row_step: int = 1,
    minor_row_lw: float = 0.15,
    minor_row_alpha: float = 0.15,
    outer_lw: float = 1.2,
    outer_color: str = "black",
    gutter_color: str | None = None,
    figsize: tuple[float, float] | None = None,
    subplots_adjust: dict[str, float] | None = None,
) -> Plotter
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cmap` | `str` | `"viridis"` | Colormap name. |
| `center` | `float | None` | `None` | Center value for diverging normalization. |
| `vmin` | `float | None` | `None` | Minimum value override. |
| `vmax` | `float | None` | `None` | Maximum value override. |
| `show_minor_rows` | `bool` | `True` | Draw thin row gridlines. |
| `minor_row_step` | `int` | `1` | Spacing for minor row lines. |
| `minor_row_lw` | `float` | `0.15` | Minor row line width. |
| `minor_row_alpha` | `float` | `0.15` | Minor row line alpha. |
| `outer_lw` | `float` | `1.2` | Outer border width. |
| `outer_color` | `str` | `"black"` | Outer border color. |
| `gutter_color` | `str | None` | `None` | Mask color for edge artifacts in the matrix panel. |
| `figsize` | `tuple[float, float] | None` | `None` | Override figure size (defaults to `(9, 7)`). |
| `subplots_adjust` | `dict[str, float] | None` | `None` | Figure margins (defaults to `left=0.15`, `right=0.70`, `bottom=0.05`, `top=0.95`). |

Use `center` for diverging color scales and `vmin`/`vmax` for explicit limits.

### `plot_dendrogram`

```python
Plotter.plot_dendrogram(
    *,
    axes: Sequence[float] | None = None,
    color: str | None = None,
    linewidth: float | None = None,
    data_pad: float = 0.25,
) -> Plotter
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `axes` | `Sequence[float] | None` | `None` | Dendrogram panel box (defaults to `[0.06, 0.05, 0.09, 0.90]`). |
| `color` | `str | None` | `None` | Dendrogram line color (defaults to `"#888888"`). |
| `linewidth` | `float | None` | `None` | Dendrogram line width (defaults to `1.0`). |
| `data_pad` | `float` | `0.25` | Expands y-limits to avoid top/bottom clipping. |

### `plot_cluster_labels`

The implementation signature is `Plotter.plot_cluster_labels(cluster_labels, **kwargs)`.
The list below documents the supported keyword arguments and effective defaults.

```python
Plotter.plot_cluster_labels(
    cluster_labels: pd.DataFrame,
    *,
    label_fields: tuple[str, ...] = ("label", "n", "p"),
    max_words: int | None = None,
    wrap_text: bool = True,
    wrap_width: int | None = None,
    overflow: str = "wrap",
    font: str = "Helvetica",
    fontsize: float | None = None,
    color: str | None = None,
    alpha: float | None = None,
    axes: Sequence[float] | None = None,
    overrides: dict[int, str | dict[str, Any]] | None = None,
    skip_unlabeled: bool = False,
    placeholder_text: str | None = None,
    placeholder_color: str | None = None,
    label_text_pad: float | None = None,
    label_x: float | None = None,
    label_gutter_width: float | None = None,
    label_gutter_color: str | None = None,
    label_sep_color: str | None = None,
    label_sep_lw: float | None = None,
    label_sep_alpha: float | None = None,
    label_sep_xmin: float | None = None,
    label_sep_xmax: float | None = None,
    boundary_color: str | None = None,
    boundary_lw: float | None = None,
    boundary_alpha: float | None = None,
    dendro_boundary_color: str | None = None,
    dendro_boundary_lw: float | None = None,
    dendro_boundary_alpha: float | None = None,
) -> Plotter
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cluster_labels` | `pd.DataFrame` | required | Must include `cluster` and `label`; optional `pval`. |
| `label_fields` | `tuple[str, ...]` | `("label", "n", "p")` | Fields shown in each label; allowed values are `"label"`, `"n"`, `"p"`. |
| `max_words` | `int | None` | `None` | Truncate labels to this word count. |
| `wrap_text` | `bool` | `True` | Enables wrapping logic; wrapping is applied only when `wrap_width` is set. |
| `wrap_width` | `int | None` | `None` | Characters per line when wrapping. |
| `overflow` | `str` | `"wrap"` | Overflow behavior: `"wrap"` or `"ellipsis"`. |
| `font` | `str` | `"Helvetica"` | Label font family. |
| `fontsize` | `float | None` | `9` | Label font size. |
| `color` | `str | None` | `"black"` | Label text color. |
| `alpha` | `float | None` | `0.9` | Label text alpha (`0.6` for placeholders). |
| `axes` | `Sequence[float] | None` | `None` | Label panel box (defaults to `[0.70, 0.05, 0.29, 0.90]`). |
| `overrides` | `dict[int, str | dict[str, Any]] | None` | `None` | Per-cluster overrides. Values may be a label string, or a dict with `label` (required), optional `pval`, and optional `hide_stats`. |
| `skip_unlabeled` | `bool` | `False` | Skip clusters with no label. |
| `placeholder_text` | `str | None` | `None` | Placeholder label (defaults to `"\\u2014"`). |
| `placeholder_color` | `str | None` | `None` | Placeholder color (defaults to `"#b22222"`). |
| `label_text_pad` | `float | None` | `None` | Padding between tracks and text (defaults to `0.01`). |
| `label_x` | `float | None` | `None` | Left offset for label tracks (defaults to `0.02`). |
| `label_gutter_width` | `float | None` | `None` | Gutter width between matrix and labels (defaults to `0.01`). |
| `label_gutter_color` | `str | None` | `None` | Gutter color (defaults to `"white"`). |
| `label_sep_color` | `str | None` | `None` | Separator line color (defaults to `"gray"`). |
| `label_sep_lw` | `float | None` | `None` | Separator line width (defaults to `0.5`). |
| `label_sep_alpha` | `float | None` | `None` | Separator line alpha (defaults to `0.3`). |
| `label_sep_xmin` | `float | None` | `None` | Separator start x position (auto if `None`). |
| `label_sep_xmax` | `float | None` | `None` | Separator end x position (auto if `None`). |
| `boundary_color` | `str | None` | `None` | Cluster boundary color in matrix (defaults to `"black"`). |
| `boundary_lw` | `float | None` | `None` | Cluster boundary line width in matrix (defaults to `0.5`). |
| `boundary_alpha` | `float | None` | `None` | Cluster boundary alpha in matrix (defaults to `0.6`). |
| `dendro_boundary_color` | `str | None` | `None` | Cluster boundary color in dendrogram (defaults to `"white"`). |
| `dendro_boundary_lw` | `float | None` | `None` | Dendrogram boundary line width (defaults to `0.5`). |
| `dendro_boundary_alpha` | `float | None` | `None` | Dendrogram boundary alpha (defaults to `0.3`). |

Use `overrides` to edit or hide labels per cluster and the `label_*` options to tune gutter and spacing.

Behavior notes:

- `n` is derived from cluster sizes in the attached layout (not from `cluster_labels` input columns).
- `label_fields` values outside `{ "label", "n", "p" }` raise `ValueError`.
- Dict-style `overrides` entries require a non-empty `label`.
- If `skip_unlabeled=True`, clusters without labels are omitted instead of receiving placeholder text.

## Label Panel Tracks

### `plot_cluster_bar`

```python
Plotter.plot_cluster_bar(
    name: str,
    values: dict[int, float | None] | pd.Series | pd.DataFrame,
    *,
    kind: str = "pvalue",
    width: float | None = None,
    left_pad: float = 0.0,
    right_pad: float = 0.0,
    cmap: str | Colormap = "YlOrBr",
    norm: Normalize | None = None,
    alpha: float = 0.9,
    enabled: bool = True,
    title: str | None = None,
    cluster_col: str = "cluster",
    pval_col: str = "pval",
) -> Plotter
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `str` | required | Track name used for ordering. |
| `values` | `dict[int, float | None]` / `pd.Series` / `pd.DataFrame` | required | Cluster values; DataFrame uses `cluster_col`/`pval_col`. |
| `kind` | `str` | `"pvalue"` | Only `"pvalue"` is supported. |
| `width` | `float | None` | `None` | Track width (defaults to `0.015`). |
| `left_pad` | `float` | `0.0` | Left padding in the label panel. |
| `right_pad` | `float` | `0.0` | Right padding in the label panel. |
| `cmap` | `str | Colormap` | `"YlOrBr"` | Colormap name or instance. |
| `norm` | `Normalize | None` | `None` | Normalization for `-log10(p)`. |
| `alpha` | `float` | `0.9` | Bar alpha. |
| `enabled` | `bool` | `True` | Register the track. |
| `title` | `str | None` | `None` | Optional track title. |
| `cluster_col` | `str` | `"cluster"` | Cluster id column name for DataFrame input. |
| `pval_col` | `str` | `"pval"` | Value column name for DataFrame input. |

### `plot_gene_bar`

```python
Plotter.plot_gene_bar(
    values: Mapping[Hashable, Any],
    *,
    mode: str = "categorical",
    colors: dict[Any, Any] | None = None,
    cmap: str = "viridis",
    vmin: float | None = None,
    vmax: float | None = None,
    missing_color: str | None = None,
    left_pad: float = 0.0,
    width: float | None = None,
    right_pad: float = 0.0,
    name: str = "gene_bar",
    title: str | None = None,
    enabled: bool = True,
) -> Plotter
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `values` | `Mapping[Hashable, Any]` | required | Row label to category or numeric value. |
| `mode` | `str` | `"categorical"` | `"categorical"` or `"continuous"`. |
| `colors` | `dict[Any, Any] | None` | `None` | Category to color mapping for categorical mode. |
| `cmap` | `str` | `"viridis"` | Colormap for continuous mode. |
| `vmin` | `float | None` | `None` | Minimum for continuous mode normalization. |
| `vmax` | `float | None` | `None` | Maximum for continuous mode normalization. |
| `missing_color` | `str | None` | `None` | Missing-value color (defaults to `"#eeeeee"`). |
| `left_pad` | `float` | `0.0` | Left padding in the label panel. |
| `width` | `float | None` | `None` | Track width (defaults to `0.012`). |
| `right_pad` | `float` | `0.0` | Right padding in the label panel. |
| `name` | `str` | `"gene_bar"` | Track name used for ordering. |
| `title` | `str | None` | `None` | Optional track title. |
| `enabled` | `bool` | `True` | Register the track. |

### Track Order

```python
Plotter.set_label_track_order(order: Sequence[str] | None = None) -> Plotter
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `order` | `Sequence[str] | None` | `None` | Explicit track order. Use `None` for default order. |

### Track Titles

```python
Plotter.plot_bar_labels(
    *,
    font: str = "Helvetica",
    fontsize: float = 10,
    color: str | None = None,
    alpha: float = 1.0,
    pad: float = 2,
    rotation: float = 0,
) -> Plotter
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `font` | `str` | `"Helvetica"` | Font family for track titles. |
| `fontsize` | `float` | `10` | Font size for track titles. |
| `color` | `str | None` | `"black"` | Text color. |
| `alpha` | `float` | `1.0` | Text alpha. |
| `pad` | `float` | `2` | Padding in points below the tracks. |
| `rotation` | `float` | `0` | Text rotation in degrees. |

## Axes and Titles

### `plot_title`

```python
Plotter.plot_title(
    title: str,
    *,
    fontsize: float | None = None,
    pad: float | None = None,
    color: str | None = None,
) -> Plotter
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `title` | `str` | required | Title text. |
| `fontsize` | `float | None` | `14` | Title font size. |
| `pad` | `float | None` | `15` | Padding above the plot. |
| `color` | `str | None` | `"black"` | Title color. |

### `plot_matrix_axis_labels`

```python
Plotter.plot_matrix_axis_labels(
    *,
    xlabel: str = "",
    ylabel: str = "",
    fontsize: float = 12,
    fontweight: str = "normal",
    xlabel_pad: float = 8,
    ylabel_pad: float | None = None,
    font: str | None = None,
    color: str | None = None,
    alpha: float = 1.0,
) -> Plotter
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `xlabel` | `str` | `""` | X-axis label text. |
| `ylabel` | `str` | `""` | Y-axis label text. |
| `fontsize` | `float` | `12` | Axis label font size. |
| `fontweight` | `str` | `"normal"` | Axis label font weight. |
| `xlabel_pad` | `float` | `8` | Padding for the x-axis label. |
| `ylabel_pad` | `float | None` | `None` | Padding between matrix and y-axis label (defaults to `0.015`). |
| `font` | `str | None` | `None` | Font family for axis labels. |
| `color` | `str | None` | `"black"` | Axis label color. |
| `alpha` | `float` | `1.0` | Axis label alpha. |

### `plot_row_ticks`

```python
Plotter.plot_row_ticks(
    labels: Sequence[str] | None = None,
    *,
    position: str = "right",
    fontsize: float = 9,
    max_labels: int | None = None,
) -> Plotter
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `labels` | `Sequence[str] | None` | `None` | Row labels; defaults to matrix index. |
| `position` | `str` | `"right"` | Tick side: `"left"` or `"right"`. |
| `fontsize` | `float` | `9` | Tick label font size. |
| `max_labels` | `int | None` | `None` | Show at most this many labels. |

### `plot_col_ticks`

```python
Plotter.plot_col_ticks(
    labels: Sequence[str] | None = None,
    *,
    position: str = "top",
    fontsize: float = 9,
    rotation: float = 90,
    max_labels: int | None = None,
) -> Plotter
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `labels` | `Sequence[str] | None` | `None` | Column labels; defaults to matrix columns. |
| `position` | `str` | `"top"` | Tick side: `"top"` or `"bottom"`. |
| `fontsize` | `float` | `9` | Tick label font size. |
| `rotation` | `float` | `90` | Tick label rotation in degrees. |
| `max_labels` | `int | None` | `None` | Show at most this many labels. |

## Colorbars

### `add_colorbar`

```python
Plotter.add_colorbar(
    *,
    name: str,
    cmap: str | Colormap,
    norm: Normalize,
    label: str | None = None,
    ticks: Sequence[float] | None = None,
    color: str | None = None,
) -> Plotter
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `str` | required | Colorbar name. |
| `cmap` | `str` / `Colormap` | required | Colormap name or instance. |
| `norm` | `Normalize` | required | Matplotlib normalization. |
| `label` | `str | None` | `None` | Colorbar label. |
| `ticks` | `Sequence[float] | None` | `None` | Tick locations. |
| `color` | `str | None` | `None` | Tick and label color. |

### `plot_colorbars`

```python
Plotter.plot_colorbars(
    *,
    nrows: int | None = None,
    ncols: int | None = None,
    height: float = 0.05,
    hpad: float = 0.01,
    vpad: float = 0.01,
    gap: float = 0.02,
    border_color: str | None = None,
    border_width: float = 0.8,
    border_alpha: float = 1.0,
    fontsize: float | None = None,
    font: str | None = None,
    color: str | None = None,
    label_position: str = "below",
) -> Plotter
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `nrows` | `int | None` | `None` | Grid rows; inferred if `None`. |
| `ncols` | `int | None` | `None` | Grid columns; inferred if `None`. |
| `height` | `float` | `0.05` | Total colorbar strip height. |
| `hpad` | `float` | `0.01` | Horizontal spacing between colorbars. |
| `vpad` | `float` | `0.01` | Vertical spacing between colorbars. |
| `gap` | `float` | `0.02` | Gap between matrix and strip. |
| `border_color` | `str | None` | `None` | Border color (defaults to `"black"`). |
| `border_width` | `float` | `0.8` | Border line width. |
| `border_alpha` | `float` | `1.0` | Border alpha. |
| `fontsize` | `float | None` | `None` | Tick and label font size (defaults to `9`). |
| `font` | `str | None` | `None` | Tick and label font family. |
| `color` | `str | None` | `None` | Tick and label color (defaults to `"black"`). |
| `label_position` | `str` | `"below"` | Label placement: `"below"` or `"above"`. |

## Legends

### `plot_sigbar_legend`

```python
Plotter.plot_sigbar_legend(
    *,
    axes: Sequence[float] = [0.92, 0.20, 0.015, 0.25],
    sigbar_cmap: str | None = None,
    norm: Normalize | None = None,
    sigbar_min_logp: float | None = None,
    sigbar_max_logp: float | None = None,
) -> Plotter
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `axes` | `Sequence[float]` | `[0.92, 0.20, 0.015, 0.25]` | Legend box `[x0, y0, w, h]`. |
| `sigbar_cmap` | `str | None` | `None` | Colormap for the legend (defaults to `"YlOrBr"`). |
| `norm` | `Normalize | None` | `None` | Normalization for `-log10(p)`. |
| `sigbar_min_logp` | `float | None` | `None` | Lower bound for legend scale (defaults to `2.0`). |
| `sigbar_max_logp` | `float | None` | `None` | Upper bound for legend scale (defaults to `10.0`). |

## Rendering

### `set_background`

```python
Plotter.set_background(color: str) -> Plotter
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `color` | `str` | required | Figure background color for display and save. |

### `show`

```python
Plotter.show() -> None
```

### `save`

```python
Plotter.save(path: str, **kwargs) -> None
```

`**kwargs` are passed to Matplotlib `savefig`.

## Notes

- `Plotter` expects `Results` with layout from `Analysis.finalize()`.
