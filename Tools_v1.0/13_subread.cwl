#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.0
label: "counting mapped reads using featureCounts"
doc: |
  "counting mapped reads using featureCounts command in Subread
  Original script: https://github.com/RyoMameda/workflow/blob/main/08_quantification.sh"

requirements:
  WorkReuse:
    enableReuse: true
  InlineJavascriptRequirement: {}

baseCommand: [featureCounts]

arguments:
  - -T
  - $(inputs.threads)
  - -t
  - "CDS"
  - -g
  - "gene_id"
  - -a
  - $(inputs.input_gtf_file)
  - -p
  - $(inputs.input_bam_file)
  - -o
  - $(inputs.input_bam_file.basename.replace(/\.(bam|gz|bz2|fq|fastq)$/, ''))_counts.txt

inputs:
  - id: threads
    type: int
    label: "threads"
    doc: "Number of threads to use"
    default: 16

  - id: input_gtf_file
    type: File
    label: "Input gtf file"
    doc: "gtf formated file which contains annotaion of rRNA, Swiss-Prot and hypothesis proteins for metagenomic predicted proteins"
    default:
      class: File
      location: ../out/all_contigs_SRR27548858_annotation.gtf

  - id: input_bam_file
    type: File
    label: "Input bam file"
    doc: "sorted bam file from mapping process"
    default:
      class: File
      location: ../out/SRR27548858_1_trim_bwa_mem.sam

outputs:
  - id: output_counts_file
    type: File
    label: "read counts txt file"
    doc: "txt file containing mapped read counts to metagenomic predicted protein coding sequences"
    outputBinding:
      glob: $(inputs.input_bam_file.basename.replace(/\.(bam|gz|bz2|fq|fastq)$/, ''))_counts.txt

hints:
  - class: DockerRequirement
    dockerPull: quay.io/biocontainers/subread:2.0.6--he4a0461_0

$namespaces:
  s: https://schema.org/
  edam: https://edamontology.org/
