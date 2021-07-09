library(tidyverse)

#needs a list of fasta files
fasta = read.csv("list_fasta", header = F, sep = "\t")
fasta <- rename(fasta , "ref_spec" = V1)

#needs a list of source of those files
sourc = read.csv("list_source", header = F, sep = "\t")
sourc <- rename(sourc, "source" = V1)

#needs a list of species
species = read.csv("list_species", header = F, sep = "\t")
species <- rename(species, "species" = V1)

#needs a list of strain (can put NA if not known)
strain = read.csv("list_strain", header = FALSE, sep = "\t")
strain <- rename(strain, "strain" = V1)

#make sure the items within the lists match before this step
combine = cbind(fasta,sourc,species,strain)

#will build genome_source.txt for you
write.csv(combine, quote = FALSE, row.names = FALSE, "genome_source.txt")