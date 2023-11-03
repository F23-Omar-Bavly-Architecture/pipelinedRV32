`timescale 1ns / 1ps
`include "defines.v"
/*******************************************************************
*
* Module: NBit2x1Mux.v
* Project: SingleCycleRV32I
* Author: Omar Elfouly omarelfouly@aucegypt.edu and Bavly Remon bavly.remon2004@aucegypt.edu
* Description: module responsible for defining a 2 by 1 mux that takes an n bit input
*
* Change history:   11/3/2023 - Import from lab 6
*                   11/3/2023 - Adds Comment and includes define
*
**********************************************************************/


module NBit2x1Mux#(parameter N=32)(input [N-1:0] mux_input_1,input [N-1:0] mux_input_0, output [N-1:0] mux_out, input selection_bit);
    genvar i;
    generate 
        for(i = 0; i<N;i=i+1) begin 
            TwoXOneMux mux_inst(.mux_input_1(mux_input_1[i]),.mux_input_0(mux_input_0[i]),.mux_out(mux_out[i]),.selection_bit(selection_bit));
        end
    endgenerate 
endmodule