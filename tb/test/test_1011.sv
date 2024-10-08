`ifndef TEST_1011_SV
`define TEST_1011_SV

`include "test_1011.svh"

class test_1011 extends base_test;

	`uvm_component_utils(test_1011)
	function new(string name="test_1011", uvm_component parent=null);
		super.new(name,parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		pattern = 4'b1011;
		super.build_phase(phase);
		void'(seq.randomize() with { num inside {[3000:5000]}; });
	endfunction
	
endclass

`endif
