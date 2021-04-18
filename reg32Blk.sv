module reg32Blk
	#(
		D_WIDTH=32
	 )
	 (
		input               clk,
		input               rst_n,
		
		input  [4:0]        rs1,
		input  [4:0]        rs2,
		input  [4:0]        rd,
		input                regLd,
		input                regStr,
		input  [D_WIDTH-1:0] WBDat,
		output [D_WIDTH-1:0] rs1Out, 
		output [D_WIDTH-1:0] rs2Out		
	
	);

	
	reg [32-1:0][D_WIDTH-1:0]  regBlk ;
	
	always @(posedge clk or negedge rst_n)
	begin
		if(~rst_n)
		begin
			regBlk <= '0;
		end
		else 
		begin
			if(regStr)
			begin
				regBlk[rd] <= WBDat;
			end
			else if(regLd)
			begin
				rs1Out <= regBlk[rd];
			end
		end
	end

endmodule