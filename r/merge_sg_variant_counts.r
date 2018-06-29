#!/usr/bin/env Rscript

suppressPackageStartupMessages(require(SGSeq))

# Parse command-line args
library(argparser, quietly = TRUE)
p <- arg_parser("Merge SGVariantCounts")
p <- add_argument(p, 'out_prefix', type = "character", help = 'Output file path')
p <- add_argument(p, '--variant_files', type = "character", 
                  nargs = Inf, help = 'SGVariantCount files')
argv <- parse_args(p)

# Load all the new SGVariantCounts files and merge them
# These are all R objects called `sg_variant_counts`
variant_counts_paths <- argv$variant_files
load(variant_counts_paths[1])
merged <- sg_variant_counts
rm(sg_variant_counts)
print(summary(merged))
for (i in seq(2, length(variant_counts_paths))) {
  print(i)
  load(variant_counts_paths[i])
  merged <- cbind(merged, sg_variant_counts)
  rm(sg_variant_counts)
  print(summary(merged))
}
print(summary(merged))

# Rename and export
splice_graph_variant_counts <- merged
output_file_name <- paste0(argv$out_prefix, '.sg_variant_counts.RData')
save(splice_graph_variant_counts, file = output_file_name)
