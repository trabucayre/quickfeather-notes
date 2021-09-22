VPATH+=$(UTILS_DIR)
UTILS_SRCS:=$(wildcard $(UTILS_DIR)/*.c )

UTILS_SRCS:=$(filter-out micro_tick64.c, $(notdir $(UTILS_SRCS)))
SRCS+=$(addprefix $(UTILS_DIR)$(DIR_SEP),$(UTILS_SRCS))
OBJS+=$(addprefix output/,$(UTILS_SRCS:.c=.o))
CFLAGS += -I$(UTILS_DIR)/../inc
