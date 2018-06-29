#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow

requirements:
- class: ScatterFeatureRequirement
- class: StepInputExpressionRequirement
- class: SubworkflowFeatureRequirement

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
  gtf_file: File
  output_prefix: string
  splice_graph_type: string
  chromosome: 
    type:
      type: array
      items: string

outputs:
  merged_sgfeature_counts:
    type: File
    outputSource: collect_feature_and_variant_counts/merged_sgfeature_counts
  merged_sgvariant_counts:
    type: File
    outputSource: collect_feature_and_variant_counts/merged_sgvariant_counts

steps:
  collect_bam_stats:
    run: collect_bam_stats_workflow.cwl
    in:
      sample_name: sample_name
      bam_file: bam_file
      output_prefix: output_prefix
    out: [merged_bam_info_file]

  predict_tx_features:
    run: predict_tx_features_workflow.cwl
    in:
      bam_info: collect_bam_stats/merged_bam_info_file
      bam_file: bam_file
      chromosome: chromosome
      output_prefix: output_prefix
    out: [merged_txfeatures_out]

  build_splice_variant_graphs:
    run: build_splice_variant_graphs_workflow.cwl
    in: 
      gtf_file: gtf_file
      output_prefix: output_prefix
      splice_graph_type: splice_graph_type
      tx_features_files: predict_tx_features/merged_txfeatures_out
    out: [splice_graph_features_file, splice_graph_variants_file]

  collect_feature_and_variant_counts:
    run: collect_feature_and_variant_counts_workflow.cwl
    in: 
      bam_info: collect_bam_stats/merged_bam_info_file
      bam_file: bam_file
      output_prefix: output_prefix
      splice_graph_features: build_splice_variant_graphs/splice_graph_features_file
      splice_graph_variants: build_splice_variant_graphs/splice_graph_variants_file
    out: [merged_sgfeature_counts, merged_sgvariant_counts]
       
      

 
