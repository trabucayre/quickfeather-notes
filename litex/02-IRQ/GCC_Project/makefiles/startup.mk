HAL_DIR       = $(QORC_SDK)/HAL/startup/
VPATH        += $(HAL_DIR)

STARTUP_SRCS := startup_EOSS3B_GCC.c vectors_CM4F_gcc.c

LIB_SRCS     += $(addprefix $(HAL_DIR),$(STARTUP_SRCS))
LIB_OBJS     += $(addprefix output/,$(STARTUP_SRCS:.c=.o))

#OBJS+=$(addprefix $(OUTPUT_PATH)/,$(STARTUP_SRCS:.c=.o))
#OBJS+=$(STARTUP_SRCS:.c=.o)
