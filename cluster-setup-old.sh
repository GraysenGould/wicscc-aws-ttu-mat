#!/bin/bash

sudo su ec2-user -i

cd ~

export SPACK_ROOT=/fsx/spack
git clone -b v0.22.1 -c feature.manyFiles=true https://github.com/spack/spack $SPACK_ROOT
echo "export SPACK_ROOT=/fsx/spack" >> $HOME/.bashrc
echo "source \$SPACK_ROOT/share/spack/setup-env.sh" >> $HOME/.bashrc
source $HOME/.bashrc

pip3 install botocore boto3



spack mirror add aws-hpc-weather s3://aws-hpc-weather/spack_v0.22.1/
spack buildcache keys --install --trust --force

# install intell compilers

spack install intel-oneapi-compilers@2022.0.2
spack find

#inform spack about compilers
spack load intel-oneapi-compilers
spack compiler find
spack unload

#display
spack compilers

#install libfabric with EFA support:
spack install libfabric@1.20.0 fabrics=efa,tcp,udp,sockets,verbs,shm,mrail,rxd,rxm %intel


#install mpi library 
spack install intel-oneapi-mpi+external-libfabric%intel

#install NCAR command language
spack install ncl^hdf5@1.8.22

#ensure correct setup
spack load ncl
ncl -h
spack unload ncl

#set default window size
cat << EOF > $HOME/.hluresfile
*windowWorkstationClass*wkWidth  : 1000
*windowWorkstationClass*wkHeight : 1000
EOF
