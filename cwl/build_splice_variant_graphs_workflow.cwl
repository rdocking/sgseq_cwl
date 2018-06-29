#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow

requirements:
- class: ScatterFeatureRequirement
- class: StepInputExpressionRequirement
- class: SubworkflowFeatureRequirement

inputs:
  gtf_file: File
  output_prefix: string
  splice_graph_type: string
  tx_features_files:
    type:
      type: array
      items: File

outputs:
  splice_graph_features_file:
    type: File
    outputSource: generate_splice_graph_features/annotated_splice_graph_file
  splice_graph_variants_file:
    type: File
    outputSource: generate_splice_graph_variants/splice_graph_variants_file

steps:
  generate_transcript_db:
    run: generate_transcript_db.cwl
    in: 
      gtf_file: gtf_file
      out_file: 
        valueFrom: $(inputs.gtf_file.basename).transcript_db.RData
    out: [transcript_db_file]

  generate_splice_graph_features:
    run: generate_splice_graph_features.cwl
    in: 
      transcript_db: generate_transcript_db/transcript_db_file
      output_prefix: output_prefix
      splice_graph_type: splice_graph_type
      txfeatures_files: tx_features_files
    out: [annotated_splice_graph_file]

  generate_splice_graph_variants:
    run: find_splice_graph_variants.cwl
    in: 
      splice_graph: generate_splice_graph_features/annotated_splice_graph_file
      output_prefix: output_prefix
    out: [splice_graph_variants_file]
