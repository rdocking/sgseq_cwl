#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow

requirements:
- class: ScatterFeatureRequirement
- class: StepInputExpressionRequirement
- class: SubworkflowFeatureRequirement

inputs:
  bam_info:
    type: File
  bam_file:
    type:
      type: array
      items: File
    secondaryFiles:
      - .bai
  output_prefix: string
  splice_graph_features:
    type: File  
  splice_graph_variants:
    type: File  

outputs:
  merged_sgfeature_counts:
    type: File
    outputSource: merge_sgfeature_counts/merged_feature_counts_file
  merged_sgvariant_counts:
    type: File
    outputSource: merge_sg_variant_counts/merged_variant_counts_file

steps:
  get_splice_graph_feature_counts:
    run: run_getSGFeatureCounts.cwl
    scatter: [bam_info, bam_file]
    scatterMethod: dotproduct 
    in: 
      bam_info: bamInfo/bam_info_file
      bam_file: bam_file
      splice_graph: merge_txfeatures/annotated_splice_graph_file
      out_file: 
        valueFrom: $(inputs.bam_file.basename).sg_features.RData
    out: [sg_featurecounts_out]

  merge_sgfeature_counts:
    run: merge_sgfeature_counts.cwl
    in: 
      output_prefix: output_prefix
      sgfeature_count_files: splice_graph_feature_count/sg_featurecounts_out
    out: [merged_feature_counts_file]

  sg_variant_counts:
    run: run_getSGVariantCounts.cwl
    scatter: [bam_info, bam_file]
    scatterMethod: dotproduct 
    in:
      bam_info: bamInfo/bam_info_file
      bam_file: bam_file
      sg_variants: splice_graph_variants/splice_graph_variants_file
      out_file: 
        valueFrom: $(inputs.bam_file.basename).sg_variant_counts.RData
    out: [sg_variantcounts_out]

  merge_sg_variant_counts:
    run: merge_sgvariant_counts.cwl
    in: 
      output_prefix: output_prefix
      sg_variant_count_files: sg_variant_counts/sg_variantcounts_out
    out: [merged_variant_counts_file]
