`ifndef TB_TOP_SVH
`define TB_TOP_SVH

//include the UVM package
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "my_macros.svh"

`include "../env/interfaces/des_if.sv"
`include "../../rtl/det_1011.sv"
`include "../test/base_test.sv"
`include "../test/test_1011.sv"
`include "../env/coverage/coverage.sv"

`timescale 1ns/1ps
	
`endif
