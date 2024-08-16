#!/bin/bash

# settings from input
direction=${1:-0}
thickness=${2:-2000}
fold=${3:-0}
keep=${4:-1}

echo "Felix-AI: training for direction" $direction"," $thickness "with fold" $fold

# settings for directories
currdir=$(pwd)
jobdir=$currdir

jobfile="FAI-${direction}-${thickness}-${fold}.sh"

cat >${jobfile} <<EOD
#!/bin/bash
# Job name:
#SBATCH --job-name=ai-diff
#SBATCH --account=su007-rr-gpu
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
#SBATCH --time=48:00:00
#
## Command(s) to run (example):

date
module restore ai-diffraction-160824
cd .. #/ai-diffraction
srun python train.py --dataroot datasets/patterns-primary --direction $direction --thickness $thickness --gpu_ids 0 --split data/splits/patterns-primary/$fold
date
EOD

chmod 755 ${jobfile}
#sbatch --partition devel ${jobfile} # for DEVEL queueing system
#sbatch ${jobfile} # for PRODUCTION queueing system

sleep 1
