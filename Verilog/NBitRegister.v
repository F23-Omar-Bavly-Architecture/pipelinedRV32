`timescale 1ns / 1ps
`include "defines.v"
/*******************************************************************
*
* Module: NBitRegister.v
* Project: SingleCycleRV32I
* Author: Omar Elfouly omarelfouly@aucegypt.edu and Bavly Remon bavly.remon2004@aucegypt.edu
* Description: module responsible for an n bit register
*
* Change history:   11/3/2023 - Import from lab 6
*                   11/3/2023 - Adds Comment and includes define
*
**********************************************************************/


module NBitRegister#(parameter N =32)(input clk, input rst, input load , input [N-1:0] D,output [N-1:0] Q);
    genvar i;
    wire [N-1:0] muxOut;
    generate
        for(i = 0; i<N ; i=i+1) begin
            TwoXOneMux mux_inst(.mux_input_1(D[i]),.mux_input_0(Q[i]),.selection_bit(load),.mux_out(muxOut[i]));
            DFlipFlop DFF_inst(.clk(clk),.rst(rst),.D(muxOut[i]),.Q(Q[i]));
        end
    endgenerate
endmodule
