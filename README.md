
![GitHub last commit (branch)](https://img.shields.io/github/last-commit/RyoMameda/workflow_cwl/main)
![Status](https://img.shields.io/badge/status-development-yellow)
[![cwltool](https://img.shields.io/badge/cwltool-3.1.20250110105449-success)](https://github.com/common-workflow-language/cwltool/releases/tag/3.1.20250110105449)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)
[![Open in Dev Containers](https://img.shields.io/static/v1?label=Dev%20Containers&message=python3.11&color=blue&logo=docker)](https://github.com/yonesora56/plant2human/tree/main/.devcontainer)

# Gene Expression Analysis Workflow in Complex Microbiomes (work-in-progress)

&nbsp;

## Workflow Schema 
- more details: [Optimization of Mapping Tools and Investigation of Ribosomal RNA Influence for Data-Driven Gene Expression Analysis in Complex Microbiomes](https://doi.org/10.3390/microorganisms13050995)

![image](./image/microorganisms-13-00995-g001.png)

&nbsp;

## Progress in Workflow Implementation

![CWLization](./image/workflow_cwlization.png)

&nbsp;

### 1. based shell script & python script

GitHub: https://github.com/RyoMameda/workflow

&nbsp;

### 2. Minimum Requirements

- `Docker`
- `cwltool`

&nbsp;

### 3. Test dataset

- If you are testing with the following files, please place them in the `Data` directory!
- 

#### Metagenome data

- [SRR27548858](https://www.ncbi.nlm.nih.gov/sra/?term=SRR27548858)

#### Metatranscriptome data

- [SRR27548863](https://www.ncbi.nlm.nih.gov/sra/?term=SRR27548863)
- [SRR27548864](https://www.ncbi.nlm.nih.gov/sra/?term=SRR27548864)
- [SRR27548865](https://www.ncbi.nlm.nih.gov/sra/?term=SRR27548865)

&nbsp;

### 4. Data to be prepared in advance except FASTQ files

```bash
# rRNA data from SILVA website (release138.1; accessed on 17,September,2025)
curl -O https://ftp.arb-silva.de/release_138.1/Exports/SILVA_138.1_LSUParc_tax_silva.fasta.gz
curl -O https://ftp.arb-silva.de/release_138.1/Exports/SILVA_138.1_SSUParc_tax_silva.fasta.gz

# Swiss-Prot data from UniProt for diamond makedb process (accessed on 17,September,2025)
curl -O https://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.fasta.gz

# Pfam data from InterPro (accessed on 17,September,2025)) for hmmscan proess (on going)
# curl -O https://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.hmm.gz
```

&nbsp;

### 5. Workflow Component

This analysis workflow is broadly divided into two components: one for processing metagenome data and another for processing metatranscriptome data.
These two components are still under development, but our goal is to eventually combine them and create them as an analysis workflow.

&nbsp;

#### Metagenomic analysis workflow

In this process, the following steps are performed:


1. Trimming using `fastp`
2. Assembly process using `megahit`. 
3. Prediction Protein sequences using `prodigal`.
4. Mapping process using `bwa mem`.
5. Annotation using `BLAST`, `diamond`, `custom python script`.
6. Calculation of GPM (Genes per million)

&nbsp;

#### Metatranscriptomic analysis workflow

In this process, the following steps are performed:

1. Trimming using `fastp`
2. Mapping process using `bwa mem`.
3. Counted mapped reads using `Subread`
4. Calculation of TPM (Transcripts per million)

&nbsp;

### 6. Command Execution (sub-workflow)

```bash
# annotation sub-workflow
# Download the metagenome FASTQ files, then run processing with fastp, megahit, and prodigal before proceeding with this operation.

cwltool --debug --outdir <output directory> ./Worlkflow/annotation_sw.cwl ./config/annotation_sw_test_config.yml

# mapping sub-workflow
cwltool --debug --outdir <output directory> ./Worlkflow/metagenomic_contig_mapping_sw.cwl 

```


### Analysis Workflow Article

[Optimization of Mapping Tools and Investigation of Ribosomal RNA Influence for Data-Driven Gene Expression Analysis in Complex Microbiomes](https://doi.org/10.3390/microorganisms13050995)