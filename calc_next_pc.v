`timescale 1ns / 1ps
module calc_next_pc(
input branch,
input jump,
input jumpReg,
input [31:0] pc,
input [31:0] epc,
input zero,
input negative,
input [31:0] inst,
input [31:0] rs,
output [31:0] next_pc,
input exception
);
    wire [31:0] branch_pc;
    wire [31:0] jump_pc;
    wire [31:0] add_four_pc;
    wire eret;
    assign eret = (inst[31:26] == 6'b010000 && inst[5:0] == 6'b011000);
    assign add_four_pc = pc + 4;
    assign jump_pc = (jumpReg ? rs : {add_four_pc[31:28], inst[25:0], 2'b0}) - 32'h00400000;
    assign branch_pc = add_four_pc + {{14{inst[15]}}, inst[15:0], 2'b0};
    
    reg branch_help;
    always @ (*)
    begin
        case(inst[31:26])
            6'b000100:
                branch_help = zero;
            6'b000101:
                branch_help = ~zero;
            6'b000001:
                branch_help = ~negative;
            default:
                branch_help = 1'b0;
        endcase
    end
    
    assign next_pc = exception ? 32'h00400004 : (eret ? epc : (jump ? jump_pc : ((branch & branch_help) ? branch_pc : add_four_pc)));
    
endmodule