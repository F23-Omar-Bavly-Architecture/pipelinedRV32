`timescale 1ns / 1ps
`include "defines.v"
/*******************************************************************
*
* Module: DataMemory.v
* Project: SingleCycleRV32I
* Author: Omar Elfouly omarelfouly@aucegypt.edu and Bavly Remon bavly.remon2004@aucegypt.edu
* Description: module responsible for implmenting Data Memory
*
* Change history:   11/3/2023 - Import from lab 6
*                   11/3/2023 - Adds Comment and includes define
*                   11/3/2023 - Adapts to byte addressable
*                   11/3/2023 - Added funct3
*
**********************************************************************/


module DataMemory(input clk, input MemRead, input MemWrite, input [2:0] func3, input [31:0] addr, input [31:0] data_in, output reg [31:0] data_out);

//    reg [7:0] mem [1024-1:0];
    reg [31:0] mem [1024/2-1:0];
    integer byte0, byte1, byte2, byte3, Byte0_word, Byte1_word, Byte2_word, Byte3_word, read_byte0_LSB, read_byte0_MSB, read_byte1_LSB, read_byte1_MSB, 
    read_byte2_LSB, read_byte2_MSB, read_byte3_LSB, read_byte3_MSB;
    always@(*) begin
        byte0 = addr;
        byte1 = addr+1;
        byte2 = addr+2;
        byte3 = addr+3;
    
        Byte0_word = byte0/4;
        Byte1_word = (byte1)/4;
        Byte2_word = (byte2)/4;
        Byte3_word = (byte3)/4;
        
        read_byte0_LSB = (byte0%4)*8;
        read_byte0_MSB = read_byte0_LSB+7; 
        
        read_byte1_LSB = (byte1%4)*8;
        read_byte1_MSB = read_byte1_LSB+7; 
        
        read_byte2_LSB = (byte2%4)*8;
        read_byte2_MSB = read_byte2_LSB+7; 
        
        read_byte3_LSB = (byte3%4)*8;
        read_byte3_MSB = read_byte3_LSB+7;
        
        
        if(MemRead) begin
            case(func3)
                0: data_out = {{24{mem[ Byte0_word ][ read_byte0_MSB ]}} , mem[Byte0_word][ read_byte0_MSB : read_byte0_LSB ]};
                1: data_out = {{16{mem[ Byte1_word ][read_byte1_MSB]}},mem[Byte1_word][ read_byte1_MSB : read_byte1_LSB ],mem[ Byte0_word ][ read_byte0_MSB : read_byte0_LSB ]};
                2: data_out = {mem[Byte3_word][ read_byte3_MSB : read_byte3_LSB ],mem[Byte2_word][ read_byte2_MSB : read_byte2_LSB ],mem[Byte1_word][ read_byte1_MSB : read_byte1_LSB ],mem[ Byte0_word ][ read_byte0_MSB : read_byte0_LSB ]};
                4: data_out = {{24{1'b0}} , mem[Byte0_word][ read_byte0_MSB : read_byte0_LSB ]};
                5: data_out = {{16{1'b0}},mem[Byte1_word][ read_byte1_MSB : read_byte1_LSB ],mem[ Byte0_word ][ read_byte0_MSB : read_byte0_LSB ]};
                default: data_out = 0;
            endcase
        end else begin
            data_out = 0;
        end
    end
    
    always@(posedge clk) begin
        if(MemWrite) begin
            case(func3) 
                0: mem[addr[31:2]] <= {mem[addr[31:2]][31:8], data_in[7:0]};
                1: begin
                   mem[addr[31:2]] <= { mem[addr[31:2]][31:16], data_in[15:0]};
                end
                2: begin
                    mem[addr[31:2]] <= data_in;/*
                    mem[addr+3] <= data_in[31:24] ;
                    mem[addr+2] <= data_in[23:16];
                    mem[addr+1] <= data_in[15:8];
                    mem[addr] <= data_in[7:0];*/
                end
                default: mem[addr[31:2]] = data_in;
            endcase
        end
    end
    
    initial begin
        //$readmemh("./hex/test1_data.hex", mem);
        {mem[3],mem[2],mem[1],mem[0]}=32'd17;
        {mem[7],mem[6],mem[5],mem[4]}=32'd9;
        {mem[11],mem[10],mem[9],mem[8]}=32'd25;
    end
endmodule
