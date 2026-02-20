# Installation

HiMaLAYAS is a Python package distributed under the BSD 3-Clause License. You can install from PyPI or from source.

## Install From PyPI

```bash
pip install himalayas
```

## Install From Source

```bash
git clone https://github.com/himalayas-base/himalayas.git
cd himalayas
pip install .
```

For development, use an editable install instead:

```bash
pip install -e .
```

## Verify Installation

```python
import himalayas
print(himalayas.__version__)
```

## Optional Dependencies

HiMaLAYAS works without optional dependencies. The packages below are optional and control performance or text processing behavior.

| Package | Purpose | Behavior if missing |
| --- | --- | --- |
| `fastcluster` (`speed` extra) | Faster hierarchical linkage when `optimal_ordering=False`. | Falls back to SciPy linkage. |
| `nltk` (`text` extra) | Improved tokenization/lemmatization for `label_mode="compressed"`. | Falls back to regex-based tokenization. |

Install optional packages as needed:

```bash
pip install "himalayas[speed]"
pip install "himalayas[text]"
```
