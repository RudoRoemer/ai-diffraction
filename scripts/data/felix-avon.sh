#!/bin/bash

# settings from input
cif0=${1:-1}
cif1=${2:-1}
keep=${3:-1}

echo "F-CIF: going through prospective CIFs" $cif0 "to " $cif1

# settings for files
binary=felix.INT64Nifort.d

# settings for directories
currdir=$(pwd)
jobdir=$currdir

binarydir=$HOME/PROJECT-ai-diffraction/EXE
#for cif in {$cif0..$cif1}
for cif in $(seq $cif0 1 $cif1); do

    #echo "--- working in" $cif

    if [ ! -d $cif ]; then
        echo "--- skipping non-existent" $cif
    else

        echo "--- working in" $cif

        cd $cif

        jobdir=$(pwd)

        jobname=$cif
        echo $jobname

        jobfile=$(printf "$jobname.sh")
        logfile=$(printf "$jobname.log")

        # Check if felix.runtime exists
        if [ ! -f felix.runtime ]; then
            echo "!!! felix.runtime not found in" $jobdir", using default runtime 02:00:00"
            runtime="02:00:00"
        else
            runtime=$(cat felix.runtime)
            # echo "Using runtime from felix.runtime: $runtime"
        fi

        #inpfile=AMLdiag-$size-$energy-$disorder.inp

        echo "binarydir=" $binarydir " jobdir=" $jobdir

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

if [ ! -f felix.inp ] 
then
    echo "!!! felix.inp not found in" $jobdir", ABORTing!"
    exit 1
fi
    
if [ ! -f felix.cif ] 
then
    echo "!!! felix.cif not found in" $jobdir", ABORTing!"
    exit 2
fi

if [ ! -f felix.hkl ] 
then
    echo "!!! felix.hkl not found in" $jobdir", ABORTing!"
    exit 3
fi
  
echo "felix.inp/.cif/.hkl ALL found - proceeding with calculation!"

#$binarydir/$binary <$inpfile

srun --mpi=pmi2 $binarydir/$binary

#zip -m inp.zip *.inp
#zip -m sh.zip *.sh

exit 0

EOD

        chmod 755 ${jobfile}
        #sbatch -p devel ${jobfile} # for queueing system
        sbatch ${jobfile} # for queueing system

        #(source $jobdir/${jobfile} ) >& $jobdir/${logfile} & # for parallel shell execution
        #source ${jobfile} #>& ${logfile} # for sequential shell execution

        #echo "<return>"
        sleep 1

        cd ..

    fi

done
