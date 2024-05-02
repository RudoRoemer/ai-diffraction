#!/bin/bash

for PHASE in train test val
do
    for SPLIT in 0 1 2 3 4 5 6 7 8 9
    do
        for EPOCH in 10
        do
            python test.py --dataroot datasets/FDP --gpu_ids 0 --split data/FDP_splits/random/${SPLIT} --input structure --name pattern_random${SPLIT} --how_many 99999 --phase ${PHASE} --which_epoch ${EPOCH}
        done
    done
done