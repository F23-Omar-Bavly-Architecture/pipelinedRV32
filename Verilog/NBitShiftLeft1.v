`timescale 1ns / 1ps
`include "defines.v"
/*******************************************************************
*
* Module: NBitShiftLeft1.v
* Project: SingleCycleRV32I
* Author: Omar Elfouly omarelfouly@aucegypt.edu and Bavly Remon bavly.remon2004@aucegypt.edu
* Description: module responsible for implmenting a module that preforms a 1 bit shift left operation on an n bit input
*
* Change history:   11/3/2023 - Import from lab 6
*                   11/3/2023 - Adds Comment and includes define
*
**********************************************************************/


module NBitShiftLeft1 #(parameter N = 32) (input [N-1 : 0] input_data, output [N-1 : 0] output_data);
    assign output_data = {input_data[N-2:0],1'b0};
endmodule
