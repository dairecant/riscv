module IDecode
  #(
		I_WIDTH=32
	)
	(
		input  logic 					clk,
		input  logic 					rst_n,
		input  logic               go,
		input  instr_type          instr,
		output logic [4:0]		   rd,
		output logic [2:0]		   f3,
		output logic [6:0]		   f7,
		output logic [4:0]		   rs1,
		output logic [4:0]		   rs2,
		output logic [I_WIDTH:0]	imm,
		output logic [11:0]        offset,
		output logic [4:0]         base,
		output logic [2:0]         loadSz,
		output logic               ALUinstr,
		output logic               branchInstr,
		output logic               loadInstr,
		output logic               storeInstr,
	   output logic               jumpInstr	
	);
	

	
	
	logic [I_WIDTH-1:0] instr_d, instr_q;
	logic [7:0] instr_fmt;

	assign instr_d = instr;
	//registered instr
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
	
	


		
	always_comb
	begin
		case(instr_q[6:0])
			{R_TYPE,I_TYPE,S_TYPE,B_TYPE,U_TYPE,J_TYPE} : opcodeValid = 1'b1;
			default: opcodeValid = 1'b0;
		endcase	
	end
	
	
	always_comb
	begin: instr_fmt_decode
		case(instr_q[6:0]) //decode instr format one-hot
			R_TYPE:
				begin
					instr_fmt = 8'b00000001;
				end
			I_TYPE:
				begin
					instr_fmt = 8'b00000010;
				end				
			S_TYPE:
				begin
					instr_fmt = 8'b00000100;
				end
			B_TYPE:
				begin
					instr_fmt = 8'b00001000;			
				end	
			U_TYPE:
				begin
					instr_fmt = 8'b00010000;			
				end
			J_TYPE:
				begin
					instr_fmt = 8'b00100000;				
				end
			FENCE:
				begin
					instr_fmt = 8'b01000000;
				end
			E_TYPE:
				begin
					instr_fmt = 8'b10000000;
				end
			default:
					instr_fmt = 8'b00000000;					
		endcase	
	end
	
	always_comb
	begin: instr_decode
			case(instr_q[6:0]) //decode instr format one-hot
			R_TYPE:
				begin
					imm    = '0;
					rs1    = instr.data[12:8];
					rs2    = instr.data[17:13];
					rd     = instr.data[4:0];
					f3     = instr.data[7:5];
					f7     = instr.data[24:18];
					ALUinstr = 1'b1;
				end
			I_TYPE:
				begin
					imm = {instr.data[24],instr.data[23:18],instr.data[17:14],instr.data[13]};				
					rs1 = instr.data[12:8];
					rd  = instr.data[4:0];
					f3  = instr.data[7:5];
					rs2 = '0;
					f7  = '0;
					ALUinstr = 1'b1;
					
				end				
			S_TYPE:
				begin
					imm = {instr.data[24],instr.data[23:18],instr.data[4:1],instr.data[0]};				
					rs1 = instr.data[12:8];
					rs2 = instr.data[17:13];
					f3  = instr.data[7:5];
					f7  = '0;
					ALUinstr = 1'b1;

				end
			B_TYPE:
				begin
					imm = {instr.data[24],instr.data[0],instr.data[23:18],instr.data[4:1],1'b0};								
					rs1 = instr.data[12:8];
					rs2 = instr.data[17:13];
					f3  = instr.data[7:5];
					f7  = '0;
					ALUinstr = 1'b1;
				end	
			U_TYPE:
				begin
					imm = {instr.data[24],instr.data[23:13],instr.data[12:5],12'b0};												
					rd  = instr.data[4:0];
					rs2 = '0;
					rs1 = '0;
					f7  = '0;
					ALUinstr = 1'b0;			
					
				end
			J_TYPE:
				begin
					imm = {instr.data[24],instr.data[12:5],instr.data[13],instr.data[23:18],instr.data[17:14],1'b0};												
					rd  = instr.data[4:0];
					rs1 = '0;
					rs2 = '0;
					f3  = '0;
					ALUinstr = 1'b1;
					f7  = '0;
				
				end
			FENCE:
				begin
					imm = '0;	
					rd  = '0;
					rs1 = '0;
					rs2 = '0;
					f3  = '0;
					f7  = '0;		
					ALUinstr = 1'b0;			
				end
			E_TYPE:
				begin
					imm = '0;
					rd  = '0;
					rs1 = '0;
					rs2 = '0;
					f3  = '0;
					f7  = '0;					
					ALUinstr = 1'b0;			
					end
			default:
				begin
					imm = '0;
					rd  = '0;
					rs1 = '0;
					rs2 = '0;
					f3  = '0;
					f7  = '0;					
					ALUinstr = 1'b0;	
				end
			endcase		
	end

	
	/*
	assign ALUinstr    =  (instr_q.opcode==ALUTypeI  ) |  (instr_q[6:0]==ALUTypeR);
	assign loadInstr   =  (instr_q.opcode==loadType  ); 
	assign storeInstr  =  (instr_q.opcode==storeType ); 
	assign branchInstr =   instr_q.opcode==branchType ;
	assign jumpInstr   =   instr_q.opcode==jumpType ;

	
	bit R_TYPE,I_TYPE,S_TYPE,B_TYPE,U_TYPE,J_TYPE;
	
	assign	R_TYPE  = (instr_q.opcode==ALUTypeR); 
	assign	I_TYPE  = (instr_q.opcode==ALUTypeI) | loadInstr | (instr_q[6:0]==7'b1100111) ; 
	assign	S_TYPE  = storeInstr; 
	assign	B_TYPE  = branchInstr; 
	assign	U_TYPE  = (instr_q.opcode==7'b0x100111); 
	assign	J_TYPE  = (instr_q.opcode==7'b1101111);	
	
	
	//RD Decode
	assign rd = (~(S_TYPE | B_TYPE | loadInstr ))? instr_q[11:7] : 'd0;
	
	
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
		case (instr_q.opcode)
			ALUTypeR:
						begin
							imm12 = 1'b1;
							imm20 = 1'b0;
							imm   = {'0,{instr_q[31:20]}};
							loadSz = '0;
							offset = '0;
							base   = '0;
					end
			loadType:
						begin
							imm12 = 1'b1;
							imm20 = 1'b0;
							imm    = {'0,instr_q[31:25],instr_q[11:7]};
							loadSz = instr_q[14:12]; //load word etc.
							offset = instr_q[31:20];
							base   = instr_q[19:15];
						end							
			storeType:
						begin
							imm12 = 1'b1;
							imm20 = 1'b0;
							imm   = {'0,instr_q[31:25],instr_q[11:7]};
							loadSz = '0;
							offset = '0;
							base   = '0;							
						end			
			branchType:
						begin
							imm12 = 1'b1;
							imm20 = 1'b0;					
							imm   = {'0,instr_q[31],instr_q[7],instr_q[30:25],instr_q[11:8]};
							loadSz = '0;
							offset = '0;
							base   = '0;							
						end	
			7'b0x100111: //u type
						begin
							imm12 = 1'b0;
							imm20 = 1'b1;
							imm   = {instr_q[31:12]};
							loadSz = '0;
							offset = '0;
							base   = '0;													
						end
			7'b1101111: //j type
						begin			
							imm12 = 1'b0;
							imm20 = 1'b1;
							imm   = {instr_q[31],instr_q[19:12],instr_q[20],instr_q[30:21]};
							loadSz = '0;
							offset = '0;
							base   = '0;							
						end
			default:
						begin
							imm    = '0;
							imm12  = 1'b0;
							imm20  = 1'b0;							
							loadSz = '0;
							offset = '0;
							base   = '0;						
						end
		endcase
	end
	/***********DIFFERING LENGTHS*******************************/
	
	
	endmodule