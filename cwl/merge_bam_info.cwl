class: CommandLineTool
cwlVersion: v1.0

baseCommand:
  - Rscript
  - '--vanilla'
  - merge_bam_info.r

inputs:
  - id: output_prefix
    type: string
    inputBinding:
      position: 1
  - id: bam_info_files
    type: File[]
    inputBinding:
      position: 2
      prefix: --bam_info_files

outputs:
  - id: merged_bam_info_file
    type: File
    outputBinding:
      glob: $(inputs.output_prefix).bam_info.tsv
