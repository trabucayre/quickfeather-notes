BOARD=quickfeather

include config.mk

VPATH:=$(OUTPUT_PATH)
VPATH+=../src

FPGA_TOP=litexIrq
LITEX_GATEWARE_DIR=build/quicklogic_quickfeather/gateware
LITEX_SOFTWARE_DIR=build/quicklogic_quickfeather/software

MAIN_SRCS:=exceptions.c main.c pincfg_table_$(BOARD).c s3x_pwrcfg.c sec_debug.c
SRCS=$(addprefix ../src/,$(MAIN_SRCS))
OBJS=$(addprefix output/,$(MAIN_SRCS:.c=.o))

CFLAGS+=-I../inc
CFLAGS+=-I"$(QORC_SDK)/Libraries/CMSIS/inc" \
		-I"$(QORC_SDK)/Libraries/CMSIS/inc" \
		-I"$(QORC_SDK)/Libraries/DatablockManager/inc" \
		-I"$(LITEX_SOFTWARE_DIR)/include"

ifeq ($(BOARD), quickfeather)
CFLAGS += -Dquickfeather=1
else
ifeq ($(BOARD), qomu)
CFLAGS += -Dqomu=1
endif
endif

include makefiles/startup.mk
include makefiles/HAL.mk
include makefiles/FreeRTOS.mk
include makefiles/utils.mk
include makefiles/BSP.mk
include makefiles/power.mk
include makefiles/cli.mk
#include makefiles/appfpga.mk

SYMBIFLOW_BIN     = $(shell which symbiflow_write_binary)
SYMB_BIN_DIR      = $(shell dirname $(shell which symbiflow_write_binary))
SYMBIFLOW_BIN_DIR = $(dir $(shell which symbiflow_write_binary))

elf_out=$(OUTPUT_PATH)$(DIR_SEP)$(OUTPUT_FILE).elf
bin_out=$(OUTPUT_PATH)$(DIR_SEP)$(OUTPUT_FILE).bin
map_out=$(OUTPUT_PATH)$(DIR_SEP)$(OUTPUT_FILE).map
sym_out=$(OUTPUT_PATH)$(DIR_SEP)$(OUTPUT_FILE).sym.txt

GATEWARE=$(LITEX_GATEWARE_DIR)/quicklogic_quickfeather.bin

SRCS += $(LIB_SRCS)
OBJS += $(LIB_OBJS)

all: $(GATEWARE) $(bin_out)

software:$(bin_out)

$(bin_out): $(elf_out)
	@echo Convert ELF to BIN
	$(HIDE)$(ELF2BIN) $(ELF2BIN_OPTIONS) $< $@
	$(HIDE)$(NM) $(OUTPUT_PATH)${DIR_SEP}$(OUTPUT_FILE).elf > $(sym_out)

$(elf_out): $(OBJS) $(QORC_LIB)
	@echo Linking ...
	$(LD) $^ $(LD_FLAGS_1) $(LIBS) $(LD_FLAGS_2)

output/%.o:%.c
	@echo Compile: $<
	$(CC) $(CFLAGS) -c $< -o $@

gateware: $(GATEWARE)
$(GATEWARE): #../fpga/$(FPGA_TOP).py
	python3 -m litex_boards.targets.quicklogic_quickfeather --cpu-type=eos-s3 --build
	#python3 $< --cpu-type=eos-s3 --build

flash_all:$(bin_out) $(GATEWARE)
	python3 $(QORC_SDK)/TinyFPGA-Programmer-Application/tinyfpga-programmer-gui.py \
		--port /dev/ttyACM0 --reset --mode fpga-m4 \
		--m4app $(bin_out) --appfpga $(GATEWARE)

flash_software: $(bin_out)
	python3 $(QORC_SDK)/TinyFPGA-Programmer-Application/tinyfpga-programmer-gui.py \
		--port /dev/ttyACM0 --reset --mode fpga-m4 --m4app $(bin_out)

flash_fpga:$(GATEWARE)
	python3 $(QORC_SDK)/TinyFPGA-Programmer-Application/tinyfpga-programmer-gui.py \
		--port /dev/ttyACM0 --reset --mode fpga-m4 --appfpga $(GATEWARE)

clean-software-all: clean-software
	@rm -fr $(LIB_OBJS) $(QORC_LIB)
clean-gateware:
	@rm -rf build
clean-software:
	@rm -fr $(OBJS) output/*.d $(elf_out) $(bin_out) $(map_out) $(sym_out)
clean-all: clean-software-all clean-gateware
