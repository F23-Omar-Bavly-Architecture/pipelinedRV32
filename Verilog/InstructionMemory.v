`timescale 1ns / 1ps
`include "defines.v"
/*******************************************************************
*
* Module: InstructionMemory.v
* Project: SingleCycleRV32I
* Author: Omar Elfouly omarelfouly@aucegypt.edu and Bavly Remon bavly.remon2004@aucegypt.edu
* Description: module responsible for implmenting Instruction Memory
*
* Change history:   11/3/2023 - Import from lab 6
*                   11/3/2023 - Adds Comment and includes define
*                   11/3/2023 - Adapted to example given on slides
*
**********************************************************************/

module InstructionMemory (input [29:0] addr, output [31:0] data_out);
    /*reg [31:0] mem [0:63];
    assign data_out = mem[addr];
    initial begin
        mem[0]=32'b000000000000_00000_010_00001_0000011 ; //lw x1, 0(x0)
        mem[1]=32'b000000000100_00000_010_00010_0000011 ; //lw x2, 4(x0)
        mem[2]=32'b000000001000_00000_010_00011_0000011 ; //lw x3, 8(x0)
        mem[3]=32'b0000000_00010_00001_110_00100_0110011 ; //or x4, x1, x2
        mem[4]=32'b0_000000_00011_00100_000_0100_0_1100011; //beq x4, x3, 4
        mem[5]=32'b0000000_00010_00001_000_00011_0110011 ; //add x3, x1, x2
        mem[6]=32'b0000000_00010_00011_000_00101_0110011 ; //add x5, x3, x2
        mem[7]=32'b0000000_00101_00000_010_01100_0100011; //sw x5, 12(x0)
        mem[8]=32'b000000001100_00000_010_00110_0000011 ; //lw x6, 12(x0)
        mem[9]=32'b0000000_00001_00110_111_00111_0110011 ; //and x7, x6, x1
        mem[10]=32'b0100000_00010_00001_000_01000_0110011 ; //sub x8, x1, x2
        mem[11]=32'b0000000_00010_00001_000_00000_0110011 ; //add x0, x1, x2
        mem[12]=32'b0000000_00001_00000_000_01001_0110011 ; //add x9, x0, x1
    end */
    
    //reg [7:0] mem[(4*1024-1):0]; // 4 KB memory
//    reg [7:0] mem [1023:0];
    reg [7:0] mem [63:0];
    
    assign data_out = {mem[{addr,2'b11}],mem[{addr,2'b10}],mem[{addr,2'b01}],mem[{addr,2'b00}]};
    
    initial begin
//        $readmemh("../Test/Hex/test1_mem.hex", mem);
        // LUI test cases
        {mem[3],mem[2],mem[1],mem[0]}=32'b00000000000001100100000010110111; //lui x1, 100
        {mem[7],mem[6],mem[5],mem[4]}=32'b11111111111110011100000100110111; // lui x2,-100
        {mem[11],mem[10],mem[9],mem[8]}=32'b00000000000000000000000110110111; //lui x3, 0
        
        //AUIPC
        {mem[15],mem[14],mem[13],mem[12]}=32'b00000000000000000001001000010111;//auipc x4, 1
        {mem[19],mem[18],mem[17],mem[16]} = 32'b00000000000000000000001000010111; //auipc x4, 0
        {mem[23],mem[22],mem[21],mem[20]} = 32'b11111111111110011100001000010111; //auipc x4, -100
        
        //JAL
        {mem[27],mem[26],mem[25],mem[24]} = 32'b00000000100000000000001011101111; // jal x5, 8
        {mem[31],mem[30],mem[29],mem[28]} = 32'b00000000100000000000001011101111; //jal x5, 8
        {mem[35],mem[34],mem[33],mem[32]} = 32'b11111111110111111111001011101111; //jal x5, -4
        
        
        
        //{mem[39],mem[38],mem[37],mem[36]} = 32'b
    end

endmodule
