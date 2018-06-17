module DIVU(
input [31:0]dividend, //������
input [31:0]divisor, //����
input start, //������������
input clock,
input reset,
output [31:0]q, //��
output [31:0]r, //����
output busy //������æ��־λ
);
    reg busy_1;
    assign busy = busy_1;
	wire ready;
	reg [4:0]count;
	reg [31:0] reg_q;
	reg [31:0] reg_r;
	reg [31:0] reg_b;
	reg busy2,r_sign;
	assign ready = ~busy_1 & busy2;
	wire [32:0] sub_add = r_sign?({reg_r,reg_q[31]} + {1'b0,reg_b}):({reg_r,reg_q[31]} - {1'b0,reg_b}); //�ӡ�������
	assign r = ready ? (r_sign? reg_r + reg_b : reg_r) : r;
	assign q = ready ? reg_q : q;
	always @ (negedge clock or posedge reset)
	begin
		if (reset == 1) 
		begin //����
			count <= 5'b0;
			busy_1 <= 1'b0;
			busy2 <= 1'b0;
		end
		else 
		begin
			busy2 <= busy_1;
			if (start) 
			begin //��ʼ�������㣬��ʼ��
                reg_r <= 32'b0;
                r_sign <= 1'b0;
                reg_q <= dividend;
                reg_b <= divisor;
                count <= 5'b0;
                busy_1 <= 1'b1;
		    end
		    else if (busy_1)
            begin //ѭ������
                reg_r <= sub_add[31:0]; //��������
                r_sign <= sub_add[32]; //���Ϊ�����´����
                reg_q <= {reg_q[30:0],~sub_add[32]};
                count <= count + 5'b1; //��������һ
                if (count == 5'b11111) busy_1 <= 0; //������������
            end
	   end
	end
endmodule