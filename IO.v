`include "define.v"
module IO(
    input wire clk,
    input wire rst,
    input wire ce,
    input wire we,
    input wire [31:0] addr,
    input wire [31:0] dataIn,
    output reg [31:0] dataOut,
    
    //IO devices
    output reg[15:0] led,
    output reg[7:0] seg,
    output reg[7:0] seg_cs,
    input wire[15:0] sw
); 

      //read
      always @(*)
        if(rst == `RstEnable)
            dataOut <= `Zero;
        else
            if(ce == `RamDisable)
                dataOut <= `Zero;
            else
                begin
                    case(addr)
                      `SW:
                          dataOut <= {16'b0,sw};
                     // `BUTTON:
                          //dataOut <= Button;
                    endcase
                end
      //write
      always @ (posedge clk)
        if(rst == `RstEnable)
            led <= `Zero;
        else if(ce == `RamEnable)
            begin
              case(addr)
                `SEG:
                    begin
                        seg_cs[7:0] <= 8'b11111111;
                        case({dataIn[0],dataIn[1],dataIn[2],dataIn[3]})
                            4'b0000:
                                seg <= 8'b10111111;
                            4'b0001:
                                seg <= 8'b10000110;   
                            4'b0010:
                                seg <= 8'b11011011;
                            4'b0011:
                                seg <= 8'b11001111; 
                            4'b0100:
                                seg <= 8'b11100110; 
                            4'b0101:
                                seg <= 8'b11101101; 
                            4'b0110:
                                seg <= 8'b11111100;     
                            4'b0111:
                                seg <= 8'b10000111; 
                            4'b1000:
                                seg <= 8'b11111111;
                            4'b1001:
                                seg <= 8'b11100111; 
                            4'b1010:
                                seg <= 8'b11110111; 
                            4'b1011:
                                seg <= 8'b11111111; 
                            4'b1100:
                                seg <= 8'b10111001; 
                            4'b1101:
                                seg <= 8'b10111111; 
                            4'b1110:
                                seg <= 8'b11111001; 
                            4'b1111:
                                seg <= 8'b11110001; 
                            default:
                                seg <= 8'b11111111; 
                        endcase
                    end
                `LED:
                    led <= dataIn[15:0];
              endcase
            end    
            
  
endmodule



