class: CommandLineTool
cwlVersion: v1.0

baseCommand:
  - Rscript
  - '--vanilla'
  - /projects/rdocking_prj/software/sgseq_cwl/r/get_sg_variant_counts.r

inputs:
  - id: bam_info
    type: File
    inputBinding:
      position: 1
  - id: bam_file
    type: File
    inputBinding:
      position: 2
    secondaryFiles: 
    - .bai
  - id: sg_variants
    type: File
    inputBinding:
      position: 3
  - id: out_file
    type: string
    inputBinding:
      position: 4

outputs:
  - id: sg_variantcounts_out
    type: File
    outputBinding:
      glob: $(inputs.out_file)

arguments: ['--cpus', $(runtime.cores)]

requirements:
  - class: ResourceRequirement
    ramMin: 42000
    coresMin: 1
    tmpdirMin: 40000
  - class: InlineJavascriptRequirement
