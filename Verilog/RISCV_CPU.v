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
    output reg [12:0] ssd
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

    assign leds = (led_Selection==2'b00)? instruction [15:0] :
    ((led_Selection==2'b01)?instruction [31:16] : 
    {2'b00,Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite,ALUSelection, Zflag , PCMuxSelector });
    
    wire[31:0] PCOutput;
    wire[31:0] Pc4Out;
    wire[31:0] BranchTarget;
    wire[31:0] PCInput;
    wire[31:0] Rs1Read;
    wire[31:0] Rs2Read;
    wire[31:0] RegFileInputData;
    wire[31:0] ImmGenOut;
    wire[31:0] ShiftLeft1Out;
    wire[31:0] Alu2ndSource;
    wire[31:0] AluOut;
    wire[31:0] MemOut;
    
    
    always@(*) begin
        case(ssd_Selection)
            0: begin
            ssd= PCOutput[12:0];
            end
            1: begin
            ssd= Pc4Out[12:0];
            end
            2: begin
            ssd= BranchTarget[12:0];
            end
            3: begin
            ssd= PCInput[12:0];
            end
            4: begin
            ssd= Rs1Read[12:0];
            end
            5: begin
            ssd= Rs2Read[12:0];
            end
            6: begin
            ssd= RegFileInputData[12:0];
            end
            7: begin
            ssd=  ImmGenOut[12:0];
            end
            8: begin
            ssd= ShiftLeft1Out[12:0];
            end
            9: begin
            ssd= Alu2ndSource[12:0];
            end
            10: begin
            ssd= AluOut[12:0];
            end
            11: begin
            ssd= MemOut[12:0];
            end
            default: begin
            ssd= 0;
            end
        endcase
    end
    
    NBitRegister #(32) PC(.clk(clk),.rst(rst),.load(PCWrite),.D(PCInput),.Q(PCOutput));
    
    NbitRCA #(32) add4ToPC(.input_1(PCOutput),.input_0(`THIRTYTWO_FOUR),.Carry_in(`SINGLE_BIT_ZERO),.Sum(Pc4Out),.Carry_out(/*ignore*/));
    
    InstructionMemory InstructionMemory_inst(.addr(PCOutput[31:2]),.data_out(instruction)); // take all of PC except first two bits to divide by 4
    
    wire [1:0] rfWriteSelect;
    ControlUnit ControlUnit_inst(.inst20(instruction[20]),.instruction_opcode(`OPCODE),.Branch(Branch),.MemRead(MemRead),.MemtoReg(MemtoReg),.ALUOp(ALUOp),.MemWrite(MemWrite),.ALUSrc(ALUSrc),.RegWrite(RegWrite),.PCWrite(PCWrite),.rfWriteSelect(rfWriteSelect));
    
    wire [31:0] FinalRegFileData;

    RegFile #(32) RegFile_inst(.clk(clk),.rst(rst),.write_data(FinalRegFileData),.read_reg_1(instruction[`IR_rs1]), .read_reg_2(instruction[`IR_rs2]),.write_reg(instruction[`IR_rd]),.RegWrite(RegWrite),.read_data_1(Rs1Read),.read_data_2(Rs2Read));
    
    ImmGen ImmGen_inst(.instruction(instruction),.Imm(ImmGenOut));
    
    ALUControlUnit ALUControlUnit_inst(.ALUOp(ALUOp),.func3(instruction[`IR_funct3]),.inst30(instruction[30]),.ALUSelection(ALUSelection),.instruction5(instruction[5]));
    
    NbitRCA #(32) PCBranchCalc(.input_1(PCOutput),.input_0(ImmGenOut),.Carry_in(1'b0),.Sum(BranchTarget),.Carry_out(/*ignore1*/));
    
    assign PCMuxSelector = branchMuxSelect || (`OPCODE == `OPCODE_JAL) || (`OPCODE == `OPCODE_JALR);
    
    wire PCMuxSecondSourceMuxSelector;
    assign PCMuxSecondSourceMuxSelector = (`OPCODE == `OPCODE_JALR);
    
    wire [31:0] PCSecondSource;
    NBit2x1Mux #(32) PCMuxSecondSourceMux(.mux_input_1(AluOut),.mux_input_0(BranchTarget),.selection_bit(PCMuxSecondSourceMuxSelector),.mux_out(PCSecondSource));
    
    NBit2x1Mux #(32) PCMux(.mux_input_1(PCSecondSource),.mux_input_0(Pc4Out),.selection_bit(PCMuxSelector),.mux_out(PCInput));
    
    NBit2x1Mux #(32) RegMux(.mux_input_1(ImmGenOut),.mux_input_0(Rs2Read),.selection_bit(ALUSrc),.mux_out(Alu2ndSource));
    
    ALU_32_bit ALU_32_bit_inst(.instruction5(instruction5),.a(Rs1Read),.b(Alu2ndSource),.shamt(instruction[`IR_shamt]),.r(AluOut),.cf(CarryFlag), .zf(Zflag), .vf(OverflowFlag), .sf(SignFlag), .alufn(ALUSelection));
    
    BranchControlUnit BranchControlUnit_inst(.Branch(Branch),.cf(CarryFlag),.zf(Zflag),.vf(OverflowFlag),.sf(SignFlag),.func3(instruction[`IR_funct3]),.branchMuxSelect(branchMuxSelect));
    
    DataMemory dataMem(.clk(clk),.MemRead(MemRead),.MemWrite(MemWrite),.func3(instruction[`IR_funct3]),.addr(AluOut),.data_in(Rs2Read),.data_out(MemOut));
    
    NBit2x1Mux #(32) dataMux(.mux_input_1(MemOut),.mux_input_0(AluOut),.selection_bit(MemtoReg),.mux_out(RegFileInputData));
    
    FourByOneMux RegisterFileWriteDataMux(.mux_input_3(Pc4Out),.mux_input_2(BranchTarget),.mux_input_1(ImmGenOut),.mux_input_0(RegFileInputData),.selection_bits(rfWriteSelect),.mux_out(FinalRegFileData));
    
endmodule
