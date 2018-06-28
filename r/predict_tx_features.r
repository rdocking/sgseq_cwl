#!/usr/bin/env Rscript

# Parse command-line args
library(argparser, quietly = TRUE)
p <- arg_parser("Run SGSeq::predictTxFeatures for a single sample")
p <- add_argument(p, 'bam_info', type = "character", help = 'BAM info file (from SGSeq::getBamInfo)')
p <- add_argument(p, 'bam_file', type = "character", help = 'BAM file')
p <- add_argument(p, 'out_file', type = "character", help = 'Output file path')
p <- add_argument(p, '--chromosome', type = "character", 
                  help = 'Chromosome to process')
p <- add_argument(p, '--cpus', type = "integer", 
                    help = 'Number of CPUs to use', default = 1)
argv <- parse_args(p)

# Load BioConductor Packages
suppressPackageStartupMessages(require(SGSeq))
suppressPackageStartupMessages(require(BSgenome.Hsapiens.UCSC.hg19))

# Read in the sample info
bam_info.df <- 
  read.table(argv$bam_info, header = TRUE, stringsAsFactors = FALSE)

# Update the data frame with the provided path of the bam_file
# This is a bit hacky, but I can't figure out a better way to get the current BAM path into the DF
bam_info.df[1,]$file_bam <- argv$bam_file

# Generate GRanges for just hg19 standard chromosomes
# TODO is to avoid this hard-coding
genome <- BSgenome.Hsapiens.UCSC.hg19
seq_info <- seqinfo(genome)
standard_chrs <- keepStandardChromosomes(seq_info)
standard_chrs_minus_mito <- dropSeqlevels(standard_chrs, 'chrM')
hg19_standard.granges <- GRanges(standard_chrs_minus_mito)

# If the chromosomes option is defined, subset to just that chromosome
if (!is.na(argv$chromosome)) {
  granges_to_process <- 
    keepSeqlevels(hg19_standard.granges, 
                  argv$chromosome, 
                  pruning.mode = "coarse")
}

# Run predictTxFeatures
# Non-default options:
## max_complexity - Default is 20, tweaked down to 10
tx_features <- 
  SGSeq::predictTxFeatures(
    sample_info = bam_info.df,
    which = granges_to_process, 
    min_overhang = NULL,
    max_complexity = 10,
    verbose = TRUE,
    cores = as.integer(argv$cpus))

# Write out the output
save(tx_features, file = argv$out_file)
