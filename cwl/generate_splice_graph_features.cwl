class: CommandLineTool
cwlVersion: v1.0

baseCommand:
  - Rscript
  - '--vanilla'
  - /projects/rdocking_prj/software/sgseq_cwl/r/generate_splice_graph_features.r

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
  - id: txfeatures_files
    type: File[]
    inputBinding:
      position: 4
      prefix: --txfeatures_files

outputs:
  - id: annotated_splice_graph_file
    type: File
    outputBinding:
      glob: $(inputs.output_prefix).sg_features.RData

requirements:
  - class: ResourceRequirement
    ramMin: 42000
    tmpdirMin: 40000

