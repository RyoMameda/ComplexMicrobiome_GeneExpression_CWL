#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.2
label: "metagenome assembly process using megahit"
doc: |
  "metagenome assembly process using megahit
  Original script: https://github.com/RyoMameda/workflow/blob/main/03_assembly.sh"

requirements:
  ShellCommandRequirement: {}
  WorkReuse:
    enableReuse: true

inputs:
  - id: fastq_1
    type: File
    label: "Forward reads file (_1_trim.fastq.gz)"
    doc: "genomic forward reads file (_1_trim.fastq.gz)"
    default:
      class: File
      location: ../Data/SRR27548858_1_trim.fastq.gz
  - id: fastq_2
    type: File
    label: "Reverse reads file (_2_trim.fastq.gz)"
    doc: "genomic reverse reads file (_2_trim.fastq.gz)"
    default:
      class: File
      location: ../Data/SRR27548858_2_trim.fastq.gz
  - id: output_dir_name
    type: string
    label: "Output directory name (e.g., contig${sample_name})"
    doc: "Output directory name (e.g., contig${sample_name})"
    default: "contigs_megahit"
  - id: threads
    type: int
    label: "Number of threads to use"
    doc: "Number of threads to use"
    default: 16


arguments:
  - shellQuote: false
    valueFrom: |
      megahit -1 $(inputs.fastq_1.path) -2 $(inputs.fastq_2.path) -o $(inputs.output_dir_name) -t $(inputs.threads)

outputs:
  - id: all-for-debugging
    type:
      type: array
      items: [File, Directory]
    outputBinding:
      glob: "*"

hints:
  - class: DockerRequirement
    dockerPull: quay.io/biocontainers/megahit:1.2.6--h8b12597_0