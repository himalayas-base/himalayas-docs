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

## Development Tutorials

The tutorials on the `v0.0.17` documentation branch use APIs added after 0.0.16. Clone that documentation branch and install its `requirements.txt`, which pins an immutable HiMaLAYAS source commit until 0.0.17 is released. Start Jupyter in `notebooks/` so the bundled data paths resolve. See the [repository instructions](https://github.com/himalayas-base/himalayas-docs/tree/v0.0.17#quickstart) for local source overrides and HTML regeneration. Installing the current PyPI release alone does not select this development tutorial environment.

## Verify Installation

```python
import himalayas
print(himalayas.__version__)
```

## Required Dependencies

HiMaLAYAS requires `scikit-learn` (used to select a threshold when `linkage_threshold="auto"`). It is installed automatically with `pip install himalayas`.

## Optional Dependencies

HiMaLAYAS works without optional dependencies. The packages below are optional and control performance or text processing behavior.

| Package | Purpose | Behavior if missing |
| --- | --- | --- |
| `fastcluster` (`speed` extra) | Faster hierarchical linkage when `optimal_ordering=False`. | Falls back to SciPy linkage. |
| `nltk` (`text` extra) | Improved tokenization and lemmatization for `label_mode="compressed"`. | Falls back to regex-based tokenization. |

Install optional packages as needed:

```bash
pip install "himalayas[speed]"
pip install "himalayas[text]"
```
