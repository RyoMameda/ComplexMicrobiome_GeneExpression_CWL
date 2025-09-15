#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.2
label: "seqkit stats process"
doc: |
  "seqkit stats process
  Original script: https://github.com/RyoMameda/workflow/blob/main/03_assembly.sh"

requirements:
  WorkReuse:
    enableReuse: true

baseCommand: [seqkit, stats]

arguments:
  - -a
  - -T
  - $(inputs.input_contigs_fasta_file.path)

inputs:
  - id: input_contigs_fasta_file
    type: File
    label: "Input fasta file"
    doc: "Input fasta file"

outputs:
  - 

hints:
  - class: DockerRequirement
    dockerPull: quay.io/biocontainers/seqkit:2.10.0--h9ee0642_0