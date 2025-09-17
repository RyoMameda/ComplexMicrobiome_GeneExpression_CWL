#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool
label: "trimming by fastp (paired-end fastq data)"
doc: |
  "trimming by fastp (for pair-end fastq data). using fastp version 0.23.4. 
  Modified from https://github.com/nigyta/bact_genome/blob/master/cwl/tool/fastp/fastp.cwl
  Original script: https://github.com/RyoMameda/workflow/blob/main/02_readsQC.sh
  original command: fastp -i ${f}_1.fastq.gz -I ${f}_2.fastq.gz -o ${f}_1_trim.fastq.gz -O ${f}_2_trim.fastq.gz -q 20 -h ${f}_fastp.html -w ${threads} -t 1 -T 1"

requirements:
  InlineJavascriptRequirement: {}

baseCommand: [fastp]
arguments:
    - -i
    - $(inputs.fastq1.path)
    - -I
    - $(inputs.fastq2.path)
    - -o
    - $(inputs.fastq1.basename.replace(/\.gz$|\.bz2$/, '').replace(/\.fq$|\.fastq$/, ''))_trim.fastq.gz
    - -O
    - $(inputs.fastq2.basename.replace(/\.gz$|\.bz2$/, '').replace(/\.fq$|\.fastq$/, ''))_trim.fastq.gz
    - -h
    - $(inputs.fastq1.basename.replace(/\.gz$|\.bz2$/, '').replace(/\.fq$|\.fastq$/, ''))_trim.report.html
    - -j
    - $(inputs.fastq1.basename.replace(/\.gz$|\.bz2$/, '').replace(/\.fq$|\.fastq$/, ''))_trim.report.json
    - -q
    - $(inputs.quality_phred)
    - -t
    - $(inputs.trim_tail1)
    - -T
    - $(inputs.trim_tail2)
    - -w
    - $(inputs.threads)


inputs:
    - id: fastq1
      type: File
      label: "fastq1"
      doc: "fastq1 file (e.g. MK.F1_R1.fastq.gz)"

    - id: fastq2
      type: File
      label: "fastq2"
      doc: "fastq2 file (e.g. MK.F1_R2.fastq.gz)"

    - id: quality_phred
      label: "qualified quality phred"
      doc: "Qualifying threshold value of quality phred"
      type: int
      default: 20

    - id: trim_tail1
      label: "Number of bases trimmed from fastq1 tail"
      doc: "Number of bases trimmed from fastq1 tail"
      type: int
      default: 1

    - id: trim_tail2
      label: "Number of bases trimmed from fastq2 tail"
      doc: "Number of bases trimmed from fastq2 tail"
      type: int
      default: 16

    - id: threads
      label: "Number of threads to use"
      doc: "Number of threads to use"
      type: int
      default: 16


outputs:
    - id: out_fastq1
      type: File
      label: "trimmed fastq1 file"
      doc: "trimmed paired-end fastq file (e.g. MK.F1_R1_trim.fq.gz)"
      outputBinding:
        glob: $(inputs.fastq1.basename.replace(/\.gz$|\.bz2$/, '').replace(/\.fq$|\.fastq$/, ''))_trim.fastq.gz
    - id: out_fastq2
      type: File
      label: "trimmed fastq2 file"
      doc: "trimmed paired-end fastq file (e.g. MK.F1_R2_trim.fq.gz)"
      outputBinding:
        glob: $(inputs.fastq2.basename.replace(/\.gz$|\.bz2$/, '').replace(/\.fq$|\.fastq$/, ''))_trim.fastq.gz
    - id: out_html
      type: File
      label: "trimming report html file"
      doc: "trimming report html file (e.g. MK.F1_R1_trim.report.html)"
      outputBinding:
        glob: $(inputs.fastq1.basename.replace(/\.gz$|\.bz2$/, '').replace(/\.fq$|\.fastq$/, ''))_trim.report.html
    - id: out_json
      type: File
      label: "trimming report json file"
      doc: "trimming report json file (e.g. MK.F1_R1_trim.report.json)"
      outputBinding:
        glob: $(inputs.fastq1.basename.replace(/\.gz$|\.bz2$/, '').replace(/\.fq$|\.fastq$/, ''))_trim.report.json
    - id: stdout_log
      type: File
      label: "stdout log file"
      doc: "stdout log file (e.g. MK.F1_R1_stdout_run_fastp.log)"
      outputBinding:
        glob: $(inputs.fastq1.basename.replace(/\.gz$|\.bz2$/, '').replace(/\.fq$|\.fastq$/, ''))_stdout_run_fastp.log
    - id: stderr_log
      type: File
      label: "stderr log file"
      doc: "stderr log file (e.g. MK.F1_R1_stderr_run_fastp.log)"
      outputBinding:
        glob: $(inputs.fastq1.basename.replace(/\.gz$|\.bz2$/, '').replace(/\.fq$|\.fastq$/, ''))_stderr_run_fastp.log

stdout: $(inputs.fastq1.basename.replace(/\.gz$|\.bz2$/, '').replace(/\.fq$|\.fastq$/, ''))_stdout_run_fastp.log
stderr: $(inputs.fastq1.basename.replace(/\.gz$|\.bz2$/, '').replace(/\.fq$|\.fastq$/, ''))_stderr_run_fastp.log

hints:
  - class: DockerRequirement
    dockerPull: quay.io/biocontainers/fastp:0.23.4--hadf994f_2

$namespaces:
  s: https://schema.org/
  edam: https://edamontology.org/
