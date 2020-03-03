`include "define.v"
module HiLo(
    input wire rst,
    input wire clk,
    input wire [31:0] wHiData,
    input wire [31:0] wLoData,
    input wire whi,
    input wire wlo,
    output reg [31:0] rHiData,
    output reg [31:0] rLoData
);
    reg [31:0] Hi,Lo;
    always@(*)
       if(rst == `RstEnable)
         begin
           rHiData = `Zero;
           rLoData = `Zero;
         end
       else
         begin
           rHiData = Hi;
           rLoData = Lo;
         end
         
    always@(posedge clk)
       if(rst == `RstDisable)
         begin
           if(whi == `Valid)
             Hi <= wHiData;
           if(wlo == `Valid)
              Lo <= wLoData;
         end
         
endmodule 