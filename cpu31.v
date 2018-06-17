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
	
	wire [31:0] div_q; //��
    wire [31:0] div_r; //����
    wire div_busy;
        
    wire [31:0] divu_q; //��
    wire [31:0] divu_r; //����
    wire divu_busy;
    
    wire [31:0] div_dividend;
    wire [31:0] div_divisor;
    wire [31:0] divu_dividend;
    wire [31:0] divu_divisor;
    
	pcreg PC_pre(
        .clk(clk), //1 λ���룬�Ĵ���ʱ���źţ�������ʱΪ PC �Ĵ�����ֵ
        .rst(reset), //1 λ���룬 �첽�����źţ��ߵ�ƽʱ�� PC �Ĵ�������
        //ע���� ena �ź���Чʱ�� rst Ҳ�������üĴ���
        .ena(~div_busy&~divu_busy), //1 λ����,��Ч�źŸߵ�ƽʱ PC �Ĵ������� data_in
        //��ֵ�����򱣳�ԭ�����
        .data_in(pc_builtin), //32 λ���룬�������ݽ�������Ĵ����ڲ�
        .data_out(pre_pc) //32 λ���������ʱʼ����� PC
        //�Ĵ����ڲ��洢��ֵ
        );
	
	pcreg PC_next(
	.clk(clk), //1 λ���룬�Ĵ���ʱ���źţ�������ʱΪ PC �Ĵ�����ֵ
	.rst(reset), //1 λ���룬 �첽�����źţ��ߵ�ƽʱ�� PC �Ĵ�������
	//ע���� ena �ź���Чʱ�� rst Ҳ�������üĴ���
	.ena(~div_busy&~divu_busy), //1 λ����,��Ч�źŸߵ�ƽʱ PC �Ĵ������� data_in
	//��ֵ�����򱣳�ԭ�����
	.data_in(next_pc), //32 λ���룬�������ݽ�������Ĵ����ڲ�
	.data_out(pc_builtin) //32 λ���������ʱʼ����� PC
	//�Ĵ����ڲ��洢��ֵ
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
	
	wire [4:0] aluc; //4 λ���룬���� alu �Ĳ���
	
	alu_Controller alu_Controller_dut(
	.aluOp(aluOp),
	.aluc(aluc));
	
	wire [31:0] a; //32 λ���룬������ 1
	wire [31:0] b; //32 λ���룬������ 2
	wire [31:0] r; //32 λ������� a�� b ���� aluc ָ���Ĳ�������
	wire zero; //0 ��־λ
	wire carry; // ��λ��־λ
	wire negative; // ������־λ
	wire overflow; // �����־λ


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
	.a(a), //32 λ���룬������ 1
	.b(b), //32 λ���룬������ 2
	.aluc(aluc), //4 λ���룬���� alu �Ĳ���
	.r(r), //32 λ������� a�� b ���� aluc ָ���Ĳ�������
	.zero(zero), //0 ��־λ
	.carry(carry), // ��λ��־λ
	.negative(negative), // ������־λ
	.overflow(overflow)// �����־λ
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
	.clk(~clk), //�Ĵ�����ʱ���źţ��½���д������
	.rst(reset), //reset �źţ��첽��λ���ߵ�ƽʱȫ���Ĵ�������
	.we(we), //�Ĵ�����д��Ч�źţ��ߵ�ƽʱ����Ĵ���д�����ݣ��͵�ƽʱ����Ĵ�����������
	.raddr1(raddr1), //�����ȡ�ļĴ����ĵ�ַ
	.raddr2(raddr2), //�����ȡ�ļĴ����ĵ�ַ
	.waddr(waddr), //д�Ĵ����ĵ�ַ
	.wdata(wdata), //д�Ĵ������ݣ������� clk �½���ʱ��д��
	.rdata1(rdata1), //raddr1 ����Ӧ�Ĵ������������
	.rdata2(rdata2) //raddr2 ����Ӧ�Ĵ������������
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
       .dividend(a), //������
       .divisor(b), //����
       .start(is_div&~div_busy), //������������
       .clock(clk),
       .reset(reset),
       .q(div_q), //��
       .r(div_r), //����
       .busy(div_busy) //������æ��־λ
       );
    
    DIVU divu_dut(
       .dividend(a), //������
       .divisor(b), //����
       .start(is_divu&~divu_busy), //������������
       .clock(clk),
       .reset(reset),
       .q(divu_q), //��
       .r(divu_r), //����
       .busy(divu_busy) //������æ��־λ
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