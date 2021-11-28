#
# GCC Configuration options for QORC SDK
#

DASH_G=-gdwarf-4
DASH_O=-Os

#Assembler flags
export AS_FLAGS= -mcpu=cortex-m4 -mthumb -mlittle-endian \
	-mfloat-abi=hard -mfpu=fpv4-sp-d16 $(DASH_O) -fmessage-length=0 \
	-fsigned-char -ffunction-sections -fdata-sections  $(DASH_G) -MMD -MP

#Preprocessor macros

export MACROS=-D__FPU_USED=1 -D__FPU_USED=1 \
        -D__M4_DEBUG \
        -D__EOSS3_CHIP \
        -D__RTOS \
        -D__GNU_SOURCE \
        -D_DEFAULT_SOURCE \
        -DARM_MATH_CM4 \
        -DFFE_NEWARCH \
        -DARM_MATH_MATRIX_CHECK \
        -DARM_MATH_ROUNDING \
        -D__FPU_PRESENT \
        -DconfigUSE_STATS_FORMATTING_FUNCTIONS \
        -DconfigUSE_TRACE_FACILITY \
        -D$(TOOLCHAIN) \
        -DNDEBUG\
        -DGCC_MAKE

export OPT_FLAGS=-fmerge-constants -fomit-frame-pointer -fcrossjumping \
	-fexpensive-optimizations -ftoplevel-reorder
export LIBCMSIS_GCC_DIR=$(QORC_SDK)/Libraries/CMSIS/lib/GCC

# C compiler flags
export CFLAGS= $(MACROS) \
        -mcpu=cortex-m4 -mthumb -mlittle-endian -mfloat-abi=hard -mfpu=fpv4-sp-d16 \
        ${DASH_O} $(OPT_FLAGS) -fmessage-length=0 -lm \
        -fsigned-char -ffunction-sections -fdata-sections  ${DASH_G} -std=c99 -MMD -MD -MP


export LD_FLAGS_1= -mcpu=cortex-m4 -mthumb -mlittle-endian -mfloat-abi=hard -mfpu=fpv4-sp-d16 \
            ${DASH_O} $(OPT_FLAGS) -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  \
            ${DASH_G} -T "$(PROJ_DIR)/$(BOARD).ld" -Xlinker --gc-sections -Wall -Werror \
	-Wl,--fatal-warnings -Wl,-Map,"$(OUTPUT_PATH)/$(OUTPUT_FILE).map" \
            --specs=nano.specs --specs=nosys.specs -Wl,--no-wchar-size-warning \
            -o "$(OUTPUT_PATH)/$(OUTPUT_FILE).elf" -lm\
    -L$(LIBCMSIS_GCC_DIR) -larm_cortexM4lf_math


export ELF2BIN_OPTIONS=-O binary
