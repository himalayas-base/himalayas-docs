# Condensed Dendrogram

The condensed dendrogram summarizes clusters while preserving the original dendrogram order and branch heights. Labels are generated internally from `Results.cluster_labels(...)`.
`plot_dendrogram_condensed(...)` returns a rendered handle (`CondensedDendrogramPlot`) with explicit `show()` and `save()` methods.

## Signature

```python
plot_dendrogram_condensed(
    results: Results,
    *,
    term_col: str = "term",
    cluster_col: str = "cluster",
    weight_col: str = "pval",
    label_mode: str = "top_term",
    label_col: str | None = "term_name",
    summary_max_words: int = 6,
    figsize: Sequence[float] = (10, 10),
    sigbar_cmap: str | Colormap = "YlOrBr",
    sigbar_min_logp: float = 2.0,
    sigbar_max_logp: float = 10.0,
    sigbar_norm: Normalize | None = None,
    sigbar_width: float = 0.06,
    sigbar_height: float = 0.8,
    sigbar_alpha: float = 1.0,
    font: str = "Helvetica",
    fontsize: float = 9,
    max_words: int | None = None,
    wrap_text: bool = True,
    wrap_width: int | None = None,
    overflow: str = "wrap",
    omit_words: Sequence[str] | None = None,
    label_fields: Sequence[str] = ("label", "n", "p"),
    label_overrides: dict[int, str] | None = None,
    label_color: str = "black",
    label_alpha: float = 1.0,
    label_fontweight: str = "normal",
    dendrogram_color: str = "black",
    dendrogram_lw: float = 1.0,
    label_left_pad: float = 0.02,
    background_color: str | None = None,
) -> CondensedDendrogramPlot
```

## Parameters

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `results` | `Results` | required | Results exposing `cluster_layout()` and `clusters`. |
| `term_col` | `str` | `"term"` | Term id column used during internal label generation. |
| `cluster_col` | `str` | `"cluster"` | Cluster id column used during internal label generation. |
| `weight_col` | `str` | `"pval"` | Weight/p-value column used during internal label generation. |
| `label_mode` | `str` | `"top_term"` | One of `"top_term"` or `"compressed"` for internal label generation. |
| `label_col` | `str | None` | `"term_name"` | Optional display-name column for internal label generation. |
| `summary_max_words` | `int` | `6` | Max words used by internal `"compressed"` label summarization. |
| `figsize` | `Sequence[float]` | `(10, 10)` | Figure size (width, height). |
| `sigbar_cmap` | `str / Colormap` | `"YlOrBr"` | Colormap for the significance bar. |
| `sigbar_min_logp` | `float` | `2.0` | Minimum `-log10(p)` for scaling. |
| `sigbar_max_logp` | `float` | `10.0` | Maximum `-log10(p)` for scaling. |
| `sigbar_norm` | `Normalize | None` | `None` | Optional normalization; overrides min/max scaling. |
| `sigbar_width` | `float` | `0.06` | Significance bar width (axes fraction). |
| `sigbar_height` | `float` | `0.8` | Height of each significance bar relative to row pitch. Must be in `(0, 1]`. |
| `sigbar_alpha` | `float` | `1.0` | Significance bar alpha. |
| `font` | `str` | `"Helvetica"` | Label font family. |
| `fontsize` | `float` | `9` | Label font size. |
| `max_words` | `int | None` | `None` | Truncate labels to this word count. |
| `wrap_text` | `bool` | `True` | Wrap long labels. |
| `wrap_width` | `int | None` | `None` | Characters per line when wrapping. |
| `overflow` | `str` | `"wrap"` | Overflow behavior: `"wrap"` or `"ellipsis"`. |
| `omit_words` | `Sequence[str] | None` | `None` | Words to omit from label text. |
| `label_fields` | `Sequence[str]` | `("label", "n", "p")` | Label fields to include. |
| `label_overrides` | `dict[int, str] | None` | `None` | Mapping `cluster_id -> label` for custom names. |
| `label_color` | `str` | `"black"` | Label text color. |
| `label_alpha` | `float` | `1.0` | Label text alpha. |
| `label_fontweight` | `str` | `"normal"` | Label font weight. |
| `dendrogram_color` | `str` | `"black"` | Dendrogram line color. |
| `dendrogram_lw` | `float` | `1.0` | Dendrogram line width. |
| `label_left_pad` | `float` | `0.02` | Left padding for labels (axes fraction). |
| `background_color` | `str | None` | `None` | Figure and axes background color. |

## Return Handle

```python
CondensedDendrogramPlot
```

| Property / Method | Type | Description |
| --- | --- | --- |
| `fig` | `matplotlib.figure.Figure` | Rendered figure handle. |
| `ax_den` | `matplotlib.axes.Axes` | Dendrogram axis. |
| `ax_sig` | `matplotlib.axes.Axes` | Significance bar axis. |
| `ax_txt` | `matplotlib.axes.Axes` | Label text axis. |
| `show()` | `() -> None` | Displays the rendered figure. Raises `RuntimeError` if the figure was closed. |
| `save(path, **kwargs)` | `(str | PathLike[str], **kwargs) -> None` | Saves the rendered figure with current facecolor. Raises `RuntimeError` if the figure was closed. |

## Example

```python
from himalayas.plot import plot_dendrogram_condensed

condensed = plot_dendrogram_condensed(
    results,
    figsize=(6, 10),
    sigbar_min_logp=2.0,
    sigbar_max_logp=10.0,
    label_fields=("label", "n", "p"),
    wrap_text=True,
    wrap_width=34,
)

condensed.show()
```

## Example (Zoom Results)

After a zoom analysis, you can summarize the zoomed hierarchy with the same function:

```python
condensed = plot_dendrogram_condensed(
    zoom_results,
    figsize=(4, 8),
    sigbar_min_logp=0.0,
    sigbar_max_logp=30.0,
    label_fields=("label", "n"),
    wrap_text=True,
    wrap_width=30,
)

condensed.save("zoom_condensed_dendrogram.png", dpi=300)
```

## Notes

- Labels are generated internally from the attached `Results` object.
- `label_fields` must be a subset of `{ "label", "n", "p" }`.
- Use `Results.cluster_labels(...)` only for inspection/export/custom workflows, not as required input.
