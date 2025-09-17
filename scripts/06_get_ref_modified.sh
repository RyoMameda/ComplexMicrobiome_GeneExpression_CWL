#!/bin/sh

threads=10

# input and output file path
dir=db
#

cd ${db}

# rRNA data from SILVA (release138.1)
curl -O https://ftp.arb-silva.de/release_138.1/Exports/SILVA_138.1_LSUParc_tax_silva.fasta.gz
curl -O https://ftp.arb-silva.de/release_138.1/Exports/SILVA_138.1_SSUParc_tax_silva.fasta.gz
pigz -d SILVA*.fasta.gz
makeblastdb -dbtype nucl -parse_seqids -in SILVA_138.1_LSUParc_tax_silva.fasta -out SILVA_138.1_LSUParc_tax_silva
# index files for BLASTN are included in tar archives

# Swiss-Prot data from UniProt
curl -O https://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.fasta.gz
# making BLASTP index files
pigz -d uniprot_sprot.fasta.gz
diamond makedb --in uniprot_sprot.fasta --db uniprot_sprot --threads ${threads}
pigz uniprot_sprot.fasta

# Pfam data from InterPro
curl -O https://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.hmm.gz
