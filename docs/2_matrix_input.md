# Matrix Input

A `Matrix` wraps a numeric `pandas.DataFrame` and validates labels and values. This is the primary input for clustering and plotting.

## Signature

```python
Matrix(df: pd.DataFrame, *, axis: str = "rows")
```

## Parameters

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `df` | `pd.DataFrame` | required | Numeric matrix with labeled rows. Row labels become the matrix label universe. |
| `axis` | `str` | `"rows"` | Orientation of labels. Use `"rows"` for standard usage. Reserved for column-labeled use cases. |

## Example

```python
import pandas as pd
from himalayas import Matrix

DF = pd.read_csv("data/gi_pcc_sampled.tsv", sep="\t", index_col=0)

matrix = Matrix(DF)
print(matrix.values.shape)
print(matrix.labels[:5])
```

## Example (Stacked / Long Matrix Table)

If your matrix is stored as three columns (`row_id`, `col_id`, `value`), pivot it first:

```python
import pandas as pd
from himalayas import Matrix

stacked_df = pd.DataFrame(
    {
        "row_id": ["GENE_A", "GENE_A", "GENE_B", "GENE_B", "GENE_C"],
        "col_id": ["GENE_A", "GENE_B", "GENE_A", "GENE_C", "GENE_C"],
        "value": [1.00, 0.42, 0.42, -0.30, 1.00],
    }
)

matrix_df = stacked_df.pivot_table(
    index="row_id",
    columns="col_id",
    values="value",
    aggfunc="mean",  # If duplicates exist for the same row/col pair, average them.
)

# Build a square matrix over the full label universe.
labels = sorted(set(matrix_df.index).union(matrix_df.columns))
DF = matrix_df.reindex(index=labels, columns=labels)

# Choose how to handle missing row/col pairs for your data.
DF = DF.fillna(0.0)

matrix = Matrix(DF)
```

## Common Errors

- `Matrix must have at least one row and one column` if the DataFrame is empty.
- `Matrix labels must be unique` if the index has duplicates.
- `Matrix values must be numeric` if any entries are non-numeric.

## Notes

- Missing values should be handled before creating `Matrix`.
- Matrix symmetry and normalization are user-defined; HiMaLAYAS does not enforce them.
