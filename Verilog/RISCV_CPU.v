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
    wire[31:0] ImmGenOut;
    wire[31:0] Alu2ndSource;
    wire[31:0] AluOut;
    wire[31:0] MemOut;
    
    SSDGenerator ssdGen(.ssd_Selection(ssd_Selection),.PCOutput(PCOutput[12:0]),
    .Pc4Out(Pc4Out[12:0]),.BranchTarget(BranchTarget[12:0]),.PCInput(PCInput[12:0]),
    .Rs1Read(Rs1Read[12:0]),.Rs2Read(Rs2Read[12:0]),.RegFileInputData(RegFileInputData[12:0]),
    .ImmGenOut(ImmGenOut[12:0]),.Alu2ndSource(Alu2ndSource[12:0]),.AluOut(AluOut[12:0]),
    .MemOut(MemOut[12:0]),.ssd(ssd));
    
    wire [31:0] IF_ID_PC;
    wire [31:0] IF_ID_Inst;
    
//    wire stall;
//    wire stall_n;
//    assign stall_n = ~stall;
//    wire [31:0] InstOrFlush;
//    assign InstOrFlush = PCSrc? 32'b00000000000000000000000000110011:instruction;
    NBitRegister #(64) IF_ID (.clk(clk),.rst(reset),.load(/*stall_n*/1), .D({PCOutput, /*InstOrFlush*/instruction}),.Q({IF_ID_PC,IF_ID_Inst}));
    
    wire ID_EX_MemRead;
    wire [4:0] ID_EX_Rd;
//    HazardDetectionUnit HazardDetectionUnit_INST( .IF_ID_Rs1(IF_ID_Inst[19:15]),.IF_ID_Rs2(IF_ID_Inst[24:20]),.ID_EX_Rd(ID_EX_Rd),.ID_EX_MemRead(ID_EX_MemRead),.stall(stall)); 

    
    wire [31:0] ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm;
    wire ID_EX_RegWrite;
    wire ID_EX_MemtoReg;
    wire ID_EX_Branch;
    wire ID_EX_MemWrite;
    wire [1:0] ID_EX_ALUOp;
    wire ID_EX_ALUSrc;
    wire [3:0] ID_EX_Func; // func3 + 30
    wire [4:0] ID_EX_Rs1, ID_EX_Rs2;// ID_EX_Rd;
//    wire [7:0] ID_EX_Ctrl;
//    NBit2x1Mux #(8) ID_EX_Stall_MUX(.A(8'd0),.B({RegWrite, MemtoReg, Branch, MemRead , MemWrite, ALUOp, ALUSrc}),.S(stall || PCSrc),.out(ID_EX_Ctrl));

    NBitRegister #(155)  ID_EX( .clk(clk),.rst(reset),.load(1'b1), .D({/*ID_EX_Ctrl*/RegWrite, MemtoReg, Branch, MemRead , MemWrite, ALUOp, ALUSrc, IF_ID_PC, Rs1Read , Rs2Read, ImmGenOut, IF_ID_Inst[30], IF_ID_Inst[14:12], IF_ID_Inst[19:15], IF_ID_Inst[24:20], IF_ID_Inst[11:7]}),
    .Q({ID_EX_RegWrite, ID_EX_MemtoReg, ID_EX_Branch, ID_EX_MemRead, ID_EX_MemWrite, ID_EX_ALUOp, ID_EX_ALUSrc,ID_EX_PC,ID_EX_RegR1,ID_EX_RegR2,ID_EX_Imm, ID_EX_Func,ID_EX_Rs1,ID_EX_Rs2,ID_EX_Rd}));

//    wire [1:0] forwardA;
//    wire [1:0] forwardB;
    wire EX_MEM_RegWrite;
    wire [4:0] EX_MEM_Rd;
    wire MEM_WB_RegWrite;

//    ForwardingUnit ForwardingUnit_inst(.ID_EX_Rs1(ID_EX_Rs1), .ID_EX_Rs2(ID_EX_Rs2), .EX_MEM_Rd(EX_MEM_Rd), .MEM_WB_Rd(MEM_WB_Rd), .EX_MEM_RegWrite(EX_MEM_RegWrite), .MEM_WB_RegWrite(MEM_WB_RegWrite), .forwardA(forwardA), .forwardB(forwardB));

    wire [31:0] EX_MEM_ALU_out, EX_MEM_ALU_B;
    
    wire EX_MEM_MemtoReg;
    wire EX_MEM_Branch;
    wire EX_MEM_MemRead;
    wire EX_MEM_MemWrite;
    
    wire EX_MEM_Zero;
    
//    wire [4:0] EX_MEM_Ctrl_Input;
//    assign EX_MEM_Ctrl_Input = PCSrc? 5'd0 : {ID_EX_RegWrite, ID_EX_MemtoReg, ID_EX_Branch, ID_EX_MemRead, ID_EX_MemWrite};

    NBitRegister #(107) EX_MEM (.clk(clk),.rst(reset),.load(1'b1),.D({/*EX_MEM_Ctrl_Input*/ID_EX_RegWrite, ID_EX_MemtoReg, ID_EX_Branch, ID_EX_MemRead, ID_EX_MemWrite, BranchTarget, Zflag, AluOut, ALU_B, ID_EX_Rd}),
    .Q({EX_MEM_RegWrite, EX_MEM_MemtoReg, EX_MEM_Branch, EX_MEM_MemRead, EX_MEM_MemWrite, EX_MEM_BranchAddOut, EX_MEM_Zero,EX_MEM_ALU_out, EX_MEM_ALU_B, EX_MEM_Rd}));

    wire [31:0] MEM_WB_Mem_out, MEM_WB_ALU_out;
    wire MEM_WB_MemtoReg;

    NBitRegister #(71) MEM_WB (.clk(clk),.rst(reset),.load(1'b1),.D({EX_MEM_RegWrite, EX_MEM_MemtoReg, MemOut, EX_MEM_ALU_out, EX_MEM_Rd}),
    .Q({MEM_WB_RegWrite, MEM_WB_MemtoReg, MEM_WB_Mem_out, MEM_WB_ALU_out,MEM_WB_Rd}));

    NBitRegister #(32) PC(.clk(clk),.rst(rst),.load(PCWrite),.D(PCInput),.Q(PCOutput));
    
    NbitRCA #(32) add4ToPC(.input_1(PCOutput),.input_0(`THIRTYTWO_FOUR),
    .Carry_in(`SINGLE_BIT_ZERO),.Sum(Pc4Out),.Carry_out(/*ignore*/));
    
    InstructionMemory InstructionMemory_inst(.addr(PCOutput[31:2]),.data_out(instruction)); // take all of PC except first two bits to divide by 4
    
    wire [1:0] rfWriteSelect; // NEED TO ADD TO REGISTERS
    
    ControlUnit ControlUnit_inst(.inst20(IF_ID_Inst[20]),.instruction_opcode(IF_ID_Inst[6:2]),
    .Branch(Branch),.MemRead(MemRead),.MemtoReg(MemtoReg),.ALUOp(ALUOp),
    .MemWrite(MemWrite),.ALUSrc(ALUSrc),.RegWrite(RegWrite),.PCWrite(PCWrite),
    .rfWriteSelect(rfWriteSelect));
    
    wire [31:0] FinalRegFileData;
    
    RegFile #(32) RegFile_inst(.clk(clk),.rst(rst),.write_data(FinalRegFileData),
    .read_reg_1(instruction[`IR_rs1]), .read_reg_2(instruction[`IR_rs2]),.write_reg(instruction[`IR_rd]),
    .RegWrite(RegWrite),.read_data_1(Rs1Read),.read_data_2(Rs2Read));
    
    ImmGen ImmGen_inst(.instruction(instruction),.Imm(ImmGenOut));
    
    ALUControlUnit ALUControlUnit_inst(.ALUOp(ALUOp),.func3(instruction[`IR_funct3]),
    .inst30(instruction[30]),.ALUSelection(ALUSelection),.instruction5(instruction[5]));
    
    NbitRCA #(32) PCBranchCalc(.input_1(PCOutput),.input_0(ImmGenOut),.Carry_in(1'b0),
    .Sum(BranchTarget),.Carry_out(/*ignore1*/));
    
    assign PCMuxSelector = branchMuxSelect || (`OPCODE == `OPCODE_JAL) || (`OPCODE == `OPCODE_JALR);
    
    wire PCMuxSecondSourceMuxSelector;
    assign PCMuxSecondSourceMuxSelector = (`OPCODE == `OPCODE_JALR);
    
    wire [31:0] PCSecondSource;
    NBit2x1Mux #(32) PCMuxSecondSourceMux(.mux_input_1(AluOut),.mux_input_0(BranchTarget),
    .selection_bit(PCMuxSecondSourceMuxSelector),.mux_out(PCSecondSource));
    
    NBit2x1Mux #(32) PCMux(.mux_input_1(PCSecondSource),.mux_input_0(Pc4Out),
    .selection_bit(PCMuxSelector),.mux_out(PCInput));
    
    NBit2x1Mux #(32) RegMux(.mux_input_1(ImmGenOut),.mux_input_0(Rs2Read),
    .selection_bit(ALUSrc),.mux_out(Alu2ndSource));
    
    ALU_32_bit ALU_32_bit_inst(.instruction5(instruction[5]),.a(Rs1Read),
    .b(Alu2ndSource),.shamt(instruction[`IR_shamt]),.r(AluOut),.cf(CarryFlag),
    .zf(Zflag), .vf(OverflowFlag), .sf(SignFlag), .alufn(ALUSelection));
    
    BranchControlUnit BranchControlUnit_inst(.Branch(Branch),.cf(CarryFlag),
    .zf(Zflag),.vf(OverflowFlag),.sf(SignFlag),.func3(instruction[`IR_funct3]),
    .branchMuxSelect(branchMuxSelect));
    
    DataMemory dataMem(.clk(clk),.MemRead(MemRead),.MemWrite(MemWrite),
    .func3(instruction[`IR_funct3]),.addr(AluOut),.data_in(Rs2Read),
    .data_out(MemOut));
    
    NBit2x1Mux #(32) dataMux(.mux_input_1(MemOut),.mux_input_0(AluOut),
    .selection_bit(MemtoReg),.mux_out(RegFileInputData));
    
    FourByOneMux RegisterFileWriteDataMux(.mux_input_3(Pc4Out),
    .mux_input_2(BranchTarget),.mux_input_1(ImmGenOut),
    .mux_input_0(RegFileInputData),.selection_bits(rfWriteSelect),
    .mux_out(FinalRegFileData));
    
endmodule
