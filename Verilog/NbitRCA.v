`timescale 1ns / 1ps
`include "defines.v"
/*******************************************************************
*
* Module: NbitRCA.v
* Project: SingleCycleRV32I
* Author: Omar Elfouly omarelfouly@aucegypt.edu and Bavly Remon bavly.remon2004@aucegypt.edu
* Description: module responsible for implmenting an n bit ripple carry adder
*
* Change history:   11/3/2023 - Import from lab 6
*                   11/3/2023 - Adds Comment and includes define
*
**********************************************************************/


module NbitRCA #(N=8)(
    input [N-1:0] input_1,
    input [N-1:0] input_0,
    input Carry_in,
    output [N-1:0] Sum,
    output Carry_out
    );
    
    wire [N:0] Carrys;
    
    assign Carrys[0] = Carry_in;
    genvar i;
    
    generate
        for(i=0;i<N;i=i+1) begin
            FullAdder inst(.input_1(input_1[i]),.input_0(input_0[i]),.Carry_in(Carrys[i]),.Sum(Sum[i]),.Carry_out(Carrys[i+1]));
        end
    endgenerate
    
    
    assign Carry_out = Carrys[N];
    
endmodule
