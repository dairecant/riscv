`timescale 1ns / 1ps


module reg32Blk_tb();

parameter D_WIDTH = 32;
parameter FREQ            = 64'd50000000;
parameter PERIOD          = 20;
parameter CLK_HALF_PERIOD = (PERIOD/2);

logic               clk_tb,rst_n_tb,regLd_tb,regStr_tb,outputValid_tb;
logic [4:0]         rs1_tb,rs2_tb,rd_tb;
logic [D_WIDTH-1:0] rs1Out_tb,rs2Out_tb,WBDat_tb,rs1Exp,rs2Exp;
integer waitTime,i;

logic [32-1:0]  regBlk_tb [D_WIDTH-1:0] ;


reg32Blk dut (
 
		.clk(clk_tb),
		.rst_n(rst_n_tb),
		.rs1(rs1_tb),
		.rs2(rs2_tb),
		.rd(rd_tb),
		.regLd(regLd_tb),
		.regStr(regStr_tb),
		.WBDat(WBDat_tb),
		.rs1Out(rs1Out_tb), 
		.rs2Out(rs2Out_tb),
		.outputValid(outputValid_tb)
	
	);

	initial 
	begin
		rst_n_tb  = 1'b0;
		regLd_tb  = 1'b0;  
		regStr_tb = 1'b0;
		rs1_tb    = 'd0;
		rs2_tb    = 'd0;
		rd_tb     = 'd0;
		WBDat_tb  = 'd0;
		rs1Exp    = 'd0;
		rs2Exp    = 'd0;

		#(10*PERIOD);
		checkOutputs();
		
		#(10*PERIOD);
		rst_n_tb  = 1'b1;
		#(PERIOD);

		$writememh("memInit.txt", regBlk_tb);
		//$readmemh("memInit.txt", dut.regBlk);
		

		regLd_tb = 1'b1;
		rs1Exp = regBlk_tb[0];
		rs2Exp = regBlk_tb[2];

		for(i = 0; i < 16; i=i+1)
		begin
			#PERIOD;
			checkOutputs();
			rs1Exp = regBlk_tb[i];
			rs2Exp = regBlk_tb[i*2+1];
			rs1_tb    = i;
			rs2_tb    = i*2;
		end

				$stop;

	end
	
	
	initial 
	begin
		clk_tb = 1'b0;
		forever
		begin
			#CLK_HALF_PERIOD clk_tb = ~clk_tb;
		end
	end

	function checkOutputs();
		begin
			if(rs1Out_tb != rs1Exp)
			begin
				$fatal("%t ERROR: rs1 does not match expected value --> expected: %d actual %d",$time,rs1Exp,rs1Out_tb);
			end
			else if(rs2Out_tb != rs2Exp)
			begin
				$fatal("%t ERROR: rs2 does not match expected value --> expected: %d actual %d",$time,rs2Exp,rs2Out_tb);
			end
			else begin
				$display("%t  rs1 expected: %d rs1 actual %d",$time,rs1Exp,rs1Out_tb);
				$display("%t  rs2 expected: %d rs2 actual %d",$time,rs2Exp,rs2Out_tb);
			end
		end
	endfunction
endmodule