##input: Output of legume_rep_gene_filter.R
#usage: python network_generator.py network.gml

import networkx as nx
import pandas as pd
import sys
gml=sys.argv[1]
network = nx.read_gml(gml, label='label', destringizer=None)

node_attribute_frame = pd.read_csv('node_attributes.tsv', sep='\t')
node_attribute_frame.index = ['type']
attributes = node_attribute_frame.to_dict()

nx.set_node_attributes(network, attributes)

nx.write_gml(network,'pea_attribute_network.gml')

network = nx.read_gml(gml, label='label', destringizer=None)

node_attribute_frame = pd.read_csv('network_selfblasts_node_attributes.tsv', sep='\t')
node_attribute_frame.index = ['type']
attributes = node_attribute_frame.to_dict()
nx.set_node_attributes(network, attributes)

node_attribute_species_frame = pd.read_csv('network_selfblasts_node_species.tsv', sep='\t')
node_attribute_species_frame.index = ['species']
species_attributes = node_attribute_species_frame.to_dict()
nx.set_node_attributes(network, species_attributes)


nx.write_gml(network,'network_species_attribute.gml')
