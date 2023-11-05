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
    /* old version
    reg [31:0] mem [0:63];
    assign data_out = MemRead? mem [addr] : 0;
    always@(posedge clk) begin
        if(MemWrite) begin
            mem[addr] = data_in ;
        end
    end
    
    initial begin
        mem[0]=32'd17;
        mem[1]=32'd9;
        mem[2]=32'd25;
    end */
    
    //reg [7:0] mem[(4*1024-1):0];
    reg [7:0] mem [1024-1:0];
    
    always@(*) begin
    case(func3)
        0: data_out = {{24{mem[addr][7]}} , mem[addr]};
        1: data_out = {{16{mem[addr+1][7]}},mem[addr+1],mem[addr]};
        2: data_out = {mem[addr+3],mem[addr+2],mem[addr+1],mem[addr]};
        4: data_out = {{24{1'b0}} , mem[addr]};
        5: data_out = {{16{1'b0}},mem[addr+1],mem[addr]};
        default: data_out = 0;
    endcase
    
    end
    
    always@(posedge clk) begin
        if(MemWrite) begin
            case(func3) 
                0: mem[addr] = data_in[7:0];
                1: begin
                   mem[addr] = data_in[7:0];
                   mem[addr+1] = data_in[15:8];
                end
                2: begin
                    mem[addr+3] = data_in[31:24] ;
                    mem[addr+2] = data_in[23:16];
                    mem[addr+1] = data_in[15:8];
                    mem[addr] = data_in[7:0];
                end
            endcase
        end
    end
    
    initial begin
        //$readmemh("./hex/test1_data.hex", mem);
        {mem[3],mem[2],mem[1],mem[0]}=32'd17;
    end
endmodule
