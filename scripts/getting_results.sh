#!/bin/bash

for PHASE in train test; do
    for SPLIT in 0 1 2 3 4 5 6 7 8 9; do
        for EPOCH in 10 20 30; do
            python test.py --dataroot "" --gpu_ids 0 --split ""${SPLIT} --direction 0 --how_many 99999 --phase ${PHASE} --which_epoch ${EPOCH}
        done
    done
done
