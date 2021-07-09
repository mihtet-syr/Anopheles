#make a list of the gtf files of genomes to be used as reference without the .gtf ending
# ls | grep .gtf | sed 's/.gtf//' > list_ref

read -p " Pick the type of gtf annotation file: 1 =  RefSeq or 2 =  Genbank or 3 = VectorBase " number2  
read -p " Pick the type of gtf annotation file: 1 =  gtf or 2 =  gff " number1  
if [ $number1 -eq 1 ] &&  [ $number2 -eq 1 ]
then  
echo "You picked RefSeq"
for loop1 in $(cat list_ref)
    do
    cd /home/mihtet/myGitRep/Anopheles/fasta_gtf #path to directory with fasta files and gtf files
    awk '$3 == "CDS"' $loop1.gtf | sed 's/"; db_xref.*exon_number "/_/g' > $loop1.CDS.gtf
    grep -Po 'transcript_id "\K.*?(?=")' $loop1.CDS.gtf > $loop1.CDS.exons.txt    
    sed -i '1 i\exons' $loop1.CDS.exons.txt #gives EXON_LIST 
    for loop2 in $loop1
        do
        gffread $loop2.CDS.gtf -g $loop2.fna -x $loop2.CDS.fasta #gives REF_EXONS file 
        samtools faidx $loop2.CDS.fasta 
        done
    cut -f 1,2 $loop1.CDS.fasta.fai > $loop1.CDS.exon_lengths # gives EXON_LENGTHS
    done

elif [ $number1 -eq 1 ] &&  [ $number2 -eq 2 ]
then
echo "You picked Genbank"
for loop1 in $(cat list_ref)
    do
    cd /home/mihtet/myGitRep/Anopheles/fasta_gtf #path to directory with fasta files and gtf files
    awk '$3 == "CDS"' $loop1.gtf | sed 's/"; db_xref.*exon_number "/_/g' > $loop1.CDS.gtf
    sed -i 's/gnl|WGS:AAAB|//g' $loop1.CDS.gtf
    grep -Po 'transcript_id "\K.*?(?=")' $loop1.CDS.gtf > $loop1.CDS.exons.txt    
    sed -i '1 i\exons' $loop1.CDS.exons.txt #gives EXON_LIST 
    for loop2 in $loop1
        do
        gffread $loop2.CDS.gtf -g $loop2.fna -x $loop2.CDS.fasta #gives REF_EXONS file 
        samtools faidx $loop2.CDS.fasta 
        done
    cut -f 1,2 $loop1.CDS.fasta.fai > $loop1.CDS.exon_lengths # gives EXON_LENGTHS
    done
elif [ $number1 -eq 2 ] &&  [ $number2 -eq 3 ]
then
echo "You picked gff VectorBase" 
for loop1 in $(cat list_ref)
    do
    cd /home/mihtet/myGitRep/Anopheles/fasta_gtf #path to directory with fasta files and gtf files
    awk '$3 == "CDS"'  $loop1.gff |  sed 's/;.*$//g' > $loop1.CDS.gff # for gff files 
    grep -oP '(?<=ID=).*' $loop1.CDS.gff > $loop1.CDS.exons.txt # for gff files
    sed -i '1 i\exons' $loop1.CDS.exons.txt #gives EXON_LIST 
    for loop2 in $loop1
        do
        gffread $loop2.CDS.gff -g $loop2.fna -x $loop2.CDS.fasta #for gff
        samtools faidx $loop2.CDS.fasta 
        done
    cut -f 1,2 $loop1.CDS.fasta.fai > $loop1.CDS.exon_lengths # gives EXON_LENGTHS
    done
else
echo "Annotation file not supported"

fi  
