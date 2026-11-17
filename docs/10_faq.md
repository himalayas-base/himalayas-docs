# FAQ and Troubleshooting

## Where can I find a full end-to-end example?

Use either notebook based on depth:

- Quickstart: [HTML](quickstart.html) | [Binder](https://mybinder.org/v2/gh/himalayas-base/himalayas-docs/main?filepath=notebooks/quickstart.ipynb)
- Advanced Quickstart: [HTML](quickstart_advanced.html) | [Binder](https://mybinder.org/v2/gh/himalayas-base/himalayas-docs/main?filepath=notebooks/quickstart_advanced.ipynb)

## I get "Matrix labels must be unique"

Your DataFrame index has duplicate labels. Ensure the row labels are unique before creating a `Matrix`.

## I get "Matrix values must be numeric"

The DataFrame contains non-numeric values. Convert columns to numeric or filter invalid rows.

## I get "No annotation terms overlap matrix labels"

None of the annotation labels are present in the matrix. Double-check your identifier system and ensure labels match exactly.

## Annotation terms were dropped unexpectedly

HiMaLAYAS filters term labels to matrix labels, then applies term-size filters in `Annotations(...)`.

- Terms with overlap below `min_term_size` are dropped.
- Terms above `max_term_size` are dropped when `max_term_size` is set.

## I get "min_cluster_size exceeds N"

`min_cluster_size` is larger than the number of rows in the matrix. Lower the value or analyze fewer items.

## I get an empty enrichment table

Common causes:

- `min_overlap` is too high.
- Terms are filtered out because they do not overlap with the matrix.
- Your annotations are too sparse or the matrix is too small.
- With `merge_small_clusters=False`, clusters smaller than `min_cluster_size` are excluded from enrichment reporting by design.

## How do I choose between `global` and `per_cluster` q-values?

Set scope in `Analysis.finalize(fdr_scope=...)`:

- `fdr_scope="global"` (default): BH across all cluster-term tests in the run.
- `fdr_scope="per_cluster"`: BH independently within each cluster.

Use `"global"` for full-run interpretation and `"per_cluster"` for within-cluster interpretation.

## Why do zoomed q-values differ from full-run q-values even with shared background?

`background=...` aligns the enrichment universe and helps make p-values comparable.
q-values can still differ because Benjamini-Hochberg FDR is applied over the hypothesis family tested in each run.

If you need directly comparable FDR across views, compute and store a separate "global q" from a single master hypothesis family.

## Clustering is slower than expected

When `optimal_ordering=False`, HiMaLAYAS uses `fastcluster` if installed and otherwise falls back to SciPy linkage. Installing the `speed` extra can improve clustering speed in this mode.

When `optimal_ordering=True`, SciPy optimal ordering is used and can be slower on larger matrices.

```bash
pip install "himalayas[speed]"
```

## Compressed labels differ across environments

`Results.cluster_labels(label_mode="compressed")` uses NLTK tokenization and lemmatization when available and falls back to regex tokenization when NLTK resources are unavailable.

Install the text extra to enable NLTK support:

```bash
pip install "himalayas[text]"
```

## The plotter raises "Results has no attached ClusterLayout"

Make sure you called `Analysis.finalize(...)` before plotting. The plotter needs layout metadata.

## Cluster labels look crowded

Try:

- Reducing `max_words` in `plot_cluster_labels`.
- Enabling `wrap_text=True` with a smaller `wrap_width`.
- Increasing figure size or shrinking font size.

## I called `plot_dendrogram_condensed(...)` but no figure appears

`plot_dendrogram_condensed(...)` returns a `CondensedDendrogramPlot` handle. Call `.show()` to display it or `.save(...)` to write it to disk.

```python
condensed = plot_dendrogram_condensed(results)
condensed.show()
```

## My bar titles do not appear

Titles are drawn only when `plotter.plot_bar_labels(...)` is declared. Each bar supplies its text through `title=`, and `plot_bar_labels(...)` turns the titles on and sets their font, size, and offset. This applies to row bars (`plot_label_bar`) and column bars (`plot_col_label_bar`).

## I get "plot_col_dendrogram() requires Analysis.finalize(col_cluster=True, col_dendrogram=True)"

The column tree needs the column linkage, which is kept only on request. Finalize with both flags:

```python
analysis.finalize(col_cluster=True, col_dendrogram=True)
```

## The column dendrogram or column bars are cut off or crowded

By default they sit in the empty space above the matrix, which fits the tree or one bar. For more, lower the top of the matrix and give the row dendrogram and label panel the same top. See [`plot_col_dendrogram`](7_plotting.md#plot_col_dendrogram).

## The legend overlaps the colorbar labels

Colorbar labels hang below the colorbar strip. Raise `gap` in `plot_label_legends(...)`, for example `plot_label_legends(gap=0.045)`.

## Results differ slightly between installs on tied data

When distances tie exactly, as in 0/1 matrices, the merge order is not unique, and SciPy and `fastcluster` can break ties differently. Tree shape and cluster boundaries can then differ between installs. Continuous data rarely ties. Pin the same environment, or install the `speed` extra everywhere, when exact reproducibility matters.

## How do I load gene sets from a GMT file?

Use `Annotations.from_gmt("terms.gmt", matrix)`. See [Annotation Input](3_annotation_input.md#from_gmt).

If you still have issues, open an issue in the repository with a minimal reproducible example.
