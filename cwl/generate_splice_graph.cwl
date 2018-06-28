class: CommandLineTool
cwlVersion: v1.0

baseCommand:
  - Rscript
  - '--vanilla'
  - >-
    /projects/karsanlab/rdocking/KARSANBIO-108_splicing/KARSANBIO-1462_sgseq_test/lib/merge_txfeatures.R

inputs:
  - id: transcript_db
    type: File
    inputBinding:
      position: 1
  - id: output_prefix
    type: string
    inputBinding:
      position: 2
  - id: splice_graph_type
    type: string
    inputBinding:
      position: 3
  - id: merge_mode
    type: string
    inputBinding:
      position: 4
  - id: txfeatures_files
    type: File[]
    inputBinding:
      position: 5
      prefix: --txfeatures_files

outputs:
  - id: merged_tx_features
    type: File
    outputBinding:
      glob: $(inputs.output_prefix).*.RData

requirements:
  - class: ResourceRequirement
    ramMin: 42000
    tmpdirMin: 40000

