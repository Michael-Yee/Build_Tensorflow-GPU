#!/bin/bash

# stop on error
set -e

# install the required packages
sudo apt-get update && sudo apt-get -y upgrade
sudo apt-get -y install linux-headers-$(uname -r) linux-image-extra-`uname -r`

# install cuda v8.0 
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
rm cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
sudo apt-get update
sudo apt-get install -y cuda

# install cuDNN v5.1 (Register @ https://developer.nvidia.com/rdp/cudnn-download)
CUDNN_FILE=ccudnn-8.0-linux-x64-v5.1.tgz
wget http://developer.download.nvidia.com/compute/redist/cudnn/v5.1/${CUDNN_FILE}
tar xvzf ${CUDNN_FILE}
rm ${CUDNN_FILE}
sudo cp cuda/include/cudnn.h /usr/local/cuda/include # move library files to /usr/local/cuda
sudo cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*
rm -rf cuda

# set the appropriate library path
echo 'export CUDA_HOME=/usr/local/cuda
export CUDA_ROOT=/usr/local/cuda
export PATH=$PATH:$CUDA_ROOT/bin:$HOME/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CUDA_ROOT/lib64
' >> ~/.bashrc

# install anaconda v4.3
# https://www.continuum.io/downloads
wget https://repo.continuum.io/archive/Anaconda2-4.3.0-Linux-x86_64.sh
bash Anaconda2-4.3.0-Linux-x86_64.sh -b -p /home/ubuntu/anaconda2
rm Anaconda2-4.3.0-Linux-x86_64.sh
echo 'export PATH="/home/ubuntu/anaconda2/bin:$PATH"' >> ~/.bashrc

# Ubuntu/Linux 64-bit - GPU enabled - Python 2.7 tensorflow
# https://www.tensorflow.org/get_started/os_setup
export TF_BINARY_URL=https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-0.12.1-cp27-none-linux_x86_64.whl
/home/ubuntu/anaconda2/bin/pip install $TF_BINARY_URL

# update terminal to latest update of .bashrc file
source .bashrc
exec bash