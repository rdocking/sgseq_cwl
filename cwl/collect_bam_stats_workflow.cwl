#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow

requirements:
- class: ScatterFeatureRequirement
- class: StepInputExpressionRequirement

inputs:
  sample_name:
    type:
      type: array
      items: string
  bam_file:
    type:
      type: array
      items: File
    secondaryFiles:
      - .bai
  output_prefix: string

outputs:
  merged_bam_info_file:
    type: File
    outputSource: merged_bam_info_file/merged_bam_info_file

steps:
  get_bam_info:
    run: get_bam_info.cwl
    scatter: [sample_name, bam_file]
    scatterMethod: dotproduct 
    in:
      sample_name: sample_name
      bam_file: bam_file
      out_file: 
        valueFrom: $(inputs.bam_file.basename).bam_info.tsv
    out: [bam_info_file]

  merged_bam_info_file:
    run: merge_bam_info.cwl
    in:
      output_prefix: output_prefix
      bam_info_files: get_bam_info/bam_info_file
    out: [merged_bam_info_file]