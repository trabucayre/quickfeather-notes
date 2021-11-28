CLI_DIR   = $(QORC_SDK)/Libraries/cli
VPATH    += $(CLI_DIR)/src

CLI_SRCS := $(wildcard $(CLI_DIR)/src/*.c )

filters   = cli_filesystem.c cli_fsminterface.c

CLI_SRCS := $(filter-out $(filters),$(notdir $(CLI_SRCS)))

LIB_SRCS += $(addprefix $(CLI_DIR)$(DIR_SEP),$(CLI_SRCS))
LIB_OBJS += $(addprefix output/,$(CLI_SRCS:.c=.o))
CFLAGS   += -I$(CLI_DIR)/inc
