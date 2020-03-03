
`include "define.v"
module InstMem(
    input wire clk,
    input wire ce,
    input wire [31:0] addr,
    output reg [31:0] data
);
    reg [31:0] instmem [1023 : 0];    
    always@(*)      
        if(ce == `RomDisable)
          data = `Zero;
        else
          data = instmem[addr[11 : 2]];   
    initial
		begin

			
			
		  //sc ll
		  
			//ori r1=0x0000
			instmem[0] = 32'h34010000;
			//ori r2=0x1234
			instmem[1] = 32'h34021234;
			//sw r1 -> 0
			instmem[2] = 32'hAC220000;
			//ori r2=0x5678
			instmem[3] = 32'h34025678;
			//sc r2 -> 0  r2 = 1'b0
			instmem[4] = 32'hE0220000;
			//lw 0 -> r2
			instmem[5] = 32'h8C220000;

			//ori r3=0x0000
			instmem[6] = 32'h34030000;
			//ll 0 -> r3
			instmem[7] = 32'hC0230000;
			//addi r3 + 1
			instmem[8] = 32'h20630001;
			//sc r3 -> 0  r3=1'b1
			instmem[9] = 32'hE0230000;
			//lw 0 -> r3
			instmem[10] = 32'h8C230000;

			//ori r4 = 0xf
			instmem[11] = 32'h3404000f;
			//mtc0 r4 -> compare
			instmem[12] = 32'h40845800;
			//lui r4 = 0x10000000
			instmem[13] = 32'h3C041000;
			//ori r4 = 0x10000401
			instmem[14] = 32'h34840401;
			//mtc0 r4 -> status
			instmem[15] = 32'h40846000;
			//mfc0 status -> r5
			instmem[16] = 32'h40056000;
			
			
			
			
			/*
			
			//syscall -> 16 +  eret
			
			instmem[0] = 32'h3401ffff;
			instmem[1] = 32'h3402ffff;
			instmem[2] = 32'h3403ffff;
			instmem[3] = 32'h3404ffff;
			
			instmem[4] = 32'h0000000c;
			
			instmem[5] = 32'h3405ffff;
			instmem[6] = 32'h3406ffff;

			
			instmem[16] = 32'h340affff;
			instmem[17] = 32'h340bffff;
			instmem[18] = 32'b01000010000000000000000000011000;
			
			*/
			
			//eret -> 20 + eret
			
			//ori r4 = 0xa
			instmem[1] = 32'h3404000a;
			//mtc0 r4 -> compare
			instmem[2] = 32'h40845800;
			
			instmem[3] = 32'h3401ffff;
			instmem[4] = 32'h3402ffff;
			instmem[5] = 32'h3403ffff;
			instmem[6] = 32'h3404ffff;
			instmem[7] = 32'h3405ffff;
			instmem[8] = 32'h3406ffff;
			instmem[9] = 32'h3407ffff;
			instmem[10] = 32'h3408ffff;
			instmem[11] = 32'h3409ffff;
			
			instmem[20] = 32'h340affff;
			instmem[21] = 32'h340bffff;
			instmem[22] = 32'b01000010000000000000000000011000;
		
   

			
		  
          end
endmodule

