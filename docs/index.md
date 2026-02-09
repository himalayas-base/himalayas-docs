# HiMaLAYAS Documentation

<div class="home-hero">
  <img src="https://i.imgur.com/zEIr4gB.png" alt="HiMaLAYAS logo" />
  <p>
    Hierarchical Matrix Layout and Annotation Software (HiMaLAYAS) is a framework
    for post hoc enrichment-based annotation of hierarchically clustered matrices.
    It treats dendrogram-defined clusters as statistical units, tests enrichment
    against categorical annotations, and renders significant labels alongside the
    matrix.
  </p>
</div>

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
