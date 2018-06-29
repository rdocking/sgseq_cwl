class: CommandLineTool
cwlVersion: v1.0

baseCommand:
  - Rscript
  - '--vanilla'
  - /projects/rdocking_prj/software/sgseq_cwl/r/merge_sg_feature_counts.r

inputs:
  - id: output_prefix
    type: string
    inputBinding:
      position: 1
  - id: sgfeature_count_files
    type: File[]
    inputBinding:
      position: 2
      prefix: --feature_files

outputs:
  - id: merged_feature_counts_file
    type: File
    outputBinding:
      glob: $(inputs.output_prefix).sg_feature_counts.RData

requirements:
  - class: ResourceRequirement
    ramMin: 42000
    tmpdirMin: 40000

