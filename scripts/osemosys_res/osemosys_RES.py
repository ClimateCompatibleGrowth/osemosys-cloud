"""Script to automate the generation of an RES from an OSeMOSYS data file
"""

import pandas as pd
import os, sys
from collections import defaultdict
from graphviz import Digraph

#data_infile = r'data.txt'

def main(data_infile, out_file):

	parsing = False

	data_all = []
	data_out = []
	data_inp = []
	output_table = []
	storage_to = []
	storage_from = []

	with open(data_infile, 'r') as f:
		for line in f:
			if line.startswith('set YEAR'):
				start_year = line.split(' ')[3]
			if line.startswith('set COMMODITY'): # Extracts list of COMMODITIES from data file. Some models use FUEL instead. 
				fuel_list = line.split(' ')[3:-1]
			if line.startswith('set FUEL'): # Extracts list of FUELS from data file. Some models use COMMODITIES instead. 
				fuel_list = line.split(' ')[3:-1]
			if line.startswith('set TECHNOLOGY'):
				tech_list = line.split(' ')[3:-1]
			if line.startswith('set STORAGE'):
				storage_list = line.split(' ')[3:-1]
			if line.startswith('set MODE_OF_OPERATION'):
				mode_list = line.split(' ')[3:-1]
			
			if line.startswith(";"):
					parsing = False   
			
			if parsing:
				if line.startswith('['):
					fuel = line.split(',')[2]
					tech = line.split(',')[1]
				elif line.startswith(start_year):
					years = line.rstrip(':= ;\n').split(' ')[0:]
					years = [i.strip(':=') for i in years]
				else:
					values = line.rstrip().split(' ')[1:]
					mode = line.split(' ')[0]
					
					if param_current=='OutputActivityRatio':    
						data_out.append(tuple([fuel,tech,mode]))
						for i in range(0,len(years)):
							output_table.append(tuple([tech,fuel,mode,years[i],values[i]]))
					
					if param_current=='InputActivityRatio':
						data_inp.append(tuple([fuel,tech,mode]))   
					
					data_all.append(tuple([tech,mode]))

					if param_current == 'param TechnologyToStorage' or param_current == 'param TechnologyToStorage':
						if not line.startswith(mode_list[0]):
							storage = line.split(' ')[0]
							values = line.rstrip().split(' ')[1:]
							for i in range(0,len(mode_list)):
								if values[i] != '0':
									storage_to.append(tuple([storage,tech,mode_list[i]]))
					
			if line.startswith(('param OutputActivityRatio','param InputActivityRatio','param TechnologyToStorage','param TechnologyFromStorage')):
				param_current = line.split(' ')[1]
				parsing = True


	list_RES = []
	list_RES_outputs = []
	input_fuels = []

	for each_inp in data_inp:
		input_fuels.append(each_inp[0])

	for each_out in data_out:
		for each_inp in data_inp:
			if each_out[0] == each_inp[0]:
				if each_out[1].startswith('LNDAGR'):
					list_RES.append(('LNDAGRXXX', each_inp[1], each_out[0]))
				elif each_inp[1].startswith('LNDCP'):
					list_RES.append((each_out[1], 'LNDCPXXXXXX', each_out[0]))
				elif each_inp[1].startswith('LNDAGR'):
					if each_inp[0].startswith('LCP'):
						list_RES.append(('LNDCPXXXXXX', 'LNDAGRXXX', 'LCPXXXXXX'))
					else:
						list_RES.append((each_out[1], 'LNDAGRXXX', each_out[0]))
				else:
					list_RES.append((each_out[1], each_inp[1], each_out[0]))
			if each_out[0] not in input_fuels:
				if each_out[1].startswith('LNDAGR'):
					if each_out[0].startswith('CRP'):
						list_RES_outputs.append(('LNDAGRXXX', 'CRPXXX', 'CRPXXX'))
					else:
						list_RES_outputs.append(('LNDAGRXXX', each_out[0], each_out[0]))
				else:
					list_RES_outputs.append((each_out[1],each_out[0],each_out[0]))
	
	list_RES = list(set(list_RES))
	list_RES_outputs = list(set(list_RES_outputs))

	f = Digraph('finite_state_machine', filename=out_file)
	f.attr(rankdir='LR', size='8,5')
	
	for each in list_RES:
		f.attr('node', shape='square')
		f.edge(each[0], each[1], label=each[2])

	for each in list_RES_outputs:
		f.attr('node', shape='doublecircle')
		f.edge(each[0], each[2], label=each[2])

	f.view()

if __name__ == '__main__':
        data_infile = sys.argv[1]
        out_file = sys.argv[2]
        main(data_infile, out_file)



