module IM 
	#(
		parameter I_WIDTH=32,
		parameter IMEM_SIZE=2**32, //size in bytes
		parameter PC_WIDTH=32
	)
	(
		input  logic                clk,
		input  logic                rst_n,
		input  logic [PC_WIDTH-1:0] PC,
		output logic [I_WIDTH-1:0]  instruction
	);

	
	//Memory generation
	logic [(IMem_SIZE/4)-1:0] IMem[I_WIDTH-1:0];
	integer i;
	
	always @(posedge clk or negedge rst_n)
		begin
			if(~rst_n)
			begin
				for(i=0; i < (IMem_SIZE/4); i=i+1)
				begin
					IMem[i] <= 'd0;
				end
			end
			else begin
			
			end
		end
	
	//Output Decode
	always @(posedge clk or negedge rst_n)
		begin
			if(~rst_n)
			begin
				instruction <= 'd0;
			end
			else begin
				instruction <= IMem[PC];
			end
		end
	
endmodule