`include "define.v"
module IF(
    input wire clk,
    input wire rst,
    output reg ce, 
	output reg [31:0] pc,
	output wire [31:0] pc_if,
	
	input wire[31:0] jAddr,
	input wire jCe,
	
	input wire[31:0] ejpc,
	input wire excpt
);
    assign pc_if = pc;

    always@(posedge clk)
        if(rst == `RstEnable)
            ce <= `RomDisable;
        else
            ce <= `RomEnable;
			
    always@(posedge clk)
        if(ce == `RomDisable)
            pc <= `Zero;
        else if(excpt == 1'b1)
            pc <= ejpc;
        else if(jCe== `Valid)
            pc <= jAddr;
        else
            pc <= pc + 4;
endmodule
