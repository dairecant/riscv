`timescale 1ns / 1ps


module reg32Blk_tb();

parameter D_WIDTH = 32;
parameter FREQ            = 64'd50000000;
parameter PERIOD          = 20;
parameter CLK_HALF_PERIOD = (PERIOD/2);

logic               clk_tb,rst_n_tb,regLd_tb,regStr_tb,outputValid_tb;
logic [4:0]         rs1_tb,rs2_tb,rd_tb;
logic [D_WIDTH-1:0] rs1Out_tb,rs2Out_tb,WBDat_tb,rs1Exp,rs2Exp;
integer error,i;

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
		error = 0;

		#(10*PERIOD);
		checkOutputs();
		
		#(10*PERIOD);
		rst_n_tb  = 1'b1;
		#(PERIOD);
       
		regBlk_tb = {  32'h02020202,32'hdeadbeef,32'hcafef00d,32'h73464258,32'h32df3258,32'h865ab897,32'h347acbef,32'h45678910,
							32'h87964565,32'h654a654b,32'h24adfecb,32'h65465a6c,32'h546abde4,32'h6a846b84,32'h65412345,32'h1bab3456,
							32'hcdef4568,32'h1ab981bb,32'hb9823def,32'h99ad9243,32'h21dcba66,32'h11111111,32'h2a2a2a2a,32'h3b3b3b3b,
							32'h4c4c4c4c,32'h5e5e5e5e,32'h3f3f3f3f,32'h7a7a7a7a,32'h8d8d8d8d,32'hbcbcbcbc,32'hb1b1b1b1,32'hf6f6f6f6};
		#(3*PERIOD);
		$display("WRITING TO REGISTERS");

		regStr_tb = 1'b1;
		for(i = 0; i < 32; i=i+1) //write to reg blk
		begin
			#PERIOD;
			rd_tb = i;
			WBDat_tb  = regBlk_tb[i];

		end
		#PERIOD; //write last reg
		regStr_tb = 1'b0;
		#(3*PERIOD);

		regLd_tb = 1'b1;
		rs1Exp = 'd0;
		@(posedge clk_tb);
		#1ns;
		checkOutputs(); //check x0 wasn't written to
		
		for(i = 0; i < 16; i=i+1) //cycle through simultaneous registers
		begin //first iteration will be simultaneous read to same reg
			$display("RS1 = %d     Rs2 = %d",rs2_tb+1,i*2+1);
			rs1Exp = regBlk_tb[rs2_tb+1];
			rs2Exp = regBlk_tb[i*2+1];
			rs1_tb    = rs2_tb+1;
			rs2_tb    = i*2+1;
			@(posedge clk_tb);
			#1ns;
			checkOutputs();

		end
		
		$display("CHECK SWEEP THROUGH REGISTERS");

		for(i = 0; i < 32; i=i+1) //cycle through simultaneous registers
		begin //first iteration will be simultaneous read to same reg
			$display("RS1 = %d     Rs2 = %d",rs2_tb+1,i*2+1);
			rs1Exp = (i==0)? 'd0 : regBlk_tb[i];
			rs2Exp = (i==0)? 'd0 : regBlk_tb[i];
			rs1_tb    = i;
			rs2_tb    = i;
			@(posedge clk_tb);
			#1ns;
			checkOutputs();

		end
		
		#(3*PERIOD);
		$display("CHECK READ/WRITE TO SAME REGISTER");
		rd_tb = rs1_tb;
		regStr_tb = 1'b1;
		WBDat_tb = 32'h0123abcd;
		@(posedge clk_tb);
		#1ns;
		checkOutputs(); //check read and write to same reg (rs1/rs2 should output previous value)
 	    rs1Exp = WBDat_tb;
	    rs2Exp = WBDat_tb;
		regStr_tb = 1'b0;

		@(posedge clk_tb);
		#1ns;
		checkOutputs(); //check read and write to same reg (rs1/rs2 should output previous value)
		regLd_tb = 1'b0;
		#(10*PERIOD);
		if(error==0)
		 begin
			$display("%t TEST PASSED",$time);
		 end
		 else begin
			$fatal("%t TEST FAILED: $ Errors.",$time,error);
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
				$error("%t ERROR: rs1 does not match expected value --> expected: %x actual %x",$time,rs1Exp,rs1Out_tb);
				error = error +1;
			end
		   if(rs2Out_tb != rs2Exp)
			begin
				$error("%t ERROR: rs2 does not match expected value --> expected: %x actual %x",$time,rs2Exp,rs2Out_tb);
				error = error +1;
			end
			if((rs2Out_tb == rs2Exp) & (rs1Out_tb == rs1Exp) ) begin
				$display("%t  rs1 expected: %x rs1 actual %x",$time,rs1Exp,rs1Out_tb);
				$display("%t  rs2 expected: %x rs2 actual %x",$time,rs2Exp,rs2Out_tb);
			end
		end
	endfunction
endmodule