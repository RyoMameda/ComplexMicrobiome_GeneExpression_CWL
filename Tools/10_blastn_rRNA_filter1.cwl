#!/usr/bin/env cwl-runner
# Generated from: makeblastdb -in ./data/uniprotkb_rice_all_240820.fasta -out ./data/index_uniprot_rice/uniprotkb_rice_all_240820 -dbtype prot -hash_index -parse_seqids
class: CommandLineTool
cwlVersion: v1.2
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
  WorkReuse:
    enableReuse: true

inputs:
  - id: blastn_result_file
    type: File
    label: "blastn result file"
    doc: "blastn result file"
    default:
      class: File
      location: ../out/blastn_rRNA_alignment.txt


arguments:
  - shellQuote: false
    valueFrom: |
      cat $(inputs.blastn_result_file.path) | awk '!x[$1]++' > $(inputs.blastn_result_file.basename.replace(/\.txt$/, ''))_rRNAlist.txt
      cut -f1 $(inputs.blastn_result_file.basename.replace(/\.txt$/, ''))_rRNAlist.txt | sort > $(inputs.blastn_result_file.basename.replace(/\.txt$/, ''))_rRNA_toplist.txt

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
      glob: $(inputs.blastn_result_file.basename.replace(/\.txt$/, ''))_rRNAlist.txt

  - id: rRNA_toplist_file
    type: File
    label: "rRNA toplist file"
    doc: "the sequence IDs of rRNA annotated predicted protein conding sequences"
    outputBinding:
      glob: $(inputs.blastn_result_file.basename.replace(/\.txt$/, ''))_rRNA_toplist.txt


hints:
  - class: DockerRequirement
    dockerPull: quay.io/biocontainers/gawk:5.1.0--2

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/
