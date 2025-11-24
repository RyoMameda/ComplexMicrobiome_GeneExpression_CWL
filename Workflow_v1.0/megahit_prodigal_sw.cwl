#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow
label: "contig construction and protein prediction"
doc: |
  "This workflow performs construction of metagenomic contigs and prediction protein sequences for metagenomic contigs.
  It executes 2 processes: contig construction and protein prediction.
  related CWL file:
  ./Tools/01_megahit.cwl
  ./Tools/02_rename.cwl
  ./Tools/03_seqkit_stats.cwl
  ./Tools/04_prodigal.cwl"

requirements:
  WorkReuse:
    enableReuse: true
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}

inputs:
############## Common Parameters ##############
  - id: THREADS
    type: int
    label: "Threads"
    doc: "Number of threads to use"
    default: 16


############## Parameters for assembling (/Tools/01_megahit.cwl) ##############
  - id: FASTQ_1
    type: File
    label: "Forward reads file (_1_trim.fastq.gz)"
    doc: "trimmed metagenomic forward reads file (_1_trim.fastq.gz)"
    default:
      class: File
      location: ../Data/SRR27548858_1_trim.fastq.gz

  - id: FASTQ_2
    type: File
    label: "Reverse reads file (_2_trim.fastq.gz)"
    doc: "trimmed metagenomic reverse reads file (_2_trim.fastq.gz)"
    default:
      class: File
      location: ../Data/SRR27548858_2_trim.fastq.gz

  - id: MEGAHIT_OUTPUT_DIR
    type: string
    label: "Output directory name (e.g., contig${sample_name})"
    doc: "Output directory name (e.g., contig${sample_name}), you should not make the directory before execution."
    default: "contigs_SRR27548858_megahit"

############## Parameters for renaming fasta file (/Tools/02_rename.cwl) ##############

############## Parameters for statical analysis of contigs (/Tools/03_seqkit_stats.cwl) ##############

############## Parameters for protein prediction (/Tools/04_prodigal.cwl) ##############

steps:
  - id: MEGAHIT
    run: ../Tools_v1.0/01_megahit.cwl
    in:
      fastq_1: FASTQ_1
      fastq_2: FASTQ_2
      output_dir_name: MEGAHIT_OUTPUT_DIR
      threads: THREADS
    out: [output_dir, final_contigs_fasta_file]
  
  - id: RENAME_CONTIG
    run: ../Tools_v1.0/02_rename.cwl
    in:
      input_contigs_fasta_file: MEGAHIT/final_contigs_fasta_file
      output_contigs_fasta_file_name:
        source: MEGAHIT_OUTPUT_DIR
        valueFrom: $(self + ".fa")
    out: [output_contigs_fasta_file]

  - id: SEQKIT_STATS
    run: ../Tools_v1.0/03_seqkit_stats.cwl
    in:
      input_contigs_fasta_file: RENAME_CONTIG/output_contigs_fasta_file
    out: [stats_file]

  - id: PROTEIN_PREDICTION
    run: ../Tools_v1.0/04_prodigal.cwl
    in:
      input_contigs_fasta_file: RENAME_CONTIG/output_contigs_fasta_file
    out: [output_protein_fasta_file, output_dna_fasta_file]


outputs:
  - id: MEGAHIT_CONTIG_DIRECTORY
    type: Directory
    label: "Output directory of megahit"
    doc: "Output directory containing final metagenomic contigs fasta file (final.contigs.fa)"
    outputSource: MEGAHIT/output_dir

  - id: NAMED_CONTIG_FASTA_FILE
    type: File
    label: "Output contigs fasta file"
    doc: "Named metagenomic contigs fasta file"
    outputSource: RENAME_CONTIG/output_contigs_fasta_file

  - id: CONTIG_STATS_FILE
    type: File
    label: "stats file"
    doc: "text file containing metagenoic contig stats"
    outputSource: SEQKIT_STATS/stats_file

  - id: PREDICTED_PROTEINS
    type: File
    label: "Output protein fasta file"
    doc: "predicted protein sequences to the selected file."
    outputSource: PROTEIN_PREDICTION/output_protein_fasta_file

  - id: PREDICTED_CODING_DNA
    type: File
    label: "Output dna fasta file"
    doc: "protein coding nucleotide sequences to the selected file"
    outputSource: PROTEIN_PREDICTION/output_dna_fasta_file

$namespaces:
  s: https://schema.org/
  edam: https://edamontology.org/
