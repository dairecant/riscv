/*******************************************************************/
// RISC-V Project
//		  Program Counter Testbench
// 	  Author: Dáire Canavan
//		  Date:   14/10/2021
//import riscv_pkg::*;



`timescale 1ns / 1ps

module pccu_tb ();

parameter FREQ            = 64'd50000000;
parameter PERIOD          = 20;
parameter CLK_HALF_PERIOD = (PERIOD/2);
parameter PC_WIDTH        = 32;
integer waitTime = 0;
logic clk_tb,rst_n_tb,go_tb,selPCsrc_tb,valid_tb;
logic [PC_WIDTH-1:0] branchIn_tb,PC_tb,exp_PC;

PCCU dut(
				.clk(clk_tb),
				.rst_n(rst_n_tb),
				.go(go_tb),
				.selPCsrc(selPCsrc_tb),
				.branchIn(branchIn_tb),
				.PC(PC_tb),
				.valid(valid_tb)

        );


		  initial
			begin
				$display("%t Clock Period :  %d",$time,PERIOD);

			    rst_n_tb    = '0;
				 go_tb       = '0;
				 selPCsrc_tb = '0;
				 rst_n_tb = 'b0;
				 exp_PC = 'd0;
             branchIn_tb = 'd0;
				 waitTime = 10*PERIOD;
			    #(waitTime);
				 rst_n_tb = 'b1;

				 waitTime = 100*PERIOD;

				 #waitTime;
				 if(PC_tb!=exp_PC)
					begin
						$fatal("%t ERROR: Program counter does not match  --> Expected : %d Actual %d",$time,exp_PC,PC_tb);
					end
				else
					begin
						$display("%t Program counter matches expected value  --> Expected : %d Actual %d",$time,exp_PC,PC_tb);
					end
				 
				 go_tb  = 1'b1;
				 waitTime = 100*PERIOD;
				 #waitTime;
				 exp_PC = 'd400;
				 if(PC_tb!=exp_PC)
					begin
						$fatal("%t ERROR: Program counter does not match  --> Expected : %d Actual %d",$time,exp_PC,PC_tb);
					end
				else
					begin
						$display("%t Program counter matches expected value  --> Expected : %d Actual %d",$time,exp_PC,PC_tb);
					end
				
				
				exp_PC = exp_PC + 'd4;
				 #PERIOD;
				 if(PC_tb!=exp_PC)
					begin
						$fatal("%t ERROR: Program counter does not match  --> Expected : %d Actual %d",$time,exp_PC,PC_tb);
					end
				else
					begin
						$display("%t Program counter matches expected value  --> Expected : %d Actual %d",$time,exp_PC,PC_tb);
					end
					
				 selPCsrc_tb = 1'b1;
				branchIn_tb = 32'hdeadbeef;
				exp_PC = branchIn_tb;
				 #PERIOD;
				 if(PC_tb!=exp_PC)
					begin
						$fatal("%t ERROR: Program counter does not match  --> Expected : %d Actual %d",$time,exp_PC,PC_tb);
					end
				else
					begin
						$display("%t Program counter matches expected value  --> Expected : %d Actual %d",$time,exp_PC,PC_tb);
					end	
				 selPCsrc_tb = 1'b0;

				exp_PC = exp_PC + 'd4;
				 #PERIOD;
				 if(PC_tb!=exp_PC)
					begin
						$fatal("%t ERROR: Program counter does not match  --> Expected : %d Actual %d",$time,exp_PC,PC_tb);
					end
				else
					begin
						$display("%t Program counter matches expected value  --> Expected : %d Actual %d",$time,exp_PC,PC_tb);
					end						
					
					
				$display("TEST PASSED");

				$stop;
			end
			
			initial 
				begin
					clk_tb = '0;
					forever
						begin
							#CLK_HALF_PERIOD clk_tb = ~clk_tb;
						end
				end
				
				
endmodule