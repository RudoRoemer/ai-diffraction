#!/bin/bash
# Job name:
#SBATCH --job-name=run_tests
#
# Partition:
#SBATCH --partition=gpu
#
# Number of nodes:
#SBATCH --nodes=1
#
# Number of tasks (one for each GPU desired for use case) (example):
#SBATCH --ntasks=1
#
# Processors per task:
# Always at least twice the number of GPUs (savio2_gpu and GTX2080TI in savio3_gpu)
# Four times the number for TITAN and V100 in savio3_gpu and A5000 in savio4_gpu
# Eight times the number for A40 in savio3_gpu
#SBATCH --cpus-per-task=1
#
#Number of GPUs, this can be in the format of "gpu:[1-4]", or "gpu:K80:[1-4] with the type included
#SBATCH --gres=gpu:1
#
# Wall clock limit:
#SBATCH --time=24:00:00
#
## Command(s) to run (example):

module restore ai

# Loop through all subfolders in checkpoints/predict-potential
for direction in "predict-potential"; do
    for epoch in {10..100..10}; do
        for thickness in "2000"; do
            full_path="checkpoints/$direction/$thickness"
            for dir in "$full_path"/*/; do
                # Remove the trailing slash to get the folder name
                experiment=$(basename "$dir")

                split=$(basename "$name" | awk -F'_' '{print $4}')

                name="$direction/$thickness/$experiment"

                # Loop through the phases "test" and "train"
                for phase in "test" "train"; do
                    # Run your command using the variables $name, $number, $epoch, and $phase
                    echo "Running command with folder: $name, number: $split, epoch: $epoch, phase: $phase"

                    srun python train.py --dataroot datasets/patterns-primary --gpu_ids 0 --name $name --split data/splits/patterns-primary/$split --phase $phase --epoch $epoch --how_many 99999
            done
        done
    done
done