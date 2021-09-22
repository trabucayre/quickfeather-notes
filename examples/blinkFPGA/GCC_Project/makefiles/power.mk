VPATH+=$(POWER_DIR)
POWER_SRCS:=$(wildcard $(POWER_DIR)/*.c )

filters=s3x_fsm_interface.c s3x_pwrcfg_prototype.c

POWER_SRCS:=$(filter-out $(filters),$(notdir $(POWER_SRCS)))

SRCS+=$(addprefix $(BSP_DIR)$(DIR_SEP),$(BSP_SRCS))
OBJS+=$(addprefix output/,$(POWER_SRCS:.c=.o))

CFLAGS += -I$(POWER_DIR)/../inc
