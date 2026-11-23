# Annotation Input

Annotations map categorical terms to labels present in your matrix. HiMaLAYAS filters labels to the matrix universe, then applies term-size filters.

## Signature

```python
Annotations(
    term_to_labels: Dict[str, Iterable[str]],
    matrix: Matrix,
    *,
    min_term_size: int = 2,
    max_term_size: int | None = None,
)
```

## Parameters

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `term_to_labels` | `Dict[str, Iterable[str]]` | required | Mapping from term to labels (genes, sectors, proteins). |
| `matrix` | `Matrix` | required | Provides the label universe. |
| `min_term_size` | `int` | `2` | Minimum number of matrix-overlapping labels required for a term to be retained. |
| `max_term_size` | `int | None` | `None` | Maximum number of matrix-overlapping labels allowed for a term to be retained. |

## Expected Mapping Format

```python
term_to_labels = {
    "mitochondrion inheritance": ["GEM1", "PTC1", "ARP2", "ADY3"],
    "vacuole inheritance": ["VPS15", "VAC17", "PEP7", "VPS3"],
}
```

Each key is an annotation term, and each value is a list of matrix label IDs.
Labels must match matrix row labels exactly. Terms can come from other GO categories, pathway memberships, protein complexes, cell-type markers, or experimental metadata; the input remains a term-to-label mapping. The [basic quickstart comparison](quickstart.html#Annotate-the-same-clusters-with-other-GO-categories) applies BP, CC and MF to the same yeast clusters.

## Common Attributes

| Attribute | Type | Description |
| --- | --- | --- |
| `annotations.matrix_labels` | `set[str]` | Matrix label universe used to filter incoming annotation labels. |
| `annotations.term_to_labels` | `Dict[str, set[str]]` | Filtered term-to-label mapping retained on the object after dropping labels not present in the matrix. |

## Common Methods

```python
Annotations.from_gmt(path, matrix, *, min_term_size=2, max_term_size=None) -> Annotations
Annotations.terms -> List[str]
Annotations.rebind(matrix: Matrix) -> Annotations
Annotations.to_gmt(path) -> None
```

| Method | Description |
| --- | --- |
| `Annotations.from_gmt(path, matrix, ...)` | Builds an `Annotations` object from a GMT gene-set file. |
| `annotations.terms` | Returns retained annotation terms after overlap filtering. |
| `annotations.rebind(matrix)` | Returns a new `Annotations` object aligned to a new matrix label universe (useful for zoom and subset workflows). |
| `annotations.to_gmt(path)` | Writes the retained terms to a GMT file. |

## `terms`

```python
Annotations.terms -> List[str]
```

Returns retained annotation terms after overlap filtering.

## `rebind`

```python
Annotations.rebind(matrix: Matrix) -> Annotations
```

Returns a new `Annotations` object aligned to a new matrix label universe. Rebinding starts from the currently visible terms and memberships, so repeated subsets preserve stepwise term selection. Original source memberships for those candidate terms remain available for enrichment with an explicit larger background. A term dropped from the visible mapping cannot become a candidate for a later rebind.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `matrix` | `Matrix` | required | New matrix whose label universe will be used to re-filter terms. |

## `from_gmt`

```python
Annotations.from_gmt(
    path: str | PathLike,
    matrix: Matrix,
    *,
    min_term_size: int = 2,
    max_term_size: int | None = None,
) -> Annotations
```

Builds an `Annotations` object from a GMT gene-set file, the format used by MSigDB and most enrichment tools. Each line holds a term name, a description, and the term's labels, separated by tabs. The description is ignored, and blank lines are skipped.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `str | PathLike` | required | Path to the GMT file. |
| `matrix` | `Matrix` | required | Provides the label universe. |
| `min_term_size` | `int` | `2` | Same as in `Annotations(...)`. |
| `max_term_size` | `int | None` | `None` | Same as in `Annotations(...)`. |

Raises `ValueError` for a line without a name, a description, and at least one label, for a repeated term name, and for a file with no terms.

## `to_gmt`

```python
Annotations.to_gmt(path: str | PathLike) -> None
```

Writes the retained terms to a GMT file. Each description is `-`, and the labels of each term are sorted. Only labels present in the matrix are written. Raises `ValueError` if a term or label contains a tab or a line break, which GMT cannot hold.

## Example (GO Biological Process)

Use the [bundled BP mapping](https://raw.githubusercontent.com/himalayas-base/himalayas-docs/v0.0.17/notebooks/data/go_bp_name_to_orfs.json) with the matrix loaded in [Matrix Input](2_matrix_input.md#example). Run from `himalayas-docs/notebooks` so `data/` points to the bundled inputs.

```python
import json
from himalayas import Annotations

with open("data/go_bp_name_to_orfs.json", "r", encoding="utf-8") as fh:
    go_bp = json.load(fh)

annotations = Annotations(go_bp, matrix)
```

## Example (Country to Sectors)

```python
country_to_sectors = {
    "Germany": ["DEU | Manufacturing", "DEU | Transport"],
    "Japan": ["JPN | Manufacturing", "JPN | Finance"],
}

annotations = Annotations(country_to_sectors, matrix)
```

## Example (GMT File)

```python
from himalayas import Annotations

annotations = Annotations.from_gmt("data/go_bp.gmt", matrix)

# Save the terms that remain after filtering to the matrix.
annotations.to_gmt("outputs/go_bp_in_matrix.gmt")
```

## Common Errors

- `Labels for term ... must be an iterable of labels` if a term maps to a string.
- `No annotation terms overlap matrix labels` if none of the labels match the matrix.
- `Line N: a GMT line needs a name, a description, and labels` if a GMT line is missing a field.
- `Line N: duplicate term ...` if a GMT file repeats a term name.

## Notes

- Terms are filtered by matrix overlap and term size limits.
- Keep `min_term_size=2` as the default floor for analysis-ready runs.
- `min_term_size` is independent from `Analysis.enrich(min_overlap=...)`; the two are not kept in sync.
