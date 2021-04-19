module IM 
	#(
		parameter I_WIDTH=32,
		parameter IMEM_SIZE=2**15, //size in bytes
		parameter ADD_WIDTH = $clog2(IMEM_SIZE >>2),
		parameter PC_WIDTH=32
	)
	(
		input  logic                clk,
		input  logic                 rst_n,
		input  logic [PC_WIDTH-1:0]  PC,
		input  logic                 go,
		input  logic                 we,
		input  logic [ADD_WIDTH-1:0] waddr,
		input  logic  [I_WIDTH-1:0]   wdata,
		output logic [I_WIDTH-1:0]   instruction
	);

	parameter WORDS = IMEM_SIZE >> 2;
		imem u0 (
		.clk_clk                         (clk),                         //                 clk.clk
		.reset_reset_n                   (rst_n),                   //               reset.reset_n
		.onchip_memory2_0_s1_address     (PC),     // onchip_memory2_0_s1.address
		.onchip_memory2_0_s1_debugaccess ('0), //                    .debugaccess
		.onchip_memory2_0_s1_clken       (go),       //                    .clken
		.onchip_memory2_0_s1_chipselect  (go),  //                    .chipselect
		.onchip_memory2_0_s1_write       ('0),       //                    .write
		.onchip_memory2_0_s1_readdata    (instruction),    //                    .readdata
		.onchip_memory2_0_s1_writedata   ('0),   //                    .writedata
		.onchip_memory2_0_s1_byteenable  ('0)   //                    .byteenable
	);


	//Memory generation
	// use a multi-dimensional packed array to model individual bytes within the word
	/*logic [I_WIDTH-1:0] ram[0:WORDS-1];

	always_ff@(posedge clk)
	begin
		if(we) begin
		// edit this code if using other than four bytes per word
			ram[waddr] <= wdata;
		end
	end	
	
   //insert memory here
	
	//Output Decode
	always @(posedge clk or negedge rst_n)
		begin
			if(~rst_n)
			begin
				instruction <= 'd0;
			end
			else begin
				instruction <= (go)? ram[PC] : instruction;
			end
		end
	*/
endmodule


