`timescale 1ns / 1ps
`include "defines.v"
/*******************************************************************
*
* Module: RISCV_CPU.v
* Project: SingleCycleRV32I
* Author: Omar Elfouly omarelfouly@aucegypt.edu and Bavly Remon bavly.remon2004@aucegypt.edu
* Description: module responsible for implmenting a single cycle, two memory, riscv cpu
*
* Change history:   11/3/2023 - Import from lab 6
*                   11/3/2023 - Adds Comment and includes define
*
**********************************************************************/


module RISCV_CPU(
    input clk,
    input rst,
    input [1:0] led_Selection,
    input [3:0] ssd_Selection,
    output [15:0] leds,
    output [12:0] ssd
    );
    
    wire [31:0] instruction;
    wire Branch;
    wire MemRead;
    wire MemtoReg;
    wire [1:0] ALUOp;
    wire MemWrite;
    wire ALUSrc;
    wire RegWrite;
    wire [3:0] ALUSelection;
    wire [1:0] rfWriteSelect;

    wire Zflag;
    wire branchMuxSelect;
    wire CarryFlag;
    wire OverflowFlag;
    wire SignFlag;
    wire PCWrite;
    wire PCMuxSelector;

    assign leds = (led_Selection==2'b00)? instruction [15:0] :((led_Selection==2'b01)?instruction [31:16] : 
    {2'b00,Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite,ALUSelection, Zflag , PCMuxSelector });
    
    wire[31:0] PCOutput;
    wire[31:0] Pc4Out;
    wire[31:0] BranchTarget;
    wire[31:0] PCInput;
    wire[31:0] Rs1Read;
    wire[31:0] Rs2Read;
    wire[31:0] RegFileInputData;
    wire [31:0] FinalRegFileData;

    wire[31:0] ImmGenOut;
    wire[31:0] Alu2ndSource;
    wire[31:0] AluOut;
    wire[31:0] MemOut;
    
    SSDGenerator ssdGen(.ssd_Selection(ssd_Selection),.PCOutput(PCOutput[12:0]),
    .Pc4Out(Pc4Out[12:0]),.BranchTarget(BranchTarget[12:0]),.PCInput(PCInput[12:0]),
    .Rs1Read(Rs1Read[12:0]),.Rs2Read(Rs2Read[12:0]),.FinalRegFileData(FinalRegFileData[12:0]),
    .ImmGenOut(ImmGenOut[12:0]),.Alu2ndSource(Alu2ndSource[12:0]),.AluOut(AluOut[12:0]),
    .MemOut(MemOut[12:0]),.ssd(ssd));
    
    wire [31:0] IF_ID_PC;
    wire [31:0] IF_ID_Inst;
    wire [31:0] IF_ID_Pc4Out;
    
    wire stall;
    wire stall_n;
    assign stall_n = ~stall;
    wire [31:0] InstOrFlush;
    assign instruction = MemOut;
    assign InstOrFlush = ( PCMuxSelector || ( EX_MEM_MemRead || EX_MEM_MemWrite ) )? 32'b00000000000000000000000000110011:instruction;
    NBitRegister #(96) IF_ID (.clk(clk),.rst(rst),.load(stall_n), 
    .D({PCOutput, InstOrFlush, Pc4Out}),.Q({IF_ID_PC,IF_ID_Inst,IF_ID_Pc4Out}));
    
    wire ID_EX_MemRead;
    wire [4:0] ID_EX_Rd;
    HazardDetectionUnit HazardDetectionUnit_INST( .IF_ID_Rs1(IF_ID_Inst[19:15]),.IF_ID_Rs2(IF_ID_Inst[24:20]),.ID_EX_Rd(ID_EX_Rd),.ID_EX_MemRead(ID_EX_MemRead),.stall(stall)); 

    
    wire [31:0] ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm;
    wire ID_EX_RegWrite;
    wire ID_EX_MemtoReg;
    wire ID_EX_Branch;
    wire ID_EX_MemWrite;
    wire [1:0] ID_EX_ALUOp;
    wire ID_EX_ALUSrc;
    wire [1:0] ID_EX_rfWriteSelect;
    wire [3:0] ID_EX_Func; // func3 + 30
    wire [4:0] ID_EX_Rs1, ID_EX_Rs2;// ID_EX_Rd;
    wire ID_EX_Inst_5;
    wire [4:0] ID_EX_Inst_Opcode;
    wire [31:0] ID_EX_Pc4Out;
    wire [7:0] ID_EX_Ctrl;
    
    NBit2x1Mux #(8) ID_EX_Stall_MUX(.mux_input_1(8'd0),.mux_input_0({RegWrite, MemtoReg, Branch, MemRead , MemWrite, ALUOp, ALUSrc}),
    .selection_bit(stall || PCMuxSelector),.mux_out(ID_EX_Ctrl));

    NBitRegister #(195)  ID_EX( .clk(clk),.rst(rst),.load(1'b1), 
    .D({ID_EX_Ctrl, rfWriteSelect, IF_ID_PC, Rs1Read , Rs2Read, ImmGenOut, IF_ID_Inst[30],
     IF_ID_Inst[14:12], IF_ID_Inst[19:15], IF_ID_Inst[24:20], IF_ID_Inst[11:7],
     IF_ID_Inst[5], IF_ID_Inst[`IR_opcode], IF_ID_Pc4Out}),
    .Q({ID_EX_RegWrite, ID_EX_MemtoReg, ID_EX_Branch, ID_EX_MemRead, 
    ID_EX_MemWrite, ID_EX_ALUOp, ID_EX_ALUSrc, ID_EX_rfWriteSelect,ID_EX_PC,ID_EX_RegR1,
    ID_EX_RegR2,ID_EX_Imm, ID_EX_Func,ID_EX_Rs1,ID_EX_Rs2,ID_EX_Rd,
    ID_EX_Inst_5, ID_EX_Inst_Opcode, ID_EX_Pc4Out}));

    wire [1:0] forwardA;
    wire [1:0] forwardB;
    wire EX_MEM_RegWrite;
    wire [4:0] MEM_WB_Rd;
    wire [4:0] EX_MEM_Rd;
    wire MEM_WB_RegWrite;

    ForwardingUnit ForwardingUnit_inst(.ID_EX_Rs1(ID_EX_Rs1), .ID_EX_Rs2(ID_EX_Rs2), .EX_MEM_Rd(EX_MEM_Rd),
    .MEM_WB_Rd(MEM_WB_Rd), .EX_MEM_RegWrite(EX_MEM_RegWrite), .MEM_WB_RegWrite(MEM_WB_RegWrite), 
    .forwardA(forwardA), .forwardB(forwardB));

    wire [31:0] EX_MEM_ALU_out, EX_MEM_ALU_B;
    
    wire EX_MEM_MemtoReg;
    wire EX_MEM_Branch;
    wire EX_MEM_MemRead;
    wire EX_MEM_MemWrite;
    wire [1:0] EX_MEM_rfWriteSelect;
    wire EX_MEM_Zero;
    wire [4:0] EX_MEM_Inst_Opcode;
    wire [31:0] EX_MEM_Pc4Out;
    wire EX_MEM_branchMuxSelect;
    wire [2:0] EX_MEM_Func3;
    wire [31:0] EX_MEM_RegR2;
    wire [31:0] EX_MEM_BranchTarget;
    wire [31:0] EX_MEM_Imm;
    
    wire [4:0] EX_MEM_Ctrl_Input;
    assign EX_MEM_Ctrl_Input = PCMuxSelector ? 5'd0 : {ID_EX_RegWrite, ID_EX_MemtoReg, ID_EX_Branch, ID_EX_MemRead, ID_EX_MemWrite};
    wire [31:0] ALU_B;
    NBitRegister #(214) EX_MEM (.clk(clk),.rst(rst),.load(1'b1),
    .D({EX_MEM_Ctrl_Input, BranchTarget, Zflag, AluOut, ALU_B, ID_EX_Rd, ID_EX_rfWriteSelect,
    ID_EX_Inst_Opcode, ID_EX_Pc4Out, branchMuxSelect, ID_EX_Func[2:0], ID_EX_RegR2, ID_EX_Imm}),
    .Q({EX_MEM_RegWrite, EX_MEM_MemtoReg, EX_MEM_Branch, EX_MEM_MemRead, 
    EX_MEM_MemWrite, EX_MEM_BranchTarget, EX_MEM_Zero,EX_MEM_ALU_out, EX_MEM_ALU_B, EX_MEM_Rd,EX_MEM_rfWriteSelect,
    EX_MEM_Inst_Opcode, EX_MEM_Pc4Out, EX_MEM_branchMuxSelect, EX_MEM_Func3, EX_MEM_RegR2, EX_MEM_Imm}));

    wire [31:0] MEM_WB_Mem_out, MEM_WB_ALU_out;
    wire MEM_WB_MemtoReg;
    wire [1:0] MEM_WB_rfWriteSelect;
    wire [31:0] MEM_WB_Pc4Out;
    wire [31:0] MEM_WB_BranchTarget;
    wire [31:0] MEM_WB_Imm;

    NBitRegister #(169) MEM_WB (.clk(clk),.rst(rst),.load(1'b1),
    .D({EX_MEM_RegWrite, EX_MEM_MemtoReg, MemOut, EX_MEM_ALU_out, EX_MEM_Rd, EX_MEM_rfWriteSelect,
    EX_MEM_Pc4Out, EX_MEM_BranchTarget, EX_MEM_Imm}),
    .Q({MEM_WB_RegWrite, MEM_WB_MemtoReg, MEM_WB_Mem_out, MEM_WB_ALU_out,MEM_WB_Rd, MEM_WB_rfWriteSelect,
    MEM_WB_Pc4Out, MEM_WB_BranchTarget, MEM_WB_Imm}));

    NBitRegister #(32) PC(.clk(clk),.rst(rst),.load(PCWrite && stall_n && !( EX_MEM_MemRead || EX_MEM_MemWrite )),.D(PCInput),.Q(PCOutput));
    
//    NbitRCA #(32) add4ToPC(.input_1(PCOutput),.input_0(`THIRTYTWO_FOUR),
//    .Carry_in(`SINGLE_BIT_ZERO),.Sum(Pc4Out),.Carry_out(/*ignore*/));
    Adder add4ToPC(.input_1(PCOutput), .input_0(`THIRTYTWO_FOUR),
    .Carry_in(`SINGLE_BIT_ZERO), .Sum(Pc4Out), .Carry_out(/*ignore*/));
    
//    InstructionMemory InstructionMemory_inst(.addr(PCOutput[31:2]),.data_out(instruction)); // take all of PC except first two bits to divide by 4
        
    // IF_ID REG
    
    ControlUnit ControlUnit_inst(.inst20(IF_ID_Inst[20]),.instruction_opcode(IF_ID_Inst[`IR_opcode]),
    .Branch(Branch),.MemRead(MemRead),.MemtoReg(MemtoReg),.ALUOp(ALUOp),
    .MemWrite(MemWrite),.ALUSrc(ALUSrc),.RegWrite(RegWrite),.PCWrite(PCWrite),
    .rfWriteSelect(rfWriteSelect));
    
    //wire [31:0] FinalRegFileData;
    
    RegFile #(32) RegFile_inst(.clk(clk),.rst(rst),.write_data(FinalRegFileData),
    .read_reg_1(IF_ID_Inst[`IR_rs1]), .read_reg_2(IF_ID_Inst[`IR_rs2]),.write_reg(MEM_WB_Rd),
    .RegWrite(MEM_WB_RegWrite),.read_data_1(Rs1Read),.read_data_2(Rs2Read));
    
    ImmGen ImmGen_inst(.instruction(IF_ID_Inst),.Imm(ImmGenOut));
    
    // ID_EX
    
    ALUControlUnit ALUControlUnit_inst(.ALUOp(ID_EX_ALUOp),.func3(ID_EX_Func[2:0]),
    .inst30(ID_EX_Func[3]),.ALUSelection(ALUSelection),.instruction5(ID_EX_Inst_5));
    
//    NbitRCA #(32) PCBranchCalc(.input_1(ID_EX_PC),.input_0(ID_EX_Imm),.Carry_in(1'b0),
//    .Sum(BranchTarget),.Carry_out(/*ignore*/));    
    
    Adder PCBranchCalc(.input_1(ID_EX_PC),.input_0(ID_EX_Imm),.Carry_in(1'b0),
    .Sum(BranchTarget),.Carry_out(/*ignore*/));
    
    wire [31:0] EX_MEM_Forward;
    FourByOneMux EX_MEM_FORWARD_MUX(.mux_input_3(EX_MEM_Pc4Out),
    .mux_input_2(EX_MEM_BranchTarget),.mux_input_1(EX_MEM_Imm),
    .mux_input_0(EX_MEM_ALU_out),.selection_bits(EX_MEM_rfWriteSelect),
    .mux_out(EX_MEM_Forward));
    
    wire [31:0] ALU_A;
    FourByOneMux ALU_A_Mux(.mux_input_3(/*Ignore*/), .mux_input_2(EX_MEM_Forward),
    .mux_input_1(FinalRegFileData), .mux_input_0(ID_EX_RegR1), 
    .selection_bits(forwardA), .mux_out(ALU_A));
    
    FourByOneMux ALU_B_Mux(.mux_input_3(/*Ignore*/), .mux_input_2(EX_MEM_Forward), 
    .mux_input_1(FinalRegFileData), .mux_input_0(ID_EX_RegR2), 
    .selection_bits(forwardB), .mux_out(ALU_B));
    
    NBit2x1Mux #(32) RegMux(.mux_input_1(ID_EX_Imm),.mux_input_0(ALU_B),
    .selection_bit(ID_EX_ALUSrc),.mux_out(Alu2ndSource));
    
    ALU_32_bit ALU_32_bit_inst(.instruction5(ID_EX_Inst_5),.a(ALU_A),
    .b(Alu2ndSource),.shamt(ID_EX_Rs2),.r(AluOut),.cf(CarryFlag),
    .zf(Zflag), .vf(OverflowFlag), .sf(SignFlag), .alufn(ALUSelection));
    
    BranchControlUnit BranchControlUnit_inst(.Branch(ID_EX_Branch),.cf(CarryFlag),
    .zf(Zflag),.vf(OverflowFlag),.sf(SignFlag),.func3(ID_EX_Func[2:0]),
    .branchMuxSelect(branchMuxSelect));
    
    // EX_MEM
    
    assign PCMuxSelector = EX_MEM_branchMuxSelect || (EX_MEM_Inst_Opcode == `OPCODE_JAL) || (EX_MEM_Inst_Opcode == `OPCODE_JALR);
    
    wire PCMuxSecondSourceMuxSelector;
    assign PCMuxSecondSourceMuxSelector = (EX_MEM_Inst_Opcode == `OPCODE_JALR);
    
    wire [31:0] PCSecondSource;
    NBit2x1Mux #(32) PCMuxSecondSourceMux(.mux_input_1(EX_MEM_ALU_out),.mux_input_0(EX_MEM_BranchTarget),
    .selection_bit(PCMuxSecondSourceMuxSelector),.mux_out(PCSecondSource));
    
    NBit2x1Mux #(32) PCMux(.mux_input_1(PCSecondSource),.mux_input_0(Pc4Out),
    .selection_bit(PCMuxSelector),.mux_out(PCInput));
    
    /*DataMemory dataMem(.clk(clk),.MemRead(EX_MEM_MemRead),.MemWrite(EX_MEM_MemWrite),
    .func3(EX_MEM_Func3),.addr(EX_MEM_ALU_out),.data_in(EX_MEM_ALU_B ),
    .data_out(MemOut));*/
    wire [31:0] addr_mem;
    assign addr_mem = ( EX_MEM_MemRead || EX_MEM_MemWrite )? EX_MEM_ALU_out : PCOutput ;
    
    SingleMemory memory(.clk(clk), .MemRead( EX_MEM_MemRead ), .MemWrite( EX_MEM_MemWrite ),
    .func3( EX_MEM_Func3 ), .addr(addr_mem),.data_in( EX_MEM_ALU_B ),
    .data_out(MemOut));
    
    // MEM_WB
    
    NBit2x1Mux #(32) dataMux(.mux_input_1(MEM_WB_Mem_out ),.mux_input_0(MEM_WB_ALU_out ),
    .selection_bit(MEM_WB_MemtoReg),.mux_out(RegFileInputData));
    
    FourByOneMux RegisterFileWriteDataMux(.mux_input_3(MEM_WB_Pc4Out),
    .mux_input_2(MEM_WB_BranchTarget),.mux_input_1(MEM_WB_Imm),
    .mux_input_0(RegFileInputData),.selection_bits(MEM_WB_rfWriteSelect),
    .mux_out(FinalRegFileData));
    
endmodule
