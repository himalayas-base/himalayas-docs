# FAQ and Troubleshooting

## I get "Matrix labels must be unique"

Your DataFrame index has duplicate labels. Ensure the row labels are unique before creating a `Matrix`.

## I get "Matrix values must be numeric"

The DataFrame contains non numeric values. Convert columns to numeric or filter invalid rows.

## I get "No annotation terms overlap matrix labels"

None of the annotation labels are present in the matrix. Double check your identifier system and ensure labels match exactly.

## I get "min_cluster_size exceeds N"

`min_cluster_size` is larger than the number of rows in the matrix. Lower the value or analyze fewer items.

## I get an empty enrichment table

Common causes:

- `min_overlap` is too high.
- Terms are filtered out because they do not overlap with the matrix.
- Your annotations are too sparse or the matrix is too small.

## The plotter raises "Results has no attached ClusterLayout"

Make sure you called `Analysis.finalize()` before plotting. The plotter needs layout metadata.

## Cluster labels look crowded

Try:

- Reducing `max_words` in `plot_cluster_labels`.
- Enabling `wrap_text=True` with a smaller `wrap_width`.
- Increasing figure size or shrinking font size.

If you still have issues, open an issue in the repository with a minimal reproducible example.
