`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/20 23:58:45
// Design Name: 
// Module Name: regfile
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


module CP0_regfile(
input clk,
input rst,
input ce,
input [31:0] D,
output reg [31:0] O
    );
    
    always @ (posedge clk or posedge rst)
    begin
        if(rst == 1)
            O <= 32'b0;
        else if(ce)
            O <= D;
    end
    
endmodule
