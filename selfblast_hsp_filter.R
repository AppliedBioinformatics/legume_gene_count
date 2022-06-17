##input: Blast file in outfmt 6 
#usage: Rscript selfblast_hsp_filter.R blast_file.tsv

library(tidyverse)
library(data.table)

args = commandArgs(trailingOnly=TRUE)

hsp_table <- blasts <- fread(args[1],nThread=20, header = F) %>% as_tibble()

colnames(hsp_table) <- c('qseqid','sseqid','sscinames','scomnames','pident','length','mismatch','gapopen','qstart','qend','sstart','send','ppos','evalue','bitscore')

df = hsp_table %>%
  group_by(qseqid, sseqid) %>%
  filter(evalue < 0.01) %>%
  filter(evalue==min(evalue))

write_tsv (df, paste0(unlist(strsplit(args[1],'[.]'))[1],'_filtered_e001.tsv'))
nodes = tibble(node=unique(c(df$qseqid,df$sseqid)))
edges = select(df, qseqid,sseqid)
write_csv(nodes,paste0(unlist(strsplit(args[1],'[.]'))[1],'_filtered_e001_nodes.csv'))
write_csv(edges,paste0(unlist(strsplit(args[1],'[.]'))[1],'_filtered_e001_edges.csv'))
