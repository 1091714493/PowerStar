`include "define.v"
module CP0(
    input wire clk,
    input wire rst,
    input wire cp0we,
    input wire[4:0] cp0wAddr,
    input wire[31:0] cp0wData,
    input wire[4:0] cp0rAddr,
    output reg[31:0] cp0rData,
    input wire[5:0] int,
    output reg intimer,
	  input wire[31:0] excptype,
	  input wire[31:0] epc,
	  output wire[31:0] cause
);
    reg[31:0] count_o;
    reg[31:0] compare_o;
    reg[31:0] status_o;
    reg[31:0] cause_o;
    reg[31:0] epc_o;
    
    assign cause = cause_o;
    
    always@(*)
      cause_o[15:10] = int;
    
    always@(posedge clk)
      if(rst == `RstEnable)
        begin
          count_o = `Zero;
          compare_o = `Zero;
          status_o = 32'h10000000;
          cause_o = `Zero;
          epc_o = `Zero;
          intimer = `InterruptNotAssert;
        end
      else
        begin
        intimer = `InterruptNotAssert;
		    count_o = count_o + 1;
		    
		    if(compare_o != `Zero && count_o == compare_o)
		        intimer = `InterruptAssert;
		    if(cp0we == `WriteEnable)
				begin
				  case(cp0wAddr)
					`CP0_COUNT:
					  count_o = cp0wData;
					`CP0_COMPARE:
					  begin
						compare_o = cp0wData;
						intimer = `InterruptNotAssert;
					  end
					`CP0_STATUS:
					  status_o = cp0wData;
					`CP0_EPC:
					  epc_o = cp0wData;
					`CP0_CAUSE:
					  begin
						cause_o[9:8] = cp0wData[9:8];
						cause_o[23] = cp0wData[23];
						cause_o[22] = cp0wData[22];
					  end
					default: ;
				  endcase
				end
				
			case(excptype)
			  32'h00000001:
			    begin
			      epc_o = epc;
			      status_o[1] = 1'b1;
			      cause_o[6:2] = 5'b00000;
			    end
				32'h00000008:
					begin
						epc_o = epc + 4;
						status_o[1] = 1'b1;
						cause_o[31] = 1'b0;
						cause_o[6:2] = 5'b01000;
					end
				32'h0000000e:
					status_o[1] = 1'b0;
			endcase
			
        end
                   
    always@(*)
      if(rst == `RstEnable)
        cp0rData = `Zero;
      else
        begin
          case(cp0rAddr)
            `CP0_COUNT:
                cp0rData = count_o ;
            `CP0_COMPARE:
                cp0rData = compare_o;
            `CP0_STATUS:
                cp0rData = status_o;
            `CP0_EPC:
                cp0rData = epc_o;
            `CP0_CAUSE:
                cp0rData = cause_o;
            default: ;
          endcase
        end

endmodule
            
    
  
  