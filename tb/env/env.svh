`ifndef ENV_SVH
`define ENV_SVH

//include the UVM package
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "../my_macros.svh"

`include "../components/some_agent/agent.sv"
`include "scoreboards/scoreboard.sv"
`include "sequencers/gen_item_seq.sv"
`include "sequencers/Item.sv"

`endif
