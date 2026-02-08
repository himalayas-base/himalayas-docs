# HiMaLAYAS Documentation

<img src="https://i.imgur.com/zEIr4gB.png" width="25%" align="left" style="margin-right: 1.5em;">

Hierarchical Matrix Layout and Annotation Software (HiMaLAYAS) is a framework for post hoc enrichment-based annotation of hierarchically clustered matrices. It treats dendrogram-defined clusters as statistical units, tests enrichment against categorical annotations, and renders significant labels alongside the matrix.

Use this documentation to get set up, run an analysis, and build visualizations.

## Start Here

- [Introduction](0_introduction.md)
- [Installation](1_installation.md)

## Notebook Walkthrough

- [Quickstart (HTML)](quickstart.html)

## Core Workflow

1. Load a real-valued matrix into `Matrix`.
2. Load term-to-label annotations into `Annotations`.
3. Run `Analysis.cluster()` and `Analysis.enrich()`.
4. Call `Analysis.finalize()` to attach layout and optional q-values (Benjamini-Hochberg FDR-adjusted p-values).
5. Plot with `Plotter` and summarize clusters.

## Use Cases

- Annotate clustered matrices for biological or non-biological data.
- Zoom into a cluster and rerun enrichment on the subset.
