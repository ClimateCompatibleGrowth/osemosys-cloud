import pandas as pd
import os

global det_col
global color_dict
det_col = None
color_dict = None


name_color_codes = pd.read_csv(
        os.path.join(os.getcwd(), 'name_color_codes.csv'),
        encoding='latin-1')


def set_cols_from_language(language):
    global det_col
    global color_dict
    if language == 'es':
        det_col = dict(
                    [(c, n) for c, n in zip(name_color_codes.code, name_color_codes.name_spanish)]
                )
        color_dict = dict(
                    [(n, c) for n, c in zip(name_color_codes.name_spanish, name_color_codes.colour)]
                )
    else:
        det_col = dict(
                    [(c, n) for c, n in zip(name_color_codes.code, name_color_codes.name_english)]
                )
        color_dict = dict(
                    [(n, c) for n, c in zip(name_color_codes.name_english, name_color_codes.colour)]
                    )


def df_filter(df, lb, ub, t_exclude, years):
    df['t'] = df['t'].str[lb:ub]
    df['value'] = df['value'].astype('float64')
    df = df[~df['t'].isin(t_exclude)].pivot_table(index='y',
                                                  columns='t',
                                                  values='value',
                                                  aggfunc='sum').reset_index().fillna(0)
    df = df.reindex(sorted(df.columns), axis=1).set_index('y').reset_index().rename(columns=det_col)  # noqa
    df = df_years(df, years)
    return df


def df_years(df, years):
    new_df = pd.DataFrame()
    new_df['y'] = years
    new_df['y'] = new_df['y'].astype(int)
    df['y'] = df['y'].astype(int)
    new_df = pd.merge(new_df, df, how='outer', on='y').fillna(0)
    return new_df
