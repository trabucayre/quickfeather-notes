# quickfeather-notes
Notes, scripts and apps for the [Quickfeather Development Kit](https://www.quicklogic.com/products/eos-s3/quickfeather-development-kit/)


## Prerequisites

Using a *quickfeather* board need to have tools to deal with CPU and
FPGA.

Since number of distribution is huge, with different package manager and naming
for application/libraries, we considerer the case of *debian* and *ubuntu*.

### A toolchain for cortexM4 CPU:

__With distribution package manager__
```bash
sudo apt install gcc-arm-none-eabi
```

__With a binary toolchain__
```bash
wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2020q2/gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2
tar -xf gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2
```

**Note: with the toolchain from developer.arm.com your PATH must be updated to
add /somewhere/gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux/bin**
```bash
export PATH=$PATH:/somewhere/gcc-arm-none-eabi-9-2020-q2-update/bin
```

### FPGA toolchain

```bash
sudo apt install build-essentials git cmake bison flex python3-pip \
	tcl-dev ca-certificates libffi-dev libreadline-dev \
	gawk iverilog pkg-config clang curl graphviz xdot
```

```bash
pip3 install --user git+https://github.com/symbiflow/fasm
pip3 install --user git+https://github.com/antmicro/quicklogic-fasm
pip3 install --user git+https://github.com/antmicro/quicklogic-fasm-utils
```

**GUI support for vtr-verilog-to-routing (optional)**

```bash
sudo apt install libgtk-3 libx11-dev
```

**symbiflow-arch-defs (mandatory)**

```bash
sudo apt install wget libxcursor-dev libxcursor-dev libxdamage-dev \
        libxcomposite-dev libxinerama-dev libxext-dev \
        libxrandr-dev libxi-dev
```

### Building toolchain

This repository provide a script (**run.sh**) to build the FPGA toolchain

This script may be used directly on your host computer or by using docker.
The second option reduce the amount of residual package but since the build
is not (currently) static this solution is limited to debian testing (or
equivalent distribution/package version.

At the end (and with default configuration), the current directory must contains two new directory:
* **build**: where everything is build. At this time this repository is no more
  mandatory
* **quicklogic**: toolchain directory

### Building directly on the host computer

```bash
[SKIP_VPR=1] [SKIP_YOSYS=1] [SKIP_PLUGINS=1] [SKIP_SYMBIFLOW=1] [INSTALL_DIR=/somewhere] ./run.sh
```

where:
* SKIP_XX: skip the corresponding build step
* INSTALL_DIR: target destination (default **quicklogic** in the current
  directory)


### Through a Docker container

Two script are provided:

1. **prepare_docker** to build the image with all mandatories dependencies
2. **launch_docker** to create a container in interactive mode

Prepare image:
```bash
host$ ./prepare_docker
```

Enter docker image:
```bash
host$ ./launch_docker
docker# su user
docker$ cd /opt/quicklogic
docker$ ./run.sh
docker$ exit
docker# exit
host$
```

### FPGA toolchain use

To be able to use the FPGA toolchain **PATH** must be updated:
```bash
export PATH=/somewhere/quickfeather-notes/quicklogic/bin:/somewhere/quickfeather-notes/quicklogic/bin/python:$PATH
```

**Adapt toolchain path if INSTALL_DIR has been used**
