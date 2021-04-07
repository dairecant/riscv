/*******************************************************************/
// RISC-V Project
//		  Program Counter Module
// 	  Author: Dáire Canavan
//		  Date:   05/04/2021
/*******************************************************************/


module PCCU #(
	parameter PC_WIDTH=32
)
(
	input  logic 					 clk,
	input  logic 					 rst_n,
	input  logic 					 selPCsrc,
	input  logic [PC_WIDTH-1:0] branchIn,
	output logic [PC_WIDTH-1:0] PC
);

	reg  [PC_WIDTH-1:0] nextPC;
	wire [PC_WIDTH-1:0] PCAdd4;  
	
	
	always_comb
	begin
		if(selPCsrc)
			begin
				nextPC = branchIn;
			end 
		else
			begin
				nextPC = PCAdd4;
			end	
	end

	assign PCAdd4 = PC + 'd4;

	always @ (posedge clk or negedge rst_n)
	begin
		if(~rst_n)
			begin
				PC <= '0;		
			end 
		else 
			begin
				PC <= nextPC;
			end	
	end
	
	
endmodule