#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow
label: "Subworkflow for Annotation"
doc: |
  "Main workflow for Metagenome and Metatranscriptome Annotation
  related CWL file:
  ./Tools/00_fastp.cwl
  ./Tools/05_bwa_mem_index.cwl
  ./Tools/13_subread.cwl
  ./Workflow/annotation_sw.cwl
  ./Workflow/megahit_prodigal_sw.cwl
  ./Workflow/metagenomic_contig_mapping_sw.cwl"

requirements:
  SubworkflowFeatureRequirement: {}


inputs:
############## Parameters for trimming NGS reads (/Tools/00_fastp.cwl) ##############
  - id: THREADS
    type: int
    label: "threads"
    doc: "number of threads to use in main workflow"
    default: 16
  - id: CONTIG_FASTQ_1
    type: File
    label: "metagenomic fastq1"
    doc: "metagenomic fastq1 file which you want to construct metagenomic contigs for"
  - id: CONTIG_FASTQ_2
    type: File
    label: "metagenomic fastq2"
    doc: "metagenomic fastq2 file which you want to construct metagenomic contigs for"
  - id: MAP_FASTQ_1
    type: File
    label: "mapping reads fastq1"
    doc: "metagenomic or metatranscriptomic fastq1 file which you want to map metagenomic contigs"
  - id: MAP_FASTQ_2
    type: File
    label: "mapping reads fastq2"
    doc: "metagenomic or metatranscriptomic fastq2 file which you want to map metagenomic contigs"
  - id: TRIM_QUALITY
    label: "qualified quality phred"
    doc: "Qualifying threshold value of quality phred"
    type: int
    default: 20
  - id: TRIM_TAIL
    label: "Number of bases trimmed from fastq1 tail"
    doc: "Number of bases trimmed from fastq1 tail"
    type: int
    default: 1

############## Parameters for contig construction and protein prediction (/Worlkflow/megahit_prodigal_sw.cwl) ##############
  - id: MEGAHIT_OUTPUT_DIR
    type: string
    label: "Output directory name (e.g., contig${sample_name})"
    doc: "Output directory name (e.g., contig${sample_name}), you should not make the directory before execution."

############## Parameters for indexing contigs (/Tools/05_bwa_mem_index.cwl) ##############

############## Parameters for mapping process (/Worlkflow/metagenomic_contig_mapping_sw.cwl) ##############

############## Parameters for annotation (/Worlkflow/annotation_sw.cwl) ##############
  - id: EVALUE
    type: float
    label: "evalue"
    doc: "E-value threshold of BLASTP (diamond) and BLASTN alignment"
    default: 0.1
  - id: BLASTN_rRNA_FASTA_FILE1
    type: File
    label: "SILVA_138.1_LSUParc_tax_silva"
    doc: "SILVA_138.1_LSUParc_tax_silva"
    default:
      class: File
      location: ../Data/SILVA_138.1_LSUParc_tax_silva.fasta.gz
  - id: BLASTN_rRNA_FASTA_FILE2
    type: File
    label: "SILVA_138.1_SSUParc_tax_silva"
    doc: "SILVA_138.1_SSUParc_tax_silva"
    default:
      class: File
      location: ../Data/SILVA_138.1_SSUParc_tax_silva.fasta.gz
  - id: DIAMOND_FASTA_FILE
    type: File
    label: "Protein fasta file for diamond index"
    doc: "Protein fasta file for diamond index"
    default:
      class: File
      location: ../Data/uniprot_sprot.fasta.gz
  - id: GTF_FILE_NAME
    type: string
    label: "Output GTF file name"
    doc: "Output GTF file name"

############## Parameters for reads counting (/Tools/13_subread.cwl) ##############

############## Workflow steps ##############
steps:
  - id: TRIMMING_CONTIG
    run: ../Tools_v1.0/00_fastp.cwl
    label: "quality-trimming pair-end fastq data for contig construction"
    in:
      fastq1: CONTIG_FASTQ_1
      fastq2: CONTIG_FASTQ_2
      threads: THREADS
      quality_phred: TRIM_QUALITY
      trim_tail1: TRIM_TAIL
      trim_tail2: TRIM_TAIL
    out: [out_html, out_fastq1, out_fastq2]

  - id: TRIMMING_MAP
    run: ../Tools_v1.0/00_fastp.cwl
    label: "quality-trimming pair-end fastq data for mapping"
    in:
      fastq1: MAP_FASTQ_1
      fastq2: MAP_FASTQ_2
      threads: THREADS
      quality_phred: TRIM_QUALITY
      trim_tail1: TRIM_TAIL
      trim_tail2: TRIM_TAIL
    out: [out_html, out_fastq1, out_fastq2]

  - id: CONTIG_CONST_PROT_PREDICT
    run: megahit_prodigal_sw.cwl
    label: "quality-trimming pair-end fastq data for mapping"
    in:
      FASTQ_1: TRIMMING_CONTIG/out_fastq1
      FASTQ_2: TRIMMING_CONTIG/out_fastq2
      THREADS: THREADS
      MEGAHIT_OUTPUT_DIR: MEGAHIT_OUTPUT_DIR
    out: [MEGAHIT_CONTIG_DIRECTORY, NAMED_CONTIG_FASTA_FILE, CONTIG_STATS_FILE, PREDICTED_PROTEINS, PREDICTED_CODING_DNA]

  - id: CONTIG_INDEX
    run: ../Tools_v1.0/05_bwa_mem_index.cwl
    label: "indexing for predicted CDS of metagenomic contigs"
    in:
      input_fasta_file: CONTIG_CONST_PROT_PREDICT/PREDICTED_CODING_DNA
    out: [index_bwa_dir, index_bwa_files]

  - id: MAPPING
    run: metagenomic_contig_mapping_sw.cwl
    label: "mapping reads to predicted CDS of metagenomic contigs"
    in:
      FASTQ_1: TRIMMING_MAP/out_fastq1
      FASTQ_2: TRIMMING_MAP/out_fastq2
      THREADS: THREADS
      INDEX_BWA_FILENAME: CONTIG_INDEX/index_bwa_files
    out: [MAPPING_BAM, BAM_FLAGSTAT]

  - id: ANNOTATION
    run: annotation_sw.cwl
    label: "annotation of predicted CDS"
    in:
      SW_THREADS: THREADS
      SW_EVALUE: EVALUE
      SW_BLASTN_rRNA_FASTA_FILE1: BLASTN_rRNA_FASTA_FILE1
      SW_BLASTN_rRNA_FASTA_FILE2: BLASTN_rRNA_FASTA_FILE2
      SW_PRODIGAL_RESULT_PROTEIN_FASTA_FILE: CONTIG_CONST_PROT_PREDICT/PREDICTED_PROTEINS
      SW_PRODIGAL_RESULT_DNA_FASTA_FILE: CONTIG_CONST_PROT_PREDICT/PREDICTED_CODING_DNA
      SW_DIAMOND_INDEX_FILE: DIAMOND_FASTA_FILE
      SW_OUTPUT_GTF_FILE_NAME: GTF_FILE_NAME
    out: [OUTPUT_GTF_FILE]

  - id: READS_COUNTIG
    run: ../Tools_v1.0/13_subread.cwl
    label: "counting mapping reads"
    in:
      threads: THREADS
      input_gtf_file: ANNOTATION/OUTPUT_GTF_FILE
      input_bam_file: MAPPING/MAPPING_BAM
    out: [output_counts_file]

outputs:
  - id: TRIMMING_CONTIG_HTML
    type: File
    label: "Output HTML file of reads for contig construction"
    doc: "Trimming output HTML file of metagenomic reads for contig construction"
    outputSource: TRIMMING_CONTIG/out_html

  - id: TRIMMING_MAP_HTML
    type: File
    label: "Output HTML file of reads for mapping"
    doc: "Trimming output HTML file of metagenomic reads for mapping to contigs"
    outputSource: TRIMMING_MAP/out_html

  - id: CONTIG_FASTA_FILE
    type: File
    label: "metagenomic contig"
    doc: "Constructed metagenomic contigs fasta file"
    outputSource: CONTIG_CONST_PROT_PREDICT/NAMED_CONTIG_FASTA_FILE

  - id: CONTIG_STATS_FILE
    type: File
    label: "stats of metagenomic contig"
    doc: "Statical analysis file of metagenomic contigs"
    outputSource: CONTIG_CONST_PROT_PREDICT/CONTIG_STATS_FILE

  - id: PROTEINS
    type: File
    label: "predicted proteins"
    doc: "Predicted proteins of metagenomic contigs"
    outputSource: CONTIG_CONST_PROT_PREDICT/PREDICTED_PROTEINS

  - id: CDS
    type: File
    label: "predicted coding sequences"
    doc: "Predicted conding sequences of metagenomic contigs"
    outputSource: CONTIG_CONST_PROT_PREDICT/PREDICTED_CODING_DNA

  - id: INDEX
    type: Directory
    label: "index bwa dir"
    doc: "index files will be contained in this directry"
    outputSource: CONTIG_INDEX/index_bwa_dir

  - id: BAM
    type: File
    label: "bam file"
    doc: "sorted bam formated file"
    outputSource: MAPPING/MAPPING_BAM

  - id: BAM_STATS_FILE
    type: File
    label: "flagstat file"
    doc: "flagstat file containing mapping efficiency information"
    outputSource: MAPPING/BAM_FLAGSTAT

  - id: GTF
    type: File
    label: "Output GTF file"
    doc: "GTF file contains gene annotation of metagenomic contigs"
    outputSource: ANNOTATION/OUTPUT_GTF_FILE

  - id: READ_COUNT
    type: File
    label: "read counts txt file"
    doc: "txt file containing mapped read counts to metagenomic predicted protein coding sequences"
    outputSource: READS_COUNTIG/output_counts_file


$namespaces:
  s: https://schema.org/
  edam: https://edamontology.org/
