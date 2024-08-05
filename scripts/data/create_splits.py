import numpy as np
import os

dataroot = "../../datasets/felix_output/2000"
splits = "../../data/splits/felix_output"

os.makedirs(splits, exist_ok=True)

np.random.seed(42)

codes = np.array(os.listdir(dataroot))

ratios = np.array([0.80, 0.10, 0.10])
size = len(codes)
limits = np.ceil(np.cumsum(ratios * size)).astype(int)

for i in range(20):
    np.random.shuffle(codes)
    train = codes[:limits[0]]
    val = codes[limits[0]:limits[1]]
    test = codes[limits[1]:limits[2]]
    
    os.makedirs(os.path.join(splits, f"{i}"), exist_ok=True)
    np.savetxt(os.path.join(splits, f"{i}", "train"), train, delimiter = ',', fmt=r"%s")
    np.savetxt(os.path.join(splits, f"{i}", "val"), val, delimiter = ',', fmt=r"%s")
    np.savetxt(os.path.join(splits, f"{i}", "test"), test, delimiter = ',', fmt=r"%s")
    
