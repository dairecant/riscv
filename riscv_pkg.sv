package riscv_pkg;
parameter I_WIDTH   = 32;
parameter PC_WIDTH  = I_WIDTH;
parameter IMM_WIDTH = 12;
parameter RS_WIDTH  = 5;
	typedef struct
		{
			logic        [I_WIDTH-1:0] rsu;
			logic  signed [I_WIDTH-1:0] rs;
		} rs_type;


typedef struct {
logic[24:0] data;
logic[6:0]  opcode;
}instr_type;
		
typedef logic [I_WIDTH-1:0] riscVDat;		
typedef logic [PC_WIDTH-1:0] PC;
typedef logic [4:0]	        rdAdr;
typedef logic [4:0]	        rsAdr;
typedef logic [4-1:0]        func3;
typedef logic [6:0]	        func7;
typedef logic [6:0]	        Opcode;
typedef logic [11:0]         tgh;
typedef logic [19:0]	 immediate;		

parameter  loadType     = 7'b0000011;
parameter  storeType    = 7'b0100011;
parameter  ALUTypeI     = 7'b0010011;
parameter  ALUTypeR     = 7'b0110011;
parameter  branchType   = 7'b0110011;
parameter  jumpType     = 7'b110x111;
parameter  luiType      = 7'b0110111;
parameter  auipcType    = 7'b0010111;

parameter R_TYPE = 7'b0110011;
parameter I_TYPE = 7'b0010011;
parameter S_TYPE = 7'b0100011;
parameter B_TYPE = 7'b1100011;
parameter U_TYPE = 7'b0x10111;
parameter J_TYPE = 7'b1101111;
parameter FENCE  = 7'b0001111;
parameter E_TYPE = 7'b1110011;


enum bit[2:0] {ADDI,SLLI,SLTI,SLTIU,XORI,SRLI_SRAI,ORI,ANDI} alu_i_ops;    
enum bit[2:0] {MUL,MULH,MULHSU,MULHU,DIV,DIVU,REM,REMU}      alu_m_ops;    
enum bit[2:0] {ADD_SUB,SLL,SLT, SLTU,XOR,SRL_SRA,OR,AND}     alu_r_ops;


endpackage