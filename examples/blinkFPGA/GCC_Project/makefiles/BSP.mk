VPATH+=$(BSP_DIR)
BSP_SRCS:=$(wildcard $(BSP_DIR)/*.c )

filters=

BSP_SRCS:=$(filter-out $(filters),$(notdir $(BSP_SRCS)))

SRCS   += $(addprefix $(BSP_DIR)$(DIR_SEP),$(BSP_SRCS))
OBJS   += $(addprefix output/,$(BSP_SRCS:.c=.o))
CFLAGS += -I$(BSP_DIR)/../inc
