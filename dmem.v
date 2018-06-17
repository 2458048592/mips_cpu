`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/04/25 21:15:24
// Design Name: 
// Module Name: dmem
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
module dmem (
input clk, //存储器时钟信号，下降沿时向 ram 内部写入数据
input memRead, 
input memWrite, 
input [1:0] lsHB,
input lU,
input [10:0] addr,
input [31:0] Writedata, 
output reg [31:0] Readdata);

    wire [8:0] addr_in = addr[10:2];
    reg [31:0] ram_data[2047:0];
	
	always @ (*)
	begin
		if (memRead)
		begin
			case(lsHB)
				2'b00:
					Readdata <= ram_data[addr_in];
				2'b01:
					case(addr[1:0])
                        2'b00:
                            Readdata <= (lU ? {24'b0, ram_data[addr_in][7:0]} : {{24{ram_data[addr_in][7]}}, ram_data[addr_in][7:0]});
                        2'b01:
                            Readdata <= (lU ? {24'b0, ram_data[addr_in][15:8]} : {{24{ram_data[addr_in][15]}}, ram_data[addr_in][15:8]});
                        2'b10:
                            Readdata <= (lU ? {24'b0, ram_data[addr_in][23:16]} : {{24{ram_data[addr_in][23]}}, ram_data[addr_in][23:16]});
                        2'b11:
                            Readdata <= (lU ? {24'b0, ram_data[addr_in][31:24]} : {{24{ram_data[addr_in][31]}}, ram_data[addr_in][31:24]});
					endcase
				2'b10:
				begin
					case(addr[1:0])
						2'b00:
							Readdata <= (lU ? {16'b0, ram_data[addr_in][15:0]} : {{16{ram_data[addr_in][15]}}, ram_data[addr_in][15:0]});
						2'b10:
							Readdata <= (lU ? {16'b0, ram_data[addr_in][31:16]} : {{16{ram_data[addr_in][31]}}, ram_data[addr_in][31:16]});
					endcase
				end
			endcase
		end
		else
			Readdata <= {32{1'bz}};
	end
	
	
    always @ (negedge clk)
    begin
        if(memWrite)
        begin
            case(lsHB)
                2'b00:
                    ram_data[addr_in] <= Writedata;
                2'b01:
				begin
                    case(addr[1:0])
                        2'b00:
                            ram_data[addr_in][7:0] <= Writedata[7:0];
                        2'b01:
                            ram_data[addr_in][15:8] <= Writedata[7:0];
                        2'b10:
                            ram_data[addr_in][23:16] <= Writedata[7:0];
                        2'b11:
                            ram_data[addr_in][31:24] <= Writedata[7:0];
					endcase
				end
                2'b10:
				begin
					case(addr[1:0])
						2'b00:
							ram_data[addr_in][15:0] <= Writedata[15:0];
						2'b10:
							ram_data[addr_in][31:16] <= Writedata[15:0];
					endcase
				end
            endcase
        end
    end
endmodule
