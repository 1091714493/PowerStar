
`include "define.v"
module MIPS(
    input wire clk,
    input wire rst,
    input wire [31:0] instruction,
    output wire romCe,
    output wire [31:0] instAddr,
      
    input wire[5:0] int,
    output wire intimer,
    
    input wire memCe_mem, memWr_mem,
    input wire [31:0] memAddr_mem,wtData_mem,
    output wire [31:0] rdData_mem
);
    wire [31:0] regaData_regFile, regbData_regFile;
    wire [31:0] regaData_id, regbData_id; 
    wire [31:0] regcData_ex,regData;   
    wire regaRead, regbRead;
    wire [4:0] regaAddr, regbAddr,regWr;
    wire regcWrite_id, regcWrite_ex;
    wire [4:0] regcAddr_id, regcAddr_ex,regAddr;
	
	wire[31:0] jAddr_id;
	wire jCe;
	  
	wire [5:0] op_i;
    wire [5:0] op;
    wire [31:0] memAddr_ex;
    wire [31:0] memData;
	
	wire [31:0] wHiData;
	wire [31:0] wLoData;
	wire whi;
	wire wlo;
	wire [31:0] rHiData;
	wire [31:0] rLoData;
	
	wire wLLbit,wbit,excpt,excpt_l,rLLbit;
	
	wire cp0we;
	wire[4:0] cp0wAddr;
	wire[31:0] cp0wData;
	wire[4:0] cp0rAddr;
	wire[31:0] cp0rData;
	
	wire[31:0] ejpc;
	
	wire[31:0] pc_id;
	wire[31:0] excptype_id,excptype_ex;
	wire[31:0] epc_ex,pc_o;
	
	wire[31:0] cause;
	wire[31:0] pc_if;
	
 assign int = {5'b00000,intimer}; 

    IF pc0(
        .clk(clk),
        .rst(rst),
        .ce(romCe), 
        .pc(instAddr),
        .pc_if(pc_if),
		
		.jAddr(jAddr_id),
		.jCe(jCe),
		
		.ejpc(ejpc),
		.excpt(excpt)
    );
	
    ID id0(
        .rst(rst),        
        .inst(instruction),
        .regaData_i(regaData_regFile),
        .regbData_i(regbData_regFile),
        .op(op_i),
        .regaData(regaData_id),
        .regbData(regbData_id),
        .regaRead(regaRead),
        .regbRead(regbRead),
        .regaAddr(regaAddr),
        .regbAddr(regbAddr),
        .regcWrite(regcWrite_id),
        .regcAddr(regcAddr_id),
		
		.pc(pc_if),
		.jAddr(jAddr_id),
		.jCe(jCe),
		
		.pc_i(pc_id),
		.excptype(excptype_id)
    );
    EX ex0(
        .rst(rst),
        .op_i(op_i),        
        .regaData(regaData_id),
        .regbData(regbData_id),
        .regcWrite_i(regcWrite_id),
        .regcAddr_i(regcAddr_id),
        .regcData(regcData_ex),
        .regcWrite(regcWrite_ex),
        .regcAddr(regcAddr_ex),
        
        .op(op),
        .memAddr(memAddr_ex),
        .memData(memData),
		
		.wHiData(wHiData),
		.wLoData(wLoData),
		.whi(whi),
		.wlo(wlo),
		.rHiData(rHiData),
		.rLoData(rLoData),
		    
		.cp0we(cp0we),
        .cp0wAddr(cp0wAddr),
        .cp0wData(cp0wData),
        .cp0rAddr(cp0rAddr),
        .cp0rData(cp0rData),
		
		.pc_i(pc_id),
		.excptype_i(excptype_id),
	
		.excptype(excptype_ex),
		.epc(epc_ex),
		.pc_o(pc_o),
		.cause(cause)
    ); 
       
    RegFile regfile0(
        .clk(clk),
        .rst(rst),
        .we(regWr),
        .waddr(regAddr),
        .wdata(regData),
        .regaRead(regaRead),
        .regbRead(regbRead),
        .regaAddr(regaAddr),
        .regbAddr(regbAddr),
        .regaData(regaData_regFile),
        .regbData(regbData_regFile)
    );
    
    MEM mem0(
        .rst(rst),		
		  .op(op),
		  .regcData(regcData_ex),
		  .regcAddr(regcAddr_ex),
		  .regcWr(regcWrite_ex),
		  .memAddr_i(memAddr_ex),
		  .memData(memData),	
		  .rdData(rdData_mem),
		  .regAddr(regAddr),
		  .regWr(regWr),
		  .regData(regData),	
		  .memAddr(memAddr_mem),
		  .wtData(wtData_mem),
		  .memWr(memWr_mem),	
		  .memCe(memCe_mem),
		  .wLLbit(wLLbit),
		  .wbit(wbit),
		  .rLLbit(rLLbit)
    );
	
	HiLo hilo0(
		.rst(rst),
		.clk(clk),
		.wHiData(wHiData),
		.wLoData(wLoData),
		.whi(whi),
		.wlo(wlo),
		.rHiData(rHiData),
		.rLoData(rLoData)
	);
	
	
	LLbit llbit0(
		.rst(rst),
		.clk(clk),
		.wLLbit(wLLbit),
		.wbit(wbit),
		.excpt(excpt_l),
		.rLLbit(rLLbit)
	);
	
	CP0 cp0(
		.clk(clk),
		.rst(rst),
		.cp0we(cp0we),
		.cp0wAddr(cp0wAddr),
		.cp0wData(cp0wData),
		.cp0rAddr(cp0rAddr),
		.cp0rData(cp0rData),
		.int(int),
		.intimer(intimer),
		.epc(pc_o),
		.excptype(excptype_ex),
		.cause(cause)
	);
	
	Ctrl ctrl0(
		.rst(rst),
		.ejpc(ejpc),
		.excpt(excpt),
		.excpt_l(excpt_l),
		.excptype(excptype_ex),
		.epc(epc_ex)
	);
endmodule

