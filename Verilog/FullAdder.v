`timescale 1ns / 1ps
`include "defines.v"
/*******************************************************************
*
* Module: FullAdder.v
* Project: SingleCycleRV32I
* Author: Omar Elfouly omarelfouly@aucegypt.edu and Bavly Remon bavly.remon2004@aucegypt.edu
* Description: module responsible for implmenting a full adder
*
* Change history:   11/3/2023 - Import from lab 6
*                   11/3/2023 - Adds Comment and includes define
*
**********************************************************************/


module FullAdder( input input_1, input input_0, input Carry_in, output Sum, output Carry_out);
    assign {Carry_out,Sum} = input_1 + input_0 + Carry_in;
endmodule 
