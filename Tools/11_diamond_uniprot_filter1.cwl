#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.2
label: "diamond result file filter"
doc: |
  "extracting sequence IDs of Swiss-Prot annotated predicted protein sequences
  original script: scripts/07_annotation_modified.sh
  original command: awk '!x[$1]++' ${f}-rRNA_uniprot.txt | cut -f1 | sort > ${f}-rRNA_uniprot_toplist.txt"

requirements:
  ShellCommandRequirement: {}
  InlineJavascriptRequirement: {}
  WorkReuse:
    enableReuse: true

inputs:
  - id: diamond_alignment_result_file
    type: File
    label: "diamond alignment result file"
    doc: "text file containing annotaion of Swiss-Prot using DIAMOND"
    default:
      class: File
      location: ../out/diamond_alignment.txt

arguments:
  - shellQuote: false
    valueFrom: |
      awk '!x[$1]++' $(inputs.diamond_alignment_result_file.path) | cut -f1 | sort > $(inputs.diamond_alignment_result_file.basename.replace(/\.txt$/, ''))_toplist.txt

outputs:
  # - id: all-for-debugging
  #   type:
  #     type: array
  #     items: [File, Directory]
  #   outputBinding:
  #     glob: "*"

  - id: diamond_alignment_file
    type: File
    label: "diamond alignment file"
    doc: "the sequence IDs of Swiss-Prot annotated predicted protein sequences"
    outputBinding:
      glob: $(inputs.diamond_alignment_result_file.basename.replace(/\.txt$/, ''))_toplist.txt


hints:
  - class: DockerRequirement
    dockerPull: quay.io/biocontainers/gawk:5.1.0--2

$namespaces:
  s: https://schema.org/
  edam: https://edamontology.org/
