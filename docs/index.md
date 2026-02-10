# HiMaLAYAS Documentation

<div class="home-hero">
  <img src="https://i.imgur.com/zEIr4gB.png" alt="HiMaLAYAS logo" />
  <p>
    <b>Hierarchical Matrix Layout and Annotation Software</b> (<b>HiMaLAYAS</b>) is a framework
    for post hoc enrichment-based annotation of hierarchically clustered matrices.
    It treats dendrogram-defined clusters as statistical units, tests annotation
    enrichment, and renders significant annotations alongside the matrix. HiMaLAYAS
    supports biological and non-biological domains.
  </p>
</div>

This documentation walks through installation, workflows, and examples using HiMaLAYAS.

## Start Here

- [Introduction](0_introduction.md)
- [Installation](1_installation.md)

## Notebook Walkthrough

- [Quickstart Notebook (HTML)](quickstart.html)
- [Run Quickstart in Binder](https://mybinder.org/v2/gh/himalayas-base/himalayas-docs/HEAD?filepath=notebooks/quickstart.ipynb)

## Core Workflow

1. Load a real-valued matrix into `Matrix`.
2. Load term-to-label annotations into `Annotations`.
3. Run `Analysis.cluster()` and `Analysis.enrich()`.
4. Call `Analysis.finalize()` to attach layout and optional q-values (Benjamini-Hochberg FDR-adjusted p-values).
5. Plot with `Plotter` and summarize clusters.

## Use Cases

- Annotate clustered matrices for biological or non-biological data.
- Zoom into a cluster and rerun enrichment on the subset.

## Citation

For a full description of HiMaLAYAS and its applications, see:

Horecka, I., and Röst, H. (2026)
<br>
_HiMaLAYAS: enrichment-based annotation of hierarchically clustered matrices_
<br>
_bioRxiv_. [https://doi.org/10.1101/2026.xx.xx.xxxxxx](https://doi.org/10.1101/2026.xx.xx.xxxxxx)
<br>
Under review at _Bioinformatics_.
