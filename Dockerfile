FROM mcr.microsoft.com/devcontainers/cpp:ubuntu-24.04

RUN apt-get --yes -qq update \
 && apt-get --yes -qq upgrade \
 && apt-get --yes -qq install build-essential \
                      git cmake clangd gcc g++ \
                      python3-dev python3-numpy python3-matplotlib python3-pip pipx \
                      libopenmpi-dev \
                      libhdf5-mpi-dev \
                      paraview \
 && apt-get --yes -qq clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /home/ubuntu
ENV CMAKE_PREFIX_PATH="/opt/conduit:/opt/catalyst"

# build Conduit
RUN git clone --recursive https://github.com/llnl/conduit.git \
 && cd conduit \
 && mkdir -p /opt/conduit \
 && cmake -S src -B build -DCMAKE_BUILD_TYPE=Debug -DENABLE_MPI=ON -DCMAKE_INSTALL_PREFIX=/opt/conduit \
 && cmake --build build --parallel 4 \
 && cmake --install build
 && cmake --build build --target clean

# build Catalyst
RUN git clone https://gitlab.kitware.com/paraview/catalyst.git \
 && cd catalyst \
 && mkdir -p /opt/catalyst \
 && cmake -B build -S . -DCATALYST_WITH_EXTERNAL_CONDUIT=ON -DCMAKE_INSTALL_PREFIX=/opt/catalyst \
 && cmake --build build --parallel 4 \
 && cmake --install build
 && cmake --build build --target clean

# build Quokka
WORKDIR /
RUN git clone --recursive https://github.com/quokka-astro/quokka.git \
 && cd quokka \
 && cmake -B build_3d -S . -DCMAKE_BUILD_TYPE=RelWithDebInfo -DAMReX_SPACEDIM=3 -DAMReX_CONDUIT=ON -DAMReX_CATALYST=ON \
 && cmake --build build_3d --parallel 4

# careful: building all AMReX_SPACEDIM variants causes out of disk space error
#RUN git clone --recursive https://github.com/quokka-astro/quokka.git \
# && cd quokka \
# && cmake -B build_1d -S . -DCMAKE_BUILD_TYPE=RelWithDebInfo -DAMReX_SPACEDIM=1 \
# && cmake --build build_1d --parallel 4 \
# && cmake -B build_2d -S . -DCMAKE_BUILD_TYPE=RelWithDebInfo -DAMReX_SPACEDIM=2 \
# && cmake --build build_2d --parallel 4 \
# && cmake -B build_3d -S . -DCMAKE_BUILD_TYPE=RelWithDebInfo -DAMReX_SPACEDIM=3 \
# && cmake --build build_3d --parallel 4
 
WORKDIR /home/ubuntu
USER ubuntu
RUN pipx install esbonio && pipx ensurepath
CMD [ "/bin/bash" ]
