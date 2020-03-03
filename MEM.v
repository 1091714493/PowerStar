`include "define.v"
module MEM(
	input wire rst,		
	input wire [5:0] op,
	input wire [31:0] regcData,
	input wire [4:0] regcAddr,
	input wire regcWr,
	input wire [31:0] memAddr_i,
	input wire [31:0] memData,	
	input  wire [31:0] rdData,
	
	output wire [4:0]  regAddr,
	output wire regWr,
	output wire [31:0] regData,	
	output wire [31:0] memAddr,
	output reg [31:0] wtData,
	output reg memWr,	
	output reg memCe,
	
	input wire rLLbit,
	output reg wLLbit,
	output reg wbit
);
  assign regAddr = regcAddr;    
  assign regWr = regcWr;    
  assign memAddr = memAddr_i;
  assign regData = (op == `Lw)|(op == `Ll) ? rdData : ( (op == `Sc) ? {{31{1'b0}},rLLbit} :  regcData ) ;  
  
  
  always @ (*)        
    if(rst == `RstEnable)          
      begin            
		wtData = `Zero;            
		memWr = `RamUnWrite;            
		memCe = `RamDisable; 
		
		wLLbit = 1'b0;
		wbit = 1'b0;
      end        
	else
		case(op)                
			`Lw:                  
			  begin                    
				 wtData = `Zero;                        
				 memWr = `RamUnWrite;                     
				 memCe = `RamEnable;                    
			  end                
			`Sw:                  
			  begin                    
				 wtData = memData;
				 memWr = `RamWrite;                      
				 memCe = `RamEnable;                   
			 end
			
			`Ll:
				begin
					wtData = `Zero;                        
					memWr = `RamUnWrite;                     
					memCe = `RamEnable;  
					wLLbit = 1'b1;
					wbit = `WriteEnable;
				end
			
			`Sc:
				begin
					if(rLLbit == 1'b1)
						begin
							wtData = memData;                    
							memWr = `RamWrite;                      
							memCe = `RamEnable;
							wLLbit = 1'b0;
							wbit = `WriteEnable;
						end
					else ;

				end
			
			 default:                  
			  begin                    
				wtData = `Zero;                    
				memWr = `RamUnWrite;                    
				memCe = `RamDisable;
				wLLbit = 1'b0;
				wbit = 1'b0;
			  end            
   endcase
  
endmodule