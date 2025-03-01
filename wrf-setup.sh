#!/bin/bash


#install wrf
echo -e "\nGG - install wrf:"
spack install -j $(nproc) wrf@4.3.3%intel build_type=dm+sm ^intel-oneapi-mpi+external-libfabric

# retreive model
echo -e "\nGG - Retreive model:"
cd /fsx
curl -O https://www2.mmm.ucar.edu/wrf/OnLineTutorial/wrf_cloud/wrf_simulation_CONUS12km.tar.gz
tar -xzf wrf_simulation_CONUS12km.tar.gz


#prepare data (ingore error)
echo -e "\nGG - Prepare data - please ignore error:"
cd /fsx/conus_12km/
WRF_ROOT=$(spack location -i wrf%intel)/test/em_real/
ln -s $WRF_ROOT* .

#generate bash script:
echo -e "\nGG - Generate Bash script that runs WRF:"
cd /fsx/conus_12km/
cat > slurm-wrf-conus12km.sh << EOF
#!/bin/bash

#SBATCH --job-name=WRF
#SBATCH --output=conus-%j.out
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=48
#SBATCH --exclusive

export I_MPI_OFI_LIBRARY_INTERNAL=0
spack load intel-oneapi-mpi intel-oneapi-compilers
spack load wrf
module load libfabric-aws
wrf_exe=\$(spack location -i wrf)/run/wrf.exe
set -x
ulimit -s unlimited
ulimit -a

export OMP_NUM_THREADS=2
export FI_PROVIDER=efa
export I_MPI_FABRICS=shm:ofi
export I_MPI_OFI_PROVIDER=efa
export I_MPI_PIN_DOMAIN=omp
export KMP_AFFINITY=compact
export I_MPI_DEBUG=4

time mpiexec.hydra -np \$SLURM_NTASKS --ppn \$SLURM_NTASKS_PER_NODE \$wrf_exe
EOF



#next steps: submit jobs
