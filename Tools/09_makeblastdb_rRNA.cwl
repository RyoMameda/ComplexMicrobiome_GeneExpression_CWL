#!/usr/bin/env cwl-runner
# Generated from: makeblastdb -in ./data/uniprotkb_rice_all_240820.fasta -out ./data/index_uniprot_rice/uniprotkb_rice_all_240820 -dbtype prot -hash_index -parse_seqids
class: CommandLineTool
cwlVersion: v1.2
label: "makeblastdb command for rRNA database creation"
doc: |
  "This tool is used to create a blast database from a fasta file."

requirements:
  ShellCommandRequirement: {}
  WorkReuse:
    enableReuse: true

inputs:
  - id: index_dir_name
    type: string
    label: "index directory name"
    doc: "index directory name"
    default: "SILVA_138.1_LSUParc_tax_silva"

  - id: input_fasta_file
    type: File
    label: "input fasta file"
    doc: "rRNA sequence fasta file (zipped fasta can be acceptable for BLAST v2.17.0 or later version"
    default:
      class: File
      location: ../Data/SILVA_138.1_LSUParc_tax_silva.fasta.gz

arguments:
  - shellQuote: false
    valueFrom: |
      mkdir -p $(inputs.index_dir_name)
      makeblastdb -dbtype nucl -parse_seqids -in $(inputs.input_fasta_file.path) -out $(inputs.index_dir_name)/$(inputs.input_fasta_file.basename)
      touch $(inputs.index_dir_name)/$(inputs.input_fasta_file.basename) # create empty file

outputs:
  # - id: all-for-debugging
  #   type:
  #     type: array
  #     items: [File, Directory]
  #   outputBinding:
  #     glob: "*"

  - id: index_dir
    type: Directory
    doc: "directory containing index files for BLASTN"
    outputBinding:
      glob: "$(inputs.index_dir_name)"
  
  - id: index_file
    type: File
    doc: "all of these files arethe result of indexing for BLASTN"
    outputBinding:
      glob: "$(inputs.index_dir_name)/$(inputs.input_fasta_file.basename)"
    secondaryFiles:
      - .ndb
      - .nhr
      - .nin
      - .njs
      - .nog
      - .nos
      - .not
      - .nsq
      - .ntf
      - .nto


hints:
  - class: DockerRequirement
    dockerPull: quay.io/biocontainers/blast:2.17.0--h66d330f_0

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/
