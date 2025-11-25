#!/usr/bin/env cwl-runner
# Generated from: makeblastdb -in ./data/uniprotkb_rice_all_240820.fasta -out ./data/index_uniprot_rice/uniprotkb_rice_all_240820 -dbtype prot -hash_index -parse_seqids
class: CommandLineTool
cwlVersion: v1.0
label: "blastn result file filter"
doc: |
  "This tool is used to filter blastn result. BLASTN result text file contains annotation of rRNA.
  Sometimes, more than one rRNA are annotated to one query sequence, it should be fixed for gft file production.
  Also, later process needs rRNA annotated predicted coding sequences list.
  original script: scripts/07_annotation_modified.sh
  original command1: cat ${f}_*.txt | awk '!x[$1]++' > ${f}_rRNAlist.txt
  original command2: cut -f1 ${f}_rRNAlist.txt | sort > ${f}_rRNA_toplist.txt"

requirements:
  ShellCommandRequirement: {}
  InlineJavascriptRequirement: {}

inputs:
  - id: blastn_result_file1
    type: File
    label: "blastn result file"
    doc: "blastn result file"
    default:
      class: File
      location: ../out/blastn_rRNA_alignment_silva_138.1_LSUParc_tax_silva.txt

  
  - id: blastn_result_file2
    type: File
    label: "blastn result file"
    doc: "blastn result file"
    default:
      class: File
      location: ../out/blastn_rRNA_alignment_silva_138.1_SSUParc_tax_silva.txt


arguments:
  - shellQuote: false
    valueFrom: |
      cat $(inputs.blastn_result_file1.path) $(inputs.blastn_result_file2.path) | awk '!x[$1]++' > concat_rRNAlist.txt
      cut -f1 concat_rRNAlist.txt | sort > concat_rRNA_toplist.txt

outputs:
  # - id: all-for-debugging
  #   type:
  #     type: array
  #     items: [File, Directory]
  #   outputBinding:
  #     glob: "*"

  - id: rRNAlist_file
    type: File
    label: "rRNAlist file"
    doc: "annotation information of rRNA which is the input of gtf file creation"
    outputBinding:
      glob: concat_rRNAlist.txt

  - id: rRNA_toplist_file
    type: File
    label: "rRNA toplist file"
    doc: "the sequence IDs of rRNA annotated predicted protein conding sequences"
    outputBinding:
      glob: concat_rRNA_toplist.txt


hints:
  - class: DockerRequirement
    dockerPull: quay.io/biocontainers/gawk:5.1.0--2

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/
