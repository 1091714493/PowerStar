`include "define.v"
module Ctrl(
	input wire rst,
	input wire[31:0] excptype,
	input wire[31:0] epc,
	output reg [31:0] ejpc,
	output reg excpt,
	output wire excpt_l
);
    assign excpt_l = excpt;
    
	always@(*)
		if(rst == `RstEnable)
			begin
				excpt = 1'b0;
				ejpc = `Zero;
			end
		else
			if(excptype != `Zero)
				begin
					excpt = 1'b1;
					case(excptype)
						32'h00000008:
							ejpc = 32'h00000040;
						32'h0000000e:
							ejpc = epc;
            32'h00000001:
              ejpc = 32'h00000050;
					endcase
				end
			else
				excpt = 1'b0;
endmodule