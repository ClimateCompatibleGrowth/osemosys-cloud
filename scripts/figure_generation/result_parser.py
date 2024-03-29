import os
import pandas as pd


class ResultParser:
    def __init__(self, results_path):
        self.all_params = {}
        self._df_y_min = 9999
        self._df_y_max = 0
        self.results_path = results_path
        self.__parse_results()
        self.years = pd.Series(list(range(self._df_y_min, self._df_y_max + 1)))

    def __parse_results(self):
        for each_file in os.listdir(self.results_path):
            if each_file.endswith(".csv"):
                df_param = pd.read_csv(os.path.join(self.results_path, each_file))
                param_name = df_param.columns[-1]
                df_param.rename(columns={param_name: 'value'}, inplace=True)
                self.all_params[param_name] = pd.DataFrame(df_param)
                if 'y' in df_param.columns:
                    if self._df_y_min > df_param.y.min():
                        self._df_y_min = df_param.y.min()
                    if self._df_y_max < df_param.y.max():
                        self._df_y_max = df_param.y.max()
            else:
                raise Exception("Non-csv file in the results folder")
