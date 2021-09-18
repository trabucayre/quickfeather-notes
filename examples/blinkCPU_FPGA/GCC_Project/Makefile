include config.mk

VPATH:=$(OUTPUT_PATH)

all: _makedirs_ external_srcs appfpga appdir
	-${HIDE}$(RM) $(OUTPUT_PATH)$(DIR_SEP)bin$(DIR_SEP)$(OUTPUT_FILE).*
	make -f makefiles/Makefile_output
	-${HIDE}$(MKDIR) $(OUTPUT_PATH)$(DIR_SEP)bin
	@echo Copy output files ...
	${HIDE}$(CP) $(OUTPUT_PATH)$(DIR_SEP)$(OUTPUT_FILE).bin $(OUTPUT_PATH)$(DIR_SEP)bin
	${HIDE}$(CP) $(OUTPUT_PATH)$(DIR_SEP)$(OUTPUT_FILE).map $(OUTPUT_PATH)$(DIR_SEP)bin
	${HIDE}$(CP) $(OUTPUT_PATH)$(DIR_SEP)$(OUTPUT_FILE).elf $(OUTPUT_PATH)$(DIR_SEP)bin

_makedirs_:
	@-$(MKDIR) $(DEPEND_PATH)
	@-$(MKDIR) $(OUTPUT_PATH)


.PHONY: _makedirs_


.PHONY: external_srcs
external_srcs: Startup HAL FreeRTOS Libraries BSP
	@echo "External sources built"

.PHONY: appfpga
appfpga:
	make -f makefiles/Makefile_appfpga
clean_appfpga:
	make -f makefiles/Makefile_appfpga clean
	
CLEAN_TARGET += appfpga
	
.PHONY: appdir
appdir:
	make -f makefiles/Makefile_appdir
clean_appdir:
	make -f makefiles/Makefile_appdir clean

CLEAN_TARGET += appdir

.PHONY:Startup
Startup:
	make -f makefiles/Makefile_Startup
clean_Startup:
	make -f makefiles/Makefile_Startup clean

CLEAN_TARGET += Startup

.PHONY:HAL
HAL:
	make -f makefiles/Makefile_HAL
clean_HAL:
	make -f makefiles/Makefile_HAL clean

CLEAN_TARGET += HAL

FreeRTOS:
	make -f makefiles/Makefile_FreeRTOS
clean_FreeRTOS:
	make -f makefiles/Makefile_FreeRTOS clean

CLEAN_TARGET += FreeRTOS

.PHONY:BSP
# same Makefile for both (same content)
BSP:
	make -f makefiles/Makefile_quickfeather_BSP
clean_BSP:
	make -f makefiles/Makefile_quickfeather_BSP clean

CLEAN_TARGET += BSP

.PHONY:Libraries
Libraries:
	make -f makefiles/Makefile_Libraries
clean_Libraries:
	make -f makefiles/Makefile_Libraries clean

CLEAN_TARGET += Libraries

flash:
	python3 $(PROJ_ROOT)/TinyFPGA-Programmer-Application/tinyfpga-programmer-gui.py \
		--port /dev/ttyACM0 --reset --mode m4 --m4app output/$(OUTPUT_FILE).bin

load_swd:
	openocd -f ../../../sipeed_swd.cfg -f board/quicklogic_quickfeather.cfg \
	-c "init" -c "soft_reset_halt; reset halt" \
	-c "load_image output/bin/blinkCPU_FPGA.bin 0 bin" \
	-c "reset run" -c "shutdown"

load_swd_tigard:
	openocd -f ../../../tigard.cfg -f board/quicklogic_quickfeather.cfg \
	-c "init" -c "soft_reset_halt; reset halt" \
	-c "load_image output/bin/blinkCPU_FPGA.bin 0 bin" \
	-c "reset run" -c "shutdown"

start_ocd:
	openocd -f ../../../sipeed_swd.cfg -f board/quicklogic_quickfeather.cfg \
	-c "init" -c "soft_reset_halt"

DELETEME=
DELETEME += $(wildcard $(OUTPUT_PATH)$(DIR_SEP)bin$(DIR_SEP)$(OUTPUT_FILE).*)
DELETEME += $(wildcard $(OUTPUT_PATH)$(DIR_SEP)*.o)
DELETEME += $(wildcard $(DEPEND_PATH)$(DIR_SEP)*.d)
DELETEME := $(strip $(DELETEME))
# Clean
clean: $(CLEAN_TARGET:%=clean_%)
	make -f makefiles/Makefile_output clean
ifneq (,$(DELETEME))
	-$(HIDE)$(RM) $(DELETEME)
endif
