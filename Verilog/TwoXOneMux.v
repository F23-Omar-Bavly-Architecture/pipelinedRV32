`timescale 1ns / 1ps
`include "defines.v"
/*******************************************************************
*
* Module: TwoXOneMux.v
* Project: SingleCycleRV32I
* Author: Omar Elfouly omarelfouly@aucegypt.edu and Bavly Remon bavly.remon2004@aucegypt.edu
* Description: module responsible for designing a 2 by one multiplexer
*
* Change history:   11/3/2023 - Import from lab 6
*                   11/3/2023 - Adds Comment and includes define
*
**********************************************************************/


module TwoXOneMux(input mux_input_1, input mux_input_0, input selection_bit, output mux_out);
    assign mux_out = (selection_bit)? mux_input_1 : mux_input_0;
endmodule
