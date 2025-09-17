#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.2
label: "diamond alignment process"
doc: |
  "annotating process of Swiss-Prot (reviewed sequences of UniProt) sequences for predicted protein sequences using DIAMOND blastp
  original script: scripts/07_annotation_modified.sh
  original command: diamond blastp -p ${threads} -d ${db}/${swissprot} -o ${f}-rRNA_uniprot.txt -f 6 qseqid sseqid stitle evalue --quiet -q ${f}-rRNA.faa --top 1 -e 0.1 --sensitive --iterate"

requirements:
  WorkReuse:
    enableReuse: true

baseCommand: [diamond, blastp]

arguments:
  - -p
  - $(inputs.threads)
  - -d
  - $(inputs.database_file.path)
  - -o
  - $(inputs.output_file_name)
  # You may not edit "-f" following terms, or 12_faablast2gtf4tpm.cwl do not work correctly.
  - -f
  - "6"
  - "qseqid"
  - "sseqid"
  - "stitle"
  - "evalue"
  - --quiet
  - -q
  - $(inputs.filtered_rRNA_fasta_file.path)
  - --top
  - "1"
  - -e
  - $(inputs.evalue)
  # following options are adopted for sensitive search
  - --sensitive
  - --iterate

inputs:
  - id: threads
    type: int
    label: "threads"
    doc: "Number of threads to use"
    default: 16

  - id: database_file
    type: File
    label: "database file"
    doc: "indexed database file for DIAMOND"
    default:
      class: File
      location: ../out/uniprot_sprot.dmnd

  - id: output_file_name
    type: string
    label: "output file name"
    doc: "text file of annotation information of Swiss-Prot"
    default: "diamond_alignment.txt"

  - id: filtered_rRNA_fasta_file
    type: File
    label: "filtered rRNA fasta file"
    doc: "filtered rRNA fasta file"
    default:
      class: File
      location: ../out/all_contigs_SRR27548858_protein_rRNA.fasta

  - id: evalue
    type: float
    label: "evalue"
    doc: "evalue"
    default: 0.1


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
    doc: "diamond alignment file"
    outputBinding:
      glob: "$(inputs.output_file_name)"


hints:
  - class: DockerRequirement
    dockerPull: quay.io/biocontainers/diamond:2.0.15--hb97b32f_1

$namespaces:
  s: https://schema.org/
  edam: https://edamontology.org/
