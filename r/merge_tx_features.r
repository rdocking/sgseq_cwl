#!/usr/bin/env Rscript

suppressPackageStartupMessages(require(SGSeq))

# Parse command-line args
library(argparser, quietly = TRUE)
p <- arg_parser("Merge TxFeatures")
p <- add_argument(p, 'output_prefix', type = "character", help = 'Output file path')
p <- add_argument(p, '--txfeatures_files', type = "character", 
                  nargs = Inf, help = 'TxFeatures files')
argv <- parse_args(p)

# Get the list of txfeatures files
txfeatures_files <- argv$txfeatures_files

load(txfeatures_files[1])
merged <- tx_features
rm(tx_features)
first_sample_to_merge <- 2
print(summary(merged))

for (i in seq(first_sample_to_merge, length(txfeatures_files))) {
  print(i)
  load(txfeatures_files[i])
  merged <- SGSeq::mergeTxFeatures(merged, tx_features)
  rm(tx_features)
  print(summary(merged))
}
print(summary(merged))

# Rename and set file name
tx_features <- merged
output_file_name <- paste0(argv$output_prefix, '.tx_features.RData')
 
# Save final output
save(tx_features, file = output_file_name)
 

