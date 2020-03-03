`include "define.v"
module LLbit(
	input wire rst,
	input wire clk,
	input wire wLLbit,
	input wire wbit,
	input wire excpt,
	output reg rLLbit
);

	always@(posedge clk)
		begin
			if(rst == `RstEnable)
				rLLbit = 1'b0;
			else if(excpt == 1'b1)
				rLLbit = 1'b0;
			else if((wbit == `WriteEnable))
				rLLbit = wLLbit;
		end

endmodule

	
