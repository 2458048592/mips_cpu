`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:14:04 11/24/2013 
// Design Name: 
// Module Name:    sccomp_dataflow 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////


module sccomp_dataflow(
input clk_in,
input reset,
input [15:0] sw,
output [7:0] o_seg,
output [7:0] o_sel);

	wire [31:0]Readdata;
	wire [31:0]Writedata;
	wire [31:0]data_fmem;
	wire [31:0]inst;
	wire clk;
	
	wire [31:0] pc_from_zero;
	wire [31:0] addr_from_zero;
	wire [31:0] addr;

    wire memRead, memWrite;
    
    //assign clk = clk_in;
    clk_wiz_0 clk_div
    (
    // Clock in ports
     .clk_in1(clk_in),      // input clk_in1
     // Clock out ports
     .clk_out1(clk));    // output clk_out1
    
    wire [1:0] lsHB;
    wire lU;
	cpu sccpu(clk, reset, inst, Readdata, pc_from_zero, addr, Writedata, lsHB, lU, memRead, memWrite);

    assign pc = pc_from_zero + 32'h00400000;
    //assign pc = pc_from_zero;
    assign addr_from_zero = addr - 32'h10010000;
    //assign addr_from_zero = addr;
    
	wire seg7_cs,switch_cs;
	
    io_sel io_mem(addr, 1'b1, memWrite, memRead, seg7_cs, switch_cs);
    
	dist_mem_gen_0 imem_dut (
      .a(pc_from_zero[12:2]),      // input wire [10 : 0] a
      .spo(inst)  // output wire [31 : 0] spo
    );
	dmem scdmem(clk, memRead, memWrite, lsHB, lU, addr_from_zero[10:0], Writedata, data_fmem);
    
    seg7x16 seg7(clk, reset, seg7_cs, Writedata, o_seg, o_sel);
    
    sw_mem_sel sw_mem(switch_cs, sw, data_fmem, Readdata);
    
endmodule
/*
module sccomp_dataflow(
input clk_in,
input reset,
output [31:0] inst,
output [31:0] pc,
output [31:0] addr);
    
    wire [15:0] sw;
    assign sw = 16'h8001;
	wire [31:0]Readdata;
	wire [31:0]Writedata;
	wire [31:0]data_fmem;
	wire clk;
	
	wire [31:0] pc_from_zero;
	wire [31:0] addr_from_zero;

    wire memRead, memWrite;
    
    assign clk = clk_in;
    //clk_wiz_0 clk_div
    //(
    // Clock in ports
     //.clk_in1(clk_in),      // input clk_in1
     // Clock out ports
     //.clk_out1(clk));    // output clk_out1
    
    wire [1:0] lsHB;
    wire lU;
	cpu sccpu(clk, reset, inst, Readdata, pc_from_zero, addr, Writedata, lsHB, lU, memRead, memWrite);

    assign pc = pc_from_zero + 32'h00400000;
    //assign pc = pc_from_zero;
    assign addr_from_zero = addr - 32'h10010000;
    //assign addr_from_zero = addr;
    
	wire seg7_cs,switch_cs;
	
    io_sel io_mem(addr, 1'b1, memWrite, memRead, seg7_cs, switch_cs);
    
    imem imem_dut(
    .pc(pc_from_zero[12:2]),
    .inst(inst));
    
	dmem scdmem(clk, memRead, memWrite, lsHB, lU, addr_from_zero[10:0], Writedata, data_fmem);
    
    seg7x16 seg7(clk, reset, seg7_cs, Writedata, o_seg, o_sel);
    
    sw_mem_sel sw_mem(switch_cs, sw, data_fmem, Readdata);
    
endmodule*/