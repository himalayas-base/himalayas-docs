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
        label_fields=("label", "p"),
        wrap_text=True,
        wrap_width=40,
        axes=[0.62, 0.16, 0.36, 0.79],
    )
    .plot_cluster_bar(
        name="sigbar",
        norm=Normalize(0, 30),
        width=0.04,
        left_pad=0.02,
    )
    .plot_label_bar(
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
| `figsize` | `tuple[float, float] | None` | `(9, 7)` | Figure size override. |
| `subplots_adjust` | `dict[str, float] | None` | `{"left": 0.15, "right": 0.70, "bottom": 0.05, "top": 0.95}` | Figure margins override. |

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
| `axes` | `Sequence[float] | None` | `[0.06, 0.05, 0.09, 0.90]` | Dendrogram panel box. |
| `color` | `str | None` | `"#888888"` | Dendrogram line color. |
| `linewidth` | `float | None` | `1.0` | Dendrogram line width. |
| `data_pad` | `float` | `0.25` | Expands y-limits to avoid top/bottom clipping. |

### `plot_cluster_labels`

Labels are generated internally from attached `Results` via `Results.cluster_labels(...)`.
Use `Results.cluster_labels(...)` when you want an explicit post-hoc label table (inspection/export/custom side workflows), not as a required input to this method.
The list below documents the supported keyword arguments and effective defaults.

```python
Plotter.plot_cluster_labels(
    *,
    overrides: dict[int, Any] | None = None,
    term_col: str = "term",
    cluster_col: str = "cluster",
    weight_col: str = "pval",
    label_mode: str = "top_term",
    label_col: str | None = "term_name",
    max_words: int = 6,
    label_fields: tuple[str, ...] = ("label", "n", "p"),
    wrap_text: bool = True,
    wrap_width: int | None = None,
    overflow: str = "wrap",
    font: str = "Helvetica",
    fontsize: float | None = 9,
    color: str | None = "black",
    alpha: float | None = 0.9,
    axes: Sequence[float] | None = [0.70, 0.05, 0.29, 0.90],
    skip_unlabeled: bool = False,
    placeholder_text: str | None = "\\u2014",
    placeholder_color: str | None = "#b22222",
    label_text_pad: float | None = 0.01,
    label_x: float | None = 0.02,
    label_gutter_width: float | None = 0.01,
    label_gutter_color: str | None = "white",
    label_sep_color: str | None = "gray",
    label_sep_lw: float | None = 0.5,
    label_sep_alpha: float | None = 0.3,
    label_sep_xmin: float | None = None,
    label_sep_xmax: float | None = 1.0,
    boundary_color: str | None = "black",
    boundary_lw: float | None = 0.5,
    boundary_alpha: float | None = 0.6,
    dendro_boundary_color: str | None = "white",
    dendro_boundary_lw: float | None = 0.5,
    dendro_boundary_alpha: float | None = 0.3,
) -> Plotter
```

Defaults shown here are effective user-facing defaults resolved from internal style config.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `overrides` | `dict[int, str | dict[str, Any]] | None` | `None` | Per-cluster overrides. Values may be a label string, or a dict with `label` (required), optional `pval`, and optional `hide_stats`. |
| `term_col` | `str` | `"term"` | Term id column used during internal label generation. |
| `cluster_col` | `str` | `"cluster"` | Cluster id column used during internal label generation. |
| `weight_col` | `str` | `"pval"` | Weight/p-value column used during internal label generation. |
| `label_mode` | `str` | `"top_term"` | One of `"top_term"` or `"compressed"` for internal label generation. |
| `label_col` | `str | None` | `"term_name"` | Optional display-name column for internal label generation. |
| `max_words` | `int` | `6` | Max words used by internal `"compressed"` label generation. |
| `label_fields` | `tuple[str, ...]` | `("label", "n", "p")` | Fields shown in each label; allowed values are `"label"`, `"n"`, `"p"`. |
| `wrap_text` | `bool` | `True` | Enables wrapping logic; wrapping is applied only when `wrap_width` is set. |
| `wrap_width` | `int | None` | `None` | Characters per line when wrapping. |
| `overflow` | `str` | `"wrap"` | Overflow behavior: `"wrap"` or `"ellipsis"`. |
| `font` | `str` | `"Helvetica"` | Label font family. |
| `fontsize` | `float | None` | `9` | Label font size. |
| `color` | `str | None` | `"black"` | Label text color. |
| `alpha` | `float | None` | `0.9` | Label text alpha (`0.6` for placeholders). |
| `axes` | `Sequence[float] | None` | `[0.70, 0.05, 0.29, 0.90]` | Label panel box. |
| `skip_unlabeled` | `bool` | `False` | Skip clusters with no label. |
| `placeholder_text` | `str | None` | `"\\u2014"` | Placeholder label for unlabeled clusters. |
| `placeholder_color` | `str | None` | `"#b22222"` | Placeholder text color. |
| `label_text_pad` | `float | None` | `0.01` | Padding between tracks and text. |
| `label_x` | `float | None` | `0.02` | Left offset for label tracks. |
| `label_gutter_width` | `float | None` | `0.01` | Gutter width between matrix and labels. |
| `label_gutter_color` | `str | None` | `"white"` | Gutter color. |
| `label_sep_color` | `str | None` | `"gray"` | Separator line color. |
| `label_sep_lw` | `float | None` | `0.5` | Separator line width. |
| `label_sep_alpha` | `float | None` | `0.3` | Separator line alpha. |
| `label_sep_xmin` | `float | None` | `auto (label_text_x)` | Separator start x position. |
| `label_sep_xmax` | `float | None` | `1.0` | Separator end x position. |
| `boundary_color` | `str | None` | `"black"` | Cluster boundary color in matrix. |
| `boundary_lw` | `float | None` | `0.5` | Cluster boundary line width in matrix. |
| `boundary_alpha` | `float | None` | `0.6` | Cluster boundary alpha in matrix. |
| `dendro_boundary_color` | `str | None` | `"white"` | Cluster boundary color in dendrogram. |
| `dendro_boundary_lw` | `float | None` | `0.5` | Dendrogram boundary line width. |
| `dendro_boundary_alpha` | `float | None` | `0.3` | Dendrogram boundary alpha. |

Use `overrides` to edit or hide labels per cluster and the `label_*` options to tune gutter and spacing.

Behavior notes:

- Labels are always generated from the attached `Results` object.
- `n` is derived from cluster sizes in the attached layout.
- `label_fields` values outside `{ "label", "n", "p" }` raise `ValueError`.
- Dict-style `overrides` entries require a non-empty `label`.
- If `skip_unlabeled=True`, clusters without labels are omitted instead of receiving placeholder text.

## Label Panel Tracks

### `plot_cluster_bar`

Requires `plot_cluster_labels(...)` in the same plotting chain. Rendering raises
`ValueError` if an enabled cluster bar track is declared without a cluster-label layer.

```python
Plotter.plot_cluster_bar(
    name: str,
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
) -> Plotter
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `str` | required | Track name used for ordering. |
| `kind` | `str` | `"pvalue"` | Only `"pvalue"` is supported. |
| `width` | `float | None` | `0.015` | Track width. |
| `left_pad` | `float` | `0.0` | Left padding in the label panel. |
| `right_pad` | `float` | `0.0` | Right padding in the label panel. |
| `cmap` | `str | Colormap` | `"YlOrBr"` | Colormap name or instance. |
| `norm` | `Normalize | None` | `None` | Normalization for `-log10(p)`. |
| `alpha` | `float` | `0.9` | Bar alpha. |
| `enabled` | `bool` | `True` | Register the track. |
| `title` | `str | None` | `None` | Optional track title. |

### `plot_label_bar`

```python
Plotter.plot_label_bar(
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
    name: str = "label_bar",
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
| `missing_color` | `str | None` | `"#eeeeee"` | Missing-value color. |
| `left_pad` | `float` | `0.0` | Left padding in the label panel. |
| `width` | `float | None` | `0.012` | Track width. |
| `right_pad` | `float` | `0.0` | Right padding in the label panel. |
| `name` | `str` | `"label_bar"` | Track name used for ordering. |
| `title` | `str | None` | `None` | Optional track title. |
| `enabled` | `bool` | `True` | Register the track. |

### Track Order

```python
Plotter.set_label_track_order(order: Sequence[str] | None = None) -> Plotter
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `order` | `Sequence[str] | None` | `declaration order` | Explicit track order. |

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
| `ylabel_pad` | `float | None` | `0.015` | Padding between matrix and y-axis label. |
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
| `labels` | `Sequence[str] | None` | `matrix.df.index (ordered)` | Row labels. |
| `position` | `str` | `"right"` | Tick side: `"left"` or `"right"`. |
| `fontsize` | `float` | `9` | Tick label font size. |
| `max_labels` | `int | None` | `all labels` | Show at most this many labels. |

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
| `labels` | `Sequence[str] | None` | `matrix.df.columns (ordered)` | Column labels. |
| `position` | `str` | `"top"` | Tick side: `"top"` or `"bottom"`. |
| `fontsize` | `float` | `9` | Tick label font size. |
| `rotation` | `float` | `90` | Tick label rotation in degrees. |
| `max_labels` | `int | None` | `all labels` | Show at most this many labels. |

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
| `color` | `str | None` | `"black"` | Tick and label color. |

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
| `nrows` | `int | None` | `auto` | Grid rows. |
| `ncols` | `int | None` | `auto` | Grid columns. |
| `height` | `float` | `0.05` | Total colorbar strip height. |
| `hpad` | `float` | `0.01` | Horizontal spacing between colorbars. |
| `vpad` | `float` | `0.01` | Vertical spacing between colorbars. |
| `gap` | `float` | `0.02` | Gap between matrix and strip. |
| `border_color` | `str | None` | `"black"` | Border color. |
| `border_width` | `float` | `0.8` | Border line width. |
| `border_alpha` | `float` | `1.0` | Border alpha. |
| `fontsize` | `float | None` | `9` | Tick and label font size. |
| `font` | `str | None` | `None` | Tick and label font family. |
| `color` | `str | None` | `"black"` | Tick and label color. |
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
| `sigbar_cmap` | `str | None` | `"YlOrBr"` | Colormap for the legend. |
| `norm` | `Normalize | None` | `None` | Normalization for `-log10(p)`. |
| `sigbar_min_logp` | `float | None` | `2.0` | Lower bound for legend scale. |
| `sigbar_max_logp` | `float | None` | `10.0` | Upper bound for legend scale. |

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
