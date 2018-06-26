#!/usr/bin/env Rscript

# Parse command-line args
library(argparser, quietly = TRUE)
p <- arg_parser("Run SGSeq::getBamInfo for a single sample")
p <- add_argument(p, 'sample', type = "character", help = 'Sample name')
p <- add_argument(p, 'bam_file', type = "character", help = 'BAM file path')
p <- add_argument(p, 'out_file', type = "character", help = 'Output file path')
p <- add_argument(p, '--cpus', type = "integer", 
                    help = 'Number of CPUs to use', default = 1)
argv <- parse_args(p)

options(echo = TRUE)
suppressPackageStartupMessages(require(SGSeq))

# Construct a data frame with the sample info
sample_info.df <- data.frame(sample_name = as.character(argv$sample),
                            file_bam = as.character(argv$bam_file),
                            stringsAsFactors = FALSE)

# Run the bamInfo script
bam_info <- SGSeq::getBamInfo(sample_info.df, cores = argv$cpus)

# Write out the output
write.table(bam_info, file = argv$out_file, 
             quote = FALSE, sep = "\t", row.names = FALSE)
