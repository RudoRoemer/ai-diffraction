#!/bin/bash
# Job name:
#SBATCH --job-name=test1
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
#SBATCH --time=02:00:00
#
## Command(s) to run (example):

module restore ai
cd ai-diffraction
srun python train.py --dataroot ../datasets/felix_output_9940 --direction 0 --thickness 2000 --gpu_ids 0 --split ../datasets/splits/felix_output_9940/0
