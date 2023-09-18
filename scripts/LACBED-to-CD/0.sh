#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=42
#SBATCH --mem-per-cpu=3850
#SBATCH --partition=compute
#SBATCH --time=25:00:00

module restore ai

srun python train.py --dataroot ~/FDP --split ./data/splits/0 --gpu_ids -1 --input LACBED --name LACBED/seed0_CD --no_vgg_loss
