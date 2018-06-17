`timescale 1ns / 1ps
module alu(
input [31:0] a, //32 位输入，操作数 1
input [31:0] b, //32 位输入，操作数 2
input [4:0] aluc, //4 位输入，控制 alu 的操作
output [31:0] r, //32 位输出，由 a、 b 经过 aluc 指定的操作生成
output zero, //0 标志位
output carry, // 进位标志位
output negative, // 负数标志位
output overflow // 溢出标志位
);
    
    reg [32:0] reg_r;
	reg [31:0] clz_tmp;
    reg reg_zero;
    reg reg_carry;
    reg reg_negative;
    reg reg_overflow;
    
    
    assign r = reg_r[31:0];
    assign zero = reg_zero;
    assign carry = reg_carry;
    assign negative = reg_negative;
    assign overflow =  reg_overflow;
    
    always @ (*)
    begin
        casez(aluc)
            5'b00000:
            begin
                reg_r = a + b;
                reg_carry = reg_r[32];
            end
            
            5'b00010:
            begin
                reg_r = a + b;
                reg_overflow = (!(a[31] ^ b[31]) & (a[31] ^ reg_r[31]));
            end
            
            5'b00001:
            begin
                reg_r = a - b;
                reg_carry = reg_r[32];
            end
            
            5'b00011:
            begin
                reg_r = a - b;
                reg_overflow = (!(a[31] ^ b[31]) & (a[31] ^ reg_r[31]));
            end
            
            5'b00100:
            begin
                reg_r = a & b;
            end
            
            5'b00101:
            begin
                reg_r = a | b;
            end
            
            5'b00110:
            begin
                reg_r = a ^ b;
            end
            
            5'b00111:
            begin
                reg_r = ~(a | b);
            end
            
            5'b0100?:
            begin
                reg_r = {b[15:0], 16'b0};
            end
		   
		    5'b01011:
            begin
 				reg_r = ($signed(a) < $signed(b)) ? 33'b1 : 33'b0;
            end
		   
		    5'b01010:
            begin
				reg_r = (a < b) ? 33'b1 : 33'b0;
				reg_carry = reg_r[0];
            end
		   
		    5'b01100:
            begin
		 	 	reg_r = $signed(b) >>> a;
				if(1 <= a && a <= 32)
				begin
					reg_carry = b[a - 1];
				end
				else
				begin
					reg_carry = 1'b0;
				end
            end
		   
		    5'b0111?:
		    begin
				reg_r = b << a;
				if(0 < a && a <= 32)
				begin
					reg_carry = b[32 - a];
				end
				else
				begin
					reg_carry = 1'b0;
				end
		    end
		   
		    5'b01101:
            begin
				reg_r = b >> a;
				if(1 <= a && a <= 32)
				begin
					reg_carry = b[a - 1];
				end
				else
				begin
					reg_carry = 1'b0;
				end
            end
		   
		    5'b10000:
		    begin
				clz_tmp = a;
				reg_r = 33'b0;
				
				if(16'hffff & clz_tmp[31:16])
					clz_tmp = clz_tmp >> 16;
				else
					reg_r = 16;
				
				if(8'hff & clz_tmp[15:8])
					clz_tmp = clz_tmp >> 8;
				else
					reg_r = reg_r + 8;
					
				if(4'hf & clz_tmp[7:4])
					clz_tmp = clz_tmp >> 4;
				else
					reg_r = reg_r + 4;
				
				if(2'b11 & clz_tmp[3:2])
					clz_tmp = clz_tmp >> 2;
				else
					reg_r = reg_r + 2;
				
				case(clz_tmp[1:0])
					2'b00:
						reg_r = reg_r + 2;
					2'b01:
						reg_r = reg_r + 1;
					default:
						reg_r = reg_r;
				endcase
		    end
		   
		    5'b10001:
		    begin
				reg_r <= a;
			end
		   
        endcase
        reg_zero = (aluc[3:1] == 3'b101) ? (a == b) : (reg_r[31:0] == 0);
        reg_negative = (aluc == 5'b01011) ? reg_r[0] : reg_r[31];
     end

endmodule