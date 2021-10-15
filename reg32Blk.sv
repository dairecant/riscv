module reg32Blk
	#(
		D_WIDTH=32
	 )
	 (
		input                       clk,
		input                       rst_n,
		input  [4:0]                rs1,
		input  [4:0]                rs2,
		input  [4:0]                rd,
		input                       regLd,
		input                       regStr,
		input  logic [D_WIDTH-1:0]  WBDat,
		output logic [D_WIDTH-1:0]  rs1Out, 
		output logic [D_WIDTH-1:0]  rs2Out,
		output logic                outputValid
	
	);

	
	logic [32-1:0] regBlk [D_WIDTH-1:0];
	
	always @(posedge clk or negedge rst_n)
	begin: regStore
		if(~rst_n)
		begin
			regBlk <= '0;
		end
		else 
		begin
			if(regStr & rd!='d0) //x0 always 0
			begin
				regBlk[rd] <= WBDat;
			end
		end
	end

   always @(posedge clk or negedge rst_n)
	begin: regOUT1
		if(~rst_n)
		begin
			rs1Out <= 'd0;
		end
		else 
		begin
		   if(regLd)
			begin
				rs1Out <= regBlk[rs1];
			end
			else
			begin
				rs1Out <= rs1Out;
			end
		end
	end

   always @(posedge clk or negedge rst_n)
	begin: regOUT2
		if(~rst_n)
		begin
			rs2Out <= 'd0;
		end
		else 
		begin
		   if(regLd)
			begin
				rs2Out <= regBlk[rs2];
			end
			else
			begin
				rs2Out <= rs2Out;
			end
		end
	end	

	
endmodule