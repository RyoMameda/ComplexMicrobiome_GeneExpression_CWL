#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.2
label: "samtools process"
doc: |
  "diamond index process
  original script: https://github.com/RyoMameda/workflow/blob/main/06_get_ref.sh
  original command: diamond makedb -in uniprot_sprot.fasta -db uniprot_sprot --threads ${threads}"

requirements:
  WorkReuse:
    enableReuse: true

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
      "protein fasta file
      dataset: https://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.fasta.gz"
    default:
      class: File
      location: ../Data/uniprot_sprot.fasta

  - id: db_name
    type: string
    label: "db name"
    doc: "db name"
    default: "uniprot_sprot"

  - id: threads
    type: int
    label: "threads"
    doc: "threads for bwa mem process"
    default: 16

outputs:
  - id: diamond_db_file
    type: File
    label: "diamond db file"
    doc: "diamond db file"
    outputBinding:
      glob: "$(inputs.db_name).dmnd"


hints:
  - class: DockerRequirement
    dockerPull: quay.io/biocontainers/diamond:2.0.15--hb97b32f_1

$namespaces:
  s: https://schema.org/
  edam: https://edamontology.org/