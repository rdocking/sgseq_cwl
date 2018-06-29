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
  output_prefix: string

# Note - this will be a single file from this workflow, 
#  but this is specified as an array so we can have the downstream
#  workflow start from sets of tx_feature files
outputs:
  merged_txfeatures_out:
    type:
      type: array 
      items: File
    outputSource: merge_txfeatures/merged_tx_features

steps:

  txfeatures:
    run: predict_tx_features.cwl
    scatter: [bam_file, chromosome]
    scatterMethod: flat_crossproduct
    in: 
      bam_info: bam_info
      bam_file: bam_file
      chromosome: chromosome
      out_file: 
        valueFrom: $(inputs.bam_file.basename).$(inputs.chromosome).txfeatures.RData
    out: [txfeatures_out]

  merge_txfeatures:
    run: merge_tx_features.cwl
    in: 
      output_prefix: output_prefix
      txfeatures_files: txfeatures/txfeatures_out
    out: [merged_tx_features]

