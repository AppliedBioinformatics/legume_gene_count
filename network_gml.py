##input: Output of selfblast_hsp_filter.R 
#usage: python selfblast_hsp_filter.R network_gml.py selfblast_output_10hsp_blast_filtered_nodes.csv selfblast_output_10hsp_blast_filtered_edge.csv

import networkx as nx
import matplotlib.pyplot as plt
import csv
from operator import itemgetter
from networkx.algorithms import community
import sys
gml1=sys.argv[1]
gml2=sys.argv[2]

with open(gml1, 'r') as nodecsv: # Open the file
    nodereader = csv.reader(nodecsv) # Read the csv
            # Retrieve the data (using Python list comprehension and list slicing to remove the header row, see footnote 3)
    nodes = [n for n in nodereader][1:]
    node_names = [n[0] for n in nodes] # Get a list of only the node names

with open(gml2, 'r') as edgecsv: # Open the file
    edgereader = csv.reader(edgecsv) # Read the csv
    edges = [tuple(e) for e in edgereader][1:] # Retrieve the data

print(len(node_names))
print(len(edges))

G = nx.Graph()
G.add_nodes_from(node_names)
G.add_edges_from(edges)
print(nx.info(G))
options = {'node_size': 100,
        'width': 3,
        }
nx.draw(G, with_labels=True, font_weight='bold', **options)
nx.write_gml(G, 'network.gml')
