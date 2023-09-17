#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=42
#SBATCH --mem-per-cpu=3850
#SBATCH --gres=gpu:1
#SBATCH --partition=gpu
#SBATCH --time=10:00:00

module restore ai

srun python src/train.py --dataroot ~/FDP --split ./data/splits/F_-4_3_m --gpu_ids -1 --input CD --name seedF_-4_3_m_CD

