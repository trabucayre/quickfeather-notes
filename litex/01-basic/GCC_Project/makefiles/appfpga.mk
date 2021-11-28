FPGA_DIR   = $(QORC_SDK)/Libraries/FPGA
VPATH     += $(FPGA_DIR)/src

FPGA_SRCS := $(wildcard $(FPGA_DIR)/src/*.c )

filters    =

FPGA_SRCS := $(filter-out $(filters),$(notdir $(FPGA_SRCS)))

LIB_SRCS  += $(addprefix $(FPGA_DIR)$(DIR_SEP),$(FPGA_SRCS))
LIB_OBJS  += $(addprefix output/,$(FPGA_SRCS:.c=.o))
CFLAGS    += -I$(FPGA_DIR)/inc
