# quokka-container
a Docker container for Quokka development

## Run this container
1. Start Docker on your computer (see the [documentation](https://docs.docker.com/config/daemon/start/)).
2. Download the container by running (in a terminal):
   ```
   docker pull --platform linux/x86_64 ghcr.io/benwibking/quokka-container:main
   ```
4. Start and log into the container:
   ```
   docker run -it -v quokka_data:/home/ubuntu ghcr.io/benwibking/quokka-container:main /bin/bash
   ```
6. Run a simulation using the pre-compiled Quokka binaries:
   ```
   mpirun /quokka/build/src/HydroBlast3D/test_hydro3d_blast /quokka/tests/blast_32.in
   ```
7. Examine the output using `yt` or another analysis tool (e.g., VisIt or Paraview).
