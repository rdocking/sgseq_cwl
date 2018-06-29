#!/usr/bin/env Rscript

suppressPackageStartupMessages(require(SGSeq))

# Parse command-line args
library(argparser, quietly = TRUE)
p <- arg_parser("Merge SGFeatureCounts")
p <- add_argument(p, 'out_prefix', type = "character", help = 'Output file path')
p <- add_argument(p, '--feature_files', type = "character", 
                  nargs = Inf, help = 'SGFeatureCounts files')
argv <- parse_args(p)

# Load all the new SGFeatureCounts files and merge them
# These are all R objects called `sg_feature_counts`
feature_counts_paths <- argv$feature_files
load(feature_counts_paths[1])
merged <- sg_feature_counts
rm(sg_feature_counts)
print(summary(merged))
for (i in seq(2, length(feature_counts_paths))) {
  print(i)
  load(feature_counts_paths[i])
  merged <- cbind(merged, sg_feature_counts)
  rm(sg_feature_counts)
  print(summary(merged))
}
print(summary(merged))

# Rename and export
splice_graph_feature_counts <- merged
output_file_name <- paste0(argv$out_prefix, '.sg_feature_counts.RData')
save(splice_graph_feature_counts, file = output_file_name)

