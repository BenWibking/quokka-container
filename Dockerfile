FROM mcr.microsoft.com/devcontainers/cpp:ubuntu-24.04

RUN apt-get --yes -qq update \
 && apt-get --yes -qq upgrade \
 && apt-get --yes -qq install build-essential \
                      git cmake clangd gcc g++ \
                      python3-dev python3-numpy python3-matplotlib python3-pip pipx \
                      libopenmpi-dev \
                      libhdf5-mpi-dev \
 && apt-get --yes -qq clean \
 && rm -rf /var/lib/apt/lists/*

RUN git clone --recursive https://github.com/quokka-astro/quokka.git \
 && cd quokka \
 && cmake -B build_1d -S . -DCMAKE_BUILD_TYPE=RelWithDebInfo -DAMReX_SPACEDIM=1 \
 && cmake --build build_1d --parallel 4
 && cmake -B build_2d -S . -DCMAKE_BUILD_TYPE=RelWithDebInfo -DAMReX_SPACEDIM=2 \
 && cmake --build build_2d --parallel 4
 && cmake -B build_3d -S . -DCMAKE_BUILD_TYPE=RelWithDebInfo -DAMReX_SPACEDIM=3 \
 && cmake --build build_3d --parallel 4
 
WORKDIR /home/ubuntu
USER ubuntu

RUN pipx install esbonio && pipx ensurepath

CMD [ "/bin/bash" ]
