#needs 4 separate lists of fasta files, the source, the species, the strain

Rscript build_genome_source.R 
sed -i 's/,/\t/g' genome_source.txt #gives the GENOMES_ANN