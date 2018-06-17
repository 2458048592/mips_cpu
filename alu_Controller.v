module alu_Controller(
input [5:0] aluOp,
output reg [4:0] aluc
);
	always @ (*)
	begin
		case(aluOp)
			6'b100000:
				aluc <= 5'b00010;
			6'b100001:
				aluc <= 5'b00000;
			6'b100010:
				aluc <= 5'b00011;
			6'b100011:
				aluc <= 5'b00001;
			6'b100100:
				aluc <= 5'b00100;
			6'b100101:
				aluc <= 5'b00101;
			6'b100110:
				aluc <= 5'b00110;
			6'b100111:
				aluc <= 5'b00111;
			6'b101010:
				aluc <= 5'b01011;
			6'b101011:
				aluc <= 5'b01010;
			6'b000000:
				aluc <= 5'b01111;
			6'b000010:
				aluc <= 5'b01101;
			6'b000011:
				aluc <= 5'b01100;
			6'b000100:
				aluc <= 5'b01111;
			6'b000110:
				aluc <= 5'b01101;
			6'b000111:
				aluc <= 5'b01100;
			6'b001111:
				aluc <= 5'b01000;//100x lui
			6'b011100:
				aluc <= 5'b10000;//clz
			6'b011101:
				aluc <= 5'b10001;//bgez
		endcase
	end
endmodule