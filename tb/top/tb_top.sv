`ifndef TB_TOP_SV
`define TB_TOP_SV

`include "tb_top.svh"

module tb_top;
	reg clk;
	
	always #10 clk = ~clk;
	
	//Design and its virtual interface here
	des_if _if (clk);
	
	det_1011 DUT (
		.clk(clk),
		.rstn(_if.rstn),
		.in(_if.in),
		.out(_if.out)
	);
	
	//Coverage module and its virtual interface here
	coverage_vif _cov (.clk(clk), .rstn(_if.rstn), .in(_if.in), .out(_if.out));
	
	initial begin
		clk <= 0;
		uvm_config_db#(virtual des_if)::set(null, "uvm_test_top", "des_vif", _if);
		uvm_config_db#(virtual coverage_vif)::set(null, "uvm_test_top", "cov_vif", _cov);
		run_test("test_1011");
	end
	
endmodule

`endif
