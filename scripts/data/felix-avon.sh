#!/bin/bash

# settings from input
cif0=${1:-1}
cif1=${2:-1}
keep=${3:-1}

echo "F-CIF: going through prospective CIFs from" $cif0 "to" $cif1

# settings for files
binary=felix.INT64Nifort.d

# settings for directories
currdir=$(pwd)
jobdir=$currdir

binarydir=$HOME/PROJECT-ai-diffraction/EXE

for cif in $(seq $cif0 1 $cif1); do

    if [ ! -d $cif ]; then
        echo "--- skipping non-existent directory" $cif
    else

        echo "--- working in directory" $cif

        cd $cif

        jobdir=$(pwd)
        jobname=$cif
        jobfile="${jobname}.sh"
        logfile="${jobname}.log"

        # Check if felix.runtime exists
        if [ ! -f felix.runtime ]; then
            echo "!!! felix.runtime not found in" $jobdir", using default runtime 1:30:00"
            runtime="1:30:00"
        else
            runtime=$(cat felix.runtime)
            echo "Using runtime from felix.runtime: $runtime"
        fi

        echo "binarydir=$binarydir jobdir=$jobdir"

        # settings for parallel submission

        cat >${jobfile} <<EOD
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=48
#SBATCH --time=$runtime

# --- avon standard
#SBATCH --mem-per-cpu=3700

# --- avon HMEM
##SBATCH --mem-per-cpu=31418
##SBATCH --partition=hmem

module purge
module load intel imkl impi GCC/11.3.0 OpenMPI/4.1.4 FFTW.MPI/3.3.10

if [ ! -f felix.inp ]; then
    echo "!!! felix.inp not found in $jobdir, ABORTing!"
    exit 1
fi
    
if [ ! -f felix.cif ]; then
    echo "!!! felix.cif not found in $jobdir, ABORTing!"
    exit 2
fi

if [ ! -f felix.hkl ]; then
    echo "!!! felix.hkl not found in $jobdir, ABORTing!"
    exit 3
fi
  
echo "felix.inp/.cif/.hkl ALL found - proceeding with calculation!"

srun --mpi=pmi2 $binarydir/$binary

exit 0
EOD

        chmod 755 ${jobfile}
        sbatch ${jobfile} # for queueing system

        sleep 1

        cd ..

    fi

done
