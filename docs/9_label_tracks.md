# Label Tracks and Legends

Label panel tracks let you add cluster-level bars and row-level annotations.

## `plot_cluster_bar` (Significance)

```python
plotter.plot_cluster_bar(
    norm=Normalize(0, 30),
    name="sigbar",
    title="Enrichment",
    values=cluster_labels,
    pval_col="pval",
    width=0.05,
    left_pad=0.06,
    right_pad=0.01,
)
```

Key params: `norm`, `width`, `left_pad`, `right_pad`, `title`.

## `plot_gene_bar` (Row Level)

```python
plotter.plot_gene_bar(
    values=gene_essential_map,
    mode="categorical",
    colors=gene_essential_colors,
    left_pad=0.03,
    width=0.06,
    right_pad=0.00,
    name="essentiality",
    title="Essential",
)
```

Key params: `mode`, `colors`, `left_pad`, `width`, `right_pad`.

## Track Order

```python
plotter.set_label_track_order(("sigbar", "essentiality", "characterization"))
```

## Track Labels

```python
plotter.plot_bar_labels(font="Helvetica", fontsize=14, color="black", pad=4, rotation=90)
```
