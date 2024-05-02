#!/bin/bash

for SPLIT in 0 1 2 3
do
    for PHASE in train test val
    do
        for EPOCH in 10 20 40 60 80 100
        do
            python test.py --dataroot datasets/FDP --gpu_ids 0 --split data/FDP_splits/random/${SPLIT} --input pattern --name structure_random${SPLIT} --how_many 99999 --phase ${PHASE} --which_epoch ${EPOCH}
        done
    done
done
