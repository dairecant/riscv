module riscv_core

#(		parameter I_WIDTH=32,
		parameter IMEM_SZ=2**32,
		parameter PC_WIDTH=I_WIDTH,
		parameter D_WIDTH=32,
		parameter ALU_WIDTH=32
	)(
		input clk,
		input rst_n,
		output reg bootOK
	
	);


logic [I_WIDTH-1:0] instruction,branchVal,raIn,rbIn,WBDat;
typedef logic [4-1:0]   f3;
logic [PC_WIDTH-1:0]    pc;
logic [6:0]             opcode;
logic 				      ALUinstr,branchValid,regLd,regStr,raSelPC,rbSelImm;
logic [4:0]		         rd,rs1,rs2;
logic [4-1:0]		      f3;
logic [6:0]		         f7;
logic [19:0]		      imm;
	
IDecode  dec(
					.clk(clk),
					.rst_n(rst_n),
					.loadInstr(),
					.instruction(instruction),
					.opcode(opcode),
					.rd(rd),
					.f3(f3),
					.f7(f7),
					.rs1(rs1),
					.rs2(rs2),
					.imm(imm),
					.ALUinstr(ALUinstr),
					.branchValid(branchValid),
					.memWr(memWr),
					.memRd(memRd),
					.regLd(regLd),
					.regStr(regStr)	
);


IM		  	instr_mem(
					.clk(clk),
					.rst_n(rst_n),
					.PC(pc),
					.instruction(instruction)
);



PCCU		pCounter(
				.clk(clk),
				.rst_n(rst_n),
				.selPCsrc(1'b0),
				.branchIn(branchVal),
				.PC(pc)
);

reg32Blk cache(
				.clk(clk),
				.rst_n(rst_n),
				.regLd(regLd),				
				.regStr(regStr),
				.WBDat(WBDat),
				.rs1Out(rs1), 
				.rs2Out(rs2)
				.outputValid(regRdy)
);



assign raIn = (raSelPC)?  pc  : rs1;
assign rbIn = (rbSelImm)? imm : rs2;

ALU	   alu(
				.clk(clk),
				.rst_n(rst_n),
				.opcodeValid(regRdy),
				.f3(f3),
				.opcode(opcode),
				.imm(imm[11:0]),
				.rs1(raIn),
				.rs2(rbIn),	
				.aluOut(aluOut)
);

always @ (posedge clk or negedge rst_n)
begin
	bootOK <= 	ALUinstr | branchValid | regLd | regStr ;
end
endmodule