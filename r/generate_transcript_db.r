#!/usr/bin/env Rscript

# Parse command-line args
library(argparser, quietly = TRUE)
p <- arg_parser("Run SGSeq::getBamInfo for a single sample")
p <- add_argument(p, 'gtf_file', type = "character", help = 'GTF file')
p <- add_argument(p, 'out_file', type = "character", help = 'Output file path')
argv <- parse_args(p)

options(echo = TRUE)
suppressPackageStartupMessages(require(SGSeq))

# Read GTF file with transcripts
# Currently assuming the default values for transcript IDs
txdb <- SGSeq::importTranscripts(file = argv$gtf_file,
                                 tag_tx = 'transcript_id', tag_gene = 'gene_id')

# Convert to TxFeatures
txdb_features <- SGSeq::convertToTxFeatures(txdb)

# Subset to regular chromosomes
txdb_features_main_chrs <- 
  GenomeInfoDb::keepStandardChromosomes(txdb_features, pruning.mode = "coarse")

# Write the txfeatures file
save(txdb_features_main_chrs, file = argv$out_file)

