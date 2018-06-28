#!/usr/bin/env Rscript

suppressPackageStartupMessages(require(SGSeq))

# Parse command-line args
library(argparser, quietly = TRUE)
p <- arg_parser("Merge SGVariantCounts")
p <- add_argument(p, 'transcript_db', type = "character", help = 'Output file path')
p <- add_argument(p, 'output_prefix', type = "character", help = 'Output file path')
p <- add_argument(p, 'splice_graph_type', type = "character", 
                  help = 'Build the splice graph with "known", "predicted", or "both" kinds of features')
p <- add_argument(p, 'merge_mode', type = "character", 
                  help = 'Merge to "txfeatures" or to "sgfeatures"')
p <- add_argument(p, '--txfeatures_files', type = "character", 
                  nargs = Inf, help = 'TxFeatures files')
argv <- parse_args(p)

# Possible analysis paths:
# --splice_graph_type 'known' - use only the existing transcript annotation
# --splice_graph_type 'predicted' - use only predicted splice sites
# --splice_graph_type 'both' - combine known and predicted
print(paste("Splice graph mode:", argv$splice_graph_type))

# Merge mode:
# "txfeatures" - just merge and output to txfeatures
# "sgfeatures" - do final processing and convert to SGfeatures
print(paste("Merging mode: ", argv$merge_mode))

# Loads 'txdb_features_main_chrs'
# This is the main transcript DB generated from the supplied GTF file
load(argv$transcript_db)

# Get the list of txfeatures files
txfeatures_files <- argv$txfeatures_files

# If we're using the known annotations, or both known and novel, load the known annotation set:
first_sample_to_merge <- NULL
merged <- NULL
if (argv$splice_graph_type %in% c('known', 'both')) {
  merged <- txdb_features_main_chrs
  first_sample_to_merge <- 1
# Otherwise, start from the first set of predictions  
} else if (argv$splice_graph_type == 'predicted') {
  load(txfeatures_files[1])
  merged <- tx_features
  rm(tx_features)
  first_sample_to_merge <- 2
} 
print(summary(merged))

# If we're using novel predictions, load all the new TxFeatures files and merge them
if (argv$splice_graph_type %in% c('predicted', 'both')) {
  
  for (i in seq(first_sample_to_merge, length(txfeatures_files))) {
    print(i)
    load(txfeatures_files[i])
    merged <- SGSeq::mergeTxFeatures(merged, tx_features)
    rm(tx_features)
    print(summary(merged))
  }
  print(summary(merged))

}

# Split for merge mode:
#  If we're just exporting txfeatures, rename and export
#  Otherwise, do terminal exon processing
if (argv$merge_mode == 'txfeatures') {

  # Rename and set file name
  tx_features <- merged
  output_file_name <- paste0(argv$output_prefix, '.tx_features.RData')
  
  # Save final output
  save(tx_features, file = output_file_name)
  
} else if (argv$merge_mode == 'sgfeatures') {
  # Process Terminal Exons
  merged.process_terminal <- SGSeq::processTerminalExons(merged)
  
  # Convert to SGFeatures
  merged.process_terminal.sg_features <- 
    SGSeq::convertToSGFeatures(merged.process_terminal)
  
  # Annotate with transcript features
  merged.process_terminal.sg_features.annotated <- 
    SGSeq::annotate(merged.process_terminal.sg_features, 
                    txdb_features_main_chrs)
  
  # Rename and set file name
  splice_graph_features <- merged.process_terminal.sg_features.annotated
  output_file_name <- paste0(argv$output_prefix, '.sg_features.RData')

  # Save final output
  save(splice_graph_features, file = output_file_name)
  
}

