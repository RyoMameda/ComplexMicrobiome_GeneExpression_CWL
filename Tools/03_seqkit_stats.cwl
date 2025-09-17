#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.2
label: "seqkit stats process"
doc: |
  "statical analysis of metagenomic contigs using SeqKit
  Checking value to confirm the contigs quality
  Original script: https://github.com/RyoMameda/workflow/blob/main/03_assembly.sh"

requirements:
  WorkReuse:
    enableReuse: true

baseCommand: [seqkit, stats]

arguments:
  # all statics (including quartiles of seq length, sum_gap, N50) will be produced as output
  - -a
  # tabular format output
  - -T
  - $(inputs.input_contigs_fasta_file.path)

inputs:
  - id: input_contigs_fasta_file
    type: File
    label: "Input fasta file"
    doc: "Input metagenomic contigs fasta file"
    default:
      class: File
      location: ../out/all_contigs_SRR27548858.fa

outputs:
  - id: all-for-debugging
    type:
      type: array
      items: [File, Directory]
    outputBinding:
      glob: "*"

stdout: $(inputs.input_contigs_fasta_file.basename).stats.txt

hints:
  - class: DockerRequirement
    dockerPull: quay.io/biocontainers/seqkit:2.10.0--h9ee0642_0

$namespaces:
  s: https://schema.org/
  edam: https://edamontology.org/
