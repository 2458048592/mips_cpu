module Controller(
input [5:0] op,
input [5:0] func,
input [4:0] MT,
output reg regSrc,
output reg regDst,
output reg aluSrc,
output reg zeroExt,
output reg [1:0] lsHB,
output reg lU,
output reg memToReg,
output reg regWrite,
output reg memRead,
output reg memWrite,
output reg branch,
output reg jump,
output reg jumpReg,
output reg [5:0] aluOp);
    
    always @ (*)
    begin
        casez(op)
			6'b010000://mfc0 + mtc0 + eret
			begin
				if (MT == 5'b00100)//mtc0
				begin
					regWrite <= 1'b0;
					memToReg <= 1'b0;
					memRead <= 1'b0;
					memWrite <= 1'b0;
					branch <= 1'b0;
					jump <= 1'b0;
					aluOp <= 6'b001111;//op的类型(任意数都可以，因为不会用到)
				end
				else if (MT == 5'b00000)//mfc0
				begin
					regDst <= 1'b0;//写回15-11(否则20-16）
					regWrite <= 1'b1;
					memToReg <= 1'b0;
					memRead <= 1'b0;
					memWrite <= 1'b0;
					branch <= 1'b0;
					jump <= 1'b0;
					aluOp <= 6'b001111;//op的类型(任意数都可以，因为不会用到)
				end
				else if (func == 6'b011000)//eret
				begin
					regWrite <= 1'b0;
					memToReg <= 1'b0;
					memRead <= 1'b0;
					memWrite <= 1'b0;
					branch <= 1'b0;
					jump <= 1'b0;
					aluOp <= 6'b001111;//op的类型(任意数都可以，因为不会用到)
				end
			end
						
		//R-Type Instruction
			6'b000000:
			begin
				case(func)
					6'b001000://jr
					begin
						regWrite <= 1'b0;
						memRead <= 1'b0;
						memWrite <= 1'b0;
						jump <= 1'b1;
						jumpReg <= 1'b1;
						branch <= 1'b0;
						aluOp <= 6'b001111;//op的类型(任意数都可以，因为不会用到)
					end
					
					6'b001001://jalr
					begin
						regDst <= 1'b0;//写回15-11
						regWrite <= 1'b1;//写回reg
						memToReg <= 1'b0;//内存到reg
						memRead <= 1'b0;//读内存
						memWrite <= 1'b0;//写内存
						branch <= 1'b0;//分支
						jump <= 1'b1;//跳转指令
						jumpReg <= 1'b1;
						branch <= 1'b0;
						aluOp <= 6'b001111;//op的类型(任意数都可以，因为不会用到)
					end
					
					6'b001100://syscall
					begin
						regWrite <= 1'b0;
						memRead <= 1'b0;
						memWrite <= 1'b0;
						jump <= 1'b0;
						branch <= 1'b0;
						aluOp <= 6'b001111;//op的类型(任意数都可以，因为不会用到)
					end
					6'b001101://break
					begin
						regWrite <= 1'b0;
						memRead <= 1'b0;
						memWrite <= 1'b0;
						jump <= 1'b0;
						branch <= 1'b0;
						aluOp <= 6'b001111;//op的类型(任意数都可以，因为不会用到)
					end
					6'b110100://teq
					begin
						regWrite <= 1'b0;
						memRead <= 1'b0;
						memWrite <= 1'b0;
						jump <= 1'b0;
						branch <= 1'b0;
                        aluOp <= 6'b100010;
                        aluSrc <= 1'b0;
					end
					
					6'b010000://mfhi
					begin
						regDst <= 1'b1;
						regWrite <= 1'b1;
						memRead <= 1'b0;
						memWrite <= 1'b0;
						memToReg <= 1'b0;
						jump <= 1'b0;
						branch <= 1'b0;
						aluOp <= 6'b001111;//op的类型(任意数都可以，因为不会用到)
					end
					
					6'b010010://mflo
					begin
						regDst <= 1'b1;
						regWrite <= 1'b1;
						memRead <= 1'b0;
						memWrite <= 1'b0;
						memToReg <= 1'b0;
						jump <= 1'b0;
						branch <= 1'b0;
						aluOp <= 6'b001111;//op的类型(任意数都可以，因为不会用到)
					end
					
					6'b010001://mthi
					begin
						regWrite <= 1'b0;
						memRead <= 1'b0;
						memWrite <= 1'b0;
						memToReg <= 1'b0;
						jump <= 1'b0;
						branch <= 1'b0;
						aluOp <= 6'b001111;//op的类型(任意数都可以，因为不会用到)
					end
					
					6'b010011://mtlo
					begin
						regWrite <= 1'b0;
						memRead <= 1'b0;
						memWrite <= 1'b0;
						memToReg <= 1'b0;
						jump <= 1'b0;
						branch <= 1'b0;
						aluOp <= 6'b001111;//op的类型(任意数都可以，因为不会用到)
					end
					
					6'b011001://multu
					begin
						regSrc <= 1'b0;
						aluSrc <= 1'b0;
						regWrite <= 1'b0;
						memRead <= 1'b0;
						memWrite <= 1'b0;
						memToReg <= 1'b0;
						jump <= 1'b0;
						branch <= 1'b0;
						aluOp <= 6'b001111;//op的类型(任意数都可以，因为不会用到)
					end
					
					6'b011011://divu
                    begin
                        regSrc <= 1'b0;
                        aluSrc <= 1'b0;
                        regWrite <= 1'b0;
                        memRead <= 1'b0;
                        memWrite <= 1'b0;
                        memToReg <= 1'b0;
                        jump <= 1'b0;
                        branch <= 1'b0;
                        aluOp <= 6'b001111;//op的类型(任意数都可以，因为不会用到)
                    end
                    
                    6'b011010://div
                    begin
                        regSrc <= 1'b0;
                        aluSrc <= 1'b0;
                        regWrite <= 1'b0;
                        memRead <= 1'b0;
                        memWrite <= 1'b0;
                        memToReg <= 1'b0;
                        jump <= 1'b0;
                        branch <= 1'b0;
                        aluOp <= 6'b001111;//op的类型(任意数都可以，因为不会用到)
                    end
					
					default:
						begin
							regSrc <= (func[5:2] == 4'b0000);//shamt
							regDst <= 1'b1;//写回15-11(否则20-16）
							regWrite <= 1'b1;//写回reg
							memToReg <= 1'b0;//内存到reg
							memRead <= 1'b0;//读内存
							memWrite <= 1'b0;//写内存
							jump <= 1'b0;//跳转指令
							branch <= 1'b0;//分支
							aluOp <= func;//op的类型
							aluSrc <= 1'b0;//alu计算中第二个操作数的来源(reg / instruction)
						end
				endcase
			end
			//clz or mul
			6'b011100:
			begin
				case(func)
					6'b000010://mul
					begin
						regSrc <= 1'b0;
						aluSrc <= 1'b0;
						regDst <= 1'b1;
						regWrite <= 1'b1;
						memRead <= 1'b0;
						memWrite <= 1'b0;
						memToReg <= 1'b0;
						jump <= 1'b0;
						branch <= 1'b0;
						aluOp <= 6'b001111;//op的类型(任意数都可以，因为不会用到)
					end
					6'b100000://clz
					begin
						regSrc <= 1'b0;
						regDst <= 1'b1;//写回15-11（因为是rd所以为1）
						regWrite <= 1'b1;//写回reg
						memToReg <= 1'b0;//内存到reg
						memRead <= 1'b0;//读内存
						memWrite <= 1'b0;//写内存
						branch <= 1'b0;//分支
						jump <= 1'b0;//跳转指令
						aluOp <= 6'b011100;//op的类型
					end
				endcase
			end
		//Load
			6'b100011://lw
			begin
				regSrc <= 1'b0;
				regDst <= 1'b0;
				regWrite <= 1'b1;
				memToReg <= 1'b1;
				memRead <= 1'b1;
				memWrite <= 1'b0;
				jump <= 1'b0;//跳转指令
				branch <= 1'b0;
				aluOp <= 6'b100000;
				aluSrc <= 1'b1;
				zeroExt <= 1'b0;//extend方式（zero / sign)
				lsHB <= 2'b00;//0: lw 1: 1b 2：lh
				lU <= 1'b0;//是否无符号
			end
			6'b100000://lb
			begin
				regSrc <= 1'b0;
				regDst <= 1'b0;
				regWrite <= 1'b1;
				memToReg <= 1'b1;
				memRead <= 1'b1;
				memWrite <= 1'b0;
				jump <= 1'b0;//跳转指令
				branch <= 1'b0;
				aluOp <= 6'b100000;
				aluSrc <= 1'b1;
				zeroExt <= 1'b0;//extend方式（zero / sign)
				lsHB <= 2'b01;
				lU <= 1'b0;//0: lb 1: lbu
			end
			6'b100100://lbu
			begin
				regSrc <= 1'b0;
				regDst <= 1'b0;
				regWrite <= 1'b1;
				memToReg <= 1'b1;
				memRead <= 1'b1;
				memWrite <= 1'b0;
				jump <= 1'b0;//跳转指令
				branch <= 1'b0;
				aluOp <= 6'b100000;
				aluSrc <= 1'b1;
				zeroExt <= 1'b0;//extend方式（zero / sign)
				lsHB <= 2'b01;
				lU <= 1'b1;//0: lb 1: lbu
			end
			6'b100001://lh
			begin
				regSrc <= 1'b0;
				regDst <= 1'b0;
				regWrite <= 1'b1;
				memToReg <= 1'b1;
				memRead <= 1'b1;
				memWrite <= 1'b0;
				jump <= 1'b0;//跳转指令
				branch <= 1'b0;
				aluOp <= 6'b100000;
				aluSrc <= 1'b1;
				zeroExt <= 1'b0;//extend方式（zero / sign)
				lsHB <= 2'b10;
				lU <= 1'b0;//0: lb 1: lbu
			end
			6'b100101://lhu
			begin
				regSrc <= 1'b0;
				regDst <= 1'b0;
				regWrite <= 1'b1;
				memToReg <= 1'b1;
				memRead <= 1'b1;
				memWrite <= 1'b0;
				jump <= 1'b0;//跳转指令
				branch <= 1'b0;
				aluOp <= 6'b100000;
				aluSrc <= 1'b1;
				zeroExt <= 1'b0;//extend方式（zero / sign)
				lsHB <= 2'b10;
				lU <= 1'b1;//0: lb 1: lbu
			end
		//Save
			6'b101011://sw
			begin
				regSrc <= 1'b0;
				regWrite <= 1'b0;
				memRead <= 1'b0;
				memWrite <= 1'b1;
				branch <= 1'b0;
				jump <= 1'b0;//跳转指令
				aluOp <= 6'b100000;
				aluSrc <= 1'b1;
				zeroExt <= 1'b0;//extend方式（zero / sign)
				lsHB <= 2'b00;//0: sw 1: sb 2:sh
			end
			6'b101000://sb
			begin
				regSrc <= 1'b0;
				regWrite <= 1'b0;
				memRead <= 1'b0;
				memWrite <= 1'b1;
				branch <= 1'b0;
				jump <= 1'b0;//跳转指令
				aluOp <= 6'b100000;
				aluSrc <= 1'b1;
				zeroExt <= 1'b0;//extend方式（zero / sign)
				lsHB <= 2'b01;//0: sw 1: sb 2:sh
			end
			6'b101001://sh
			begin
				regSrc <= 1'b0;
				regWrite <= 1'b0;
				memRead <= 1'b0;
				memWrite <= 1'b1;
				branch <= 1'b0;
				jump <= 1'b0;//跳转指令
				aluOp <= 6'b100000;
				aluSrc <= 1'b1;
				zeroExt <= 1'b0;//extend方式（zero / sign)
				lsHB <= 2'b10;//0: sw 1: sb 2:sh
			end
		//Branch-on-Equal InstructionBranch-not-Equal Instruction
			6'b00010?:
			begin
				regSrc <= 1'b0;
				regWrite <= 1'b0;
				branch <= 1'b1;
				jump <= 1'b0;//跳转指令
				memRead <= 1'b0;
				memWrite <= 1'b0;
				aluOp <= 6'b100010;
				aluSrc <= 1'b0;
			end
			
			6'b000001://bgez
			begin
				regSrc <= 1'b0;
				regWrite <= 1'b0;
				branch <= 1'b1;
				jump <= 1'b0;//跳转指令
				memRead <= 1'b0;
				memWrite <= 1'b0;
				aluOp <= 6'b011101;
			end
	    
		//I-Format Instruction
			6'b001000:
			begin
				regSrc <= 1'b0;
				regDst <= 1'b0;//写回15-11
				regWrite <= 1'b1;//写回reg
				memToReg <= 1'b0;//内存到reg
				memRead <= 1'b0;//读内存
				memWrite <= 1'b0;//写内存
				branch <= 1'b0;//分支
				jump <= 1'b0;//跳转指令
				aluOp <= 6'b100000;//op的类型
				aluSrc <= 1'b1;//alu计算中第二个操作数的来源
				zeroExt <= 1'b0;//extend方式（zero / sign)
			end
			
			6'b001001:
			begin
				regSrc <= 1'b0;
				regDst <= 1'b0;//写回15-11
				regWrite <= 1'b1;//写回reg
				memToReg <= 1'b0;//内存到reg
				memRead <= 1'b0;//读内存
				memWrite <= 1'b0;//写内存
				branch <= 1'b0;//分支
				jump <= 1'b0;//跳转指令
				aluOp <= 6'b100001;//op的类型
				aluSrc <= 1'b1;//alu计算中第二个操作数的来源
				zeroExt <= 1'b0;//extend方式（zero / sign)
			end
			
			6'b001100:
			begin
				regSrc <= 1'b0;
				regDst <= 1'b0;//写回15-11
				regWrite <= 1'b1;//写回reg
				memToReg <= 1'b0;//内存到reg
				memRead <= 1'b0;//读内存
				memWrite <= 1'b0;//写内存
				branch <= 1'b0;//分支
				jump <= 1'b0;//跳转指令
				aluOp <= 6'b100100;//op的类型
				aluSrc <= 1'b1;//alu计算中第二个操作数的来源
				zeroExt <= 1'b1;//extend方式（zero / sign)
			end
		
			6'b001101:
			begin
				regSrc <= 1'b0;
				regDst <= 1'b0;//写回15-11
				regWrite <= 1'b1;//写回reg
				memToReg <= 1'b0;//内存到reg
				memRead <= 1'b0;//读内存
				memWrite <= 1'b0;//写内存
				branch <= 1'b0;//分支
				jump <= 1'b0;//跳转指令
				aluOp <= 6'b100101;//op的类型
				aluSrc <= 1'b1;//alu计算中第二个操作数的来源
				zeroExt <= 1'b1;//extend方式（zero / sign)
			end
			
			6'b001110:
			begin
				regSrc <= 1'b0;
				regDst <= 1'b0;//写回15-11
				regWrite <= 1'b1;//写回reg
				memToReg <= 1'b0;//内存到reg
				memRead <= 1'b0;//读内存
				memWrite <= 1'b0;//写内存
				branch <= 1'b0;//分支
				jump <= 1'b0;//跳转指令
				aluOp <= 6'b100110;//op的类型
				aluSrc <= 1'b1;//alu计算中第二个操作数的来源
				zeroExt <= 1'b1;//extend方式（zero / sign)
			end
			
			6'b001010:
			begin
				regSrc <= 1'b0;
				regDst <= 1'b0;//写回15-11
				regWrite <= 1'b1;//写回reg
				memToReg <= 1'b0;//内存到reg
				memRead <= 1'b0;//读内存
				memWrite <= 1'b0;//写内存
				branch <= 1'b0;//分支
				jump <= 1'b0;//跳转指令
				aluOp <= 6'b101010;//op的类型
				aluSrc <= 1'b1;//alu计算中第二个操作数的来源
				zeroExt <= 1'b0;//extend方式（zero / sign)
			end
			
			6'b001011:
			begin
				regSrc <= 1'b0;
				regDst <= 1'b0;//写回15-11
				regWrite <= 1'b1;//写回reg
				memToReg <= 1'b0;//内存到reg
				memRead <= 1'b0;//读内存
				memWrite <= 1'b0;//写内存
				branch <= 1'b0;//分支
				jump <= 1'b0;//跳转指令
				aluOp <= 6'b101011;//op的类型
				aluSrc <= 1'b1;//alu计算中第二个操作数的来源
				zeroExt <= 1'b0;//extend方式（zero / sign)
			end
			
			6'b001111:
			begin
				regDst <= 1'b0;//写回15-11（因为是rt所以为0）
				regWrite <= 1'b1;//写回reg
				memToReg <= 1'b0;//内存到reg
				memRead <= 1'b0;//读内存
				memWrite <= 1'b0;//写内存
				branch <= 1'b0;//分支
				jump <= 1'b0;//跳转指令
				aluOp <= 6'b001111;//op的类型
				aluSrc <= 1'b1;//alu计算中第二个操作数的来源(instruction)
			end
		//J
			6'b000010:
			begin
				regDst <= 1'b0;//写回15-11
				regWrite <= 1'b0;//写回reg
				memToReg <= 1'b0;//内存到reg
				memRead <= 1'b0;//读内存
				memWrite <= 1'b0;//写内存
				branch <= 1'b0;//分支
				jump <= 1'b1;//跳转指令
				jumpReg <= 1'b0;
				aluOp <= 6'b001111;//op的类型(任意数都可以，因为不会用到)
			end
		//jal
			6'b000011:
			begin
				regDst <= 1'b0;//写回15-11
				regWrite <= 1'b1;//写回reg
				memToReg <= 1'b0;//内存到reg
				memRead <= 1'b0;//读内存
				memWrite <= 1'b0;//写内存
				branch <= 1'b0;//分支
				jump <= 1'b1;//跳转指令
				jumpReg <= 1'b0;
				aluOp <= 6'b001111;//op的类型(任意数都可以，因为不会用到)
			end
			
			default:
			begin
			    regWrite <= 1'b0;
				memToReg <= 1'b0;
				memRead <= 1'b0;
				memWrite <= 1'b0;
				branch <= 1'b0;
				jump <= 1'b0;
				aluOp <= 6'b001111;//op的类型(任意数都可以，因为不会用到)
			end
			    
		endcase
	end	
endmodule