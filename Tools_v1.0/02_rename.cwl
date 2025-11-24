#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.0
label: "rename process"
doc: |
  "assembled contig rename process"

requirements:
  WorkReuse:
    enableReuse: true

baseCommand: [cp]

arguments:
  - $(inputs.input_contigs_fasta_file.path)
  - $(inputs.output_contigs_fasta_file_name)

inputs:
  - id: input_contigs_fasta_file
    type: File
    label: "Input contigs fasta file"
    doc: "Input contigs fasta file"
    default:
      class: File
      location: ../contigs_megahit/final.contigs.fa
  - id: output_contigs_fasta_file_name
    type: string
    label: "Output contigs fasta file name"
    doc: "Output contigs fasta file name"
    default: "all_contigs_SRR27548858.fa"

outputs:
  - id: output_contigs_fasta_file
    type: File
    label: "Output contigs fasta file"
    doc: "Output contigs fasta file"
    outputBinding:
      glob: "$(inputs.output_contigs_fasta_file_name)"

hints:
  - class: DockerRequirement
    dockerPull: quay.io/biocontainers/ubuntu:24.04

$namespaces:
  s: https://schema.org/
  edam: https://edamontology.org/
