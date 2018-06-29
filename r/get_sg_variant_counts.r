#!/usr/bin/env Rscript

# Parse command-line args
library(argparser, quietly = TRUE)
library(readr)
p <- arg_parser("Run SGSeq::getSGVariantCounts for a single sample")
p <- add_argument(p, 'bam_info', type = "character", help = 'BAM info file (from SGSeq::getBamInfo)')
p <- add_argument(p, 'bam_file', type = "character", help = 'BAM file')
p <- add_argument(p, 'sg_variants', type = "character", help = "SGVariants file (from run_findSGVariants.R)")
p <- add_argument(p, 'out_file', type = "character", help = 'Output file path')
p <- add_argument(p, '--cpus', type = "integer", 
                    help = 'Number of CPUs to use', default = 1)
argv <- parse_args(p)

suppressPackageStartupMessages(require(SGSeq))

# Read in the sample info
bam_info.df <- read_tsv(argv$bam_info)

# Update the data frame with the provided path of the bam_file
# This is a bit hacky, but I can't figure out a better way to get the current BAM path into the DF
# Also, filter down to the single BAM file provided - note that this _also_ may be error prone
#  since it relies on the last path component being the same
bam_base_name <- base::basename(argv$bam_file)
condition <- base::basename(bam_info.df$file_bam) == bam_base_name
bam_info.df <- bam_info.df[condition,]
bam_info.df$file_bam <- argv$bam_file
print(bam_info.df)

# Load the splice graph variants as `splice_graph_variants`
load(argv$sg_variants)
# print(splice_graph_variants)

# Run getSGVariantCounts
sg_variant_counts <- 
  SGSeq::getSGVariantCounts(
    variants = splice_graph_variants,  
    sample_info = bam_info.df,
    min_denominator = NA,
    min_anchor = 1,
    verbose = TRUE,
    cores = as.integer(argv$cpus))

# Write out the output
save(sg_variant_counts, file = argv$out_file)
