`include "define.v"
module soc_tb;
    reg clk;
    reg rst;
    reg[15:0] sw;
    wire[15:0] led;
    initial
      begin
        clk = 0;
        rst = `RstEnable;
        sw = 16'h0000;
        #200
        rst = `RstDisable;
        sw = 16'h8000;
        #1000
        #1000000000
        #1000000000
        #1000000000
        #1000000000
        $stop;
      end
    always #10 clk = ~ clk;
    SoC SoC0(
        .clk(clk), 
        .rst(rst),
        .sw(sw),
        .led(led)
    );
endmodule

