`include "define.v"
module EX(
    input wire rst,
    input wire [31:0] regaData,
    input wire [31:0] regbData,
    input wire regcWrite_i,
    input wire [4:0]regcAddr_i,
	
    output reg [31:0] regcData,
    output reg regcWrite,
    output reg [4:0] regcAddr,
    
    input wire [5:0] op_i,
    output wire [5:0] op,
    output wire [31:0] memAddr,
    output wire [31:0] memData,
	
	  input wire [31:0] rHiData,
    input wire [31:0] rLoData,
	  output reg [31:0] wHiData,
    output reg [31:0] wLoData,
    output reg whi,
    output reg wlo,
    
    output reg cp0we,
    output reg[4:0] cp0wAddr,
    output reg[31:0] cp0wData,
    output reg[4:0] cp0rAddr,
    input wire[31:0] cp0rData,
	
	input wire[31:0] pc_i,
	input wire[31:0] excptype_i,
	
	output reg[31:0] excptype,
	output reg[31:0] epc,
	output wire[31:0] pc_o,
	input wire[31:0] cause
    
);

	assign pc_o = pc_i;
    assign op = op_i;
    assign memAddr = regaData;
    assign memData = regbData;
    
    reg[31:0] Hi, Lo;

    always@(*)
        if(rst == `RstEnable || cause[10] == 1'b1)
          begin
            regcWrite = `Invalid;
            regcAddr = `Zero;
            regcData = `Zero;
            cp0we=`WriteDisable;
          end
        else
          begin
            regcWrite = regcWrite_i;
			regcAddr = regcAddr_i;
            regcData = `Zero;
            cp0we=`WriteDisable;
            cp0rAddr = `CP0_EPC;
				case(op_i)
				  `Add:
					regcData = regaData + regbData;
				  `Sub:
					regcData = regaData - regbData;
				  `And:
					regcData = regaData & regbData;
				  `Or:
					regcData = regaData | regbData;
				  `Xor:
					regcData = regaData ^ regbData;
				  `Sll:
					regcData = regbData << regaData;
				  `Srl:
					regcData = regbData >> regaData;
				  `Sra:
					regcData = ($signed(regbData)) >>> regaData;
				  `Jal:
					regcData = regaData;	   
				  `Slt:
				    begin
					  if($signed(regaData)<$signed(regbData))
					    regcData = `One;
					  else
					    regcData = `Zero;
					  end
					
					`Mfc0:
						begin
							cp0rAddr = regaData[4:0];
							regcData = cp0rData;
						end
					 
					`Mtc0:
						begin
							cp0we = `WriteEnable;
							cp0wAddr = regbData[4:0];
							cp0wData = regaData;
						end
					`Mfhi:
						regcData=rHiData;
					`Mflo:
						regcData=rLoData;
					
				  default:
				    begin
					   regcData = `Zero;
					   cp0we=`WriteDisable;
					  end
				endcase
          end

    always@(*)
	if(rst == `RstEnable)
      begin
		whi=`Invalid;
		wlo=`Invalid;
	    end
        else
			begin
				whi=`Invalid;
				wlo=`Invalid;
				case(op_i)
					`Multu:
					  begin		    	
							{Hi,Lo} = regaData * regbData;
							whi=`Valid;
							wlo=`Valid;
							wHiData=Hi;
							wLoData=Lo;
						end

					`Mult:		        
						begin		    	
							{Hi,Lo} = $signed(regaData) * $signed(regbData);
							whi=`Valid;
							wlo=`Valid;
							wHiData=Hi;
							wLoData=Lo;
						end
					
					`Divu:
					   begin
							Lo  = regaData / regbData;
							Hi  = regaData % regbData;
							whi=`Valid;
							wlo=`Valid;
							wHiData=Hi;
							wLoData=Lo;
						end
					`Div:
						begin
							Lo  = $signed(regaData)  /  $signed(regbData);
							Hi  = $signed(regaData) % $signed(regbData) ;
							whi=`Valid;
							wlo=`Valid;
							wHiData=Hi;
							wLoData=Lo;
						end
					
					`Mthi:
						begin
							whi=`Valid;
							wHiData=regaData;
						end
					`Mthi:
						begin
							wlo=`Valid;
							wLoData=regaData;
						end	
					default:
						begin
							whi=`Invalid;
							wlo=`Invalid;
						end
				endcase
			end
    
    
    always@(*)
		if(rst == `RstEnable)
			excptype = `Zero;
		else
			begin
				excptype = `Zero;
				if(cause[10] == 1'b1)
				    excptype = 32'h00000001;
				else if(excptype_i[8] == 1'b1)
					excptype = 32'h00000008;
				else if(excptype_i[12] == 1'b1)
					begin
						epc = cp0rData;
						excptype = 32'h0000000e;
					end
			end
			
endmodule

