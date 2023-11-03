`timescale 1ns / 1ps
`include "defines.v"
/*******************************************************************
*
* Module: DFlipFlop.v
* Project: SingleCycleRV32I
* Author: Omar Elfouly omarelfouly@aucegypt.edu and Bavly Remon bavly.remon2004@aucegypt.edu
* Description: module responsible for a flip flop
*
* Change history:   11/3/2023 - Import from lab 6
*                   11/3/2023 - Adds Comment and includes define
*
**********************************************************************/


module DFlipFlop(input clk, input rst, input D, output reg Q);
    always @ (posedge clk or posedge rst)
        if (rst) begin
            Q <= 1'b0;
        end else begin
            Q <= D;
    end
endmodule
