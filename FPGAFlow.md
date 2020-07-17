# FPGA (from verilog to header)

Command to use to generate an header file from one (or more) verilog file is:
```bash
ql_symbiflow  -compile -src $(RTL_DIR) -d ql-eos-s3 -t $(TOP) -v $(RTL_SRCS) -p $(PCF) -P PU64 -dump header
```
where:
* **RTL_DIR** is the location of all verilog files
* **TOP** is the name of the top module
* **RTL_SRC** is the list of verilog files (**!! name is relative to RTL_DIR**)
* **PCF** constraints file

At the end, the directory $(RTL_DIR) will contain:
* a file called *$(TOP)_bit.h*
* a directory *build* with log and intermediate files
* a file called *Makefile.symbiflow*

## with a Makefile (basic approach)

```make
RTL_DIR=../fpga/rtl
TOP=AL4S3B_FPGA_top
SRCS=$(wildcard $(RTL_DIR)/*.v)
RTL_SRCS=$(notdir $(SRCS))
PCF=quickfeather.pcf
all: $(TOP)_bit.h

%.h: $(SRCS)
    ql_symbiflow  -compile -src $(RTL_DIR) -d ql-eos-s3 -t $(TOP) -v $(RTL_SRCS) -p $(PCF) -P PU64 -dump header

clean:
	@rm -rf $(RTL_SRC)/$(TOP).h $(RTL_SRC)/build $(RTL_SRC)/Makefile.symbiflow
```

## Makefile.symbiflow
_
*ql_symbiflow* produce first, in **RTL_DIR**, a Makefile, with a content near this:
```make
PHONY:${BUILDDIR}

current_dir := /somewhere/rtl
TOP := AL4S3B_FPGA_top
VERILOG := ${current_dir}/AL4S3B_FPGA_QL_Reserved.v \
${current_dir}/AL4S3B_FPGA_Top.v \
${current_dir}/AL4S3B_FPGA_Registers.v \
${current_dir}/AL4S3B_FPGA_IP.v \
${current_dir}/LED_controller.v
PARTNAME := PU64
DEVICE  := ql-eos-s3_wlcsp
PCF := ${current_dir}/quickfeather.pcf
SDC := ${current_dir}/build/AL4S3B_FPGA_top_dummy.sdc
BUILDDIR := build

all: ${BUILDDIR}/${TOP}.bit

${BUILDDIR}/${TOP}.eblif: ${VERILOG}
    cd ${BUILDDIR} && synth -t ${TOP} -v ${VERILOG} -d ${DEVICE} 2>&1 > /somewhere/rtl/build/AL4S3B_FPGA_top.log

${BUILDDIR}/${TOP}.net: ${BUILDDIR}/${TOP}.eblif
    cd ${BUILDDIR} && pack -e ${TOP}.eblif -d ${DEVICE} -s ${SDC} 2>&1 > /somewhere/rtl/build/AL4S3B_FPGA_top.log

${BUILDDIR}/${TOP}.place: ${BUILDDIR}/${TOP}.net
    cd ${BUILDDIR} && place -e ${TOP}.eblif -d ${DEVICE} -p ${PCF} -n ${TOP}.net -P ${PARTNAME} -s ${SDC} 2>&1 > /somewhere/rtl/build/AL4S3B_FPGA_top.log

${BUILDDIR}/${TOP}.route: ${BUILDDIR}/${TOP}.place
    cd ${BUILDDIR} && route -e ${TOP}.eblif -d ${DEVICE} -s ${SDC} 2>&1 > /somewhere/rtl/build/AL4S3B_FPGA_top.log

${BUILDDIR}/${TOP}.fasm: ${BUILDDIR}/${TOP}.route
    cd ${BUILDDIR} && write_fasm -e ${TOP}.eblif -d ${DEVICE}

${BUILDDIR}/${TOP}.bit: ${BUILDDIR}/${TOP}.fasm
    cd ${BUILDDIR} && write_bitstream -d ${DEVICE} -f ${TOP}.fasm -P ${PARTNAME} -b ${TOP}.bit

${BUILDDIR}/${TOP}_bit.h: ${BUILDDIR}/${TOP}.bit
    cd ${BUILDDIR} && write_bitheader -b ${TOP}.bit

${BUILDDIR}/${TOP}.jlink: ${BUILDDIR}/${TOP}.bit
    cd ${BUILDDIR} && write_jlink -f ${TOP}.fasm -P ${PACKAGENAME} -b ${TOP}.bit

${BUILDDIR}/${TOP}_jlink.h: ${BUILDDIR}/${TOP}.jlink
    cd ${BUILDDIR} && write_jlinkheader

${BUILDDIR}/${TOP}.post_v: ${BUILDDIR}/${TOP}.bit
    cd ${BUILDDIR} && write_fasm2bels -e ${TOP}.eblif -d ${DEVICE} -p ${PCF} -n ${TOP}.net -P ${PARTNAME}
    cd ${BUILDDIR} && analysis -e ${TOP}.eblif -d ${DEVICE} -s ${SDC} 2>&1 > /somewhere/rtl/build/AL4S3B_FPGA_top.log

clean:
    rm -rf ${BUILDDIR}

```
