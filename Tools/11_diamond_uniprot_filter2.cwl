#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.2
label: "diamond result file filter"
doc: |
  "extracting unhitted protein sequence searched rRNA and Swiss-Prot
  original script: scripts/07_annotation_modified.sh
  original command: seqkit grep -v -f ${f}_list-rRNA-uniprot.txt ${f}-rRNA.faa > ${f}-rRNA-uniprot.faa"

requirements:
  WorkReuse:
    enableReuse: true
  InlineJavascriptRequirement: {}

baseCommand: [seqkit, grep]

arguments:
  # invert match option
  - -v
  - -f
  - $(inputs.uniprot_toplist_file.path)
  - $(inputs.diamond_result_filtered_rRNA_protein_fasta_file.path)


inputs:
  - id: uniprot_toplist_file
    type: File
    label: "uniprot toplist file"
    doc: "the sequence IDs of Swiss-Prot annotated predicted protein sequences"
    default:
      class: File
      location: ../out/diamond_alignment_toplist.txt

  - id: diamond_result_filtered_rRNA_protein_fasta_file
    type: File
    label: "filtered rRNA fasta file"
    doc: "predicted protein sequences without contaminated rRNA"
    default:
      class: File
      location: ../out/all_contigs_SRR27548858_protein_rRNA.fasta

stdout: $(inputs.diamond_result_filtered_rRNA_protein_fasta_file.basename.replace(/\.fasta$/, ''))_rRNA-uniprot.fasta
outputs:
  # - id: all-for-debugging
  #   type:
  #     type: array
  #     items: [File, Directory]
  #   outputBinding:
  #     glob: "*"

  - id: rRNA_uniprot_fasta_file
    type: File
    label: "unhitted fasta file"
    doc: "predicted protein sequences without Swiss-Prot sequences and contaminated rRNA"
    outputBinding:
      glob: $(inputs.diamond_result_filtered_rRNA_protein_fasta_file.basename.replace(/\.fasta$/, ''))_rRNA-uniprot.fasta

hints:
  - class: DockerRequirement
    dockerPull: quay.io/biocontainers/seqkit:2.10.0--h9ee0642_0

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/
