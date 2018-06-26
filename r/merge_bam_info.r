#!/usr/bin/env Rscript

# Parse command-line args
library(argparser, quietly = TRUE)
p <- arg_parser("Merge BamInfo files")
p <- add_argument(p, '--bam_info_files', type = "character", 
                  nargs = Inf, help = 'BamInfo files')
argv <- parse_args(p)

