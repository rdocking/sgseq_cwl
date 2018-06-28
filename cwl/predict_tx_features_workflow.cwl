#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow

# This workflow takes a BAM file and sample name as input, 
# and runs tx_features for each chromosome separately

requirements:
- class: ScatterFeatureRequirement
- class: StepInputExpressionRequirement
- class: InlineJavascriptRequirement

inputs:
  bam_info:
    type: File
  bam_file:
    type:
      type: array
      items: File
      secondaryFiles:
        - .bai
  chromosome:
    type:
      type: array
      items: string

outputs:
  txfeatures_out:
    type: File
    outputSource: merge_txfeatures/annotated_splice_graph_file

steps:

  txfeatures:
    run: run_txfeatures_by_chromosome.cwl
    scatter: [chromosome]
    scatterMethod: dotproduct
    in: 
      bam_info: bam_info
      bam_file: bam_file
      chromosome: chromosome
      out_file: 
        valueFrom: $(inputs.bam_file.basename).$(inputs.chromosome).txfeatures.RData
    out: [txfeatures_out]

  merge_txfeatures:
    run: merge_txfeatures.cwl
    in: 
      transcript_db: transcript_db
      output_prefix: sample_name
      splice_graph_type: splice_graph_type
      merge_mode:
        valueFrom: "txfeatures"
      txfeatures_files: txfeatures/txfeatures_out
    out: [annotated_splice_graph_file]

