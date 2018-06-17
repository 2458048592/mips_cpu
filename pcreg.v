`timescale 1ns / 1ps
/*module pcreg(
input clk, //1 λ���룬�Ĵ���ʱ���źţ�������ʱΪ PC �Ĵ�����ֵ
input rst, //1 λ���룬 �첽�����źţ��ߵ�ƽʱ�� PC �Ĵ�������
//ע���� ena �ź���Чʱ�� rst Ҳ�������üĴ���
input ena, //1 λ����,��Ч�źŸߵ�ƽʱ PC �Ĵ������� data_in
//��ֵ�����򱣳�ԭ�����
input [31:0] data_in, //32 λ���룬�������ݽ�������Ĵ����ڲ�
output [31:0] data_out //32 λ���������ʱʼ����� PC
//�Ĵ����ڲ��洢��ֵ
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
    input clk,   //1λ���룬�Ĵ���ʱ���źţ�������ʱΪPC�Ĵ�����ֵ 
    input rst,   //1λ���룬�첽�����źţ��ߵ�ƽʱ��PC�Ĵ������� 
                    //ע����ena�ź���Чʱ��rstҲ�������üĴ��� 
    input ena,   //1λ����,��Ч�źŸߵ�ƽʱPC�Ĵ�������data_in 
                    //��ֵ�����򱣳�ԭ����� 
    input [31:0] data_in, //32λ���룬�������ݽ�������Ĵ����ڲ� 
    output reg [31:0] data_out   //32λ���������ʱʼ����� PC  
                                //�Ĵ����ڲ��洢��ֵ 
    );       
    always@(posedge clk or posedge rst) begin
        if(rst) begin
            data_out<=32'h0;
            end
        else if(ena)
            data_out<=data_in;
        end
endmodule