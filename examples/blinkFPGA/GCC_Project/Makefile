include config.mk

VPATH:=$(OUTPUT_PATH)
VPATH+=$(MAIN_DIR)

MAIN_SRCS:=exceptions.c main.c pincfg_table_$(BOARD).c s3x_pwrcfg.c sec_debug.c
SRCS+=$(addprefix $(MAIN_DIR)$(DIR_SEP),$(MAIN_SRCS))
OBJS+=$(addprefix output/,$(MAIN_SRCS:.c=.o))

CFLAGS+=-I$(APP_DIR)$(DIR_SEP)inc
CFLAGS+=-I"$(PROJ_ROOT)/Libraries/CMSIS/inc" \
		-I"$(PROJ_ROOT)/Libraries/CMSIS/inc" \
		-I"$(PROJ_ROOT)/Libraries/DatablockManager/inc"

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

# yes it's an hack but symbiflow_write_binary has hardcoded input and output
# install dir is directory where quicklogic tools are installed
BIT2BIN=$(INSTALL_DIR)/quicklogic-arch-defs/bin/python/bitstream_to_binary.py

elf_out=$(OUTPUT_PATH)$(DIR_SEP)$(OUTPUT_FILE).elf
bin_out=$(OUTPUT_PATH)$(DIR_SEP)$(OUTPUT_FILE).bin
map_out=$(OUTPUT_PATH)$(DIR_SEP)$(OUTPUT_FILE).map
sym_out=$(OUTPUT_PATH)$(DIR_SEP)$(OUTPUT_FILE).sym.txt
BITSTREAM=build/blinkFPGA_0/$(BOARD)-symbiflow/blinkFPGA.bit
APPFPGA=$(OUTPUT_PATH)$(DIR_SEP)/blinkFPGA_gateware.bin

all: $(bin_out) $(BITSTREAM)

sw:$(bin_out)

$(bin_out): $(elf_out)
	@echo Convert ELF to BIN
	$(HIDE)$(ELF2BIN) $(ELF2BIN_OPTIONS) $< $@
	$(HIDE)$(NM) $(OUTPUT_PATH)${DIR_SEP}$(OUTPUT_FILE).elf > $(sym_out)

$(elf_out): $(OBJS)
	@echo Linking ...
	$(LD) $^ $(LD_FLAGS_1) $(LIBS) $(LD_FLAGS_2)

output/%.o:%.c
	@echo Compile: $<
	$(CC) $(CFLAGS) -c $< -o $@

gateware: $(APPFPGA)

$(BITSTREAM):
	fusesoc --cores-root ../fpga/rtl run --target $(BOARD) blinkFPGA

$(APPFPGA):$(BITSTREAM)
	python3 $(BIT2BIN) $^ $@

flash_all:$(sw) $(APPFPGA)
	python3 $(PROJ_ROOT)/TinyFPGA-Programmer-Application/tinyfpga-programmer-gui.py \
		--port /dev/ttyACM0 --reset --mode fpga-m4 \
		--m4app $(bin_out) --appfpga $(APPFPGA)

flash_sw:$(sw)
	python3 $(PROJ_ROOT)/TinyFPGA-Programmer-Application/tinyfpga-programmer-gui.py \
		--port /dev/ttyACM0 --reset --mode m4 --m4app $(bin_out)

flash_fpga:$(APPFPGA)
	python3 $(PROJ_ROOT)/TinyFPGA-Programmer-Application/tinyfpga-programmer-gui.py \
		--port /dev/ttyACM0 --reset --mode fpga --appfpga $(APPFPGA)


test:
	@echo $(bin_out)
	@echo $(elf_out)

clean:
	@rm $(OBJS) output/*.d $(elf_out) $(bin_out) $(map_out) $(sym_out)
