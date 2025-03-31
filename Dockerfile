FROM nvidia/cuda:12.8.1-devel-ubuntu24.04

RUN apt-get --yes -qq update \
 && apt-get --yes -qq upgrade \
 && apt-get --yes -qq install build-essential \
                      git cmake clangd gcc g++ \
                      python3-dev python3-numpy python3-matplotlib python3-pip \
                      libopenmpi-dev \
                      libhdf5-mpi-dev \
                      paraview \
 && apt-get --yes -qq clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /home/ubuntu

# build Quokka
WORKDIR /
RUN git clone --recursive https://github.com/quokka-astro/quokka.git \
 && cd quokka \
 && cmake -B build_3d -S . -DCMAKE_BUILD_TYPE=Release -DAMReX_SPACEDIM=3 \
 && cmake --build build_3d --parallel 4 --target test_hydro3d_blast

# build Quokka for CUDA
RUN git clone --recursive https://github.com/quokka-astro/quokka.git \
 && cd quokka \
 && cmake -B build_gpu_3d -S . -DCMAKE_BUILD_TYPE=Release -DAMReX_SPACEDIM=3 -DAMReX_GPU_BACKEND=CUDA \
 && cmake --build build_gpu_3d --parallel 4 --target test_hydro3d_blast

WORKDIR /home/ubuntu
USER ubuntu
CMD [ "/bin/bash" ]
