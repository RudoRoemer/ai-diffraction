#!/bin/bash

seed=${1:-0}
datadir=${2:-./datasets/FDP}
resultsdir=${3:-./data/FDP_splits/random/}
options=${4:-}

jobfile="MLFx-train-"$seed".sh"
jobdir="CD-Seed"$seed

echo "submitting" $jobfile

cat > ${jobfile} <<EOT
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=3700
#SBATCH --partition=gpu
#SBATCH --time=48:00:00
#SBATCH --gres=gpu:quadro_rtx_6000:1

echo "--- START" $jobfile
echo "--- output in" $jobdir

module restore ai

pwd

#srun python train.py --dataroot ./datasets/FDP --split ./data/FDP_splits/random/0 --gpu_ids 0 --input structure --name seed1_CD
#--continue_train

srun python train.py --dataroot $datadir --split $resultsdir/$seed --gpu_ids 0 --input structure --name $jobdir $options

echo "--- DONE" $jobfile
EOT

cat $jobfile
chmod 755 ${jobfile}
chmod g+w ${jobfile}
#(sbatch -p gpu-devel ${jobfile})
(sbatch ${jobfile})
#(./${jobfile})

echo "submitted" $jobfile "for" $jobdir
