#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.2
label: "bwa process"
doc: |
  "bwa mem process
  original script: https://github.com/RyoMameda/workflow/blob/main/05_mapping.sh
  original command: bwa mem -t ${threads} index_${f}_bwa ${fqdir}/${mgfq}_1_trim.fastq.gz ${fqdir}/${mgfq}_2_trim.fastq.gz"

requirements:
  WorkReuse:
    enableReuse: true

baseCommand: [bwa, mem]

arguments:
  - -t
  - $(inputs.threads)
  - $(inputs.index_bwa_dir_name)
  - $(inputs.fastq1.path)
  - $(inputs.fastq2.path)

inputs:
  - id: threads
    type: int
    label: "threads"
    doc: "threads for bwa mem process"
    default: 8

  - id: index_bwa_dir_name
    type: string
    label: "index bwa dir name"
    doc: "index bwa dir name"
    default: "index_bwa"


hints:
  - class: DockerRequirement
    dockerPull: quay.io/biocontainers/bwa:0.7.17--pl5.22.0_0

$namespaces:
  s: https://schema.org/
  edam: https://edamontology.org/