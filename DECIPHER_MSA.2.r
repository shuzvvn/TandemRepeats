#!/usr/bin/Rscript

# Usage: 
# DECIPHER_MSA.2.r \
# --infile=~/EW_project/Kgroup/nt/K24316.fas.gz \
# --outfile=~/EW_project/TR02.16/MSA_nt/K24316.MSA.rds \
# --nt


# load libraries

library(optparse)

# specify options in a list
option_list = list(
    make_option(c("-i", "--infile"), type="character", default="NA", help="input seq (Required)", metavar="filename"),
    make_option(c("-o", "--outfile"), type="character", default="NA", help="output .rds (Required)", metavar="filename"),
    make_option(c("-n", "--nt"), action="store_true", default=FALSE, help="input is DNA seq [default=%default]")
); 

# get command line options, if help option encountered print help and exit,
# otherwise if options not found on command line then set defaults,
opt <- parse_args(OptionParser(usage = "%prog [options] [--infile=FILENAME] [--outfile=FILENAME]", option_list=option_list)) 


######################## main ########################
library(DECIPHER)

# read input seq file
if ( opt$nt ) {
    seq <- readDNAStringSet(opt$infile)
    result <- AlignTranslation(seq, processors=NULL)
} else {
    seq <- readAAStringSet(opt$infile)
    result <- AlignSeqs(seq, processors=NULL)
}

# print input filename
message <- cat("Input:", opt$infile)
write(message, stderr())

message <- cat("length:", length(seq))
write(message, stderr())

# save results as RDS files
saveRDS(result, file=opt$outfile, compress = TRUE)