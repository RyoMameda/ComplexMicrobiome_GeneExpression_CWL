#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.2
label: "metagenome assembly process using MEGAHIT"
doc: |
  "metagenome assembly process using MEGAHIT
  Input files are trimmed metagenomic fastq which obtained from 00_fastp.cwl, the metagenomic contigs are outputs.
  Original script: https://github.com/RyoMameda/workflow/blob/main/03_assembly.sh"

baseCommand: [megahit]

arguments:
  - -1
  - $(inputs.fastq_1.path)
  - -2
  - $(inputs.fastq_2.path)
  - -o
  - $(inputs.output_dir_name)
  - -t
  - $(inputs.threads)

inputs:
  - id: fastq_1
    type: File
    label: "Forward reads file (_1_trim.fastq.gz)"
    doc: "trimmed metagenomic forward reads file (_1_trim.fastq.gz)"
    default:
      class: File
      location: ../Data/SRR27548858_1_trim.fastq.gz
  - id: fastq_2
    type: File
    label: "Reverse reads file (_2_trim.fastq.gz)"
    doc: "trimmed metagenomic reverse reads file (_2_trim.fastq.gz)"
    default:
      class: File
      location: ../Data/SRR27548858_2_trim.fastq.gz
  - id: output_dir_name
    type: string
    label: "Output directory name (e.g., contig${sample_name})"
    doc: "Output directory name (e.g., contig${sample_name}), you should not make the directory before execution."
    default: "contigs_megahit"
  - id: threads
    type: int
    label: "Number of threads to use"
    doc: "Number of threads to use"
    default: 8

outputs:
  - id: final_contigs_fasta_file
    type: File
    label: "Final contigs fasta file"
    doc: "Final metagenomic contigs fasta file"
    outputBinding:
      glob: "$(inputs.output_dir_name)/final.contigs.fa"

hints:
  - class: DockerRequirement
    dockerPull: quay.io/biocontainers/megahit:1.2.6--h8b12597_0

$namespaces:
  s: https://schema.org/
  edam: https://edamontology.org/
