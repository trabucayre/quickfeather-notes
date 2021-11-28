HAL_DIR  := $(QORC_SDK)/HAL
VPATH    += $(HAL_DIR)/src

HAL_SRCS := $(wildcard $(HAL_DIR)/src/*.c)

filters   = eoss3_hal_audio.c eoss3_hal_ffe.c eoss3_hal_fpga_adc.c \
			eoss3_hal_i2s_master_assp.c eoss3_hal_i2c.c

HAL_SRCS := $(filter-out $(filters),$(notdir $(HAL_SRCS)))

LIB_SRCS += $(addprefix $(HAL_SRC)/src,$(HAL_SRCS))
LIB_OBJS += $(addprefix output/,$(HAL_SRCS:.c=.o))
CFLAGS   += -I$(HAL_DIR)/inc
