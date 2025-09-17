
![GitHub last commit (branch)](https://img.shields.io/github/last-commit/RyoMameda/workflow_cwl/main)
![Status](https://img.shields.io/badge/status-development-yellow)
[![cwltool](https://img.shields.io/badge/cwltool-3.1.20250110105449-success)](https://github.com/common-workflow-language/cwltool/releases/tag/3.1.20250110105449)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)
[![Open in Dev Containers](https://img.shields.io/static/v1?label=Dev%20Containers&message=python3.11&color=blue&logo=docker)](https://github.com/yonesora56/plant2human/tree/main/.devcontainer)

# Gene Expression Analysis Workflow in Complex Microbiomes

### based shell script & python script

GitHub: https://github.com/RyoMameda/workflow

&nbsp;

### Minimum Requirements

- `Docker`
- `cwltool`

&nbsp;

### Test dataset

- Please place it in the `Data` directory!

#### Metagenome data

- [SRR27548858](https://www.ncbi.nlm.nih.gov/sra/?term=SRR27548858)

#### Metatranscriptome data

- [SRR27548863](https://www.ncbi.nlm.nih.gov/sra/?term=SRR27548863)
- [SRR27548864](https://www.ncbi.nlm.nih.gov/sra/?term=SRR27548864)
- [SRR27548865](https://www.ncbi.nlm.nih.gov/sra/?term=SRR27548865)

&nbsp;

### Data to be prepared in advance

- Please place it in the `Data` directory!

```bash

# reference rRNA data

# Swiss-Prot data from UniProt using
curl -O https://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.fasta.gz
# making BLASTP index files
pigz -d uniprot_sprot.fasta.gz

# Pfam data from InterPro
curl -O https://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.hmm.gz
```


&nbsp;

### Analysis Workflow Article

[Optimization of Mapping Tools and Investigation of Ribosomal RNA Influence for Data-Driven Gene Expression Analysis in Complex Microbiomes](https://doi.org/10.3390/microorganisms13050995)