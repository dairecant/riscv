import riscv_pkg::*;
module ALU 
#(
	parameter ALU_WIDTH=32
)
(
	input 						  clk,
	input 						  rst_n,
	input 						  opcodeValid,
	input  [7-1:0] 			  opcode,
	input  [4-1:0] 			  f3,
	input  [12-1:0]			  imm,
   input [ALU_WIDTH-1:0]	  rs1,
   input [ALU_WIDTH-1:0]	  rs2,		
	output [ALU_WIDTH-1:0]	  aluOut
	
);

	logic [ALU_WIDTH-1 : 0] alu_result_d;
	logic [ALU_WIDTH-1 : 0] alu_result_q;
	
	/***********RV32I ALU Instructions Decodde***************/
	
	//I Type
	parameter ALU_I_OP  = 7'b0010011;
	enum bit[2:0] {ADDI,SLLI,SLTI,SLTIU,XORI,SRLI_SRAI,ORI,ANDI} alu_i_ops;    


	
	/****R Type****/
	parameter ALU_R_OP  = 7'b0110011;	
//	logic [5-1:0] rs2;
	logic [7-1:0] f7;
	
	enum bit[2:0] {ADD_SUB,SLL,SLT, SLTU,XOR,SRL_SRA,OR,AND} alu_r_ops;
	
	//RV32M ALU Instructions
	logic alu_m_op;
	enum bit[2:0] {MUL,MULH,MULHSU,MULHU,DIV,DIVU,REM,REMU} alu_m_ops;    
	
	always_comb
	begin
		if(opcode == ALU_R_OP)
		begin
	//		rs2 =  imm[4:0];
			f7 =   imm[11:5];
		end
		else
		begin
			f7  = '0;
	//		rs2 = '0;
		end
	end
	assign alu_m_op = f7[0];
	




/****************************************************************************/
//Multiplier
/****************************************************************************/
	rs_type rs1SU;
	rs_type rs2SU;
	
	assign rs1SU.rsu = rs1;
	assign rs1SU.rs  = $signed(rs1);
	assign rs2SU.rsu = rs2;
	assign rs2SU.rs  = $signed(rs2);
	
	logic [ALU_WIDTH*2-1:0] mul_res;
	logic [ALU_WIDTH-1 : 0] mulInA, mulInB;
	
	always_comb
	begin
		if(alu_m_op & (opcode == ALU_R_OP))	
		begin
			case(f3)
			{MUL,MULHU}:    
				begin
					mulInA = rs1;
					mulInB = rs2;
				end
			MULH:  
				begin
					mulInA = rs1SU.rs;
					mulInB = rs2SU.rs;
				end			
			MULHSU: 
				begin
					mulInA = rs1SU.rs;
					mulInB = rs2;
				end			   			
			default:
				begin
					mulInA = '0;
					mulInB = '0;
				end
			endcase
		end
		else 
		begin
			mulInA = '0;
			mulInB = '0;		
		end
	end
	assign mul_res = mulInA * mulInB;

/****************************************************************************/
//Divider
/****************************************************************************/
	logic [ALU_WIDTH*2-1:0] div_res;
	logic [ALU_WIDTH-1 : 0] divInA, divInB;

	always_comb
	begin
			if(alu_m_op & (opcode == ALU_R_OP))
			begin
				case(f3)

					DIV:     
						begin
							divInA = rs1SU.rs;
							divInB = rs2SU.rs;							
						end
					DIVU:
						begin
							divInA = rs1;
							divInB = rs2;
						end
					default:
						begin
							divInA = '0;
							divInB = '0;
						end					
				endcase
			end
			else
			begin
				divInA = '0;
				divInB = '0;			
			end
				
		end
	
	assign div_res = divInA / divInB;

/****************************************************************************/
//Remainder
/****************************************************************************/

	logic [ALU_WIDTH-1:0] rem_res;
	logic [ALU_WIDTH-1 : 0] remInA, remInB;

		always_comb
		begin
			if(alu_m_op & (opcode == ALU_R_OP))
			begin
				case(f3)

					REM:     
						begin
							remInA = rs1SU.rs;
							remInB = rs2SU.rs;						
						end
					REMU:
						begin
							remInA = rs1;
							remInB = rs2;
						end
					default:
						begin
							remInA = '0;
							remInB = '0;
						end					
				endcase
			end
			else
			begin
				remInA = '0;
				remInB = '0;
			end			
		end
	
	assign rem_res = remInA % remInB;



/****************************************************************************/
//ALU Output Decode
/****************************************************************************/

always_comb
begin
	if (opcode==ALU_I_OP)
	begin
		case(f3)
			ADDI:      alu_result_d = rs1 + $signed(imm); //overflow ignored	in rv32i		
			SLLI:      alu_result_d = rs1 << imm[4:0];
			SLTI:      alu_result_d = ($signed(imm) > rs1)? 1 : '0; //set rd to 1
			SLTIU:     alu_result_d = (imm > rs1)? 1 : '0;
			XORI:      alu_result_d = rs1 ^ $signed(imm);
			SRLI_SRAI: 
				begin
					if(imm[10]) //shift right arithmetic
					begin
						alu_result_d = rs1 >>> imm[4:0];
					end
					else //shift right logical
					begin
						alu_result_d = rs1 >> imm[4:0];						
					end
				end
			ORI:       alu_result_d = rs1 | $signed(imm);
			ANDI:      alu_result_d = rs1 & $signed(imm);
			default:   alu_result_d = '0;
		endcase
	end
	else if(opcode==ALU_R_OP)
	begin
			if(alu_m_op)
			begin
				case(f3)
					MUL:     alu_result_d = mul_res[ALU_WIDTH-1:0];
					MULH:    alu_result_d = mul_res[ALU_WIDTH*2-1:ALU_WIDTH];
					MULHSU:  alu_result_d = mul_res[ALU_WIDTH*2-1:ALU_WIDTH];
					MULHU:   alu_result_d = mul_res[ALU_WIDTH*2-1:ALU_WIDTH];
					DIV:     alu_result_d = div_res[ALU_WIDTH*2-1:ALU_WIDTH];
					DIVU:    alu_result_d = div_res[ALU_WIDTH*2-1:ALU_WIDTH];
					REM:     alu_result_d = rem_res;
					REMU:    alu_result_d = rem_res;
					default: alu_result_d ='0;
				endcase
			end
			else begin
					case(f3)
						ADD_SUB: 
							begin
								if(f7[5])
								begin
									alu_result_d = rs2 - rs1; //overflow ignored in rv32i
								end
								else
								begin
									alu_result_d = rs1 + rs2; //overflow ignored	in rv32i						
								end
							
							end
						SLL:     alu_result_d = rs1 << rs2;
						SLT:     alu_result_d = ($signed(rs2) > rs1)? 1 : 0;
						SLTU:    alu_result_d = (rs2 > rs1)? 1 : 0;
						XOR:     alu_result_d = rs1 ^ rs2;
						SRL_SRA: 
								begin
									if(f7[5])
									begin
										alu_result_d = rs1 >>> rs2; //arithmetic right shift	
									end
									else
									begin
										alu_result_d = rs1 >> rs2; //logical right shift					
									end
								end
						OR:      alu_result_d = rs1 | rs2;
						AND:     alu_result_d = rs1 & rs2;
						default: alu_result_d = '0;
					endcase
			end			
		end
		else
		begin
			alu_result_d = '0;
		end
	end





	always@(posedge clk or negedge rst_n)
	begin
		if(~rst_n)
		begin
			alu_result_q <= 'd0;
		end
		else 
		begin
			alu_result_q <= alu_result_d;
		end
	end
	
	assign aluOut = alu_result_q;

endmodule