#!/bin/bash
# remember to use: sudo su ec2-user
cd ~

# print some stuff for fun
echo -e "\nGG - print some stuff:"
module load intelmpi
which mpirun 
module unload intelmpi
df -hT
showmount -e localhost

# do some spack stuff
echo -e "\nGG - do some spack stuff:"
export SPACK_ROOT=/fsx/spack
git clone -b v0.22.1 -c feature.manyFiles=true https://github.com/spack/spack $SPACK_ROOT
echo "export SPACK_ROOT=/fsx/spack" >> ~/.bashrc
echo "source \$SPACK_ROOT/share/spack/setup-env.sh" >> ~/.bashrc
source ~/.bashrc

#python the beast - idk what this does though
echo -e "\nGG - python go burr:"
pip3 install --user botocore boto3

#add mirror and trust the keys - as you should
echo -e "\nGG - add mirror and trust keys:"
spack mirror add aws-hpc-weather s3://aws-hpc-weather/spack_v0.22.1/
spack buildcache keys --install --trust --force

# Install Intel compilers
echo -e "\nGG - install Intell compilers:"
spack install intel-oneapi-compilers@2022.0.2
spack find

# Inform Spack about compilers
echo -e "\nGG - Inform spack about compilers:"
spack load intel-oneapi-compilers
spack compiler find
spack unload intel-oneapi-compilers

# Display available compilers
spack compilers

# Install libfabric with EFA support
echo -e "\nGG - Install libfabric:"
spack install libfabric@1.20.0 fabrics=efa,tcp,udp,sockets,verbs,shm,mrail,rxd,rxm %intel

# Install MPI library 
echo -e "\nGG - Install MPI Library:"
spack install intel-oneapi-mpi+external-libfabric%intel

# Install NCAR command language
echo -e "\nGG - install NCAR command language:"
spack install ncl^hdf5@1.8.22

# Ensure correct setup
echo -e "\nGG - Ensure correct setup:"
spack load ncl
ncl -h
spack unload ncl

# Set default window size
echo -e "\nGG - We love windows:"
cat << EOF2 > ~/.hluresfile
*windowWorkstationClass*wkWidth  : 1000
*windowWorkstationClass*wkHeight : 1000
EOF2
EOF
