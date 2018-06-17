`timescale 1ns / 1ps
/*module pcreg(
input clk, //1 位输入，寄存器时钟信号，上升沿时为 PC 寄存器赋值
input rst, //1 位输入， 异步重置信号，高电平时将 PC 寄存器清零
//注：当 ena 信号无效时， rst 也可以重置寄存器
input ena, //1 位输入,有效信号高电平时 PC 寄存器读入 data_in
//的值，否则保持原有输出
input [31:0] data_in, //32 位输入，输入数据将被存入寄存器内部
output [31:0] data_out //32 位输出，工作时始终输出 PC
//寄存器内部存储的值
);
    genvar i;
    generate 
        for(i = 0; i < 32; i = i + 1)
            begin:D_FF
                Asynchronous_D_FF  Asynchronous_D_FF_dut(.CLK(clk), .D(ena ? data_in[i] : data_out[i]), .RST_n(~rst), .Q1(data_out[i]), .Q2());
            end
    endgenerate

endmodule*/

module pcreg( 
    input clk,   //1位输入，寄存器时钟信号，上升沿时为PC寄存器赋值 
    input rst,   //1位输入，异步重置信号，高电平时将PC寄存器清零 
                    //注：当ena信号无效时，rst也可以重置寄存器 
    input ena,   //1位输入,有效信号高电平时PC寄存器读入data_in 
                    //的值，否则保持原有输出 
    input [31:0] data_in, //32位输入，输入数据将被存入寄存器内部 
    output reg [31:0] data_out   //32位输出，工作时始终输出 PC  
                                //寄存器内部存储的值 
    );       
    always@(posedge clk or posedge rst) begin
        if(rst) begin
            data_out<=32'h0;
            end
        else if(ena)
            data_out<=data_in;
        end
endmodule