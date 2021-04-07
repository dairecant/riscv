module ALU 
#(
	parameter OPCODE_WIDTH=7,
	parameter ALU_WIDTH=32
)
(
	input 						  clk,
	input 						  rst_n,
	input 						  opcodeValid,
	input  [OPCODE_WIDTH-1:0] opcode,
   input [ALU_WIDTH-1:0]	  raIn,
   input [ALU_WIDTH-1:0]	  rbIn,		
	output [ALU_WIDTH-1:0]	  aluOut
	
);

	logic [ALU_WIDTH-1 : 0] alu_result_d;
	logic [ALU_WIDTH-1 : 0] alu_result_q;
	
	
/****************************************************************************/
//Adder
/****************************************************************************/


		logic [ALU_WIDTH-1 : 0] add_carryIn;
		logic [ALU_WIDTH-1 : 0] add_carryOut;
		logic [ALU_WIDTH   : 0] adderOutFull;		
		logic [ALU_WIDTH-1 : 0] adderOut;

		assign adderOutFull = raIn + rbIn + add_carryIn;
		
		

/****************************************************************************/
//Subtractor
/****************************************************************************/


/****************************************************************************/
//Logical ops
/****************************************************************************/

	logic [ALU_WIDTH-1:0] a_or_b;
	logic [ALU_WIDTH-1:0] a_and_b;
	logic [ALU_WIDTH-1:0] a_xor_b;
	
	
	assign a_or_b =  raIn | rbIn;
	assign a_and_b = raIn & rbIn;
	assign a_xor_b = raIn ^ rbIn;

/****************************************************************************/
//Multiplier
/****************************************************************************/


/****************************************************************************/
//Divider
/****************************************************************************/


/****************************************************************************/
//Remainder
/****************************************************************************/



/****************************************************************************/
//Shift Left
/****************************************************************************/




/****************************************************************************/
//Shift Right
/****************************************************************************/




/****************************************************************************/
//ALU Output Decode
/****************************************************************************/
	always_comb
	begin
		case (opcode)
			ALU_ADD:   alu_result_d = add_result;
			ALU_SUB:   alu_result_d = sub_result;
			ALU_AND:   alu_result_d = and_result;
			ALU_OR:    alu_result_d = or_result;
			ALU_XOR:   alu_result_d = xor_result;
			ALU_DIV:   alu_result_d = div_result;
			ALU_REM:   alu_result_d = rem_result;
			ALU_MULH:  alu_result_d = mul_result[ALU_WIDTH*2-1:ALU_WIDTH]; 
			ALU_MULL:  alu_result_d = mul_result[ALU_WIDTH-1:0];  
			ALU_SLT:   alu_result_d = slt_result;
			ALU_SLTU:  alu_result_d = sltu_result;
			ALU_SHL:   alu_result_d = shl_result;
			ALU_SHR:   alu_result_d = shr_result;
			ALU_NPC:   alu_result_d = npc_result;
			ALU_AUIPC: alu_result_d = auipc_result;
			default:   alu_result_d = 'd0;	
		endcase
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
	
	assign WBDat = alu_result_q;

endmodule