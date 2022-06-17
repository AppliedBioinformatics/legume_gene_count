# legume_gene_count
#Codes for trying to calculate the representative genes in legumes. <br>
#python module networkx required<br>
<br>
#Code usage:<br>
##Blast legume against legume (Run BLAST with these parameters -outfmt "6 qseqid sseqid sscinames scomnames staxid pident length mismatch gapopen qstart qend sstart send ppos evalue bitscore")<br>
<br>
python selfblast_hsp_filter.R<br>
python network_gml.py selfblast_output_10hsp_blast_filtered_nodes.csv selfblast_output_10hsp_blast_filtered_edge.csv
