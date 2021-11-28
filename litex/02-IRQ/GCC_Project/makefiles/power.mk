POWER_DIR   = $(QORC_SDK)/Libraries/Power/
VPATH      += $(POWER_DIR)src

POWER_SRCS := $(wildcard $(POWER_DIR)src/*.c )

filters     = s3x_fsm_interface.c s3x_pwrcfg_prototype.c

POWER_SRCS := $(filter-out $(filters),$(notdir $(POWER_SRCS)))

LIB_SRCS   += $(addprefix $(POWER_DIR)src/,$(BSP_SRCS))
LIB_OBJS   += $(addprefix output/,$(POWER_SRCS:.c=.o))
CFLAGS     += -I$(POWER_DIR)inc
