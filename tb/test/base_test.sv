`ifndef BASE_TEST_SV
`define BASE_TEST_SV

`include "base_test.svh"

class base_test extends uvm_test;

	`uvm_component_utils(base_test)
	function new(string name="base_test", uvm_component parent=null);
		super.new(name,parent);
	endfunction
	
	env e0;
	bit[`LENGTH-1:0] pattern = 4'b1011;
	gen_item_seq seq;
	virtual des_if vif;
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		//create environment
		e0 = env::type_id::create("e0", this);
		
		//get virtual if handle from top level and pass it to everything in the env level
		if(!uvm_config_db#(virtual des_if)::get(this, "", "des_vif", vif))
			`uvm_fatal("TEST", "Did not get vif")
		`uvm_info("TEST", "Got vif", UVM_LOW)
		uvm_config_db#(virtual des_if)::set(this, "e0.a0.*", "des_vif", vif);
		
		//setup pattern queue and place into config db
		uvm_config_db#(bit[`LENGTH-1:0])::set(this, "*", "ref_pattern", pattern);
		
		//create sequence and randomize it
		seq = gen_item_seq::type_id::create("seq");
		seq.randomize();
	endfunction
	
	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction
	
	virtual task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		apply_reset();
		seq.start(e0.a0.s0);
		#200;
		phase.drop_objection(this);
	endtask
	
	virtual task apply_reset();
		vif.rstn <= 0;
		vif.in <= 0;
		repeat(5) @(posedge vif.clk);
		vif.rstn <= 1;
		repeat(10) @(posedge vif.clk);
	endtask
	
endclass

`endif
