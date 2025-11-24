#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.0
label: "prodigal process"
doc: |
  "prediction of protein coding sequences from metagenomic contigs using Prodigal
  Original script: https://github.com/RyoMameda/workflow/blob/main/04_prodigal.sh
  prodigal -i ${contig} -o ${output}.gbk -p meta -q -a ${output}.faa -d ${output}.fna"

requirements:
  WorkReuse:
    enableReuse: true
  InlineJavascriptRequirement: {}

baseCommand: [prodigal]

arguments:
  - -i
  - $(inputs.input_contigs_fasta_file)
  # in this workflow, gbk formated output will not be used, so it will be omited for outputs.
  - -o
  - "output.gbk"
  # "-p meta" option is for metagenomic contigs 
  - -p
  - meta
  # "-q" option is to run quietly (suppress normal stderr output)
  - -q
  - -a
  - $(inputs.input_contigs_fasta_file.basename.replace(/\.(gz|bz2|fa|fasta)$/, ''))_protein.fasta
  - -d
  - $(inputs.input_contigs_fasta_file.basename.replace(/\.(gz|bz2|fa|fasta)$/, ''))_dna.fasta

inputs:
  - id: input_contigs_fasta_file
    type: File
    label: "Input contigs fasta file"
    doc: "Input metagenomic contigs fasta file (outputs of assembling)"
    default:
      class: File
      location: ../out/all_contigs_SRR27548858.fa

outputs:
#   - id: output_gbk_file
#     type: File
#     label: "Output gbk file"
#     doc: "Output gbk file"
#     outputBinding:
#       glob: "$(inputs.output_gbk_file_name)"

  - id: output_protein_fasta_file
    type: File
    label: "Output protein fasta file"
    doc: "predicted protein sequences to the selected file."
    outputBinding:
      glob: $(inputs.input_contigs_fasta_file.basename.replace(/\.(gz|bz2|fa|fasta)$/, ''))_protein.fasta

  - id: output_dna_fasta_file
    type: File
    label: "Output dna fasta file"
    doc: "protein coding nucleotide sequences to the selected file"
    outputBinding:
      glob: $(inputs.input_contigs_fasta_file.basename.replace(/\.(gz|bz2|fa|fasta)$/, ''))_dna.fasta


hints:
  - class: DockerRequirement
    dockerPull: quay.io/biocontainers/prodigal:2.6.3--h031d066_6

$namespaces:
  s: https://schema.org/
  edam: https://edamontology.org/
