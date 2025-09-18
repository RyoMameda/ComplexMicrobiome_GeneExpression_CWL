#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow
label: "diamond proteinworkflow"
doc: |
  "This workflow performs diamond protein alignment process for predicted protein sequences.
  It executes 2 processes: diamond index creation and diamond alignment.
  related CWL file:
  ./Tools/09_diamond_index.cwl
  ./Tools/11_diamond_uniprot_alignment.cwl
  ./Tools/11_diamond_uniprot_filter1.cwl
  ./Tools/11_diamond_uniprot_filter2.cwl"

requirements:
  WorkReuse:
    enableReuse: true

inputs:
############## Common Parameters ##############
  - id: THREADS
    type: int
    label: "Threads"
    doc: "Threads"
    default: 16


############## Parameters for creating diamond index (/Tools/09_diamond_index.cwl) ##############
  - id: DIAMOND_INDEX_FILE
    type: File
    label: "Protein fasta file for diamond index"
    doc: "Protein fasta file for diamond index"
    default:
      class: File
      location: ../Data/uniprot_sprot.fasta

  - id: DIAMOND_INDEX_NAME
    type: string
    label: "Diamond index name"
    doc: "Diamond index name"
    default: "uniprot_sprot"

############## Parameters for diamond alignment (/Tools/11_diamond_uniprot_alignment.cwl) ##############
  - id: DIAMOND_OUTPUT_FILE_NAME
    type: string
    label: "Diamond output file name"
    doc: "Diamond output file name"
    default: "diamond_alignment.txt"

  - id: DIAMOND_FILTERED_RRNA_PROTEIN_FASTA_FILE
    type: File
    label: "Filtered rRNA protein fasta file"
    doc: "Filtered rRNA protein fasta file"
    default:
      class: File
      location: ../out/all_contigs_SRR27548858_protein.fasta

  - id: DIAMOND_EVALUE
    type: float
    label: "Evalue"
    doc: "Evalue"
    default: 0.1

############## Parameters for diamond filter (/Tools/11_diamond_uniprot_filter1.cwl) ##############

############## Parameters for diamond filter (/Tools/11_diamond_uniprot_filter2.cwl) ##############
#   - id: DIAMOND_FILTERED_RRNA_PROTEIN_FASTA_FILE
#     type: File
#     label: "Filtered rRNA protein fasta file"
#     doc: "Filtered rRNA protein fasta file"
#     default:
#       class: File
#       location: ../Data/all_contigs_SRR27548858_protein_rRNA.fasta


steps:
  - id: DIAMOND_INDEX
    run: ../Tools/09_diamond_index.cwl
    in:
      protein_fasta_file: DIAMOND_INDEX_FILE
      db_name: DIAMOND_INDEX_NAME
      threads: THREADS
    out: [diamond_db_file]


  - id: DIAMOND_ALIGNMENT
    run: ../Tools/11_diamond_uniprot_alignment.cwl
    in:
      threads: THREADS
      database_file: DIAMOND_INDEX/diamond_db_file
      output_file_name: DIAMOND_OUTPUT_FILE_NAME
      filtered_rRNA_fasta_file: DIAMOND_FILTERED_RRNA_PROTEIN_FASTA_FILE
      evalue: DIAMOND_EVALUE
    out: [diamond_alignment_file]


  - id: DIAMOND_FILTER1
    run: ../Tools/11_diamond_uniprot_filter1.cwl
    in:
      diamond_alignment_result_file: DIAMOND_ALIGNMENT/diamond_alignment_file
    out: [diamond_alignment_toplist_file]


  - id: DIAMOND_FILTER2
    run: ../Tools/11_diamond_uniprot_filter2.cwl
    in:
      uniprot_toplist_file: DIAMOND_FILTER1/diamond_alignment_toplist_file
      diamond_result_filtered_rRNA_protein_fasta_file: DIAMOND_FILTERED_RRNA_PROTEIN_FASTA_FILE
    out: [rRNA_uniprot_fasta_file]

outputs:
  - id: DIAMOND_TOPLIST_FILE
    type: File
    label: "Diamond toplist file"
    doc: "Diamond toplist file"
    outputSource: DIAMOND_FILTER1/diamond_alignment_toplist_file

  - id: DIAMOND_FILTERED_FILE
    type: File
    label: "Filtered rRNA protein fasta file"
    doc: "Filtered rRNA protein fasta file"
    outputSource: DIAMOND_FILTER2/rRNA_uniprot_fasta_file

$namespaces:
  s: https://schema.org/
  edam: https://edamontology.org/


      