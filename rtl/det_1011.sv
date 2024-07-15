
module det_1011 (
	input clk,
	input rstn,
	input in,
	output out	
);
	
	parameter 	IDLE 	= 0,
				S1		= 1,
				S10		= 2,
				S101	= 3,
				S1011	= 4;
	
	logic [2:0] curr_state, next_state;
	
	assign out = curr_state == S1011 ? 1 : 0;
	
	always @(curr_state, in) begin
		case(curr_state)
			IDLE : begin
				if(in) next_state = S1;
				else next_state = IDLE;
			end
			
			S1 : begin
				if(in) next_state = IDLE;
				//if(in) next_state = S1;	//fix 1
				else next_state = S10;
			end
			
			S10 : begin
				if(in) next_state = S101;
				else next_state = IDLE;
			end
			
			S101 : begin
				if(in) next_state = S1011;
				else next_state = IDLE;
				//else next_state = S10;	//fix 2
			end
			
			S1011 : begin
				next_state = IDLE;
				//if(in) next_state = S1;	//fix 3
				//else next_state = IDLE;	//fix 3
				//else next_state = S10;	//fix 4
			end
		endcase
	end
	
	
endmodule
