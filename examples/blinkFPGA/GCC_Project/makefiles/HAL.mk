HAL_DIR:= $(PROJ_ROOT)/HAL
VPATH+=$(HAL_DIR)$(DIR_SEP)src
HAL_SRCS:=$(wildcard $(HAL_DIR)$(DIR_SEP)src/*.c )
CFLAGS+=-I$(HAL_DIR)$(DIR_SEP)inc

filters=eoss3_hal_audio.c eoss3_hal_ffe.c eoss3_hal_fpga_adc.c \
	eoss3_hal_i2s_master_assp.c eoss3_hal_i2c.c
#  eoss3_hal_fpga_clk_sync.c \
#        eoss3_hal_fpga_gpio.c  eoss3_hal_fpga_sdma.c eoss3_hal_fpga_uart.c \
#        eoss3_hal_i2s.c eoss3_hal_i2s_slave_assp.c
HAL_SRCS:=$(filter-out $(filters),$(notdir $(HAL_SRCS)))
SRCS+=$(addprefix $(HAL_SRC)$(DIR_SEP),$(HAL_SRCS))

OUTPUT=output
OBJS+=$(addprefix output/,$(HAL_SRCS:.c=.o))
