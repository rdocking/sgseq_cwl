#!/usr/bin/env Rscript

# Parse command-line args
library(argparser, quietly = TRUE)
p <- arg_parser("Merge BamInfo files")
p <- add_argument(p, '--bam_info_files', type = "character", 
                  nargs = Inf, help = 'BamInfo files')
argv <- parse_args(p)

# Load all the input BAM info files and merge them
# These were all written with `write.table`
input_paths <- argv$bam_info_files

merged.df <- read.table(file = input_paths[1],
             quote = FALSE, sep = "\t", row.names = FALSE)

for (i in seq(2, length(input_paths))) {
  print(i)
  new.df <- read.table(file = input_paths[i],
            quote = FALSE, sep = "\t", row.names = FALSE)
  merged.df <- rbind(merged.df, new.df)
  rm(new.df)
}

# Export
output_file_name <- paste0(argv$out_prefix, '.bam_info.tsv')
write.table(merged.df, file = output_file_name,
            quote = FALSE, sep = "\t", row.names = FALSE)
