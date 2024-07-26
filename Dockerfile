FROM mcr.microsoft.com/devcontainers/cpp:ubuntu-24.04

RUN apt-get --yes -qq update \
 && apt-get --yes -qq upgrade \
 && apt-get --yes -qq install build-essential \
                      git cmake gcc g++ \
                      python3-dev python3-numpy python3-matplotlib python3-pip \
                      libopenmpi-dev \
                      libhdf5-mpi-dev \
 && apt-get --yes -qq clean \
 && rm -rf /var/lib/apt/lists/*

RUN git clone --recursive https://github.com/quokka-astro/quokka.git \
 && cd quokka \
 && cmake -B build -S . -DCMAKE_BUILD_TYPE=RelWithDebInfo -DAMReX_SPACEDIM=3 \
 && cmake --build build --parallel 4

WORKDIR /home/ubuntu
USER ubuntu
CMD [ "/bin/bash" ]
