class: CommandLineTool
cwlVersion: v1.0

baseCommand:
  - Rscript
  - '--vanilla'
  - /projects/rdocking_prj/software/sgseq_cwl/r/find_splice_graph_variants.r

inputs:
  - id: splice_graph
    type: File
    inputBinding:
      position: 1
  - id: output_prefix
    type: string
    inputBinding:
      position: 2

outputs:
  - id: splice_graph_variants_file
    type: File
    outputBinding:
      glob: $(inputs.output_prefix).sg_variants.RData

arguments: ['--cpus', $(runtime.cores)]

requirements:
  - class: ResourceRequirement
    ramMin: 42000
    coresMin: 1
    tmpdirMin: 40000
  - class: InlineJavascriptRequirement
