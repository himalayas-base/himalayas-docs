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

## Common Errors

- `Matrix must have at least one row and one column` if the DataFrame is empty.
- `Matrix labels must be unique` if the index has duplicates.
- `Matrix values must be numeric` if any entries are non-numeric.

## Notes

- Missing values should be handled before creating `Matrix`.
- Matrix symmetry and normalization are user-defined; HiMaLAYAS does not enforce them.
