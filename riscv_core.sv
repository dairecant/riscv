module riscv_core

#(		parameter I_WIDTH=32,
		parameter IMEM_SZ=2**15,
		parameter PC_WIDTH=I_WIDTH,
		parameter D_WIDTH=32,
		parameter ALU_WIDTH=32
	)(
		input clk,
		input rst_n,
		input en,
		output riscVDat instruction,
		output PC pc1
	
	);


riscVDat  [4:0] /*instruction,*/branchVal,raIn,rbIn,rs1Dat,rs2Dat,WBDat;
PC        [4:0] pc;
Opcode    [4:0] opcode;
rdAdr     [4:0] rd;
rsAdr     [4:0] rs1,rs2;
func3	    [4:0] f3;
func7	    [4:0] f7;
immediate [4:0] imm;
logic 	 [4:0] ALUinstr,branchValid,regLd,regStr,raSelPC,rbSelImm;
reg en_del,enPulse;

always @ (posedge clk or negedge rst_n)
begin
	if(~rst_n)
	begin
		en_del  <= '0;
		enPulse <= '0; 
	end
	else
		begin
		en_del  <= en;
		enPulse <= (~en & en_del); // instruction stepping
		end
end



IM		  	instr_mem(
					.clk(clk),
					.rst_n(rst_n),
					.PC(pc[0]),
				   .go(enPulse),		
					.we('0),
					.wdata('0),
					.instruction(instruction)
);



PCCU		pCounter(
				.clk(clk),
				.rst_n(rst_n),
				.go(enPulse),
				.selPCsrc(1'b0),
				.branchIn(branchVal),
				.PC(pc)
);

/*
IDecode  dec(
					.clk(clk),
					.rst_n(rst_n),
					.loadInstr(enPulse),
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


reg32Blk cache(
				.clk(clk),
				.rst_n(rst_n),
				.regLd(regLd),				
				.regStr(regStr),
				.WBDat(WBDat),
				.rs1Out(rs1Dat), 
				.rs2Out(rs2Dat),
				.outputValid(regRdy)
);



assign raIn = (raSelPC)?  pc  : rs1Dat;
assign rbIn = (rbSelImm)? imm : rs2Dat;

ALU	   alu(
				.clk(clk),
				.rst_n(rst_n),
				.opcodeValid(regRdy),
				.f3(f3),
				.opcode(opcode),
				.imm(imm[0][11:0]),
				.rs1(raIn),
				.rs2(rbIn),	
				.aluOut(aluOut)
);

assign WBDat = aluOut;
always @ (posedge clk or negedge rst_n)
begin
	bootOK <= 	ALUinstr | branchValid | regLd | regStr ;
end*/
assign pc1 = pc[0];
endmodule