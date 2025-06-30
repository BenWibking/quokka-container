# quokka-container
a Docker container for Quokka development

## Run this container with Docker
1. Start Docker on your computer (see the [documentation](https://docs.docker.com/config/daemon/start/)).
2. Download the container by running (in a terminal):
   ```
   docker pull --platform linux/x86_64 ghcr.io/benwibking/quokka-container:main
   ```
3. Start the container with a [bind mount](https://docs.docker.com/storage/bind-mounts/#start-a-container-with-a-bind-mount) and log in:
   ```
   docker run -it -v "$(pwd)"/quokka_data:/home/ubuntu ghcr.io/benwibking/quokka-container:main /bin/bash
   ```
4. Run a simulation using the pre-compiled Quokka binaries:
   ```
   mpirun /quokka/build_3d/src/problems/HydroBlast3D/test_hydro3d_blast /quokka/inputs/blast_32.in
   ```
5. Examine the output in the `quokka_data` directory (*which is accessible from outside the container*) using VisIt or Paraview:
   ![paraview_screenshot](https://github.com/user-attachments/assets/692f7b5a-3654-432c-862f-76ba74579ec4)

## Run this container with Singularity
1. Download the container by running (in a terminal):
   ```
   singularity pull docker://ghcr.io/benwibking/quokka-container:main
   ```
2. Start the container and log in (no explicit bind mount is necessary):
   ```
   mkdir quokka_data
   cd quokka_data
   singularity run docker://ghcr.io/benwibking/quokka-container:main
   ```
3. Run a simulation using the pre-compiled Quokka binaries:
   ```
   mpirun -np 8 /quokka/build_3d/src/problems/HydroBlast3D/test_hydro3d_blast /quokka/inputs/blast_32.in
   exit
   ```
4. Examine the output in the `quokka_data` directory (*which is accessible from outside the container*) using VisIt, Paraview, or yt:
   ![paraview_screenshot](https://github.com/user-attachments/assets/692f7b5a-3654-432c-862f-76ba74579ec4)


## Workaround: debugging using GDB on Apple Silicon host machines
If you are running Docker on Apple Silicon, there is a [truly awful workaround](https://github.com/docker/for-mac/issues/6921#issuecomment-1872394991) that is required in order to use `gdb`.
