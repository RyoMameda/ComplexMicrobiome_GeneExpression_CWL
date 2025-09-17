#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.2
label: "bwa process"
doc: |
  "bwa mem process
  original script: https://github.com/RyoMameda/workflow/blob/main/05_mapping.sh
  original command: bwa mem -t ${threads} index_${f}_bwa ${fqdir}/${mgfq}_1_trim.fastq.gz ${fqdir}/${mgfq}_2_trim.fastq.gz
  original command: bwa mem -t ${threads} index_${f}_bwa ${fqdir}/${mtfq}_1_trim.fastq.gz ${fqdir}/${mtfq}_2_trim.fastq.gz"

requirements:
  WorkReuse:
    enableReuse: true
  InlineJavascriptRequirement: {}

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
    default: 16

  - id: index_bwa_dir_name
    type: File
    label: "index bwa dir name"
    doc: "index bwa dir name"
    default:
      class: File
      location: ../out/index_bwa_dir/index_bwa
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa

  - id: fastq1
    type: File
    label: "fastq1"
    doc: "fastq1 file"
    default:
      class: File
      location: ../Data/SRR27548858_1_trim.fastq.gz
  - id: fastq2
    type: File
    label: "fastq2"
    doc: "fastq2 file"
    default:
      class: File
      location: ../Data/SRR27548858_2_trim.fastq.gz
  
stdout: $(inputs.fastq1.basename.replace(/\.gz$|\.bz2$/, '').replace(/\.fq$|\.fastq$/, ''))_bwa_mem.sam

outputs:
  - id: sam_file
    type: File
    label: "sam file"
    doc: "sam file"
    outputBinding:
      glob: $(inputs.fastq1.basename.replace(/\.gz$|\.bz2$/, '').replace(/\.fq$|\.fastq$/, ''))_bwa_mem.sam


hints:
  - class: DockerRequirement
    dockerPull: quay.io/biocontainers/bwa:0.7.17--pl5.22.0_0

$namespaces:
  s: https://schema.org/
  edam: https://edamontology.org/