#!/bin/bash

for PHASE in train test val
do
    for SPLIT in 0
    do
        python test.py --dataroot datasets/FDP --gpu_ids 0 --split data/splits/random/${SPLIT} --input CD --name CD/seed${SPLIT}_CD --how_many 99999 --phase ${PHASE} --which_epoch latest
    done
done