#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.0
label: "samtools process"
doc: |
  "checking mapping results (bam formated file) by SAMtools flagstat command
  original script: https://github.com/RyoMameda/workflow/blob/main/05_mapping.sh
  original command: samtools flagstat -@ ${threads} mg_${bam}.bam > flagstat_mg_${bam}"

requirements:
  WorkReuse:
    enableReuse: true
  InlineJavascriptRequirement: {}

baseCommand: [samtools, flagstat]

arguments:
  - -@
  - $(inputs.threads)
  - $(inputs.bam_file.path)

inputs:
  - id: threads
    type: int
    label: "threads"
    doc: "Number of threads to use"
    default: 16

  - id: bam_file
    type: File
    label: "bam file"
    doc: "sorted bam file processed by BWA-MEM and SAMtools sort command"
    default:
      class: File
      location: ../out/SRR27548858_1_trim_bwa_mem.bam

stdout: $(inputs.bam_file.basename.replace(/\.(bam|gz|bz2|fq|fastq)$/, ''))_flagstat

outputs:
  - id: flagstat_file
    type: File
    label: "flagstat file"
    doc: "flagstat file containing mapping efficiency information"
    outputBinding:
      glob: $(inputs.bam_file.basename.replace(/\.(bam|gz|bz2|fq|fastq)$/, ''))_flagstat


hints:
  - class: DockerRequirement
    dockerPull: quay.io/biocontainers/samtools:1.17--hd87286a_1

$namespaces:
  s: https://schema.org/
  edam: https://edamontology.org/
