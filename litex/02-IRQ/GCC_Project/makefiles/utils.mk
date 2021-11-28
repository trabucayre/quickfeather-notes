UTILS_DIR   = $(QORC_SDK)/Libraries/Utils/
VPATH      += $(UTILS_DIR)src

UTILS_SRCS := $(wildcard $(UTILS_DIR)src/*.c )

filters     = micro_tick64.c

UTILS_SRCS := $(filter-out $(filters), $(notdir $(UTILS_SRCS)))

LIB_SRCS   += $(addprefix $(UTILS_DIR)src,$(UTILS_SRCS))
LIB_OBJS   += $(addprefix output/,$(UTILS_SRCS:.c=.o))
CFLAGS     += -I$(UTILS_DIR)inc
