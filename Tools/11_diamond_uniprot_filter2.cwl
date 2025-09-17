#!/usr/bin/env cwl-runner
# Generated from: makeblastdb -in ./data/uniprotkb_rice_all_240820.fasta -out ./data/index_uniprot_rice/uniprotkb_rice_all_240820 -dbtype prot -hash_index -parse_seqids
class: CommandLineTool
cwlVersion: v1.2
label: "diamond result file filter"
doc: |
  "This tool is used to filter diamond result.
  original script: scripts/07_annotation_modified.sh
  original command: seqkit grep -v -f ${f}_list-rRNA-uniprot.txt ${f}-rRNA.faa > ${f}-rRNA-uniprot.faa"

requirements:
  WorkReuse:
    enableReuse: true
  InlineJavascriptRequirement: {}

baseCommand: [seqkit, grep]

arguments:
  - -v
  - -f
  - $(inputs.uniprot_list_file.path)
  - $(inputs.blastn_result_filtered_protein_fasta_file.path)


inputs:
  - id: uniprot_toplist_file
    type: File
    label: "uniprot toplist file"
    doc: "uniprot toplist file"
    default:
      class: File
      location: ../out/diamond_alignment_toplist.txt

  - id: diamond_result_filtered_rRNA_protein_fasta_file
    type: File
    label: "diamond result filtered protein fasta file"
    doc: "diamond result filtered protein fasta file"
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
    label: "rRNA fasta file"
    doc: "rRNA fasta file"
    outputBinding:
      glob: $(inputs.diamond_result_filtered_rRNA_protein_fasta_file.basename.replace(/\.fasta$/, ''))_rRNA-uniprot.fasta


hints:
  - class: DockerRequirement
    dockerPull: quay.io/biocontainers/seqkit:2.10.0--h9ee0642_0

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/