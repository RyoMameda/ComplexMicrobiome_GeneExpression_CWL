#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.2
label: "prodigal process"
doc: |
  "prediction of protein coding sequences for metagenomic contigs using Prodigal
  Original script: https://github.com/RyoMameda/workflow/blob/main/04_prodigal.sh
  prodigal -i ${contig} -o ${output}.gbk -p meta -q -a ${output}.faa -d ${output}.fna"

requirements:
  WorkReuse:
    enableReuse: true

baseCommand: [prodigal]

arguments:
  - -i
  - $(inputs.input_contigs_fasta_file)
  - -o
  - $(inputs.output_gbk_file_name)
  - -p
  # "-p meta" option is for metagenomic contigs, not for complete genomes
  - meta
  - -q
  # "-q" option is to run quietly (suppress normal stderr output)
  - -a
  - $(inputs.output_protein_fasta_file_name)
  - -d
  - $(inputs.output_dna_fasta_file_name)

inputs:
  - id: input_contigs_fasta_file
    type: File
    label: "Input contigs fasta file"
    doc: "Input metagenomic contigs fasta file"
    default:
      class: File
      location: ../out/all_contigs_SRR27548858.fa

  - id: output_gbk_file_name
    type: string
    label: "Output gbk file name"
    doc: "Output gbk file name"
    default: "all_contigs_SRR27548858.gbk"

  - id: output_protein_fasta_file_name
    type: string
    label: "Output protein fasta file name"
    doc: "Output protein fasta file name"
    default: "all_contigs_SRR27548858_protein.fasta"
  - id: output_dna_fasta_file_name
    type: string
    label: "Output dna fasta file name"
    doc: "Output dna fasta file name"
    default: "all_contigs_SRR27548858_dna.fasta"

outputs:
  - id: output_gbk_file
    type: File
    label: "Output gbk file"
    doc: "Output gbk file"
    outputBinding:
      glob: "$(inputs.output_gbk_file_name)"

  - id: output_protein_fasta_file
    type: File
    label: "Output protein fasta file"
    doc: "protein translations to the selected file."
    outputBinding:
      glob: "$(inputs.output_protein_fasta_file_name)"

  - id: output_dna_fasta_file
    type: File
    label: "Output dna fasta file"
    doc: "nucleotide sequences of genes to the selected file"
    outputBinding:
      glob: "$(inputs.output_dna_fasta_file_name)"


hints:
  - class: DockerRequirement
    dockerPull: quay.io/biocontainers/prodigal:2.6.3--h031d066_6

$namespaces:
  s: https://schema.org/
  edam: https://edamontology.org/
