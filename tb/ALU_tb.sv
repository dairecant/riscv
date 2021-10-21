`timescale 1ns / 1ps
import riscv_pkg::*;


module ALU_tb_tb();
	
	
	parameter ALU_WIDTH=32;
	parameter D_WIDTH = 32;
	parameter FREQ            = 64'd50000000;
	parameter PERIOD          = 20;
	parameter CLK_HALF_PERIOD = (PERIOD/2);
	
	
	logic 						  clk_tb;
	logic 						  rst_n_tb;
	logic 						  opcodeValid_tb;
	logic  [7-1:0] 			  opcode_tb;
	func3                     f3_tb;
	logic  [12-1:0]			  imm_tb;
   logic [ALU_WIDTH-1:0]	  rs1_tb;
   logic [ALU_WIDTH-1:0]	  rs2_tb;		
	logic [ALU_WIDTH-1:0]	  aluOut_tb,aluOutExp;
	integer error;
	func7                     f7_tb;
ALU dut
(
	.clk(clk_tb),
	.rst_n(rst_n_tb),
	.opcodeValid(opcodeValid_tb),
	.opcode(opcode_tb),
	.f3(f3_tb),
	.imm(imm_tb),
   .rs1(rs1_tb),
   .rs2(rs2_tb),		
	.aluOut(aluOut_tb)
	
);

	initial 
	begin
		clk_tb = 1'b0;
		forever
		begin
			#CLK_HALF_PERIOD clk_tb = ~clk_tb;
		end
	end

	initial begin
		$display("START ALU TEST");
		// zero all signals
		rst_n_tb       = 'd0;
		opcodeValid_tb = 'd0;
		opcode_tb      = 'd0;
		f3_tb          = 'd0;
		imm_tb         = 'd0;
		rs1_tb         = 'd0;
		rs2_tb         = 'd0;		
		aluOutExp      = 'd0;
		error          = 'd0;
		
		/***TEST LOGIC *****/
		
		#(10*PERIOD);
		rst_n_tb       = 'd1;
		opcode_tb      = I_TYPE;
		opcodeValid_tb = 'd1;

		#(10*PERIOD);
		imm_tb         = 'haaaaaaaa;
		rs1_tb         = 'h11111111;
			
			
		$display("/********************************Immediate / RS1 ALU Instructions*******************************/");
		$display("%t: ADDI",$time);
		f3_tb          = ADDI;
		aluOutExp      = rs1_tb + $signed(imm_tb);
		#(PERIOD);
		checkOutput();

		$display("%t: SLLI",$time);
		f3_tb          = SLLI;
		aluOutExp      = $signed(rs1_tb) << imm_tb[4:0];
		#(PERIOD);
		#(PERIOD);
		checkOutput();

		$display("%t: SLTI",$time);
		f3_tb          = SLTI;
		aluOutExp      = $signed(rs1_tb) < $signed(imm_tb);
		#(PERIOD);
		checkOutput();
	
		$display("%t: SLTIU",$time);	
		f3_tb          = SLTIU;
		aluOutExp      = rs1_tb < imm_tb;
		#(PERIOD);
		checkOutput();
	
		$display("%t: ANDI",$time);	
		f3_tb          = ANDI;
		aluOutExp      = rs1_tb & imm_tb;
		#(PERIOD);
		checkOutput();
		
		$display("%t: XORI",$time);
		f3_tb          = XORI;
		aluOutExp      = rs1_tb ^ imm_tb;
		#(PERIOD);
		checkOutput();
	
		$display("%t: ORI",$time);
		f3_tb          = ORI;
		aluOutExp      = rs1_tb | imm_tb;
		#(PERIOD);
		checkOutput();

		$display("%t: SRA",$time);
		f3_tb          = SRLI_SRAI;
		imm_tb[10]     = 1'b1;
		aluOutExp      = rs1_tb >>> imm_tb[4:0];
		#(PERIOD);
		checkOutput();

		$display("%t: SRL",$time);
		f3_tb          = SRLI_SRAI;
		imm_tb[10]     = 1'b0;
		aluOutExp      = rs1_tb >> imm_tb[4:0];
		#(PERIOD);
		checkOutput();
		
		opcodeValid_tb = 'd0;
		#(10*PERIOD);
		opcode_tb      = R_TYPE;
		opcodeValid_tb = 'd1;

		#(10*PERIOD);
		rs2_tb         = 'haaaaaaaa;
		rs1_tb         = 'h11111111;
			
		$display("/********************************Register / RS1 ALU Instructions*******************************/");
		$display("%t: ADD",$time);
		f3_tb          = ADD_SUB;
		f7_tb          = 'b0000000;
		imm_tb         = {f7_tb,'d0};
		aluOutExp      = rs1_tb + rs2_tb;
      @(posedge clk_tb);
		#1;
		checkOutput();

		$display("%t: SUB",$time);
		f3_tb          = ADD_SUB;
		f7_tb          = 'b0100000;
		imm_tb         = {f7_tb,5'd0};
		aluOutExp      = rs1_tb - rs2_tb;
      @(posedge clk_tb);
		#1;
		checkOutput();
		
		$display("%t: SLL",$time);
		f3_tb          = SLL;
		imm_tb         = 'd0;
		aluOutExp      = $signed(rs1_tb) << rs2_tb[4:0];
      @(posedge clk_tb);
		#1;
		checkOutput();

		$display("%t: SLT",$time);
		f3_tb          = SLT;
		f7_tb          = 'b0100000;
		imm_tb         = {f7_tb,5'd0};		
		aluOutExp      = $signed(rs1_tb) < $signed(rs2_tb);
      @(posedge clk_tb);
		#1;		
		checkOutput();
	
		$display("%t: SLTU",$time);	
		f3_tb          = SLTU;
		aluOutExp      = rs1_tb < rs2_tb;
      @(posedge clk_tb);
		#1;
		checkOutput();
	
		$display("%t: AND",$time);	
		f3_tb          = AND;
		aluOutExp      = rs1_tb & rs2_tb;
      @(posedge clk_tb);
		#1;
		checkOutput();
		
		$display("%t: XOR",$time);
		f3_tb          = XOR;
		aluOutExp      = rs1_tb ^ rs2_tb;
      @(posedge clk_tb);
		#1;
		checkOutput();
	
		$display("%t: OR",$time);
		f3_tb          = OR;
		aluOutExp      = rs1_tb | rs2_tb;
      @(posedge clk_tb);
		#1;
		checkOutput();

		#2;
		$display("%t: SRL",$time);
		f3_tb          = SRL_SRA;
		f7_tb          = 'b0000000;
		imm_tb         = {f7_tb,'d0};
		aluOutExp      = rs1_tb >> rs2_tb[4:0];
      @(posedge clk_tb);
		#1;
		checkOutput();

		#2;
		$display("%t: SRA",$time);
		f3_tb          = SRL_SRA;
		f7_tb          = 'b0100000;
		imm_tb         = {f7_tb,'d0};
		aluOutExp      = rs1_tb >>> rs2_tb[4:0];
      @(posedge clk_tb);
		#1;
		checkOutput();	
		/******************/
		//Finish Test
		
		if(error==0)
		 begin
			$display("%t TEST PASSED",$time);
		 end
		 else begin
			$fatal("%t TEST FAILED: $ Errors.",$time,error);
		 end		
		 $stop;
		
		
	end

	function checkOutput();
		begin
			if(aluOut_tb != aluOutExp)
			begin
				$error("%t ERROR: ALU Output does not match expected output --> expected: %x actual %x",$time,aluOutExp,aluOut_tb);
				error = error +1;
			end
         else
			begin
				$display("%t  ALU Output --> expected: %x rs1 actual %x",$time,aluOutExp,aluOut_tb);
			end
		end
	endfunction
endmodule
