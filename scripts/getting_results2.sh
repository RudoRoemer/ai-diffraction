#!/bin/bash

for PHASE in train test val
do
    for SPLIT in 0
    do
        for EPOCH in 20 40 60 80 100
        do
            python test.py --dataroot datasets/lacbed --gpu_ids 0 --split datasets/splits/random/${SPLIT} --input pattern --name structure_random${SPLIT} --how_many 99999 --phase ${PHASE} --which_epoch ${EPOCH}
        done
    done
done