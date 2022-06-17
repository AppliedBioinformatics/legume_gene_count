##input: Output of edgelist_generator.py 
#usage: Rscript legume_rep_gene_filter.R

library(tidyverse)
library(data.table)

networkframe <- fread('components.tsv') %>% as_tibble() %>%
  rename(component=V1, node=V2)

edges <- fread('edgelist.tsv', header=T) %>% as_tibble() %>% select(-1)
edges2 <- edges
colnames(edges2) <- colnames(edges2)[c(2,1)]
edgelist <- bind_rows(edges,edges2) %>%
  filter(source!=target) %>%
  rename(node=source)

edgetable <- edgelist %>%
  group_by(node) %>%
  summarise(edges=n())


edgelist <- edgelist %>%
  group_by(node) %>%
  summarise(edgelist=paste(target,collapse='|'))                                                                                                  

networkframe <- networkframe %>% left_join(edgetable) %>% left_join(edgelist)
networkframe <- networkframe %>%
  mutate(component=component +1 )


all_rep_genes <- tibble(rep_gene=character(), component=numeric(), edgelist=character())
for (c in unique(networkframe$component)){
  component_frame=filter(networkframe, component==c) %>% arrange(-edges)
  x=0
  if (is.na(component_frame$edges)[1]){
    rep_gene = tibble(rep_gene = component_frame$node[1], component=c, edgelist = NA)
    all_rep_genes <- bind_rows(all_rep_genes,rep_gene)
    next
    }                                 
  for (n in 1: nrow(component_frame)){
	message(nrow(component_frame))
    x=x+1
	no=component_frame$node[1]
    message(paste0('Node ',x,' of ',length(unique(component_frame$node)), ' started...'))
	if(no %in% all_rep_genes$rep_gene){next}
    if(nrow(component_frame) == 0){next}
    if(nrow(filter(component_frame, node == no)) == 0){next}
    if(filter(component_frame, node == no)$edges == max(component_frame$edges, na.rm = TRUE)){
      rep_gene = tibble(rep_gene = no, component=c , edgelist = filter(component_frame, node == no)$edgelist)
      all_rep_genes <- bind_rows(all_rep_genes,rep_gene)
      if (component_frame %>% filter(node ==no) %>% pull(edges) == 0){remove_list = no}
      else {remove_list = unlist(c(strsplit((filter(component_frame, node == no))$edgelist,'|', fixed = T),rep_gene$rep_gene))}
      component_frame = component_frame %>%
        mutate(remove=ifelse(node %in% remove_list,T,F))
      component_frame = component_frame %>%
        filter(remove==F)
  
      #fast track
      component_frame  <- component_frame %>% mutate(edgelist=str_remove_all(edgelist,paste(remove_list, collapse= '|')),edgelist=gsub("(\\|)\\1+", "\\1", edgelist),edgelist) %>% mutate(edgelist=gsub('^\\|','',edgelist)) %>%
		mutate(edges=str_count(edgelist,sapply(strsplit(no,'[.]'),'[',1))) %>% arrange(-edges)
	}
    else {next}
    message(paste0('Node ',x,' of ',length(unique(component_frame$node)), ' complete!'))
  }
  message(paste0('component ',c,' of ',length(unique(networkframe$component)), ' complete!'))
}

write_tsv(all_rep_genes,paste0(sapply(strsplit(networkframe$node[1],'[.]'),'[',1),'_new_rep_genes.tsv'))

#representative sorter

networkframe <- fread('components.tsv') %>% as_tibble() %>% 
  rename(cluster=V1, node=V2) 
networkframe <- head(networkframe,-1) 

rep_network <- left_join(networkframe, d_pea_rep, by=c("node" = "rep_gene")) 
colnames(rep_network) <- c("cluster","node","type","edgelist")
rep_network <- rep_network %>% select(2:3)

rep_network <- rep_network %>% mutate(type = ifelse(is.na(type), type, "representative"))
rep_network$type <- as.character(rep_network$type)
rep_network$type[is.na(rep_network$type)] <- "nonrepresentative"

write_tsv(rep_network, 'network_pea_rep_proteins.tsv')

wide_rep_network <- t(rep_network)
colnames(wide_rep_network) <- wide_rep_network[1,]
wide_rep_network <- wide_rep_network[2,]
wide_rep_network <- t(wide_rep_network)
test <- as.data.frame(wide_rep_network)
rownames(test) <- "type"

write_tsv(test, 'node_attributes.tsv') 
