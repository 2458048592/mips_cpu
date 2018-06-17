`timescale 1ns / 1ps
module cpu(
input clk,
input reset,
input [31:0] inst,
input [31:0] Readdata,
output [31:0] pc,
output [31:0] addr,
output [31:0] Writedata,
output [1:0] lsHB,
output lU,
output memRead,
output memWrite
);
/*
output pc,
output addr,
output wdata,IM_R,DM_CS,DM_R,DM_W,intr,inta);*/
	wire [31:26] op;
	assign op = inst[31:26];
	wire [5:0] func;
	assign func = inst[5:0];
	wire regSrc;
	wire regDst;
	wire aluSrc;
	wire memToReg;
	wire regWrite;
	wire zeroExt;
	wire branch;
	wire jump;
	wire jumpReg;
	wire [5:0] aluOp;	
	wire [31:0] pc_builtin;
	assign pc = pc_builtin;
	wire [31:0] next_pc;
	wire [31:0] pre_pc;
	    
    wire [4:0] MT;
    assign MT = inst[25:21];
	
	wire [31:0] div_q; //商
    wire [31:0] div_r; //余数
    wire div_busy;
        
    wire [31:0] divu_q; //商
    wire [31:0] divu_r; //余数
    wire divu_busy;
    
    wire [31:0] div_dividend;
    wire [31:0] div_divisor;
    wire [31:0] divu_dividend;
    wire [31:0] divu_divisor;
    
	pcreg PC_pre(
        .clk(clk), //1 位输入，寄存器时钟信号，上升沿时为 PC 寄存器赋值
        .rst(reset), //1 位输入， 异步重置信号，高电平时将 PC 寄存器清零
        //注：当 ena 信号无效时， rst 也可以重置寄存器
        .ena(~div_busy&~divu_busy), //1 位输入,有效信号高电平时 PC 寄存器读入 data_in
        //的值，否则保持原有输出
        .data_in(pc_builtin), //32 位输入，输入数据将被存入寄存器内部
        .data_out(pre_pc) //32 位输出，工作时始终输出 PC
        //寄存器内部存储的值
        );
	
	pcreg PC_next(
	.clk(clk), //1 位输入，寄存器时钟信号，上升沿时为 PC 寄存器赋值
	.rst(reset), //1 位输入， 异步重置信号，高电平时将 PC 寄存器清零
	//注：当 ena 信号无效时， rst 也可以重置寄存器
	.ena(~div_busy&~divu_busy), //1 位输入,有效信号高电平时 PC 寄存器读入 data_in
	//的值，否则保持原有输出
	.data_in(next_pc), //32 位输入，输入数据将被存入寄存器内部
	.data_out(pc_builtin) //32 位输出，工作时始终输出 PC
	//寄存器内部存储的值
	);
	
	Controller Controller_dut(
	.op(op),
	.func(func),
	.MT(MT),
	.regSrc(regSrc),
	.regDst(regDst),
	.aluSrc(aluSrc),
	.zeroExt(zeroExt),
	.lsHB(lsHB),
	.lU(lU),
	.memToReg(memToReg),
	.regWrite(regWrite),
	.memRead(memRead),
	.memWrite(memWrite),
	.branch(branch),
	.jump(jump),
	.jumpReg(jumpReg),
	.aluOp(aluOp));
	
	wire [4:0] aluc; //4 位输入，控制 alu 的操作
	
	alu_Controller alu_Controller_dut(
	.aluOp(aluOp),
	.aluc(aluc));
	
	wire [31:0] a; //32 位输入，操作数 1
	wire [31:0] b; //32 位输入，操作数 2
	wire [31:0] r; //32 位输出，由 a、 b 经过 aluc 指定的操作生成
	wire zero; //0 标志位
	wire carry; // 进位标志位
	wire negative; // 负数标志位
	wire overflow; // 溢出标志位


    wire we;
	wire [4:0] raddr1;
	wire [4:0] raddr2;
	wire [4:0] waddr;
	wire [31:0] wdata;
	wire [31:0] rdata1;
	wire [31:0] rdata2;
	
	assign a = regSrc ? {27'b0, inst[10:6]} : rdata1;
	assign b = aluSrc ? (zeroExt ? {16'b0, inst[15:0]} : {{16{inst[15]}}, inst[15:0]}): rdata2;
	
	alu alu_dut(
	.a(a), //32 位输入，操作数 1
	.b(b), //32 位输入，操作数 2
	.aluc(aluc), //4 位输入，控制 alu 的操作
	.r(r), //32 位输出，由 a、 b 经过 aluc 指定的操作生成
	.zero(zero), //0 标志位
	.carry(carry), // 进位标志位
	.negative(negative), // 负数标志位
	.overflow(overflow)// 溢出标志位
	);
	
	reg [1:0] from_HL;
	wire [63:0] mul_z;
	wire [63:0] multu_z;
	wire [31:0] HI, LO;
	reg Hi_ena;
	reg Lo_ena;
	reg [31:0] Hi_data_in;
	reg [31:0] Lo_data_in;
	
	wire mfc0;
    wire mtc0;
    wire wsta;
    wire wepc;
    wire exception;
    wire [31:0] cause;
    wire [31:0] status;
    wire [31:0] epc_out;
    wire [4:0] CP0_addr;
    wire [31:0] CP0_out;
        
	assign addr = r;
	assign we = regWrite;
	assign raddr1 = inst[25:21];
	assign raddr2 = inst[20:16];
	assign waddr = jump ? (jumpReg ? inst[15:11] : 5'b11111) : (regDst ? inst[15:11] : inst[20:16]);
	assign wdata = mfc0 ? CP0_out : (jump ? (pre_pc + 8 + 32'h00400000) : 
						  (memToReg ? Readdata : 
									  (from_HL == 2'b00 ? r :
									  (from_HL == 2'b01 ? LO :
									  (from_HL == 2'b10 ? HI :
									  mul_z[31:0])))));
	
	assign Writedata = rdata2;
	
	regfile cpu_ref(
	.clk(~clk), //寄存器组时钟信号，下降沿写入数据
	.rst(reset), //reset 信号，异步复位，高电平时全部寄存器置零
	.we(we), //寄存器读写有效信号，高电平时允许寄存器写入数据，低电平时允许寄存器读出数据
	.raddr1(raddr1), //所需读取的寄存器的地址
	.raddr2(raddr2), //所需读取的寄存器的地址
	.waddr(waddr), //写寄存器的地址
	.wdata(wdata), //写寄存器数据，数据在 clk 下降沿时被写入
	.rdata1(rdata1), //raddr1 所对应寄存器的输出数据
	.rdata2(rdata2) //raddr2 所对应寄存器的输出数据
	);
	
	calc_next_pc Next_pc_mod(
        .branch(branch),
        .jump(jump),
		.jumpReg(jumpReg),
        .pc(pc_builtin),
        .epc(epc_out - 32'h00400000),
        .zero(zero),
        .negative(negative),
        .inst(inst),
        .rs(rdata1),
        .next_pc(next_pc),
        .exception(exception)
        );
	
	always @ (*)
	begin
		case(op)
			6'b000000:
				case(func)
					6'b010000://mfhi
					begin
						from_HL <= 2'b10;
						Hi_ena <= 1'b0;
						Lo_ena <= 1'b0;
					end
					6'b010010://mflo
					begin
						from_HL <= 2'b01;
						Hi_ena <= 1'b0;
						Lo_ena <= 1'b0;
					end
					6'b010001://mthi
					begin
						Hi_data_in <= rdata1;
						from_HL <= 2'b00;
						Hi_ena <= 1'b1;
						Lo_ena <= 1'b0;
					end
					6'b010011://mtlo
					begin
						Lo_data_in <= rdata1;
						from_HL <= 2'b00;
						Hi_ena <= 1'b0;
						Lo_ena <= 1'b1;
					end
					6'b011001://multu
					begin
						Lo_data_in <= multu_z[31:0];
						Hi_data_in <= multu_z[63:32];
						from_HL <= 2'b00;
						Hi_ena <= 1'b1;
						Lo_ena <= 1'b1;
					end
					6'b011011://divu
					begin
					    Lo_data_in <= divu_q;
                        Hi_data_in <= divu_r;
                        from_HL <= 2'b00;
                        Hi_ena <= 1'b1;
                        Lo_ena <= 1'b1;
					end
					6'b011010://div
					begin
					    Lo_data_in <= div_q;
                        Hi_data_in <= div_r;
                        from_HL <= 2'b00;
                        Hi_ena <= 1'b1;
                        Lo_ena <= 1'b1;
					end		
					default:
					begin
						from_HL <= 2'b00;
						Hi_ena <= 1'b0;
						Lo_ena <= 1'b0;
					end
				endcase
			6'b011100:
				case(func)
					6'b000010://mul
					begin
						from_HL <= 2'b11;
						Hi_ena <= 1'b0;
						Lo_ena <= 1'b0;
					end
					default:
					begin
						from_HL <= 2'b00;
						Hi_ena <= 1'b0;
						Lo_ena <= 1'b0;
					end
				endcase
			default:
			begin
				from_HL <= 2'b00;
				Hi_ena <= 1'b0;
				Lo_ena <= 1'b0;
			end
		endcase
	end
	
	pcreg Hi(
	.clk(clk),
	.rst(reset),
	.ena(Hi_ena),
	.data_in(Hi_data_in),
	.data_out(HI));
	
	pcreg Lo(
	.clk(clk),
    .rst(reset),
    .ena(Lo_ena),
    .data_in(Lo_data_in),
    .data_out(LO));
	
	MUL mul_dut(
	   .clk(clk),
	   .reset(~reset),
	   .a(a),
	   .b(b),
	   .z(mul_z));
	
	MULTU multu_dut(
	   .clk(clk),
	   .reset(~reset),
	   .a(a),
	   .b(b),
	   .z(multu_z));
    
    wire is_divu;
    assign is_divu = (inst[31:26] == 6'b000000 && inst[5:0] == 6'b011011);
    wire is_div;
    assign is_div = (inst[31:26] == 6'b000000 && inst[5:0] == 6'b011010);
       
    DIV div_dut(
       .dividend(a), //被除数
       .divisor(b), //除数
       .start(is_div&~div_busy), //启动除法运算
       .clock(clk),
       .reset(reset),
       .q(div_q), //商
       .r(div_r), //余数
       .busy(div_busy) //除法器忙标志位
       );
    
    DIVU divu_dut(
       .dividend(a), //被除数
       .divisor(b), //除数
       .start(is_divu&~divu_busy), //启动除法运算
       .clock(clk),
       .reset(reset),
       .q(divu_q), //商
       .r(divu_r), //余数
       .busy(divu_busy) //除法器忙标志位
       );
    
    assign CP0_addr = inst[15:11];
    
	CP0_Controller CP0_Controller_dut(
	.op(op),
	.func(func),
	.MT(MT),
	.addr(CP0_addr),
	.status(status),
	.zero(zero),
	.mfc0(mfc0),
	.mtc0(mtc0),
	.wcau(wcau),
	.wsta(wsta),
	.wepc(wepc),
	.exception(exception),
	.cause(cause)
	);
	
	CP0 CP0_dut(
	.clk(clk),
	.rst(reset),
	.addr(CP0_addr),
	.CP0_out(CP0_out),
	.mtc0(mtc0),
	.mfc0(mfc0),
	.wcau(wcau),
	.wsta(wsta),
	.wepc(wepc),
	.data(rdata2),
	.exception(exception),
	.pc(pc + 32'h00400000),
	.cause(cause),
	.status(status),
	.epc_out(epc_out));
	
endmodule