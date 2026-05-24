# Howler Monkey Genome Project

This repository contains the custom codes, scripts, and computational pipelines utilized in the study: **"The howler monkey genome provides new insights into the distinctive howling and folivorous adaptations of New World monkeys"**.

The workflows are organized systematically to ensure the maximum reproducibility of our genomic, evolutionary, population genetic, and structural bioinformatics analyses.

---

## Repository Structure & Pipeline Overview

### 1. Genome Assembly and Assessment
Contains pipelines for chromosome-level genome assembly, reference-quality scaffolding, comprehensive gene annotation, and multi-dimensional quality control.
* **Genome Assembly:** Scripts and parameter configurations for long-read de novo assembly and Hi-C scaffolding integration.
* **Gene Annotation:** Homology-based and ab initio gene annotation workflows implementing TOGA (Tool for Ortholog Determination-Gained Alignment) and the egapx pipeline.
* **Quality Assessment:** Comprehensive quality validation checking genome completeness via BUSCO and QUAST, calculating k-mer based accuracy and consensus quality via Merqury, and filtering assemblies for structural errors using HMM-Flagger.

### 2. Phylogenomic Analysis
Pipelines for reconstructing the robust species-level phylogenetic framework of New World monkeys.
* **4D Sites Extraction:** Custom scripts to extract four-fold degenerate (4D) sites from whole-genome alignments across target primate taxa.
* **Divergence time estimation.:** MCMCTree input preparation and pipeline for divergence time estimation.

### 3. Population Genetics & Evolutionary Dynamics
Integrated workflows used to infer population-level variations, historical demographic dynamics, reticulate evolution, and locus-specific copy number alterations within the genus Alouatta.
* **Variant Calling (fastq2vcf):** Complete variant calling pipeline encompassing raw short-read quality control, reference genome mapping, variant identification (SNPs/Indels), and stringent hard filtering to output analysis-ready VCF files.
* **Population Tree (populationtree):** Population-level tree reconstruction algorithms and genetic structure analysis matrices to evaluate differentiation across individual samples.
* **Introgression Detection (introgression):** Introgression detection pipelines utilizing Dsuite (ABBA-BABA statistics) to quantify historical gene flow and characterize reticulate evolution dynamics across lineages.
* **Divergence Time Estimation (divergencetime):** Bayesian divergence time estimation workflows using MCMCTree driven by genome-wide four-fold degenerate (4D) site extractions.
* **Locus-Specific Depth Validation (check_FBP1depth):** Custom coverage-depth validation scripts designed to target and calculate locus-specific sequencing depth for the FBP1 gene, confirming regional copy number status associated with specialized metabolic adaptations.

### 4. Conserved Non-coding Elements
Workflows for reference-free alignment, cross-species conservation profiling, and screening for lineage-specific accelerated regulatory elements.
* **Cactus Alignment:** Configuration blueprints for performing large-scale, reference-free whole-genome multiple sequence alignments via ProgressiveCactus.
* **CNE Identification:** Conservation scoring frameworks (utilizing phastCons) to delineate highly Conserved Non-coding Elements (CNEs) while strictly excluding overlapping protein-coding exons.
* **Accelerated CNE Selection:** Custom statistical modeling using phyloP to screen for lineage-specific accelerated evolution within CNEs, identifying candidate regulatory elements underlying specialized phenotypes.

### 5. Gene Evolution & Structural Screening
Molecular adaptation analysis pipelines linking sequence-level evolution (positive/relaxed selection and gene loss) directly to 3D protein structural dynamics.
* **Gene Alignment:** High-throughput, codon-aware multiple sequence alignment (MSA) pipelines for orthologous coding sequences (CDS).
* **PAML Branch-Site Model:** Automated wrappers running the branch-site model in PAML (codeml) to isolate genes undergoing lineage-specific positive selection.
* **HyPhy aBSREL:** Episodic positive selection screening using aBSREL in HyPhy, providing an independent statistical cross-validation for the PAML outcomes.
* **PAML Branch Model:** Branch model configuration matrices in PAML to estimate lineage-specific dN/dS ratios and classify Rapidly Evolving Genes (REGs).
* **Gene Loss Screening:** Custom bioinformatic discovery pipelines to screen for gene loss and pseudogenization events across howler monkey genomes by tracking frameshifts, premature stops, and splice-site disruptions.
* **HyPhy RELAX:** Workflows leveraging the RELAX framework in HyPhy to robustly test whether selective pressures have been significantly relaxed (K < 1) or intensified (K > 1) in lineages experiencing functional pseudogenization.
* **Loss Visualization:** Layout and mapping scripts for plotting the mutational landscapes of pseudogenes, alignment disruption checkpoints, and selection intensity fluctuations across branches.
* **Gene Family Dynamics:** Workflows tracking the expansion, contraction, and overall birth-and-death dynamics of gene families across the primate tree.
* **FoldX & PyMOL Biophysical Evaluation:** Biophysical modeling workflows utilizing FoldX (v5.0) for automated structural relaxation (RepairPDB) and free energy calculation (BuildModel, Delta-Delta G) of positively selected sites (PSS), combined with PyMOL (v2.5) scripts for inter-atomic distance and interface remodeling visualization.

### 6. Functional Enrichment Analysis
Downstream statistical and systems biology frameworks to profile the functional landscape of adaptive and expanded genes.
* **Functional Enrichment:** Custom R scripts leveraging gProfiler to perform automated GO (Gene Ontology) and KEGG pathway enrichment tracking.
* **Tissue Enrichment:** Specialized spatial expression profiling utilizing TissueEnrich to determine the tissue-specific expression landscapes of targeted gene subsets.
* **Enrichment Visualization:** Elegant visualization workflows (generating publication-ready dot plots and interaction networks) highlighting functional annotations of expanded gene families andRichmond positively selected genes (PSGs).

### 7. Structural Variant Analysis
Dedicated structural pipelines for identifying, characterizing, and plotting large-scale genomic structural variations (SVs).
* **Targeted SV Analysis:** Structural variation extraction, mapping, and multi-sequence confirmation tracking the complex locus-level variants altering the CHIA and ASIP genes.
* **SV Mapping Tracks:** Script integration using pygenometracks to generate clean, publication-grade genomic track plots mapping structural variations, read coverages, and feature annotations across comparative loci.

---

