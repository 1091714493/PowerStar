module SoC(
    input wire clk,
    input wire rst,
    input wire[15:0] sw,
    output wire[7:0] seg_cs,
    output wire[15:0] led,
    output wire[7:0] seg
);
    wire [31:0] instAddr;
    wire [31:0] instruction;
    wire romCe;
    
    wire ramCe, ramWr;    
    wire [31:0] ramAddr;
    wire [31:0] ramRdData;
    wire [31:0] ramWtData;
    
    wire ioCe, ioWr;    
    wire [31:0] ioAddr;
    wire [31:0] ioRdData;
    wire [31:0] ioWtData;
    
    wire[5:0] int;
    wire intimer;
    
    wire memCe_mem, memWr_mem;
    wire [31:0] memAddr_mem,wtData_mem;
    wire [31:0] rdData_mem;
    
    MIOC mioc(
	      .memAddr(memAddr_mem),
		  .wtData(wtData_mem),
		  .memWr(memWr_mem),	
		  .memCe(memCe_mem),
		  .rdData(rdData_mem),
     
          .ramAddr(ramAddr),
		  .ramWtData(ramWtData),
		  .ramWe(ramWr),	
		  .ramCe(ramCe),
		  .ramRdData(ramRdData),  

          .ioAddr(ioAddr),
		  .ioWtData(ioWtData),
		  .ioWe(ioWr),	
		  .ioCe(ioCe),
		  .ioRdData(ioRdData)
	 );
    
    MIPS mips0(
        .clk(clk),
        .rst(rst),
        .instruction(instruction),
        .instAddr(instAddr),
        .romCe(romCe),
        
        .int(int),
        .intimer(intimer),
        
        .memCe_mem(memCe_mem), 
        .memWr_mem(memWr_mem),
        .memAddr_mem(memAddr_mem),
        .wtData_mem(wtData_mem),
        .rdData_mem(rdData_mem)
    );
    
    InstMem instrom0(
        .ce(romCe),
        .addr(instAddr),
        .data(instruction)
    );
    
    DataMem datamem0(       
        .ce(ramCe),        
        .clk(clk),        
        .we(ramWr),        
        .addr(ramAddr),        
        .dataOut(ramRdData),        
        .dataIn(ramWtData)   
    );
    
    IO io0(       
        .ce(ioCe),        
        .clk(clk),   
        .rst(rst),     
        .we(ioWr),        
        .addr(ioAddr),        
        .dataOut(ioRdData),        
        .dataIn(ioWtData),
        .sw(sw),
        .led(led),
        .seg(seg),
        .seg_cs(seg_cs)
    );

endmodule

