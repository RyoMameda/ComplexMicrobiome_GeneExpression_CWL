#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.2
label: "samtools process"
doc: |
  "SAMtools sorting process from BWA-MEM output sam file to bam file
  original script: https://github.com/RyoMameda/workflow/blob/main/05_mapping.sh
  original command: samtools sort -@ ${threads} > mg_${bam}.bam"

requirements:
  WorkReuse:
    enableReuse: true
  InlineJavascriptRequirement: {}

baseCommand: [samtools, sort]

arguments:
  - -@
  - $(inputs.threads)
  - -o
  - $(inputs.sam_file.basename.replace(/\.(sam|gz|bz2|fq|fastq)$/, '')).bam
  - -O
  - "BAM"
  - $(inputs.sam_file.path)

inputs:
  - id: threads
    type: int
    label: "threads"
    doc: "threads for SAMtools process"
    default: 16

  - id: sam_file
    type: File
    label: "sam file"
    doc: "output sam formated file of BWA-MEM process"
    default:
      class: File
      location: ../out/SRR27548858_1_trim_bwa_mem.sam

outputs:
  - id: bam_file
    type: File
    label: "bam file"
    doc: "sorted bam formated file"
    outputBinding:
      glob: $(inputs.sam_file.basename.replace(/\.(sam|gz|bz2|fq|fastq)$/, '')).bam


hints:
  - class: DockerRequirement
    dockerPull: quay.io/biocontainers/samtools:1.17--hd87286a_1

$namespaces:
  s: https://schema.org/
  edam: https://edamontology.org/
