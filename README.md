commands to set up cluster: (this should literally do everything) M\ <br>

sudo su ec2-user <br>

cd ~ <br>
git clone https://github.com/GraysenGould/wicscc-aws-ttu-mat.git <br>

cd ~/wicscc-aws-ttu-mat <br>
source setup-all.sh <br>

cd /fsx/conus_12km <br>

sbatch slurm-wrf-conus12km.sh <br>
