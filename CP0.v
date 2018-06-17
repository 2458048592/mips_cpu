`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/20 23:11:42
// Design Name: 
// Module Name: CP0
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


module CP0(
input clk,
input rst,
input mfc0,
input [4:0] addr,
output [31:0] CP0_out,
input mtc0,
input wcau,
input wsta,
input wepc,
input [31:0] data,
input exception,
input [31:0] pc,
input [31:0] cause,
output [31:0] status,
output [31:0] epc_out
);

wire [31:0] Cause_mux, Status_mux_0, Status_mux_1, EPC_mux;
wire [31:0] Status_out, Cause_out, EPC_out;

assign Cause_mux = mtc0 ? data : cause;
assign Status_mux_0 = exception ? {Status_out[26:0], 5'b0} : {5'b0, Status_out[31:5]};
assign Status_mux_1 = mtc0 ? data : Status_mux_0;
assign EPC_mux = mtc0 ? data : pc;

CP0_regfile Cause(.clk(clk), .rst(rst), .ce(wcau), .D(Cause_mux), .O(Cause_out));
CP0_regfile Status(.clk(clk), .rst(rst), .ce(wsta), .D(Status_mux_1), .O(Status_out));
CP0_regfile EPC(.clk(clk), .rst(rst), .ce(wepc), .D(EPC_mux), .O(EPC_out));

wire [31:0] cp0_reg [31:0];

genvar i;
generate
    for(i = 0; i < 32; i = i + 1)
    begin:CP0_out_reg
        if (i != 12 && i != 13 && i != 14)
            begin:CP0_reg    
                CP0_regfile CP0_regfile_dut(.clk(clk), .rst(rst), .ce(mtc0 & (addr == i)), .D(data), .O(cp0_reg[i]));
            end
    end
endgenerate

assign cp0_reg[12] = Status_out;
assign cp0_reg[13] = Cause_out;
assign cp0_reg[14] = EPC_out;	

assign CP0_out = mfc0 ? cp0_reg[addr] : CP0_out;
assign status = Status_out;
assign epc_out = EPC_out;

endmodule

/*
module CP0(
input clk,
input rst,
input[4:0] addr,
output reg[31:0] CP0_out,
input mtc0,
input mfc0,
input wcau,
input wsta,
input wepc,
input[31:0] data,
input exception, 
input[31:0] pc,
input[31:0] cause,
output[31:0] status,
output[31:0] epc_out
);  
reg[31:0] array_reg[31:0];
wire [31:0]Cause_out;
wire[31:0] sta;
assign sta=exception?{status[26:0],5'b0}:{5'b0,status[31:5]};
wire [31:0]Cause_wdata=mtc0?data:cause;
wire [31:0]Status_wdata=mtc0?data:sta;
wire [31:0]EPC_wdata=mtc0?data:pc;
pcreg Status(clk,rst,wsta,Status_wdata,status);
pcreg Cause(clk,rst,wcau,Cause_wdata,Cause_out);
pcreg epc(clk,rst,wepc,EPC_wdata,epc_out);
always@(*)
begin
    if(mfc0)
        case(addr)
            5'b01100:
                CP0_out<=status;
            5'b01101:
                CP0_out<=Cause_out;
            5'b01110:
                CP0_out<=epc_out;
            default:
                CP0_out<=array_reg[addr];
        endcase
end
always@(posedge clk or posedge rst)
begin
    if(rst)
    begin
    array_reg[0]<=32'b0;
    array_reg[1]<=32'b0;
    array_reg[2]<=32'b0;
    array_reg[3]<=32'b0;
    array_reg[4]<=32'b0;
    array_reg[5]<=32'b0;
    array_reg[6]<=32'b0;
    array_reg[7]<=32'b0;
    array_reg[8]<=32'b0;
    array_reg[9]<=32'b0;
    array_reg[10]<=32'b0;
    array_reg[11]<=32'b0;
    array_reg[12]<=32'b0;
    array_reg[13]<=32'b0;
    array_reg[14]<=32'b0;
    array_reg[15]<=32'b0;
    array_reg[16]<=32'b0;
    array_reg[17]<=32'b0;
    array_reg[18]<=32'b0;
    array_reg[19]<=32'b0;
    array_reg[20]<=32'b0;
    array_reg[21]<=32'b0;
    array_reg[22]<=32'b0;
    array_reg[23]<=32'b0;
    array_reg[24]<=32'b0;
    array_reg[25]<=32'b0;
    array_reg[26]<=32'b0;
    array_reg[27]<=32'b0;
    array_reg[28]<=32'b0;
    array_reg[29]<=32'b0;
    array_reg[30]<=32'b0;
    array_reg[31]<=32'b0;
    end
    else
    begin
    if(mtc0)
    begin
        array_reg[addr]<=data;
    end
    end
end
endmodule*/