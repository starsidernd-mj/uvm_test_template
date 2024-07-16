# Makefile for compiling SystemVerilog source files and running Questa/ModelSim with the GUI

#top level tb module
TB_TOP = tb_top

# Set the directories
DEP_DIR  := dependencies
SRC_DIR  := rtl
TB_DIR   := tb
WORK_DIR := work
SIM_DIR  := sim
COMP_DIR := $(TB_DIR)/components
ENV_DIR  := $(TB_DIR)/env
TEST_DIR := $(TB_DIR)/test
TOP_DIR  := $(TB_DIR)/top

# List of source files
TB_FILES_LIST := $(shell awk '{print "$(TB_DIR)/" $$0}' $(TB_DIR)/filelist.txt)
COMP_FILES_LIST := $(shell awk '{print "$(COMP_DIR)/" $$0}' $(COMP_DIR)/filelist.txt)
ENV_FILES_LIST := $(shell awk '{print "$(ENV_DIR)/" $$0}' $(ENV_DIR)/filelist.txt)
TEST_FILES_LIST := $(shell awk '{print "$(TEST_DIR)/" $$0}' $(TEST_DIR)/filelist.txt)
TOP_FILES_LIST := $(shell awk '{print "$(TOP_DIR)/" $$0}' $(TOP_DIR)/filelist.txt)

VLOG_DIRS = +incdir+. \
			+incdir+$(ENV_DIR) \
			+incdir+$(SRC_DIR) \
			+incdir+$(TB_DIR) \
			+incdir+$(COMP_DIR) \
			+incdir+$(TEST_DIR) \
			+incdir+$(TOP_DIR)
		
		
SRC =	$(TB_FILES_LIST) \
		$(ENV_FILES_LIST) \
		$(COMP_FILES_LIST) \
		$(TEST_FILES_LIST) \
		$(TOP_FILES_LIST)
		
GCC := gcc
BITS := 64
LIBNAME = uvm_dpi
LIBDIR  = $(UVM_HOME)/lib
DPI_SRC = $(UVM_HOME)/src/dpi/uvm_dpi.cc
DPILIB_VSIM_OPT = -sv_lib $(LIBDIR)/uvm_dpi 
DPILIB_TARGET = dpi_lib$(BITS)

GCCCMD =  $(GCC) \
        -m$(BITS) \
        -fPIC \
        -DQUESTA \
        -g \
        -W \
        -shared \
        -x c \
        -I$(MTI_HOME)/include \
        $(DPI_SRC) \
        -o $(LIBDIR)/$(LIBNAME).so

# Set the simulator (Questa or ModelSim)
SIMULATOR := vsim

VCOM := vcom
VLIB := vlib "work"

#Compiler flags
VLOG_OPTS := -timescale "1ns/1ns" \
			$(DPILIB_VLOG_OPT) \
			-suppress vlog-2583 \
			-sv \
			+acc \
			-mfcu \
			-suppress vlog-2181 \
			+define+UVM_NO_DPI \
			-writetoplevels questa.tops \
			+incdir+tb
			
VLOG := vlog $(VLOG_OPTS)

VSIM_OPTS := $(DPILIB_VSIM_OPT) \
			-c \
			-do "run -all; q" \
			-l questa.log \
			-f questa.tops
			
VSIM := $(SIMULATOR) $(VSIM_OPTS)

# Simulation options
SIM_OPTS = -gui

#defaul target to compile and run the simulation
all: prepare compile run

dpi_lib:
	mkdir -p $(LIBDIR)
	$(GCCCMD)

dpi_lib64:
	make -f Makefile LIBNAME=uvm_dpi BITS=64 dpi_lib
	
prepare: $(DPILIB_TARGET)
	vlib work

#compile the testbench
compile:
	vlog $(VLOG_OPTS) $(VLOG_DIRS) $(SRC)
	
#run the simulation
grun:
	vsim -sv_seed random -do "wave.do" $(TB_TOP) +UVM_TESTNAME=$(TEST) +UVM_VERBOSITY=$(VERBOSE)

run:
	vsim -c -sv_seed random -do "run -all; exit" $(TB_TOP) +UVM_TESTNAME=$(TEST) +UVM_VERBOSITY=$(VERBOSE)

#clean generated files
clean:
	rm -rf $(WORK_DIR)
	rm -rf $(SIM_DIR)/work
	rm -rf $(SIM_DIR)/transcript
	rm -rf $(SIM_DIR)/logs

.PHONY: all compile run clean
