#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow
label: "contig construction and protein prediction"
doc: |
  "This workflow performs construction of metagenomic contigs and prediction protein sequences for metagenomic contigs.
  It executes 2 processes: contig construction and protein prediction.
  related CWL file:
  ./Tools/06_bwa_mem.cwl
  ./Tools/07_samtools_sort.cwl
  ./Tools/08_samtools_flagstat.cwl"

requirements:
  WorkReuse:
    enableReuse: true


inputs:
############## Common Parameters ##############
  - id: THREADS
    type: int
    label: "Threads"
    doc: "Number of threads to use"
    default: 16

############## Parameters for assembling (/Tools/06_bwa_mem.cwl) ##############
  - id: INDEX_BWA_FILENAME
    type: File
    label: "index bwa dir name"
    doc: "directory containig index files for BWA-MEM"
    default:
      class: File
      location: ../out/index_bwa_dir/index_bwa
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa

  - id: FASTQ_1
    type: File
    label: "Forward reads file (_1_trim.fastq.gz)"
    doc: "trimmed metagenomic forward reads file (_1_trim.fastq.gz)"
    default:
      class: File
      location: ../Data/SRR27548858_1_trim.fastq.gz

  - id: FASTQ_2
    type: File
    label: "Reverse reads file (_2_trim.fastq.gz)"
    doc: "trimmed metagenomic reverse reads file (_2_trim.fastq.gz)"
    default:
      class: File
      location: ../Data/SRR27548858_2_trim.fastq.gz

############## Parameters for sorting process (/Tools/07_samtools_sort.cwl) ##############

############## Parameters for statical analysis of bam file (/Tools/08_samtools_flagstat.cwl) ##############


steps:
  - id: BWA_MEM_MAPPING
    run: ../Tools/06_bwa_mem.cwl
    in:
      fastq1: FASTQ_1
      fastq2: FASTQ_2
      index_bwa_dir_name: INDEX_BWA_FILENAME
      threads: THREADS
    out: [sam_file]

  - id: SORTING_SAM2BAM
    run: ../Tools/07_samtools_sort.cwl
    in:
      sam_file: BWA_MEM_MAPPING/sam_file
      threads: THREADS
    out: [bam_file]

  - id: BAM_STATS
    run: ../Tools/08_samtools_flagstat.cwl
    in:
      bam_file: SORTING_SAM2BAM/bam_file
      threads: THREADS
    out: [flagstat_file]

outputs:
  - id: MAPPING_BAM
    type: File
    label: "bam file"
    doc: "sorted bam formated file"
    outputSource: SORTING_SAM2BAM/bam_file

  - id: BAM_FLAGSTAT
    type: File
    label: "flagstat file"
    doc: "flagstat file containing mapping efficiency information"
    outputSource: BAM_STATS/flagstat_file

$namespaces:
  s: https://schema.org/
  edam: https://edamontology.org/
