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
		output logic [6:0]		   f7,

		output logic [4:0]		   rs1,
		output logic [4:0]		   rs2,
		output logic [19:0]		   imm,
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
	parameter	B_TYPE  = 7'b1100011; 
	parameter	U_TYPE  = 7'b0110011; 
	parameter	J_TYPE  = 7'b0110011;
	
	
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
			instr_q <= (loadInstr)? instr_d : instr_q;
		end
	end
	
	logic       opcodeValid;
	
	
	//Opcode decode
	logic r_type,i_type,s_type,b_type_u_tpe,j_type;
	always_comb
	begin
		case(instr_q[6:0])
			{R_TYPE,I_TYPE,S_TYPE,B_TYPE,U_TYPE,J_TYPE} : opcodeValid = 1'b1;
			default: opcodeValid = 1'b0;
		endcase	
	end
	 
	assign opcode  = (opcodeValid)? instr_q[6:0] : 'd0;
	assign r_type  = instr_q[6:0] == R_TYPE;
	assign i_type  = instr_q[6:0] == I_TYPE;
	assign s_type  = instr_q[6:0] == S_TYPE;
	assign b_type  = instr_q[6:0] == B_TYPE;
	assign u_type  = instr_q[6:0] == U_TYPE;
	assign j_type  = instr_q[6:0] == J_TYPE;
	
	
	//RD Decode
	assign rd = (~(s_type | b_type))? instr_q[11:7] : 'd0;
	
	
	//f3 Decode
	logic  f3Avail;
	
	assign f3Avail =   opcodeValid & (r_type | i_type | s_type | b_type); 
	assign f3      =  (opcodeValid & 
	
	
	(r_type | i_type | s_type | b_type) )? instr_q[14:12]   : 'd0; //R,I,S,B type
	


	//f7 Decode 
	logic  f7Avail;
	assign f7Avail = r_type;
	assign f7      = (f7Avail)? instr_q[31:25] : 'd0;
	
	//RS1 Decode
	logic  rs1Avail;
	assign rs1Avail = f3Avail; 
	assign rs1      = (rs1Avail )? instr_q[19:15]   : 'd0; //R,I,S,B type

	//RS2 Decode
	logic  rs2Avail;
	
	assign rs2Avail = opcodeValid & (r_type | s_type | b_type);
	assign rs2      = (rs2Avail)?           instr_q[24:20] : 'd0;  //R,S,B
	
	
	
	//Imm Decode
	logic imm12,imm20;
	always_comb
	begin
		case (instr_q)
			I_TYPE:
						begin
							imm12 = 1'b1;
							imm20 = 1'b0;
							imm   = {'0,{instr_q[31:20]}};
						end
			S_TYPE:
						begin
							imm12 = 1'b1;
							imm20 = 1'b0;
							imm   = {'0,instr_q[31:25],instr_q[11:7]};
						end			
			B_TYPE:
						begin
							imm12 = 1'b1;
							imm20 = 1'b0;
							
							imm   = {'0,instr_q[31],instr_q[7],instr_q[30:25],instr_q[11:8]};
						end	
			U_TYPE:
						begin
							imm12 = 1'b0;
							imm20 = 1'b1;
							imm   = {instr_q[31:12]};
						
						end
			J_TYPE:
						begin			
							imm12 = 1'b0;
							imm20 = 1'b1;
							imm   = {instr_q[31],instr_q[19:12],instr_q[20],instr_q[30:21]};	
						end
			default: imm = '0;
			
		endcase
	end
	/***********DIFFERING LENGTHS*******************************/
	
	
	endmodule