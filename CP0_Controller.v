`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/04 10:21:40
// Design Name: 
// Module Name: CP0_Controller
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
module CP0_Controller(
input [5:0] op,
input [5:0] func,
input [4:0] MT,
input [4:0] addr,
input [31:0] status,
input zero,
output mfc0,
output mtc0,
output wcau,
output wsta,
output wepc,
output exception,
output reg [31:0] cause
    );
    wire SYSCALL;
    wire BREAK;
    wire TEQ;
    wire ERET;
    assign SYSCALL = (op == 6'b000000 && func == 6'b001100);
    assign BREAK = (op == 6'b000000 && func == 6'b001101);
    assign ERET = (op == 6'b010000 &&  func == 6'b011000);
    assign TEQ = (op == 6'b000000 && func == 6'b110100);
    assign mfc0 = (op == 6'b010000 && MT == 5'b00000);
    assign mtc0 = (op == 6'b010000 && MT == 5'b00100);    
    always@(*)
    begin
       if(SYSCALL)
             cause<=32'b100000;
       if(BREAK)
             cause<=32'b100100;
       if(TEQ)
             cause<=32'b110100;  
    end
   
   assign wepc=((addr==5'b01110)&mtc0)||exception;
   assign wsta=((addr==5'b01100)&mtc0)||ERET||exception;
   assign wcau=((addr==5'b01101)&mtc0)||exception;
   assign exception=(BREAK)||(SYSCALL)||((TEQ&&zero));//EQUAL
   
endmodule
