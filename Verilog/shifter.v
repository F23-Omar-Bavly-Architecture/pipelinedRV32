`timescale 1ns / 1ps
`include "defines.v"
/*******************************************************************
*
* Module: shifter.v
* Project: SingleCycleRV32I
* Author: Omar Elfouly omarelfouly@aucegypt.edu and Bavly Remon bavly.remon2004@aucegypt.edu
* Description: module responsible for implmenting a shifter that will be used by the ALU
*
* Change history:   11/3/2023 - Created shifter (incomplete)
*
**********************************************************************/

module shifter(
    input   wire [31:0] a,
    input   wire [4:0]  shamt,
    input   wire [1:0]  type,
    output  reg  [31:0] r
    );
    
    
    
    
endmodule