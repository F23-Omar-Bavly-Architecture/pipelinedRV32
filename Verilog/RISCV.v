`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2023 11:43:53 AM
// Design Name: 
// Module Name: TOPModule
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RISCV(
    input clk,
    input reset,
    input [1:0] ledSel,
    input [3:0] ssdSel,
    //input SSD_clk,
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
    wire BranchAndGate;
    assign leds = (ledSel==2'b00)? instruction [15:0] : ((ledSel==2'b01)?instruction [31:16] : {2'b00,Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite,ALUSelection, Zflag , BranchAndGate });
    
    wire[7:0] PCOutput;
    wire[7:0] Pc4Out;
    wire[7:0] BranchTarget;
    wire[7:0] PCInput;
    wire[31:0] Rs1Read;
    wire[31:0] Rs2Read;
    wire[31:0] RegFileInputData;
    wire[31:0] ImmGenOut;
    wire[31:0] ShiftLeft1Out;
    wire[31:0] Alu2ndSource;
    wire[31:0] AluOut;
    wire[31:0] MemOut;
    
    
    always@(*) begin
        case(ssdSel)
            0: begin
            ssd= { 5'b00000 , PCOutput[7:0]};
            end
            1: begin
            ssd= { 5'b00000 , Pc4Out[7:0]};
            end
            2: begin
            ssd= { 5'b00000 , BranchTarget[7:0]};
            end
            3: begin
            ssd= { 5'b00000 , PCInput[7:0]};
            end
            4: begin
            ssd=Rs1Read[12:0];
            end
            5: begin
            ssd= Rs2Read[12:0];
            end
            6: begin
            ssd= RegFileInputData[12:0];
            end
            7: begin
            ssd= ImmGenOut[12:0];
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
    
    NBitRegister #(8) PC(.clk(clk),.rst(reset),.load(1'b1),.D(PCInput),.Q(PCOutput));
    //wire [5:0] const4;
    //assign cosnt4 = 6'd1;// adding 1 due to instruction memory being stored 1 addr away from each other
    wire ignore;
    NbitRCA #(8) add4ToPC(.A(PCOutput),.B(8'd4),.Cin(0),.Sum(Pc4Out),.Cout(ignore));
    
    InstructionMemory inst(.addr(PCOutput[7:2]),.data_out(instruction));
    
    ControlUnit CU (.inst(instruction[6:2]),.Branch(Branch),.MemRead(MemRead),.MemtoReg(MemtoReg),.ALUOp(ALUOp),.MemWrite(MemWrite),.ALUSrc(ALUSrc),.RegWrite(RegWrite));
    
    RegFile #(32) RF(.clk(clk),.reset(reset),.write_data(RegFileInputData),.read_reg_1(instruction[19:15]), .read_reg_2(instruction[24:20]),.write_reg(instruction[11:7]),.RegWrite(RegWrite),.read_data_1(Rs1Read),.read_data_2(Rs2Read));
    
    ImmGen immgen(.inst(instruction),.gen_out(ImmGenOut));
    
    ALUControlUnit aluCU(.ALUOp(ALUOp),.inst(instruction[14:12]),.inst30(instruction[30]),.ALUSelection(ALUSelection));
    
    NBitShiftLeft1 #(32) ShiftLeft(.X(ImmGenOut),.Y(ShiftLeft1Out));
    
    wire ignore1;
    NbitRCA #(8) PCBranchCalc(.A(PCOutput),.B(ShiftLeft1Out[7:0]),.Cin(0),.Sum(BranchTarget),.Cout(ignore1));
    
    NBit2x1Mux #(8) PCMux(.A(BranchTarget),.B(Pc4Out),.S(BranchAndGate),.out(PCInput));
    
    NBit2x1Mux #(32) RegMux(.A(ImmGenOut),.B(Rs2Read),.S(ALUSrc),.out(Alu2ndSource));
    
    NbitAlu#(32) alu(.A(Rs1Read),.B(Alu2ndSource),.S(ALUSelection),.out(AluOut),.Zflag(Zflag));
    
    assign BranchAndGate = Zflag & Branch;
    
    DataMemory dataMem(.clk(clk),.MemRead(MemRead),.MemWrite(MemWrite),.addr(AluOut[7:2]),.data_in(Rs2Read),.data_out(MemOut));
    
    NBit2x1Mux #(32) dataMux(.A(MemOut),.B(AluOut),.S(MemtoReg),.out(RegFileInputData));
    
endmodule
