# Annotation Input

Annotations map categorical terms to the labels present in your matrix. HiMaLAYAS filters out labels not present in the matrix and drops terms with no overlap.

## Signature

```python
Annotations(term_to_labels: dict[str, Iterable[str]], matrix: Matrix)
```

## Parameters

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `term_to_labels` | `dict[str, Iterable[str]]` | required | Mapping from term to labels (genes, recipes, proteins). |
| `matrix` | `Matrix` | required | Provides the label universe. |

## Common Attributes

| Attribute | Type | Description |
| --- | --- | --- |
| `annotations.term_to_labels` | `dict[str, set[str]]` | Filtered term-to-label mapping retained on the object after dropping labels not present in the matrix. |

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

- Terms with no overlap are dropped with a warning.
- You can pre-filter terms by size before loading.
