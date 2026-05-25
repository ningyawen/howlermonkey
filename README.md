# Howler Monkey Genome Project

This repository contains the custom codes, scripts, and computational pipelines utilized in the study: **"The howler monkey genome provides new insights into the distinctive howling and folivorous adaptations of New World monkeys"**.

The workflows are organized systematically to ensure the maximum reproducibility of our genomic, evolutionary, population genetic, and structural bioinformatics analyses.

---

## Repository Structure & Pipeline Overview

### 1. Genome Assembly and Assessment
Contains pipelines for de novo genome assembly,comprehensive gene annotation, and multi-dimensional quality control.
* **Genome Assembly:** Scripts and parameter configurations for long-read de novo assembly.
* **Gene Annotation:** Homology-based and ab initio gene annotation workflows implementing TOGA and the egapx pipeline.
* **Quality Assessment:** Comprehensive quality validation checking genome completeness via BUSCO and QUAST, calculating k-mer based accuracy and consensus quality via Merqury, and filtering assemblies for structural errors using HMM-Flagger.

### 2. Phylogenomic Analysis
Pipelines for reconstructing a robust species-level phylogenetic tree.
* **4D Sites Extraction:** Custom scripts to extract four-fold degenerate (4D) sites from whole-genome alignments across target primate taxa.
* **Divergence time estimation.:** MCMCTree input preparation and pipeline for divergence time estimation.

### 3. Population Genetics & Evolutionary Dynamics
Integrated workflows used to infer population-level species tree, introgression, within the genus Alouatta.
* **Variant Calling:** Complete variant calling pipeline encompassing raw short-read quality control, reference genome mapping, variant identification (SNPs/Indels), and stringent hard filtering to output analysis-ready VCF files.
* **Population Phylogeny:** Pipelines for reconstructing phylogenetic relationships and assessing genetic structure within the genus Alouatta.
* **Introgression Detection:** Pipelines based on Dsuite to detect historical introgression and gene flow among Alouatta lineages.
* **Divergence Time Estimation:** Divergence time estimation with Alouatta genus using MCMCTree driven by genome-wide four-fold degenerate (4D) site extractions

### 4. Conserved Non-coding Elements
Workflows for reference-free alignment, cross-species conservation profiling, and screening for lineage-specific accelerated regulatory elements.
* **Cactus Alignment:** Configuration blueprints for performing large-scale, reference-free whole-genome multiple sequence alignments via Cactus.
* **CNE Identification:** Conservation scoring frameworks (utilizing phastCons) to delineate highly Conserved Non-coding Elements (CNEs).
* **Accelerated CNE Selection:** Using phyloP to screen for lineage-specific accelerated evolution within CNEs, identifying candidate regulatory elements underlying specialized phenotypes.
* **Accelerated CNE Annotation:** Annotation of lineage-accelerated CNEs using the online tool GREAT to identify associated genes and potential functional enrichment.

### 5. Gene Evolution
Evolutionary genomics workflows for investigating coding-sequence evolution, including positive selection, relaxed selection, rapid evolution, gene loss, and gene family dynamics across primates and howler monkeys.
* **Gene Alignment:** Multiple sequence alignment (MSA) pipelines for orthologous coding sequences (CDS).
* **PAML Branch-Site Model:** Using the branch-site model in PAML (codeml) to isolate genes undergoing lineage-specific positive selection.
* **HyPhy aBSREL:** Episodic positive selection screening using aBSREL in HyPhy, providing an independent statistical cross-validation for the PAML outcomes.
* **PAML Branch Model:** Branch model configuration matrices in PAML to estimate lineage-specific dN/dS ratios and classify Rapidly Evolving Genes (REGs).
* **Gene Loss Screening:** Screen for gene loss across howler monkey genomes.
* **HyPhy RELAX:** Workflows leveraging the RELAX framework in HyPhy to robustly test whether selective pressures have been significantly relaxed (K < 1) or intensified (K > 1).
* **Gene Family Dynamics:** Workflows tracking the expansion, contraction, and overall birth-and-death dynamics of gene families across the primate tree.
* **FoldX & PyMOL Biophysical Evaluation:** Biophysical modeling workflows utilizing FoldX (v5.0) for automated structural relaxation (RepairPDB) and free energy calculation (BuildModel, Delta-Delta G) of positively selected sites (PSS), combined with PyMOL scripts for inter-atomic distance and interface remodeling visualization.

### 6. Functional Enrichment Analysis
Downstream statistical and systems biology frameworks to profile the functional landscape of adaptive and expanded genes.
* **Functional Enrichment:** Custom R scripts leveraging gProfiler to perform automated GO (Gene Ontology) and KEGG pathway enrichment tracking.
* **Tissue Enrichment:** Specialized spatial expression profiling utilizing TissueEnrich to determine the tissue-specific expression landscapes of targeted gene subsets.

### 7. Structural Variant Analysis
Dedicated structural pipelines for identifying, characterizing, and plotting large-scale genomic structural variations (SVs).
* **Targeted SV Analysis:** Structural variation extraction, mapping, and multi-sequence confirmation tracking the complex locus-level variants altering the CHIA and ASIP genes.
* **SV Mapping Tracks:** Script integration using pygenometracks to generate clean, publication-grade genomic track plots mapping structural variations, read coverages, and feature annotations across comparative loci.

---

