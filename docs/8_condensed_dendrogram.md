# Condensed Dendrogram

The condensed dendrogram summarizes clusters while preserving the original dendrogram order and branch heights. Labels are generated internally from `Results.cluster_labels(...)`.
`plot_dendrogram_condensed(...)` returns a rendered handle (`CondensedDendrogramPlot`) with explicit `show()` and `save()` methods.

## Signature

```python
plot_dendrogram_condensed(
    results: Results,
    *,
    rank_by: str = "p",
    label_mode: str = "top_term",
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
    label_fields: Sequence[str] | None = ("label", "n", "p"),
    label_prefix: str | None = None,
    label_overrides: dict[int, str] | None = None,
    label_color: str = "black",
    label_alpha: float = 1.0,
    placeholder_text: str = "—",
    placeholder_color: str | None = None,
    placeholder_alpha: float | None = None,
    skip_unlabeled: bool = False,
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
| `results` | `Results` | required | Results from `Analysis.finalize(...)`. |
| `rank_by` | `str` | `"p"` | Ranking statistic for representative terms. Must be `"p"` or `"q"`. |
| `label_mode` | `str` | `"top_term"` | One of `"top_term"` or `"compressed"` for internal label generation. |
| `figsize` | `Sequence[float]` | `(10, 10)` | Figure size (width, height). |
| `sigbar_cmap` | `str / Colormap` | `"YlOrBr"` | Colormap for the significance bar. |
| `sigbar_min_logp` | `float` | `2.0` | Minimum `-log10(score)` for scaling. |
| `sigbar_max_logp` | `float` | `10.0` | Maximum `-log10(score)` for scaling. |
| `sigbar_norm` | `Normalize | None` | `None` | Optional normalization; overrides minimum and maximum scaling. |
| `sigbar_width` | `float` | `0.06` | Significance bar width (axes fraction). |
| `sigbar_height` | `float` | `0.8` | Height of each significance bar relative to row pitch. Must be in `(0, 1]`. |
| `sigbar_alpha` | `float` | `1.0` | Significance bar alpha. |
| `font` | `str` | `"Helvetica"` | Label font family. |
| `fontsize` | `float` | `9` | Label font size. |
| `max_words` | `int | None` | `None` | Word-based truncation limit for labels. |
| `wrap_text` | `bool` | `True` | Wrap long labels. |
| `wrap_width` | `int | None` | `None` | Characters per line when wrapping. |
| `overflow` | `str` | `"wrap"` | Overflow behavior: `"wrap"` or `"ellipsis"`. |
| `omit_words` | `Sequence[str] | None` | `None` | Words to omit from label text. |
| `label_fields` | `Sequence[str] | None` | `("label", "n", "p")` | Label fields to include; allowed values are `"label"`, `"n"`, `"p"`, `"q"`, `"fe"`. Use `None` to suppress base label and statistic text. |
| `label_prefix` | `str | None` | `None` | Optional prefix mode for display labels. Supported values are `None`, `"cid"`, and `"alpha"`. |
| `label_overrides` | `dict[int, str] | None` | `None` | Mapping `cluster_id -> label` for custom names. |
| `label_color` | `str` | `"black"` | Label text color. |
| `label_alpha` | `float` | `1.0` | Label text alpha for regular (non-placeholder) labels. |
| `placeholder_text` | `str` | `"—"` | Placeholder label for unlabeled clusters. |
| `placeholder_color` | `str | None` | `None` | Placeholder text color. Falls back to `label_color`, then default. |
| `placeholder_alpha` | `float | None` | `None` | Placeholder text alpha. Falls back to `label_alpha`, then default. |
| `skip_unlabeled` | `bool` | `False` | Skip clusters with no label. |
| `label_fontweight` | `str` | `"normal"` | Label font weight. |
| `dendrogram_color` | `str` | `"black"` | Dendrogram line color. |
| `dendrogram_lw` | `float` | `1.0` | Dendrogram line width. |
| `label_left_pad` | `float` | `0.02` | Left padding for labels (axes fraction). |
| `background_color` | `str | None` | `None` | Figure and axes background color. |

Use `label_overrides` to specify custom labels per cluster.

Behavior notes:

- Labels are always generated from the attached `Results` object.
- Unknown keyword arguments in `plot_dendrogram_condensed(...)` raise `TypeError`.
- `label_fields` values outside `{ "label", "n", "p", "q", "fe" }` raise `ValueError`.
- `label_fields=None` is allowed.
- `label_prefix="cid"` or `label_prefix="alpha"` can prefix labels even when `"label"` is omitted from `label_fields`.
- `label_prefix="alpha"` uses Excel-style indexing (`A.`, `B.`, ..., `Z.`, `AA.`, ...).
- Cluster significance bars are scaled from `-log10(score)`, where `score` is selected by `rank_by`.
- If `skip_unlabeled=True`, clusters without labels are omitted instead of receiving placeholder text.
- Placeholder style resolves as `placeholder_color` -> `label_color`, and `placeholder_alpha` -> `label_alpha`.
- Placeholder styling applies only to unlabeled or placeholder cluster labels.
- Condensed plotting requires at least two clusters; single-cluster inputs raise a `ValueError`.

`label_fields` reference:

- `"label"`: Cluster label text generated by `Results.cluster_labels(...)` using the selected `label_mode`.
- `"n"`: Cluster size (`n`, number of members in the cluster).
- `"p"`: Representative-term hypergeometric p-value (`pval`), formatted as scientific notation.
- `"q"`: Representative-term BH-FDR q-value (`qval`), formatted as scientific notation.
- `"fe"`: Representative-term fold enrichment (`fe`), formatted as `FE=<value>`.
- Field order follows the order you pass in `label_fields` (for example, `("label", "q", "fe")`).

## Return Handle

```python
CondensedDendrogramPlot
```

| Property / Method | Type | Description |
| --- | --- | --- |
| `fig` | `matplotlib.figure.Figure` | Rendered figure handle. |
| `show()` | `() -> None` | Displays the rendered figure. If the backing figure was closed, it is rebuilt automatically from the stored render specification. |
| `save(path, **kwargs)` | `(str | PathLike[str], **kwargs) -> None` | Saves the rendered figure with current facecolor. If the backing figure was closed, it is rebuilt automatically before saving. |

## Example

```python
from himalayas.plot import plot_dendrogram_condensed

condensed = plot_dendrogram_condensed(
    results,
    rank_by="q",
    figsize=(6, 10),
    sigbar_min_logp=2.0,
    sigbar_max_logp=10.0,
    label_fields=("label", "n", "p", "q"),
    wrap_text=True,
    wrap_width=40,
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
    wrap_width=40,
)

condensed.save("zoom_condensed_dendrogram.png", dpi=300)
```

## Notes

- Labels are generated internally from the attached `Results` object.
- `label_fields` may be `None` or a subset of `{ "label", "n", "p", "q", "fe" }`.
- `label_prefix` supports `None`, `"cid"`, and `"alpha"`.
- Use `Results.cluster_labels(...)` only for inspection, export, or external workflows, not as required input.
