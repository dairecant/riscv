module DM 
	#(
		parameter I_WIDTH=32,
		parameter IMEM_SIZE=2**15, //size in bytes
		parameter ADD_WIDTH = $clog2(IMEM_SIZE >>2),
		parameter PC_WIDTH=32
	)
	(
		input  logic                clk,
		input  logic                 rst_n,
		input  logic                 byteEn,
		input  logic                 go,
		input  logic                 we,
		input  logic [IMM_WIDTH-1:0] imm,
		input  logic [RS_WIDTH-1:0]  rs1,
		input  logic [I_WIDTH-1:0]   wdata,
		output logic [I_WIDTH-1:0]   loadData
	);
	
	
	logic [ADD_WIDTH-1:0] addr;
	assign addr = rs1 + imm;

	parameter WORDS = IMEM_SIZE >> 2;
		imem u0 (
		.clk_clk                         (clk),                         //                 clk.clk
		.reset_reset_n                   (rst_n),                   //               reset.reset_n
		.onchip_memory2_0_s1_address     (addr),     // onchip_memory2_0_s1.address
		.onchip_memory2_0_s1_debugaccess ('0), //                    .debugaccess
		.onchip_memory2_0_s1_clken       (go),       //                    .clken
		.onchip_memory2_0_s1_chipselect  (go),  //                    .chipselect
		.onchip_memory2_0_s1_write       (we),       //                    .write
		.onchip_memory2_0_s1_readdata    (loadData),    //                    .readdata
		.onchip_memory2_0_s1_writedata   (wdata),   //                    .writedata
		.onchip_memory2_0_s1_byteenable  (byteEn)   //                    .byteenable
	);
	
	endmodule