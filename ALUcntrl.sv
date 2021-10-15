module ALUcntrl

(
	input                          clk,
	input                          rst_n,
	input  logic [6:0]             opcode,
	input  logic [2:0]             f3,
	input  logic [6:0]             f7,
	input  logic [19:0]            imm,
	input  logic [I_WIDTH-1:0]     rs1In,
	input  logic [I_WIDTH-1:0]     rs2In,
	
	output logic [I_WIDTH-1:0]     d1In,
	output logic [I_WIDTH-1:0]     d2In,
	output logic [3:0]             alu_op   ,
	output logic [6:0]             subop

);
 
enum bit [3:0] {ALU_ADD,ALU_SUB,ALU_SLL,ALU_SLT,ALU_SLTU,ALU_XOR,ALU_SRL,ALU_SRA,ALU_OR,ALU_AND,ALU_BEQ,ALU_BNEQ,ALU_BLT,ALU_BGE,ALU_BLTU,ALU_BGEU} ops;
enum bit [2:0] {F3ADD_SUB,f3_SLL,F3_SLT,F3_SLTU,XOR,F3_SRL_A,F3_OR,F3_AND} f3_ops;

always_comb
begin : op_decode
	case(opcode)
		{R_TYPE,I_TYPE}:
			begin
				case(f3)
					F3ADD_SUB:
						alu_op = ((f7==7'b0100000) & (opcode==R_TYPE))? ops.ALU_SUB : ops.ALU_ADD;
					f3_SLL:
						alu_op = ops.ALU_SLL;
					F3_SLT:
						alu_op = ops.ALU_SLT;
					F3_SLTU:
						alu_op = ops.ALU_SLTU;					
					F3_XOR:
						alu_op = ops.ALU_XOR;					
					F3_SRL_A:
						alu_op = (f7==7'b0100000)? ops.ALU_SRA : ops.ALU_SRL;
					F3_OR:
						alu_op = op.ALU_OR;
					F3_AND:
						alu_op = ops.ALU_AND;
					default:
						alu_op = 'd0;
				endcase
			end
		B_TYPE:
							alu_op = 'd0;
		{S_TYPE,L_TYPE}:
				op = ALU_ADD;
	default:
		alu_op = '0;
	 endcase
		

end


endmodule