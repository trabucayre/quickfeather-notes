BSP_DIR   = $(QORC_SDK)/BSP/$(BOARD)/
VPATH    += $(BSP_DIR)src

BSP_SRCS := $(wildcard $(BSP_DIR)src/*.c )

filters   =

BSP_SRCS := $(filter-out $(filters),$(notdir $(BSP_SRCS)))

LIB_SRCS += $(addprefix $(BSP_DIR)src/,$(BSP_SRCS))
LIB_OBJS += $(addprefix output/,$(BSP_SRCS:.c=.o))
CFLAGS   += -I$(BSP_DIR)inc
