class: CommandLineTool
cwlVersion: v1.0

baseCommand:
  - Rscript
  - '--vanilla'
  - /projects/rdocking_prj/software/sgseq_cwl/r/get_bam_info.r

inputs:
  - id: sample_name
    type: string
    inputBinding:
      position: 1
  - id: bam_file
    type: File
    inputBinding:
      position: 2
    secondaryFiles: 
    - .bai
  - id: out_file
    type: string
    inputBinding:
      position: 3
outputs:
  - id: bam_info_file
    type: File
    outputBinding:
      glob: $(inputs.out_file)

arguments: ['--cpus', $(runtime.cores)]

requirements:
  - class: ResourceRequirement
    ramMin: 42000
    coresMin: 1
    tmpdirMin: 40000

