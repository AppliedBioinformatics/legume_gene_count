# legume_gene_count
#Codes for trying to calculate the representative genes in legumes. <br>
#python module networkx required<br>
<br>
#Code usage:<br>
##Blast each species against itself using blastx (Run BLAST with these parameters -outfmt "6 qseqid sseqid sscinames scomnames staxid pident length mismatch gapopen qstart qend sstart send ppos evalue bitscore")<br>
<br>
python selfblast_hsp_filter.R blast_file.tsv<br>
python network_gml.py selfblast_output_10hsp_blast_filtered_nodes.csv selfblast_output_10hsp_blast_filtered_edge.csv<br>
python edgelist_generator.py network.gml<br>
Rscript legume_rep_gene_filter.R<br>
#visualisation
python network_generator.py network.gml <br>
#more than one species
#concatenate all the representative genes together in one file.
##Blast all the representatives against themselves using using blastx (Run BLAST with these parameters -outfmt "6 qseqid sseqid sscinames scomnames staxid pident length mismatch gapopen qstart qend sstart send ppos evalue bitscore")
python selfblast_hsp_filter.R all_species_blast_file.tsv<br>
python network_gml.py selfblast_output_10hsp_blast_filtered_nodes.csv selfblast_output_10hsp_blast_filtered_edge.csv<br>
python edgelist_generator.py network.gml<br>
Rscript legume_rep_gene_filter.R<br>
