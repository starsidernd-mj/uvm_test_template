`ifndef COVERAGE_SV
`define COVERAGE_SV

`include "coverage.svh"

module coverage();

	typedef struct {
		int success = 0;
		int fail = 0;
		int potential = 0;
		real rate = 0;
		time start_time[$];
		string check = "";
	} assert_struct;
	assert_struct assertions[string];

	initial begin
		assertions = '{
			"assertion_sysclk"        : '{0, 0, 0, 0, {}, ""},
			"assertion_REQ_pg_n"      : '{0, 0, 0, 0, {}, ""}
		};
	end
	
	//=====================================================
	
	function static void print_time(input time t, input time p);
		static time duration = t - p;
		`uvm_info("Time Printer", $sformatf("Duration: %0t", duration), UVM_MEDIUM);
	endfunction;
	
	function static void incr_pot(string item);
		assertions[item].potential++;
	endfunction
	
	function static void punch_time(string item, time t);
		assertions[item].start_time.push_back(t);
	endfunction
	
	function static void print_complete();
		$display("-------------------------------------------------------");
		foreach(assertions[key]) begin
			// update potential pass rate
			assertions[key].rate = 100*assertions[key].success/assertions[key].potential;
			assertions[key].check = (assertions[key].success < assertions[key].potential) ? "Yes" : "";
			$display("Assertion: %50s, Success: %08d, \tFail: %08d, \tPotential: %08d, \tRate: %8.1f, \tTime markers: %08d, \tCheck?: %s", key, assertions[key].success, assertions[key].fail, assertions[key].potential, assertions[key].rate, assertions[key].start_time.size(), assertions[key].check);
		end
	endfunction
	
	//====================================================
	//  Verify something
	//====================================================

	/*property p_get_some_mode (bit disable_chk=0, logic fp, logic pgn);
		disable iff(disable_chk)
		($rose(fp), incr_pot("assertion_REQ_pg_n"), punch_time("assertion_REQ_pg_n", $time)) |=> ##[0:$] pgn;
	endproperty
	
	assertion_REQ_pg_n: assert property (@ (posedge DUT.clk) p_get_some_mode (
		.disable_chk(u_my_module_init_if.exp_fail),
		.fp(DUT.i_fp_n),
		.pgn(DUT.o_pg_n)
	)) begin
		`uvm_info("assertion_REQ_pg_n", {"Assertion passed"}, UVM_HIGH)
		assertions["assertion_REQ_pg_n"].success++;
	end else begin
		`uvm_error("assertion_REQ_pg_n", "Assertion failed")
		assertions["assertion_REQ_pg_n"].fail++;
	end*/

endmodule 

`endif

