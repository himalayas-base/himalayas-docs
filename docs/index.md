# HiMaLAYAS Documentation

Hierarchical Matrix Layout and Annotation Software (HiMaLAYAS) is a framework for post hoc enrichment-based annotation of hierarchically clustered matrices. It treats dendrogram-defined clusters as statistical units, tests enrichment against categorical annotations, and renders significant labels alongside the matrix.

Use this documentation to get set up, run an analysis, and build publication-ready visualizations.

## Start Here

- [Introduction](0_introduction.md)
- [Installation](1_installation.md)
- [Quickstart (HTML)](quickstart.html)

## Core Workflow

1. Load a real-valued matrix into `Matrix`.
2. Load term-to-label annotations into `Annotations`.
3. Run `Analysis.cluster()` and `Analysis.enrich()`.
4. Call `Analysis.finalize()` to attach layout and optional q-values.
5. Summarize clusters and plot with `Plotter`.

## What You Can Build

- Enrichment-annotated clustered matrices for gene interaction or expression data.
- Cluster-specific zoom analyses that re-run enrichment on a subset.
- Non-biological analyses (for example, recipes by ingredient similarity).

If you want a full walkthrough, start with [Quickstart (HTML)](quickstart.html). The source notebook lives at `notebooks/quickstart.ipynb` in the repository.
