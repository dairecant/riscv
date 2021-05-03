module IDecode
  #(
		I_WIDTH=32
	)
	(
		input  logic 					clk,
		input  logic 					rst_n,
		input  logic               go,
		input  logic [I_WIDTH-1:0] instruction,
		output logic [6:0]		   opcode,
		output logic [4:0]		   rd,
		output logic [2:0]		   f3,
		output logic [6:0]		   f7,

		output logic [4:0]		   rs1,
		output logic [4:0]		   rs2,
		output logic [19:0]		   imm,
		output logic               ALUinstr,
		output logic               branchInstr,
		output logic               loadInstr,
		output logic               storeInstr	
	);
	

	
	
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
			instr_q <= (go)? instr_d : instr_q;
		end
	end
	
	logic       opcodeValid;
	
	
	//Opcode decode
	
	assign opcode  = (opcodeValid)? instr_q[6:0] : 'd0;

		
	always_comb
	begin
		case(instr_q[6:0])
			{R_TYPE,I_TYPE,S_TYPE,B_TYPE,U_TYPE,J_TYPE} : opcodeValid = 1'b1;
			default: opcodeValid = 1'b0;
		endcase	
	end
	 
	
	
	assign ALUinstr    =  (instr_q[6:0]==ALUTypeI  ) |  (instr_q[6:0]==ALUTypeR);
	assign loadInstr   =  (instr_q[6:0]==loadType  ); 
	assign storeInstr  =  (instr_q[6:0]==storeType ); 
	assign branchInstr =   instr_q[6:0]==branchType ;
	
	bit R_TYPE,I_TYPE,S_TYPE,B_TYPE,U_TYPE,J_TYPE;
	
	assign	R_TYPE  = (instr_q[6:0]==ALUTypeR); 
	assign	I_TYPE  = (instr_q[6:0]==ALUTypeI) | loadInstr | (instr_q[6:0]==7'b1100111) ; 
	assign	S_TYPE  = storeInstr; 
	assign	B_TYPE  = branchInstr; 
	assign	U_TYPE  = (instr_q[6:0]==7'b0x100111); 
	assign	J_TYPE  = (instr_q[6:0]==7'b1101111);	
	
	
	//RD Decode
	assign rd = (~(S_TYPE | B_TYPE))? instr_q[11:7] : 'd0;
	
	
	//f3 Decode
	logic  f3Avail;
	
	assign f3Avail =   (R_TYPE | I_TYPE | S_TYPE | B_TYPE); 
	assign f3      =   (f3Avail) ? instr_q[14:12]   : 'd0; //R,I,S,B type
	


	//f7 Decode 
	logic  f7Avail;
	assign f7Avail = R_TYPE;
	assign f7      = (f7Avail)? instr_q[31:25] : 'd0;
	
	//RS1 Decode
	logic  rs1Avail;
	assign rs1Avail = f3Avail; 
	assign rs1      = (rs1Avail )? instr_q[19:15]   : 'd0; //R,I,S,B type

	//RS2 Decode
	logic  rs2Avail;
	
	assign rs2Avail = opcodeValid & (R_TYPE | S_TYPE | B_TYPE);
	assign rs2      = (rs2Avail)?           instr_q[24:20] : 'd0;  //R,S,B
	
	
	
	//Imm Decode
	logic imm12,imm20;
	always_comb
	begin
		case (instr_q[6:0])
			ALUTypeR:
						begin
							imm12 = 1'b1;
							imm20 = 1'b0;
							imm   = {'0,{instr_q[31:20]}};
						end
			storeType:
						begin
							imm12 = 1'b1;
							imm20 = 1'b0;
							imm   = {'0,instr_q[31:25],instr_q[11:7]};
						end			
			branchType:
						begin
							imm12 = 1'b1;
							imm20 = 1'b0;
							
							imm   = {'0,instr_q[31],instr_q[7],instr_q[30:25],instr_q[11:8]};
						end	
			7'b0x100111: //u type
						begin
							imm12 = 1'b0;
							imm20 = 1'b1;
							imm   = {instr_q[31:12]};
						
						end
			7'b1101111: //j type
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