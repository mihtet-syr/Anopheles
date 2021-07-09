#make a list of the gtf files of genomes to be used as reference without the .gtf ending
# ls | grep .gtf | sed 's/.gtf//' > list_ref

for gtf in $(cat list_ref)
    do
    awk '$3 == "CDS"' $gtf | sed 's/;/\t/g'  | cut -f 9,10 > $gtf.9-10
    sed -i 's/\t/;/g' $gtf.9-10 
    awk '$3 == "CDS"' $gtf | cut -f 1-8 > $gtf.1-8
    paste $gtf.1-8 $gtf.9-10 > $gtf.exons.gtf
    #sed -i 's/ /=/g' $gtf.exons.gtf
    #sed -i 's/;=/;/g' $gtf.exons.gtf
    awk -F "\t" 'OFS="\t" {print $1,$2,$3,$4,$5,$6,$7,$8,$9"_"$4"_"$5}' $gtf.exons.gtf > $gtf.CDS.exons.gff
    sed -i 's/"_/_/g' $gtf.CDS.exons.gff
    sed -i 's/"; /;/g' $gtf.CDS.exons.gff
    sed -i 's/ "/=/g' $gtf.CDS.exons.gff
    sed -i 's/transcript_id/Parent/g' $gtf.CDS.exons.gff # gtf file
    grep -Po 'Parent=\K.*$' $gtf.CDS.exons.gff > $gtf.exon_list #exon list
    sed -i '1 i\exons' $gtf.exon_list
    gffread $gtf.CDS.exons.gff -g GCA_000005575.1_AgamP3_genomic.fna -x $gtf.CDS.exons.fasta
    samtools faidx $gtf.CDS.exons.fasta
    cut -f 1,2 $gtf.CDS.exons.fasta.fai > $gtf.CDS.exons_lengths
    rm $gtf.1-8 $gtf.9-10 $gtf.exons.gtf
    done

