#!/usr/bin/env Rscript

# Parse command-line args
library(argparser, quietly = TRUE)
library(readr)

p <- arg_parser("Merge BamInfo files")
p <- add_argument(p, 'out_prefix', type = "character", 
                  help = 'Output prefix')
p <- add_argument(p, '--bam_info_files', type = "character", 
                  nargs = Inf, help = 'BamInfo files')
argv <- parse_args(p)

# Load all the input BAM info files and merge them
# These were all written with `write.table`
input_paths <- argv$bam_info_files
print(input_paths)

merged.df <- read_tsv(input_paths[1])

for (i in seq(2, length(input_paths))) {
  print(i)
  new.df <- read_tsv(input_paths[i])
  merged.df <- rbind(merged.df, new.df)
  rm(new.df)
}

# Export
output_file_name <- paste0(argv$out_prefix, '.bam_info.tsv')
write_tsv(merged.df, path = output_file_name)
