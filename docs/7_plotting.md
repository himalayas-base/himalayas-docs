# Plotting

HiMaLAYAS uses a layered plotting system. Declare layers in order, then render with `show()` or `save()`.

## Signature

```python
Plotter(results: Results) -> Plotter
```

## Parameters

| Parameter | Type | Description |
| --- | --- | --- |
| `results` | `Results` | Results with a matrix and layout from `Analysis.finalize(...)`. |

## Example

```python
from matplotlib.colors import Normalize
from himalayas.plot import Plotter

# Assumes `vlim`, `gene_essential_map`, and `gene_essential_colors` are prepared upstream.
# See `quickstart.html` for the core workflow and `quickstart_advanced.html`
# for rails, legends, and nested zoom extensions.
plotter = (
    Plotter(results)
    .set_background(color="white")
    .plot_title("HiMaLAYAS - Yeast GI Matrix", fontsize=17)
    .plot_dendrogram(axes=[0.06, 0.16, 0.09, 0.79], linewidth=0.75, color="#888888")
    .plot_matrix(cmap="RdBu_r", center=0, vmin=-vlim, vmax=vlim, outer_lw=0)
    .plot_matrix_axis_labels(xlabel="Gene", ylabel="Gene", fontsize=16)
    .set_label_panel(axes=[0.62, 0.16, 0.36, 0.79], text_pad=0.02)
    .plot_cluster_labels(
        rank_by="q",
        label_fields=("label", "q"),
        wrap_text=True,
        wrap_width=40,
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

## Common Methods

| Method | Description |
| --- | --- |
| [`plotter.plot_matrix(...)`](#plot_matrix) | Declares the main matrix heatmap layer. |
| [`plotter.plot_dendrogram(...)`](#plot_dendrogram) | Declares a dendrogram layer aligned to matrix rows. |
| [`plotter.set_label_panel(...)`](#set_label_panel) | Configures shared label-panel geometry for labels and tracks. |
| [`plotter.plot_cluster_labels(...)`](#plot_cluster_labels) | Declares cluster-level labels generated from attached `Results`. |
| [`plotter.plot_cluster_bar(...)`](#plot_cluster_bar) | Declares a cluster-level bar track derived from cluster ranking scores. |
| [`plotter.plot_label_bar(...)`](#plot_label_bar) | Declares a row-level annotation bar track in the label panel. |
| [`plotter.set_label_track_order(...)`](#track-order) | Sets explicit ordering of registered label-panel tracks. |
| [`plotter.plot_bar_labels(...)`](#track-titles) | Declares titles for registered label-panel tracks. |
| [`plotter.plot_title(...)`](#plot_title) | Declares a matrix title layer. |
| [`plotter.plot_matrix_axis_labels(...)`](#plot_matrix_axis_labels) | Declares x-axis and y-axis labels for the matrix panel. |
| [`plotter.plot_row_ticks(...)`](#plot_row_ticks) | Declares row tick labels for the matrix panel. |
| [`plotter.plot_col_ticks(...)`](#plot_col_ticks) | Declares column tick labels for the matrix panel. |
| [`plotter.add_colorbar(...)`](#add_colorbar) | Declares a figure-level colorbar specification. |
| [`plotter.plot_colorbars(...)`](#plot_colorbars) | Declares layout for the bottom colorbar strip. |
| [`plotter.add_label_legend(...)`](#add_label_legend) | Declares a categorical legend block for a row-level label bar. |
| [`plotter.plot_label_legends(...)`](#plot_label_legends) | Declares layout for categorical legend blocks below the colorbar strip or matrix. |
| [`plotter.set_background(...)`](#set_background) | Sets figure background color used for display and save. |
| [`plotter.show()`](#show) | Renders (if needed) and displays the current plot. |
| [`plotter.save(...)`](#save) | Renders (if needed) and saves the current plot. |

## Core Layers

Layers render in declaration order. Later layers draw on top of earlier ones.

### `plot_matrix`

Declares the main matrix heatmap layer.

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
    figsize: Tuple[float, float] | None = None,
    subplots_adjust: Dict[str, float] | None = None,
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
| `subplots_adjust` | `Dict[str, float] | None` | `{"left": 0.15, "right": 0.70, "bottom": 0.05, "top": 0.95}` | Figure margins override. |

Use `center` for diverging color scales and `vmin`/`vmax` for explicit limits.

### `plot_dendrogram`

Declares a dendrogram layer aligned to matrix rows.

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
| `axes` | `Sequence[float] | None` | `[0.06, 0.05, 0.09, 0.90]` | Dendrogram panel box `[x0, y0, w, h]` in figure fraction. |
| `color` | `str | None` | `"#888888"` | Dendrogram line color. |
| `linewidth` | `float | None` | `1.0` | Dendrogram line width. |
| `data_pad` | `float` | `0.25` | Expands y-limits to avoid clipping at the top or bottom. |

### `set_label_panel`

Configures shared label-panel geometry for labels and tracks.

```python
Plotter.set_label_panel(
    *,
    axes: Sequence[float] | None = None,
    track_x: float | None = None,
    gutter_width: float | None = None,
    gutter_color: str | None = None,
    text_pad: float | None = None,
) -> Plotter
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `axes` | `Sequence[float] | None` | `[0.70, 0.05, 0.29, 0.90]` | Label-panel box `[x0, y0, w, h]` in figure fraction. |
| `track_x` | `float | None` | `0.02` | Starting x-position for label-panel tracks (label-panel axes fraction). |
| `gutter_width` | `float | None` | `0.01` | Gutter width before label-panel tracks (label-panel axes fraction). |
| `gutter_color` | `str | None` | `"white"` | Label-panel gutter color. |
| `text_pad` | `float | None` | `0.01` | Padding between tracks and label text (label-panel axes fraction). |

### `plot_cluster_labels`

Declares cluster-level labels generated from attached `Results`.

Labels are generated internally from attached `Results` via `Results.cluster_labels(...)`.
Use `Results.cluster_labels(...)` when you need an explicit post hoc label table for inspection, export, or external workflows, not as a required input to this method.
The list below documents the supported keyword arguments and effective defaults.

```python
Plotter.plot_cluster_labels(
    *,
    overrides: Dict[int, str] | None = None,
    rank_by: str = "p",
    label_mode: str = "top_term",
    max_words: int | None = None,
    label_fields: Tuple[str, ...] | None = ("label", "n", "p"),
    label_prefix: str | None = None,
    wrap_text: bool = True,
    wrap_width: int | None = None,
    overflow: str = "wrap",
    font: str = "Helvetica",
    fontsize: float | None = 9,
    color: str | None = "black",
    alpha: float | None = 0.9,
    skip_unlabeled: bool = False,
    placeholder_text: str | None = "\\u2014",
    placeholder_color: str | None = "#b22222",
    placeholder_alpha: float | None = 0.6,
    omit_words: Sequence[str] | None = None,
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

Defaults shown here are effective user-facing defaults resolved from internal style configuration.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `overrides` | `Dict[int, str] | None` | `None` | Per-cluster label overrides (`cluster_id -> label string`). |
| `rank_by` | `str` | `"p"` | Ranking statistic for representative terms. Must be `"p"` or `"q"`. |
| `label_mode` | `str` | `"top_term"` | One of `"top_term"` or `"compressed"` for internal label generation. |
| `max_words` | `int | None` | `None` | Word-based truncation limit for rendered labels. |
| `label_fields` | `tuple[str, ...] | None` | `("label", "n", "p")` | Fields shown in each label; allowed values are `"label"`, `"n"`, `"p"`, `"q"`, `"fe"`. Use `None` to suppress base label and statistic text. |
| `label_prefix` | `str | None` | `None` | Optional prefix mode for display labels. Supported values are `None`, `"cid"`, and `"alpha"`. |
| `wrap_text` | `bool` | `True` | Enables wrapping logic; wrapping is applied only when `wrap_width` is set. |
| `wrap_width` | `int | None` | `None` | Characters per line when wrapping. |
| `overflow` | `str` | `"wrap"` | Overflow behavior: `"wrap"` or `"ellipsis"`. |
| `font` | `str` | `"Helvetica"` | Label font family. |
| `fontsize` | `float | None` | `9` | Label font size. |
| `color` | `str | None` | `"black"` | Label text color. |
| `alpha` | `float | None` | `0.9` | Label text alpha for regular (non-placeholder) labels. |
| `skip_unlabeled` | `bool` | `False` | Skip clusters with no label. |
| `placeholder_text` | `str | None` | `"\\u2014"` | Placeholder label for unlabeled clusters. |
| `placeholder_color` | `str | None` | `"#b22222"` | Placeholder text color. Falls back to `color`, then default. |
| `placeholder_alpha` | `float | None` | `0.6` | Placeholder text alpha. Falls back to `alpha`, then default. |
| `omit_words` | `Sequence[str] | None` | `None` | Words omitted from rendered label text before formatting. |
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

Use `overrides` to edit labels per cluster. Configure panel geometry with `set_label_panel(...)`.

Behavior notes:

- Labels are always generated from the attached `Results` object.
- Unknown keyword arguments in `plot_cluster_labels(...)` raise `TypeError`.
- With `label_mode="compressed"`, `Results.cluster_labels(...)` applies `max_words` during label generation (default `6` unless overridden). `Plotter.plot_cluster_labels(...)` applies additional Plotter-side truncation only when `max_words` is explicitly provided.
- `label_fields` values outside `{ "label", "n", "p", "q", "fe" }` raise `ValueError`.
- `label_fields=None` suppresses base label and statistic text.
- `label_prefix="cid"` or `label_prefix="alpha"` can prefix labels even when `"label"` is omitted from `label_fields`.
- `label_prefix="alpha"` uses Excel-style indexing (`A.`, `B.`, ..., `Z.`, `AA.`, ...).
- If `skip_unlabeled=True`, clusters without labels are omitted instead of receiving placeholder text.
- Placeholder style resolves as `placeholder_color` -> `color` -> default, and `placeholder_alpha` -> `alpha` -> default.

`label_fields` reference:

- `"label"`: Cluster label text generated by `Results.cluster_labels(...)` using the selected `label_mode`.
- `"n"`: Cluster size (`n`, number of members in the cluster).
- `"p"`: Representative-term hypergeometric p-value (`pval`), formatted as scientific notation.
- `"q"`: Representative-term BH-FDR q-value (`qval`), formatted as scientific notation.
- `"fe"`: Representative-term fold enrichment (`fe`), formatted as `FE=<value>`.
- Field order follows the order you pass in `label_fields` (for example, `("label", "q", "fe")`).

## Label Panel Tracks

### `plot_cluster_bar`

Declares a cluster-level bar track derived from cluster ranking scores.
Bars are scaled from `-log10(score)`, where `score` is the per-cluster statistic
selected by `plot_cluster_labels(rank_by=...)`.

Requires `plot_cluster_labels(...)` in the same plotting chain. Rendering raises
`ValueError` if an enabled cluster bar track is declared without a cluster-label layer.

```python
Plotter.plot_cluster_bar(
    name: str,
    *,
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
| `width` | `float | None` | `0.015` | Track width (label-panel axes fraction). |
| `left_pad` | `float` | `0.0` | Left padding in the label panel (label-panel axes fraction). |
| `right_pad` | `float` | `0.0` | Right padding in the label panel (label-panel axes fraction). |
| `cmap` | `str | Colormap` | `"YlOrBr"` | Colormap name or instance. |
| `norm` | `Normalize | None` | `None` | Normalization for `-log10(score)`. |
| `alpha` | `float` | `0.9` | Bar alpha. |
| `enabled` | `bool` | `True` | Register the track. |
| `title` | `str | None` | `None` | Optional track title. |

### `plot_label_bar`

Declares a row-level annotation bar track in the label panel.

`values` is a mapping from matrix row id to either a category label or a numeric value.
Row-level label tracks can render without `plot_cluster_labels(...)`.

```python
# Categorical example: row_id -> category, plus category -> color.
characterization_map = {
    "YLR088W": "characterized",
    "YBR004C": "characterized",
    "YNL127W": "uncharacterized",
}
characterization_colors = {
    "uncharacterized": "#1e90ff",
    "characterized": "#ffffff",
}

# Continuous example: row_id -> numeric value (e.g., row variance).
row_variance = {
    "YLR088W": 0.82,
    "YBR004C": 0.15,
    "YNL127W": 0.67,
}
# Continuous mode uses `cmap` (and optional `vmin`/`vmax`) instead of `colors`.
```

```python
Plotter.plot_label_bar(
    values: Mapping[Hashable, Any],
    *,
    mode: str = "categorical",
    colors: Dict[Any, Any] | None = None,
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
| `colors` | `Dict[Any, Any] | None` | `None` | Category to color mapping for categorical mode. |
| `cmap` | `str` | `"viridis"` | Colormap for continuous mode. |
| `vmin` | `float | None` | `None` | Minimum for continuous mode normalization. |
| `vmax` | `float | None` | `None` | Maximum for continuous mode normalization. |
| `missing_color` | `str | None` | `"#eeeeee"` | Missing-value color. |
| `left_pad` | `float` | `0.0` | Left padding in the label panel (label-panel axes fraction). |
| `width` | `float | None` | `0.012` | Track width (label-panel axes fraction). |
| `right_pad` | `float` | `0.0` | Right padding in the label panel (label-panel axes fraction). |
| `name` | `str` | `"label_bar"` | Track name used for ordering. |
| `title` | `str | None` | `None` | Optional track title. |
| `enabled` | `bool` | `True` | Register the track. |

### Track Order

Sets explicit ordering of registered label-panel tracks.

```python
Plotter.set_label_track_order(order: Sequence[str] | None = None) -> Plotter
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `order` | `Sequence[str] | None` | `declaration order` | Explicit track order. |

### Track Titles

Declares titles for registered label-panel tracks.

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

Declares a matrix title layer.

```python
Plotter.plot_title(
    title: str,
    *,
    fontsize: float | None = None,
    font: str | None = None,
    pad: float | None = None,
    color: str | None = None,
    alpha: float | None = None,
    **kwargs,
) -> Plotter
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `title` | `str` | required | Title text. |
| `fontsize` | `float | None` | `14` | Title font size. |
| `font` | `str | None` | `None` | Title font family. |
| `pad` | `float | None` | `15` | Padding above the plot (points). |
| `color` | `str | None` | `"black"` | Title color. |
| `alpha` | `float | None` | `None` | Title text alpha. |

`**kwargs` are forwarded to Matplotlib title text kwargs.

### `plot_matrix_axis_labels`

Declares x-axis and y-axis labels for the matrix panel.

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
| `xlabel_pad` | `float` | `8` | Padding for the x-axis label (points). |
| `ylabel_pad` | `float | None` | `0.015` | Offset between matrix and y-axis label axes (figure fraction). |
| `font` | `str | None` | `None` | Font family for axis labels. |
| `color` | `str | None` | `"black"` | Axis label color. |
| `alpha` | `float` | `1.0` | Axis label alpha. |

### `plot_row_ticks`

Declares row tick labels for the matrix panel.

```python
Plotter.plot_row_ticks(
    labels: Sequence[str] | None = None,
    *,
    position: str = "right",
    fontsize: float = 9,
    max_labels: int | None = None,
    pad: float | None = None,
) -> Plotter
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `labels` | `Sequence[str] | None` | `matrix.df.index (ordered)` | Row labels. |
| `position` | `str` | `"right"` | Tick side: `"left"` or `"right"`. |
| `fontsize` | `float` | `9` | Tick label font size. |
| `max_labels` | `int | None` | `all labels` | Show at most this many labels. |
| `pad` | `float | None` | `Matplotlib default` | Tick-label padding (points). |

### `plot_col_ticks`

Declares column tick labels for the matrix panel.

```python
Plotter.plot_col_ticks(
    labels: Sequence[str] | None = None,
    *,
    position: str = "top",
    fontsize: float = 9,
    rotation: float = 90,
    max_labels: int | None = None,
    pad: float | None = None,
) -> Plotter
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `labels` | `Sequence[str] | None` | `matrix.df.columns (ordered)` | Column labels. |
| `position` | `str` | `"top"` | Tick side: `"top"` or `"bottom"`. |
| `fontsize` | `float` | `9` | Tick label font size. |
| `rotation` | `float` | `90` | Tick label rotation in degrees. |
| `max_labels` | `int | None` | `all labels` | Show at most this many labels. |
| `pad` | `float | None` | `Matplotlib default` | Tick-label padding (points). |

## Colorbars

### `add_colorbar`

Declares a figure-level colorbar specification.

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

Declares layout for the bottom colorbar strip.

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
    label_pad: float = 2.0,
    tick_decimals: int | None = None,
) -> Plotter
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `nrows` | `int | None` | `auto` | Grid rows. |
| `ncols` | `int | None` | `auto` | Grid columns. |
| `height` | `float` | `0.05` | Total colorbar strip height (figure fraction). |
| `hpad` | `float` | `0.01` | Horizontal spacing between colorbars (figure fraction). |
| `vpad` | `float` | `0.01` | Vertical spacing between colorbars (figure fraction). |
| `gap` | `float` | `0.02` | Gap between matrix and strip (figure fraction). |
| `border_color` | `str | None` | `"black"` | Border color. |
| `border_width` | `float` | `0.8` | Border line width. |
| `border_alpha` | `float` | `1.0` | Border alpha. |
| `fontsize` | `float | None` | `9` | Tick and label font size. |
| `font` | `str | None` | `None` | Tick and label font family. |
| `color` | `str | None` | `"black"` | Tick and label color. |
| `label_position` | `str` | `"below"` | Label placement: `"below"` or `"above"`. |
| `label_pad` | `float` | `2.0` | Padding between colorbar and label text (points). |
| `tick_decimals` | `int | None` | `None` | Maximum decimal places for colorbar ticks; trailing zeros are trimmed. |

### `add_label_legend`

Declares a categorical legend block for a row-level label bar.
The referenced track must be declared with `plot_label_bar(..., mode="categorical")`.

```python
Plotter.add_label_legend(
    *,
    name: str,
    title: str | None = None,
    nrows: int | None = None,
    ncols: int | None = None,
    row_pad: float | None = None,
    col_pad: float | None = None,
    show_only_present: bool = True,
) -> Plotter
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `str` | required | Name of the row-level categorical track to explain. |
| `title` | `str | None` | `None` | Legend title override. Falls back to track title, then `name`. |
| `nrows` | `int | None` | `None` | Legend grid rows. If `None`, inferred from `ncols`. |
| `ncols` | `int | None` | `None` | Legend grid columns. If `None`, inferred from `nrows`. |
| `row_pad` | `float | None` | `None` | Vertical spacing between item rows (block-relative fraction). Renderer default is `0.02` for multi-row legends and `0.0` for one row. |
| `col_pad` | `float | None` | `None` | Horizontal spacing between items in a row (block-relative fraction). Renderer default is `0.02` for multi-column legends and `0.0` for one column. |
| `show_only_present` | `bool` | `True` | If `True`, includes only categories present in plotted matrix rows. |

Behavior notes:

- Referenced legend `name` must exist and must be a row-level label bar.
- The referenced track must use `mode="categorical"`.
- A non-empty category color mapping is required on the referenced track.
- Duplicate legend declarations for the same `name` raise `ValueError`.
- Legends with no items after filtering are skipped.

### `plot_label_legends`

Declares layout for categorical legend blocks.
Legends render below the colorbar strip when colorbars exist; otherwise below the matrix.

```python
Plotter.plot_label_legends(
    *,
    height: float = 0.08,
    gap: float = 0.01,
    vpad: float = 0.01,
    title_pad: float = 2.0,
    swatch_scale: float = 0.75,
    fontsize: float | None = None,
    font: str | None = None,
    color: str | None = None,
) -> Plotter
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `height` | `float` | `0.08` | Total legend strip height (figure fraction). |
| `gap` | `float` | `0.01` | Gap from the anchor strip above (figure fraction). |
| `vpad` | `float` | `0.01` | Vertical spacing between legend blocks (figure fraction). |
| `title_pad` | `float` | `2.0` | Padding between legend title and items (points). |
| `swatch_scale` | `float` | `0.75` | Relative swatch size inside each legend cell. |
| `fontsize` | `float | None` | `9` | Legend font size. |
| `font` | `str | None` | `None` | Legend font family. |
| `color` | `str | None` | `"black"` | Legend text color. |

```python
plotter = (
    Plotter(results)
    .plot_label_bar(
        name="compound_category",
        values=gene_compound_map,
        mode="categorical",
        colors=gene_compound_colors,
        missing_color="#ffffff",
        width=0.04,
        left_pad=0.02,
    )
    .add_label_legend(
        name="compound_category",
        title="Compound category",
        show_only_present=True,
    )
    .plot_label_legends(
        height=0.04,
        gap=0.005,
        vpad=0.008,
        title_pad=2.0,
    )
)
```

## Rendering

### `set_background`

Sets figure background color used for display and save.

```python
Plotter.set_background(color: str) -> Plotter
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `color` | `str` | required | Figure background color for display and save. |

### `show`

Renders (if needed) and displays the current plot.

```python
Plotter.show() -> None
```

### `save`

Renders (if needed) and saves the current plot.

```python
Plotter.save(
    path: str | PathLike[str],
    *,
    dpi: float | None = None,
    format: str | None = None,
    bbox_inches: str | None = None,
    pad_inches: float | None = None,
    transparent: bool | None = None,
    **kwargs,
) -> None
```

`**kwargs` are passed to Matplotlib `savefig`.

## Notes

- `Plotter` expects `Results` with layout from `Analysis.finalize(...)`.
- Unit convention: text spacing uses points (`plot_title(pad=...)`, `plot_bar_labels(pad=...)`, `plot_matrix_axis_labels(xlabel_pad=...)`, `plot_row_ticks(pad=...)`, `plot_col_ticks(pad=...)`, `plot_colorbars(label_pad=...)`); layout geometry uses fractions (`height`, `gap`, `hpad`, `vpad`, `left_pad`, `right_pad`, `width`, `axes`, `track_x`, `gutter_width`, `text_pad`). `ylabel_pad` is also a geometry fraction (panel offset).
