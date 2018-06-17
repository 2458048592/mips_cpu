`timescale 1ns / 1ps
module sccomp_dataflow_tb();
    reg clk,rst;
    wire [31:0] pc,inst,addr;
    sccomp_dataflow sccomp_dataflow_dut(clk,rst,inst,pc,addr);
    integer i;
    reg [31:0] pre_pc;
    integer file_output;
    integer counter=0;
    initial begin
        //$readmemh("E:/vivado_projects/project_33 cpu54/project_33 cpu54.srcs/sources_1/new/test/he.txt", sccomp_dataflow_tb.sccomp_dataflow_dut.imem_dut.inst_mem);
        file_output=$fopen("E:/vivado_projects/project_33 cpu54/project_33 cpu54.srcs/sources_1/new/test/result.txt");
        clk=0;
        rst=0;
        pre_pc = 32'b1;
        #1 rst=1;
        #6 rst=0;
        end
    
    always #5 clk=!clk;
    always@(negedge clk) begin
        //if (sccomp_dataflow_tb.sccomp_dataflow_dut.pc != pre_pc)
        //begin
        //pre_pc = sccomp_dataflow_tb.sccomp_dataflow_dut.pc;
        counter=counter+1;
        for (i = 0; i < 1; i = i + 1)
        begin
        $fdisplay(file_output,"regfile0: %h",sccomp_dataflow_tb.sccomp_dataflow_dut.sccpu.cpu_ref.array_reg[0]);
        $fdisplay(file_output,"regfile1: %h",sccomp_dataflow_tb.sccomp_dataflow_dut.sccpu.cpu_ref.array_reg[1]);
        $fdisplay(file_output,"regfile2: %h",sccomp_dataflow_tb.sccomp_dataflow_dut.sccpu.cpu_ref.array_reg[2]);
        $fdisplay(file_output,"regfile3: %h",sccomp_dataflow_tb.sccomp_dataflow_dut.sccpu.cpu_ref.array_reg[3]);
        $fdisplay(file_output,"regfile4: %h",sccomp_dataflow_tb.sccomp_dataflow_dut.sccpu.cpu_ref.array_reg[4]);
        $fdisplay(file_output,"regfile5: %h",sccomp_dataflow_tb.sccomp_dataflow_dut.sccpu.cpu_ref.array_reg[5]);
        $fdisplay(file_output,"regfile6: %h",sccomp_dataflow_tb.sccomp_dataflow_dut.sccpu.cpu_ref.array_reg[6]);
        $fdisplay(file_output,"regfile7: %h",sccomp_dataflow_tb.sccomp_dataflow_dut.sccpu.cpu_ref.array_reg[7]);
        
        $fdisplay(file_output,"regfile8: %h",sccomp_dataflow_tb.sccomp_dataflow_dut.sccpu.cpu_ref.array_reg[8]);
        $fdisplay(file_output,"regfile9: %h",sccomp_dataflow_tb.sccomp_dataflow_dut.sccpu.cpu_ref.array_reg[9]);
        $fdisplay(file_output,"regfile10: %h",sccomp_dataflow_tb.sccomp_dataflow_dut.sccpu.cpu_ref.array_reg[10]);
        $fdisplay(file_output,"regfile11: %h",sccomp_dataflow_tb.sccomp_dataflow_dut.sccpu.cpu_ref.array_reg[11]);
        $fdisplay(file_output,"regfile12: %h",sccomp_dataflow_tb.sccomp_dataflow_dut.sccpu.cpu_ref.array_reg[12]);
        $fdisplay(file_output,"regfile13: %h",sccomp_dataflow_tb.sccomp_dataflow_dut.sccpu.cpu_ref.array_reg[13]);
        $fdisplay(file_output,"regfile14: %h",sccomp_dataflow_tb.sccomp_dataflow_dut.sccpu.cpu_ref.array_reg[14]);
        $fdisplay(file_output,"regfile15: %h",sccomp_dataflow_tb.sccomp_dataflow_dut.sccpu.cpu_ref.array_reg[15]);
        
        $fdisplay(file_output,"regfile16: %h",sccomp_dataflow_tb.sccomp_dataflow_dut.sccpu.cpu_ref.array_reg[16]);
        $fdisplay(file_output,"regfile17: %h",sccomp_dataflow_tb.sccomp_dataflow_dut.sccpu.cpu_ref.array_reg[17]);
        $fdisplay(file_output,"regfile18: %h",sccomp_dataflow_tb.sccomp_dataflow_dut.sccpu.cpu_ref.array_reg[18]);
        $fdisplay(file_output,"regfile19: %h",sccomp_dataflow_tb.sccomp_dataflow_dut.sccpu.cpu_ref.array_reg[19]);
        $fdisplay(file_output,"regfile20: %h",sccomp_dataflow_tb.sccomp_dataflow_dut.sccpu.cpu_ref.array_reg[20]);
        $fdisplay(file_output,"regfile21: %h",sccomp_dataflow_tb.sccomp_dataflow_dut.sccpu.cpu_ref.array_reg[21]);
        $fdisplay(file_output,"regfile22: %h",sccomp_dataflow_tb.sccomp_dataflow_dut.sccpu.cpu_ref.array_reg[22]);
        $fdisplay(file_output,"regfile23: %h",sccomp_dataflow_tb.sccomp_dataflow_dut.sccpu.cpu_ref.array_reg[23]);
        
        $fdisplay(file_output,"regfile24: %h",sccomp_dataflow_tb.sccomp_dataflow_dut.sccpu.cpu_ref.array_reg[24]);
        $fdisplay(file_output,"regfile25: %h",sccomp_dataflow_tb.sccomp_dataflow_dut.sccpu.cpu_ref.array_reg[25]);
        $fdisplay(file_output,"regfile26: %h",sccomp_dataflow_tb.sccomp_dataflow_dut.sccpu.cpu_ref.array_reg[26]);
        $fdisplay(file_output,"regfile27: %h",sccomp_dataflow_tb.sccomp_dataflow_dut.sccpu.cpu_ref.array_reg[27]);
        $fdisplay(file_output,"regfile28: %h",sccomp_dataflow_tb.sccomp_dataflow_dut.sccpu.cpu_ref.array_reg[28]);
        $fdisplay(file_output,"regfile29: %h",sccomp_dataflow_tb.sccomp_dataflow_dut.sccpu.cpu_ref.array_reg[29]);
        $fdisplay(file_output,"regfile30: %h",sccomp_dataflow_tb.sccomp_dataflow_dut.sccpu.cpu_ref.array_reg[30]);
        $fdisplay(file_output,"regfile31: %h",sccomp_dataflow_tb.sccomp_dataflow_dut.sccpu.cpu_ref.array_reg[31]);  
        
        $fdisplay(file_output,"pc: %h",sccomp_dataflow_tb.sccomp_dataflow_dut.pc);
        $fdisplay(file_output,"instr: %h",sccomp_dataflow_tb.sccomp_dataflow_dut.inst);
        end
        
        end
        //end
    
endmodule
