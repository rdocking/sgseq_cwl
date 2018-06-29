class: CommandLineTool
cwlVersion: v1.0

baseCommand:
  - Rscript
  - '--vanilla'
  - /projects/rdocking_prj/software/sgseq_cwl/r/merge_sg_variant_counts.r

inputs:
  - id: output_prefix
    type: string
    inputBinding:
      position: 1
  - id: sg_variant_count_files
    type: File[]
    inputBinding:
      position: 2
      prefix: --variant_files

outputs:
  - id: merged_variant_counts_file
    type: File
    outputBinding:
      glob: $(inputs.output_prefix).sg_variant_counts.RData

requirements:
  - class: ResourceRequirement
    ramMin: 42000
    tmpdirMin: 40000

