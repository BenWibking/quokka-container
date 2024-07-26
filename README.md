# quokka-container
a Docker container for Quokka development

## Run this container
1. Start Docker on your computer (see the [documentation](https://docs.docker.com/config/daemon/start/)).
2. Download the container by running (in a terminal):
   ```
   docker pull --platform linux/x86_64 ghcr.io/benwibking/quokka-container:main
   ```
4. Start the container with a [bind mount](https://docs.docker.com/storage/bind-mounts/#start-a-container-with-a-bind-mount) and log in:
   ```
   docker run -it -v "$(pwd)"/quokka_data:/home/ubuntu ghcr.io/benwibking/quokka-container:main /bin/bash
   ```
6. Run a simulation using the pre-compiled Quokka binaries:
   ```
   mpirun /quokka/build/src/HydroBlast3D/test_hydro3d_blast /quokka/tests/blast_32.in
   ```
7. Examine the output in the `quokka_data` directory (*which is accessible from outside the container*) using VisIt or Paraview:
   ![paraview_screenshot](https://github.com/user-attachments/assets/692f7b5a-3654-432c-862f-76ba74579ec4)
