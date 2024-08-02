import os
import re
import numpy as np
import matplotlib.image as image
import numba as nb
import pandas as pd

data_dir = "../mini_felix_output/"

df = pd.read_csv("metadata.csv", index_col="index")
df_latest = df.loc[df["latest"] == True]

not_found = []

for ICSD_code in os.listdir(data_dir):
    if not ICSD_code.isdigit():
        continue

    if not (df.query(f"ICSD_code=={ICSD_code}")["latest"].item()):
        continue

    i = 0
    for f in os.listdir(os.path.join(data_dir, ICSD_code)):
        if os.path.isdir(os.path.join(data_dir, ICSD_code, f)):
            i += 1
    if i != 5:
        not_found.append(int(ICSD_code))

df_latest_missing = df_latest[df_latest["ICSD_code"].isin(not_found)]
df_latest_missing.reset_index(drop=True, inplace=True)
df_latest_missing.to_csv("df_latest_missing.csv")
