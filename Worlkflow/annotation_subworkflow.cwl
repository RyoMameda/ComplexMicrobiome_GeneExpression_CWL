#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow
label: "Subworkflow for Annotation"
doc: |
  "Subworkflow for Annotation
  This subworkflow is for annotation of predicted protein coding sequences.
  "

requirements:
  # https://www.commonwl.org/user_guide/topics/workflows.html#scattering-steps
  ScatterFeatureRequirement: {}


inputs:
  - id: input_fasta_file
    type: File
    label: "input fasta file"
    doc: "input fasta file"
    default:
      class: File
      location: ../out/all_contigs_SRR27548858_protein.fasta





steps:
  - id: mapping 