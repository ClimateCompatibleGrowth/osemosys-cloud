"""Script to automate the generation of an RES from an OSeMOSYS data file
"""

import pandas as pd
import os, sys
from collections import defaultdict
from graphviz import Digraph

# data_infile = r'data.txt'


def main(data_infile, out_file):

    parsing = False
    parsing_year = False
    parsing_tech = False
    parsing_fuel = False
    parsing_mode = False
    parsing_storage = False
    parsing_emission = False

    otoole = False

    year_list = []
    fuel_list = []
    tech_list = []
    storage_list = []
    mode_list = []
    emission_list = []

    data_all = []
    data_out = []
    data_inp = []
    output_table = []
    input_table = []
    storage_to = []
    storage_from = []
    emission_table = []

    params_to_check = ['OutputActivityRatio', 
                       'InputActivityRatio', 
                       'TechnologyToStorage', 
                       'TechnologyFromStorage', 
                       'EmissionActivityRatio']

    with open(data_infile, 'r') as f:
        for line in f:
            if line.startswith('# Model file written by *otoole*'):
                otoole = True
            if parsing_year:
                year_list += [line.strip()] if line.strip() not in ['', ';'] else []
            if parsing_fuel:
                fuel_list += [line.strip()] if line.strip() not in ['', ';'] else []
            if parsing_tech:
                tech_list += [line.strip()] if line.strip() not in ['', ';'] else []
            if parsing_storage:
                storage_list += [line.strip()] if line.strip() not in ['', ';'] else []
            if parsing_mode:
                mode_list += [line.strip()] if line.strip() not in ['', ';'] else []
            if parsing_emission:
                emission_list += [line.strip()] if line.strip() not in ['', ';'] else []

            if line.startswith('set YEAR'):
                if len(line.split('=')[1]) > 1:
                    year_list = line.split(' ')[3:-1]
                else:
                    parsing_year = True
            if line.startswith('set COMMODITY'): # Extracts list of COMMODITIES from data file. Some models use FUEL instead.
                if len(line.split('=')[1]) > 1:
                    fuel_list = line.split(' ')[3:-1]
                else:
                    parsing_fuel = True
            if line.startswith('set FUEL'): # Extracts list of FUELS from data file. Some models use COMMODITIES instead.
                if len(line.split('=')[1]) > 1:
                    fuel_list = line.split(' ')[3:-1]
                else:
                    parsing_fuel = True
            if line.startswith('set TECHNOLOGY'):
                if len(line.split('=')[1]) > 1:
                    tech_list = line.split(' ')[3:-1]
                else:
                    parsing_tech = True
            if line.startswith('set STORAGE'):
                if len(line.split('=')[1]) > 1:
                    storage_list = line.split(' ')[3:-1]
                else:
                    parsing_storage = True
            if line.startswith('set MODE_OF_OPERATION'):
                if len(line.split('=')[1]) > 1:
                    mode_list = line.split(' ')[3:-1]
                else:
                    parsing_mode = True
            if line.startswith('set EMISSION'):
                if len(line.split('=')[1]) > 1:
                    emission_list = line.split(' ')[3:-1]
                else:
                    parsing_emission = True

            if line.startswith(";"):
                parsing_year = False
                parsing_tech = False
                parsing_fuel = False
                parsing_mode = False
                parsing_storage = False
                parsing_emission = False

    start_year = year_list[0]

    if not otoole:
        with open(data_infile, 'r') as f:
            for line in f:
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

                        if param_current =='OutputActivityRatio':
                            data_out.append(tuple([fuel, tech, mode]))
                            data_all.append(tuple([tech, mode]))
                            for i in range(0,len(years)):
                                output_table.append(tuple([tech, fuel, mode, years[i], values[i]]))

                        if param_current =='InputActivityRatio':
                            data_inp.append(tuple([fuel, tech, mode]))
                            data_all.append(tuple([tech, mode]))
                            for i in range(0,len(years)):
                                input_table.append(tuple([tech, fuel, mode, years[i], values[i]]))

                        if param_current == 'TechnologyToStorage' or param_current == 'TechnologyFromStorage':
                            if not line.startswith(mode_list[0]):
                                storage = line.split(' ')[0]
                                values = line.rstrip().split(' ')[1:]
                                for i in range(0, len(mode_list)):
                                    if values[i] != '0':
                                        if param_current == 'TechnologyToStorage':
                                            storage_to.append(tuple([storage, tech, mode_list[i]]))
                                            data_all.append(tuple([tech, mode_list[i]]))
                                        if param_current == 'TechnologyFromStorage':
                                            storage_from.append(tuple([storage, tech, mode_list[i]]))
                                            data_all.append(tuple([tech, mode_list[i]]))

                if line.startswith(('param OutputActivityRatio',
                                    'param InputActivityRatio',
                                    'param TechnologyToStorage',
                                    'param TechnologyFromStorage')):
                    param_current = line.split(' ')[1]
                    parsing = True

    if otoole:
        with open(data_infile, 'r') as f:
            for line in f:
                details = line.split(' ')
                if line.startswith(";"):
                    parsing = False
                if parsing:
                    if len(details) > 1:
                        if param_current == 'OutputActivityRatio':
                            tech = details[1].strip()
                            fuel = details[2].strip()
                            mode = details[3].strip()
                            year = details[4].strip()
                            value = details[5].strip()

                            if float(value) != 0.0:
                                data_out.append(tuple([fuel, tech, mode]))
                                output_table.append(tuple([tech, fuel, mode, year, value]))
                                data_all.append(tuple([tech, mode]))

                        if param_current == 'InputActivityRatio':
                            tech = details[1].strip()
                            fuel = details[2].strip()
                            mode = details[3].strip()
                            year = details[4].strip()
                            value = details[5].strip()
                            if float(value) != 0.0:
                                data_inp.append(tuple([fuel, tech, mode]))
                                input_table.append(tuple([tech, fuel, mode, year, value]))
                                data_all.append(tuple([tech, mode]))

                        if param_current == 'TechnologyToStorage':
                            tech = details[1].strip()
                            storage = details[2].strip()
                            mode = details[3].strip()
                            value = details[4].strip()
                            if float(value) > 0.0:
                                storage_to.append(tuple([storage, tech, mode]))
                                data_all.append(tuple([storage, mode]))

                        if param_current == 'TechnologyFromStorage':
                            tech = details[1].strip()
                            storage = details[2].strip()
                            mode = details[3].strip()
                            value = details[4].strip()
                            if float(value) > 0.0:
                                storage_from.append(tuple([storage, tech, mode]))
                                data_all.append(tuple([storage, mode]))

                        if param_current == 'EmissionActivityRatio':
                            tech = details[1].strip()
                            emission = details[2].strip()
                            mode = details[3].strip()
                            value = details[5].strip()
                            if float(value) != 0.0:
                                emission_table.append(tuple([emission, tech, mode]))
                                data_all.append(tuple([tech, mode]))

                if any(param in line for param in params_to_check):
                    param_current = details[-2]
                    parsing = True

    list_RES = []
    list_RES_outputs = []
    list_RES_inputs = []
    input_fuels = []
    output_fuels = []

    for each_out in data_out:
        output_fuels.append(each_out[0])

    for each_inp in data_inp:
        input_fuels.append(each_inp[0])
        if each_inp[0] not in output_fuels:
            list_RES_inputs.append((each_inp[1],
                                    each_inp[0],
                                    each_inp[0]))

    for each_out in data_out:
        data_inp_matching_each_out = [each_inp
                                      for each_inp
                                      in data_inp
                                      if each_out[0] == each_inp[0]]
        for each_inp in data_inp_matching_each_out:
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

    data_out_not_in_input_fuels = [each_out
                                   for each_out
                                   in data_out
                                   if each_out[0] not in input_fuels]
    for each_out in data_out_not_in_input_fuels:
        for each_inp in data_inp:
            if each_out[1].startswith('LNDAGR'):
                if each_out[0].startswith('CRP'):
                    list_RES_outputs.append(('LNDAGRXXX', 'CRPXXX', 'CRPXXX'))
                else:
                    list_RES_outputs.append(('LNDAGRXXX', each_out[0], each_out[0]))
            else:
                list_RES_outputs.append((each_out[1],
                                         each_out[0],
                                         each_out[0]))

    list_RES = sorted(list(set(list_RES)))
    list_RES_outputs = sorted(list(set(list_RES_outputs)))
    list_RES_inputs = sorted(list(set(list_RES_inputs)))

    f = Digraph('finite_state_machine', filename=out_file)
    f.attr(rankdir='LR', size='8,5')

    for each in list_RES:
        f.attr('node', shape='square')
        f.edge(each[0], each[1], label=each[2])

    for each in list_RES_outputs:
        f.attr('node', shape='doublecircle')
        f.edge(each[0], each[2], label=each[2])

    for each in list_RES_inputs:
        f.attr('node', shape='doublecircle', fillcolor='red', style='filled')
        f.edge(each[2], each[0], label=each[2])

    f.render()


if __name__ == '__main__':
    data_infile = sys.argv[1]
    out_file = sys.argv[2]
    main(data_infile, out_file)
