#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.0
label: "gtf file creation"
doc: |
  "annotaion informtaion file (gtf formtaed) creation from the results of BLASTN and DIAMOND
  original script: scripts/07_annotation_modified.sh
  original command: 07_1_faablast2gtf4tpm.py --faa ${f}.faa --rrna ${f}_rRNAlist.txt --uniprot ${f}-rRNA_uniprot.txt -o ${f}_annotation.gtf"

requirements: []

baseCommand: [python3]

arguments:
  - $(inputs.custom_script.path)
  - --faa
  - $(inputs.prodigal_result_protein_fasta_file.path)
  - --rrna
  - $(inputs.blastn_result_rRNA_list_file.path)
  - --uniprot
  - $(inputs.diamond_result_protein_list_file.path)
  - -o
  - $(inputs.output_gtf_file_name)

inputs:
  - id: custom_script
    type: File
    label: "custom python script"
    doc: "faablast2gtf4tpm.py provides gtf formated file from predicted proteins fasta file, BLASTN output text file (searching rRNA) and DIAMOND output text file (searching Swiss-Prot proteins)."
    default:
      class: File
      location: ../scripts/faablast2gtf4tpm.py

  - id: prodigal_result_protein_fasta_file
    type: File
    label: "prodigal result protein fasta file"
    doc: "Prodigal result protein fasta file (Do not omit any information from the result of Prodigal, such as '#' following terms in header of the fasta file)"
    default:
      class: File
      location: ../out/all_contigs_SRR27548858_protein.fasta

  - id: blastn_result_rRNA_list_file
    type: File
    label: "diamond result filtered rRNA protein fasta file"
    doc: "text file containing annotaion of Swiss-Prot will be used for gtf file creation"
    default:
      class: File
      location: ../out/blastn_rRNA_alignment_rRNAlist.txt

  - id: diamond_result_protein_list_file
    type: File
    label: "blastn result filtered rRNA protein fasta file"
    doc: "annotation information of rRNA which is the input of gtf file creation"
    default:
      class: File
      location: ../out/diamond_alignment.txt

  - id: output_gtf_file_name
    type: string
    label: "output gtf file name"
    doc: "output gtf file name"
    default: "all_contigs_SRR27548858_annotation.gtf"

outputs:
  - id: output_gtf_file
    type: File
    label: "output annotation gtf file"
    doc: "output annotation gtf file using blastn and diamond result"
    outputBinding:
      glob: $(inputs.output_gtf_file_name)

hints:
  - class: DockerRequirement
    dockerPull: quay.io/biocontainers/python:3.13

$namespaces:
  s: https://schema.org/
  edam: https://edamontology.org/
