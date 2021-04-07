module IDecode
  #(
		I_WIDTH=32
	)
	(
		input  logic 					clk,
		input  logic 					rst_n,
		input  logic               loadInstr,
		input  logic [I_WIDTH-1:0] instruction,
		output logic [6:0]		   opcode,
		output logic [4:0]		   rd,
		output logic [2:0]		   f3,
		output logic [4:0]		   rs1,
		output logic [4:0]		   rs2,
		output logic [11:0]		   imm,
		output logic [6:0]		   imm,
		output logic               ALUinstr,
		output logic               branchValid,
		output logic               memWr,
		output logic               memRd,
		output logic               regLd,
		output logic               regStr		
	);
	
	parameter	R_TYPE  = 7'b0110011; 
	parameter	I_TYPE  = 7'b0010011; 
	parameter	S_TYPE  = 7'b0100011; 
	parameter	SB_TYPE = 7'b1100011; 
	parameter	U_TYPE  = 7'b0110011; 
	parameter	UB_TYPE = 7'b0110011;
	
	logic [I_WIDTH-1:0] instr_d, instr_q;


	assign instr_d = instruction;
	//registered instruction
	always @ (posedge clk or negedge rst_n)
	begin
		if(~rst_n)
		begin
			instr_q <= 'd0;
		end
		else
		begin
			instr_q <= (loadInstr)? instr_d <= instr_q;
		end
	end
	
	logic       opcodeValid;
	
	
	//Opcode decode
	always_comb
	begin
		case(instr_q[6:0])
			R_TYPE,I_TYPE,S_TYPE,SB_TYPE,UB_TYP} : opcodeValid = 1'b1;
			default: opcodeValid = 1'b0;
		endcase	
	end
	 
	assign opcode = (opcodeValid)? instr_q[6:0] : 'd0;
	
	
	//RD Decode
	assign rd = (opcodeValid)? instr_q[11:7] : 'd0;
	
	
	//f3 Decode
	assign f3 = (opcodeValid)? instr_q[14:12] : 'd0; //R,I,S,B type
	
	
	//RS1 Decode
	assign rs1 = (opcodeValid & )? instr_q[19:15] : 'd0; //R,I,S,B type

	//RS2 Decode
	assign rs2 = (opcodeValid)? instr_q[24:20] : 'd0;  //R,S,B
	
	//Imm Decode
	/***********DIFFEREING LENGTHS*******************************/
	
	
	endmodule