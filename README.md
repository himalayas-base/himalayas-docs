# HiMaLAYAS Documentation

![Python](https://img.shields.io/badge/python-3.8%2B-yellow)
[![pypiv](https://img.shields.io/pypi/v/himalayas.svg)](https://pypi.python.org/pypi/himalayas)
[![License](https://img.shields.io/badge/license-BSD%203--Clause-blue.svg)](LICENSE)

This documentation describes Hierarchical Matrix Layout and Annotation Software (HiMaLAYAS), a framework for post hoc enrichment-based annotation of hierarchically clustered matrices. HiMaLAYAS treats dendrogram-defined clusters as statistical units, evaluates enrichment, and maps significant terms onto the clustered matrix. It supports biological and non-biological domains.

- **Full Documentation**: https://himalayas-base.github.io/himalayas-docs
- **Try in Browser (Binder)**: https://mybinder.org/v2/gh/himalayas-base/himalayas-docs/HEAD?filepath=notebooks/quickstart.ipynb
- **Source Code**: https://github.com/himalayas-base/himalayas

For a full description of HiMaLAYAS and its applications, see:
<br>
**Horecka, I. and Rost, H. (unpublished)**.
_HiMaLAYAS: enrichment-based annotation of hierarchically clustered matrices_.
Manuscript in preparation.

## Yeast Genetic Interaction Matrix Demonstration

We apply HiMaLAYAS to a hierarchically clustered _Saccharomyces cerevisiae_ genetic interaction profile similarity matrix (Costanzo et al., 2016), focusing on genes with high profile variance. Dendrogram-defined clusters are evaluated for Gene Ontology Biological Process (GO BP) enrichment, revealing hierarchical organization of biological processes.

[![HiMaLAYAS workflow overview](https://i.imgur.com/mninW8a.jpeg)](https://i.imgur.com/mninW8a.jpeg)
**HiMaLAYAS workflow and application to a hierarchically clustered yeast genetic interaction profile similarity matrix (Costanzo et al., 2016).** A real-valued matrix and categorical annotations serve as inputs; the matrix is hierarchically clustered to produce a dendrogram, which is cut at a user-defined depth to identify clusters. Each dendrogram-defined cluster is evaluated for GO Biological Process enrichment, and significant enrichments are mapped onto the clustered matrix. The application focuses on ~1,100 genes with high profile variance, where each entry represents Pearson-correlation similarity between genetic interaction profiles, and the condensed dendrogram summarizes the same hierarchy.

## Quickstart

**Try in Browser (Binder)**

[![Launch in Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/himalayas-base/himalayas-docs/HEAD?filepath=notebooks/quickstart.ipynb)

**Local Run**

```bash
pip install himalayas jupyter
git clone https://github.com/himalayas-base/himalayas-docs.git
cd himalayas-docs
jupyter notebook
```

Open `notebooks/quickstart.ipynb` in Jupyter.

## Citation

### Manuscript (unpublished)

**Horecka, I. and Rost, H.**
_HiMaLAYAS: enrichment-based annotation of hierarchically clustered matrices_.
Manuscript in preparation.

### Zenodo

No Zenodo archive is available yet.

## License

This documentation follows the [BSD 3-Clause License](LICENSE).
