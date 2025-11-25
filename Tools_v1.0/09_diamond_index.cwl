#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.0
label: "diamond index process"
doc: |
  "creating index file of Swiss-Prot protein sequences for DIAMOND process
  original script: https://github.com/RyoMameda/workflow/blob/main/06_get_ref.sh
  original command: diamond makedb -in uniprot_sprot.fasta -db uniprot_sprot --threads ${threads}"

requirements: []

baseCommand: [diamond, makedb]

arguments:
  - --in
  - $(inputs.protein_fasta_file.path)
  - --db
  - $(inputs.db_name)
  - --threads
  - $(inputs.threads)

inputs:
  - id: protein_fasta_file
    type: File
    label: "protein fasta file"
    doc: |
      "protein fasta file (zipped file can be acceptable)
      dataset: https://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.fasta.gz"
    default:
      class: File
      location: ../Data/uniprot_sprot.fasta

  - id: db_name
    type: string
    label: "db name"
    doc: "database name for DIAMOND"
    default: "uniprot_sprot"

  - id: threads
    type: int
    label: "threads"
    doc: "Number of threads to use"
    default: 16

outputs:
  - id: diamond_db_file
    type: File
    label: "diamond db file"
    doc: "database file for DIAMOND"
    outputBinding:
      glob: "$(inputs.db_name).dmnd"


hints:
  - class: DockerRequirement
    dockerPull: quay.io/biocontainers/diamond:2.0.15--hb97b32f_1

$namespaces:
  s: https://schema.org/
  edam: https://edamontology.org/
