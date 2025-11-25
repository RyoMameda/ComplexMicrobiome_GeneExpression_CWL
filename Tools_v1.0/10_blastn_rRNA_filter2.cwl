#!/usr/bin/env cwl-runner
# Generated from: makeblastdb -in ./data/uniprotkb_rice_all_240820.fasta -out ./data/index_uniprot_rice/uniprotkb_rice_all_240820 -dbtype prot -hash_index -parse_seqids
class: CommandLineTool
cwlVersion: v1.0
label: "blastn result file filter"
doc: |
  "This tool is used to filter blastn result.
  original script: scripts/07_annotation_modified.sh
  original command: seqkit grep -v -f ${f}_rRNA_toplist.txt ${f}.faa > ${f}-rRNA.faa"

requirements:
  InlineJavascriptRequirement: {}

baseCommand: [seqkit, grep]

arguments:
  # invert match option
  - -v
  - -f
  - $(inputs.rRNA_toplist_file.path)
  - $(inputs.prodigal_result_protein_fasta_file.path)


inputs:
  - id: rRNA_toplist_file
    type: File
    label: "rRNA toplist file"
    doc: "the sequence IDs of rRNA annotated predicted protein conding sequences"
    default:
      class: File
      location: ../out/blastn_rRNA_alignment_rRNA_toplist.txt

  - id: prodigal_result_protein_fasta_file
    type: File
    label: "prodigal result protein fasta file"
    doc: "predicted protein sequences of Prodigal output"
    default:
      class: File
      location: ../out/all_contigs_SRR27548858_protein.fasta

stdout: $(inputs.prodigal_result_protein_fasta_file.basename.replace(/\.fasta$/, ''))_rRNA.fasta

outputs:
  # - id: all-for-debugging
  #   type:
  #     type: array
  #     items: [File, Directory]
  #   outputBinding:
  #     glob: "*"

  - id: rRNA_fasta_file
    type: File
    label: "omitted rRNA fasta file"
    doc: "predicted protein sequences without contaminated rRNA"
    outputBinding:
      glob: $(inputs.prodigal_result_protein_fasta_file.basename.replace(/\.fasta$/, ''))_rRNA.fasta


hints:
  - class: DockerRequirement
    dockerPull: quay.io/biocontainers/seqkit:2.10.0--h9ee0642_0

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/
