//import riscv_pkg::*;
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
		output riscVDat,
		output PC pc1,
		output bootOK
	
	);


riscv_pkg::riscVDat  [4:0] /*instr,*/branchVal,raIn,rbIn,rs1Dat,rs2Dat,WBDat;
riscv_pkg::PC        [4:0] pc;
riscv_pkg::Opcode    [4:0] opcode;
riscv_pkg::rdAdr     [4:0] rd;
riscv_pkg::rsAdr     [4:0] rs1,rs2;
riscv_pkg::func3	    [4:0] f3;
riscv_pkg::func7	    [4:0] f7;
riscv_pkg::immediate [4:0] imm;
logic 	 [4:0] ALUinstr,branchValid,regLd,regStr,raSelPC,rbSelImm,loadInstr,storeInstr;
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
		enPulse <= (~en & en_del); // instr stepping
		end
end



IM		  	instr_mem(
					.clk(clk),
					.rst_n(rst_n),
					.PC(pc[0]),
				   .go(enPulse),		
					.we('0),
					.wdata('0),
					.instr(instr)
);

DM		  	data_mem
	(
		.clk(clk),
		.byteEn(),
		.go(enPulse),
		.we(writeStore),
      .imm(imm),
		.rs1(rs1),
		.wdata(writeSrc),
		.loadData(loadData)
	);

IDecode  dec(
					.clk(clk),
					.rst_n(rst_n),
					.go(enPulse),
					.instr(instr),
					.opcode(opcode),
					.rd(rd),
					.f3(f3),
					.f7(f7),
					.rs1(rs1),
					.rs2(rs2),
					.imm(imm),
					.offset(),
					.base(),
					.loadSz(),
					.ALUinstr(ALUinstr),
					.branchInstr(branchValid),
					.loadInstr(loadInstr),
					.storeInstr(storeInstr)
);


PCCU		pCounter(
				.clk(clk),
				.rst_n(rst_n),
				.go(enPulse),
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
end
assign pc1 = pc[0];
endmodule