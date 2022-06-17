##input: Output of network_gml.py
#usage: python edgelist_generator.py network.gml<br><br>

import networkx as nx
import pandas as pd
import sys
gml=sys.argv[1]
network = nx.read_gml(gml, label='label', destringizer=None)

with open('components.tsv', 'w') as out:
	for counter, i in enumerate(list(nx.connected_components(network))):  
		for a in i:        
			out.write('%s\t%s\n'%(counter, a))   

edgelist=nx.to_pandas_edgelist(network)
edgelist.to_csv("edgelist.tsv", sep="\t")
