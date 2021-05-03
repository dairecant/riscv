package riscv_pkg;
parameter I_WIDTH=32;
parameter PC_WIDTH=I_WIDTH;

	typedef struct
		{
			logic        [I_WIDTH-1:0] rsu;
			logic  signed [I_WIDTH-1:0] rs;
		} rs_type;

typedef logic [I_WIDTH-1:0] riscVDat;		
typedef logic [PC_WIDTH-1:0] PC;
typedef logic [4:0]	        rdAdr;
typedef logic [4:0]	        rsAdr;
typedef logic [4-1:0]        func3;
typedef logic [6:0]	        func7;
typedef logic [6:0]	        Opcode;

typedef logic [19:0]	 immediate;		

parameter  loadType     = 7'b0000011;
parameter  storeType    = 7'b0100011;
parameter  ALUTypeI     = 7'b0010011;
parameter  ALUTypeR     = 7'b0110011;
parameter  branchType   = 7'b0110011;
parameter  jumpType     = 7'b110x111;
parameter  luiType      = 7'b0110111;
parameter  auipcType    = 7'b0010111;

endpackage