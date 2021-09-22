SRC_PATH:= $(PROJ_ROOT)/HAL/startup
VPATH += $(SRC_PATH)

STARTUP_SRCS := startup_EOSS3B_GCC.c vectors_CM4F_gcc.c
SRCS+=$(addprefix $(SRC_PATH)$(DIR_SEP),$(STARTUP_SRCS))

OUTPUT=output
OBJS+=$(addprefix $(OUTPUT)/,$(STARTUP_SRCS:.c=.o))
#OBJS+=$(addprefix $(OUTPUT_PATH)/,$(STARTUP_SRCS:.c=.o))
#OBJS+=$(STARTUP_SRCS:.c=.o)
