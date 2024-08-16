import os
import re
import numpy as np
import matplotlib.image as image
import numba as nb
import pandas as pd
import shutil

data_dir = "input_data/"
cleaned_data_dir = "input_data_latest_cleaned/"
os.makedirs(cleaned_data_dir, exist_ok=True)

IMAGE_SIZE = 128
FACTOR = 1 / (IMAGE_SIZE - 1)
TWO_PI_I = complex(0, 2 * np.pi)


@nb.njit()
def get_lattice(arr, Cug, gVec):
    lines = len(gVec)
    for i in range(IMAGE_SIZE):
        for j in range(IMAGE_SIZE):
            for n in range(lines):  # Number of lines in .txt
                ReDotgVec = i * gVec[n][0] + j * gVec[n][1]
                ExpVar = np.exp(TWO_PI_I * ReDotgVec * FACTOR)
                arr[j][i] += np.real(Cug[n] * ExpVar)


for ICSD_code in os.listdir(data_dir):
    if ICSD_code.isdigit():
        print(ICSD_code)
    else:
        continue

    i = 0
    for f in os.listdir(os.path.join(data_dir, ICSD_code)):
        if os.path.isdir(os.path.join(data_dir, ICSD_code, f)):
            i += 1

            width = int(re.search(r"Sim_(.+)A", f).group(1))

            if os.path.exists(os.path.join(cleaned_data_dir, str(width), ICSD_code, f"diffraction_pattern.png")):
                pass
            else:
                for view in os.listdir(os.path.join(data_dir, ICSD_code, f)):
                    if "+0+0+0" in view:
                        pattern = np.fromfile(os.path.join(data_dir, ICSD_code, f, view), dtype=np.float64)
                        pattern = pattern.reshape((128, 128))
                        os.makedirs(os.path.join(cleaned_data_dir, str(width), ICSD_code), exist_ok=True)
                        image.imsave(
                            os.path.join(cleaned_data_dir, str(width), ICSD_code, f"diffraction_pattern.png"),
                            pattern,
                            cmap="Greys",
                        )

            if np.all([os.path.exists(os.path.join(cleaned_data_dir, str(w), ICSD_code, f"charge_density.png")) for w in (500, 1000, 1500, 2000)]):
                pass
            else:
                if i == 1:
                    structure_factors = np.loadtxt(os.path.join(data_dir, ICSD_code, f, "StructureFactors.txt"))
                    Cug = np.apply_along_axis(lambda row: complex(row[5], row[6]), 1, structure_factors)
                    gVec = np.apply_along_axis(lambda row: [row[0], row[1], row[2]], 1, structure_factors)
                    arr = np.zeros((IMAGE_SIZE, IMAGE_SIZE))
                    get_lattice(arr, Cug, gVec)
                    arr = arr / np.max(arr)
                image.imsave(
                    os.path.join(cleaned_data_dir, str(width), ICSD_code, f"charge_density.png"),
                    arr,
                    cmap="Greys",
                )
    if i != 4:
        for w in (500, 1000, 1500, 2000):
            shutil.rmtree(os.path.join(cleaned_data_dir, str(w), ICSD_code))
