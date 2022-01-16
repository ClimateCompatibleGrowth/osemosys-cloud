import sys
import os
from utilities import set_cols_from_language, name_color_codes
from result_parser import ResultParser
from figures.cost_electricity_generation import CostElectrictyGeneration


def main(csv_folder_path, language):
    set_cols_from_language(language)
    result_parser = ResultParser(csv_folder_path)
    data = CostElectrictyGeneration(result_parser.all_params, result_parser.years).data()
    data.to_csv(os.path.join(csv_folder_path, 'CostElectrictyGeneration.csv'), index=None)
    return


if __name__ == '__main__':
    if len(sys.argv) != 3:
        msg = "Usage: python {} <csv_folder_path> <language>"
        print(msg.format(sys.argv[0]))
        sys.exit(1)
    else:
        csv_folder_path = sys.argv[1]
        language = sys.argv[2]
        main(csv_folder_path, language)
