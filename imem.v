module imem(
input [12:2] pc,
output [31:0] inst
);
    reg [31:0] inst_mem[2048:0];
    assign inst = inst_mem[pc];
endmodule