# HiMaLAYAS Documentation

![Python](https://img.shields.io/badge/python-3.8%2B-yellow)
[![pypiv](https://img.shields.io/pypi/v/himalayas.svg)](https://pypi.python.org/pypi/himalayas)
[![License](https://img.shields.io/badge/license-BSD%203--Clause-blue.svg)](LICENSE)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.18610373.svg)](https://doi.org/10.5281/zenodo.18610373)

This documentation describes Hierarchical Matrix Layout and Annotation Software (HiMaLAYAS), a framework for post hoc enrichment-based annotation of hierarchically clustered matrices. HiMaLAYAS treats dendrogram-defined clusters as statistical units, tests annotation enrichment, and renders significant annotations alongside the matrix. It supports biological and non-biological domains.

- **Full Documentation**: [himalayas-base.github.io/himalayas-docs](https://himalayas-base.github.io/himalayas-docs)
- **Try in Browser (Binder)**: [![Launch in Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/himalayas-base/himalayas-docs/main?filepath=notebooks/quickstart.ipynb)
- **Source Code**: [github.com/himalayas-base/himalayas](https://github.com/himalayas-base/himalayas)

For a full description of HiMaLAYAS and its applications, see:
<br>
Horecka, I., and Röst, H. (2026)
<br>
_HiMaLAYAS: enrichment-based annotation of hierarchically clustered matrices_
<br>
_bioRxiv_. https://doi.org/10.1101/2026.xx.xx.xxxxxx
<br>
Submitted to _Bioinformatics_.

## Yeast Genetic Interaction Matrix Demonstration

HiMaLAYAS is applied to a hierarchically clustered
_Saccharomyces cerevisiae_ genetic interaction profile similarity matrix
(Costanzo _et al_., 2016), focusing on genes with high profile variance.
Dendrogram-defined clusters were tested for Gene Ontology Biological Process
(GO BP; Ashburner _et al_., 2000) enrichment, revealing hierarchical
organization of biological processes.

[![HiMaLAYAS workflow overview](https://imgur.com/SMDInVs.png)](https://imgur.com/SMDInVs.png)
**HiMaLAYAS workflow and application to a hierarchically clustered yeast
genetic interaction profile similarity matrix (Costanzo _et al_., 2016)**.
A real-valued matrix and categorical annotations serve as inputs. The matrix is
cut at a user-defined depth, and each dendrogram-defined cluster is evaluated
for GO BP enrichment.

## Quickstart

**Try in Browser (Binder)**

[![Launch in Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/himalayas-base/himalayas-docs/main?filepath=notebooks/quickstart.ipynb)

**Local Run**

```bash
pip install himalayas jupyter
git clone https://github.com/himalayas-base/himalayas-docs.git
cd himalayas-docs
jupyter notebook
```

Open `notebooks/quickstart.ipynb` in Jupyter.

## Citation

### Primary citation

Horecka, I., and Röst, H. (2026)
<br>
_HiMaLAYAS: enrichment-based annotation of hierarchically clustered matrices_
<br>
_bioRxiv_. https://doi.org/10.1101/2026.xx.xx.xxxxxx
<br>
Submitted to _Bioinformatics_.

### Software archive

HiMaLAYAS software for the manuscript.
<br>
Zenodo. https://doi.org/10.5281/zenodo.18610373

## License

This documentation follows the [BSD 3-Clause License](LICENSE).
