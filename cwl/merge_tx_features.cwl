class: CommandLineTool
cwlVersion: v1.0

baseCommand:
  - Rscript
  - '--vanilla'
  - /projects/rdocking_prj/software/sgseq_cwl/r/merge_tx_features.r

inputs:
  - id: output_prefix
    type: string
    inputBinding:
      position: 1
  - id: txfeatures_files
    type: File[]
    inputBinding:
      position: 2
      prefix: --txfeatures_files

outputs:
  - id: merged_tx_features
    type: File
    outputBinding:
      glob: $(inputs.output_prefix).tx_features.RData

requirements:
  - class: ResourceRequirement
    ramMin: 42000
    tmpdirMin: 40000

