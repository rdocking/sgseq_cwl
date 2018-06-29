#!/usr/bin/env Rscript

# Parse command-line args
library(argparser, quietly = TRUE)
p <- arg_parser("Run SGSeq::findSGVariants")
p <- add_argument(p, 'splice_graph', type = "character", 
                  help = 'Splice graph (from SGSeq::SGFeatures)')
p <- add_argument(p, 'output_prefix', type = "character", 
                  help = 'Output prefix')
p <- add_argument(p, '--cpus', type = "integer", 
                  help = 'Number of CPUs to use', default = 1)
argv <- parse_args(p)

suppressPackageStartupMessages(require(SGSeq))

# Load in the SGFeatures as `splice_graph_features`
load(argv$splice_graph)

# Convert to SGVariants
splice_graph_variants <- 
  SGSeq::findSGVariants(splice_graph_features, 
                        maxnvariant = 20,
                        annotate_events = TRUE, 
                        include = "default", 
                        cores = as.integer(argv$cpus))

# Save to file
output_file <- paste0(argv$output_prefix, '.sg_variants.RData')
save(splice_graph_variants, file = output_file)
