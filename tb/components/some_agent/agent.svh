`ifndef AGENT_SVH
`define AGENT_SVH

//include the UVM package
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "../../my_macros.svh"

`include "../../env/sequencers/Item.sv"
`include "driver.sv"
`include "monitor.sv"
`include "../../env/scoreboards/scoreboard.sv"

`endif
