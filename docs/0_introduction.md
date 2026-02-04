# Introduction

HiMaLAYAS is a general framework for post hoc enrichment-based annotation of hierarchically clustered matrices. It treats dendrogram-defined clusters as statistical units and maps significant terms back onto the matrix for visualization.

## Core Ideas

- Hierarchical clustering organizes rows into contiguous regions that can be treated as clusters.
- Enrichment is tested on those clusters, not on the full dendrogram alone.
- Significant terms are rendered alongside their cluster spans for interpretation.
- The workflow is domain-agnostic as long as you have a matrix and categorical annotations.
- Enrichment can be evaluated at different dendrogram depths by changing the cut threshold.

## Typical Use Cases

- Yeast genetic interaction matrices (Costanzo et al., 2016) with GO Biological Process enrichment.
- Expression similarity matrices with pathway enrichment.
- Non-biological matrices such as recipe by ingredient similarity with country of origin enrichment.

## The Minimal Object Graph

- `Matrix`: validated, labeled numeric matrix used for clustering and plotting.
- `Annotations`: term-to-label mapping aligned to the matrix label universe.
- `Analysis`: orchestrates clustering, enrichment, and layout.
- `Results`: stores enrichment output and attached context for plotting.
- `Plotter`: builds layered figures.
