class: CommandLineTool
cwlVersion: v1.0

baseCommand:
  - Rscript
  - '--vanilla'
  - /projects/rdocking_prj/software/sgseq_cwl/r/generate_transcript_db.r

inputs:
  - id: gtf_file
    type: File
    inputBinding:
      position: 1
  - id: out_file
    type: string
    inputBinding:
      position: 2
outputs:
  - id: transcript_db_file
    type: File
    outputBinding:
      glob: $(inputs.out_file)

requirements:
  - class: ResourceRequirement
    ramMin: 42000
    tmpdirMin: 40000

