# Annotation Input

Annotations map categorical terms to labels present in your matrix. HiMaLAYAS filters labels to the matrix universe, then applies term-size filters.

## Signature

```python
Annotations(
    term_to_labels: dict[str, Iterable[str]],
    matrix: Matrix,
    *,
    min_term_size: int = 2,
    max_term_size: int | None = None,
)
```

## Parameters

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `term_to_labels` | `dict[str, Iterable[str]]` | required | Mapping from term to labels (genes, recipes, proteins). |
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
Labels must match matrix row labels exactly.

## Common Attributes

| Attribute | Type | Description |
| --- | --- | --- |
| `annotations.matrix_labels` | `set[str]` | Matrix label universe used to filter incoming annotation labels. |
| `annotations.term_to_labels` | `dict[str, set[str]]` | Filtered term-to-label mapping retained on the object after dropping labels not present in the matrix. |

## Common Methods

```python
Annotations.terms -> list[str]
Annotations.rebind(matrix: Matrix) -> Annotations
```

| Method | Description |
| --- | --- |
| `annotations.terms` | Returns retained annotation terms after overlap filtering. |
| `annotations.rebind(matrix)` | Returns a new `Annotations` object aligned to a new matrix label universe (useful for zoom and subset workflows). |

## `terms`

```python
Annotations.terms -> list[str]
```

Returns retained annotation terms after overlap filtering.

## `rebind`

```python
Annotations.rebind(matrix: Matrix) -> Annotations
```

Returns a new `Annotations` object aligned to a new matrix label universe.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `matrix` | `Matrix` | required | New matrix whose label universe will be used to re-filter terms. |

## Example (GO Biological Process)

```python
import json
from himalayas import Annotations

with open("data/go_bp_name_to_orfs.json", "r", encoding="utf-8") as fh:
    go_bp = json.load(fh)

annotations = Annotations(go_bp, matrix)
```

## Example (Country to Recipes)

```python
country_to_recipes = {
    "Italy": ["r_001", "r_105", "r_214"],
    "India": ["r_002", "r_003"],
}

annotations = Annotations(country_to_recipes, matrix)
```

## Common Errors

- `Labels for term ... must be an iterable of labels` if a term maps to a string.
- `No annotation terms overlap matrix labels` if none of the labels match the matrix.

## Notes

- Terms are filtered by matrix overlap and term size limits.
- Keep `min_term_size=2` as the default floor for analysis-ready runs.
