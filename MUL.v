`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/03/21 19:29:28
// Design Name: 
// Module Name: MULTU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MUL(
    input clk,
    input reset,
    input [31:0] a,
    input [31:0] b,
    output [63:0] z
    );
    
    wire [31:0] w_a = a[31] ? -a : a;
    wire [31:0] w_b = b[31] ? -b : b;
    reg sign;
    
    reg [63:0]Store[31:0];
    
    always @ (*)
    begin
        if(!reset)
            sign <= 0;
        else    
            sign <= a[31] ^ b[31];
    end
    
    
    genvar i;
    generate
        for(i = 0; i < 32; i = i + 1)
        begin:store
            always @ (*)
            begin
                if(reset && w_b[i])
                begin
                    Store[i] = 64'b0;
                    Store[i][31 + i:i] = w_a;
                end
                else
                    Store[i] = 64'b0;
            end
        end
    endgenerate
    
    wire [63:0]Add_1[15:0];
    genvar i_1;
    generate
        for(i_1 = 0; i_1 < 16; i_1 = i_1 + 1)
        begin:add_1
           assign Add_1[i_1] = Store[i_1 << 1] + Store[(i_1 << 1) | 1];
        end
    endgenerate
    
    wire [63:0]Add_2[7:0];
    genvar i_2;
    generate
         for(i_2 = 0; i_2 < 8; i_2 = i_2 + 1)
         begin:add_2
            assign Add_2[i_2] = Add_1[i_2 << 1] + Add_1[(i_2 << 1) | 1];
         end
    endgenerate
    
    wire [63:0]Add_3[3:0];
    genvar i_3;
    generate
         for(i_3 = 0; i_3 < 4; i_3 = i_3 + 1)
         begin:add_3
             assign Add_3[i_3] = Add_2[i_3 << 1] + Add_2[(i_3 << 1) | 1];
         end
    endgenerate
    
    wire [63:0]Add_4[1:0];
    genvar i_4;
    generate
          for(i_4 = 0; i_4 < 2; i_4 = i_4 + 1)  
          begin:add_4
             assign Add_4[i_4] = Add_3[i_4 << 1] + Add_3[(i_4 << 1) | 1];
          end
    endgenerate
    
    assign z = sign ? -(Add_4[0] + Add_4[1]) : Add_4[0] + Add_4[1];
     
endmodule
