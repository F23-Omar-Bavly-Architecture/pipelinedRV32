`timescale 1ns / 1ps
`include "defines.v"
/*******************************************************************
*
* Module: FourByOneMux.v
* Project: SingleCycleRV32I
* Author: Omar Elfouly omarelfouly@aucegypt.edu and Bavly Remon bavly.remon2004@aucegypt.edu
* Description: module responsible for implmenting a 4 by 1 mux
*
* Change history:   11/3/2023 - Created
*
**********************************************************************/

module FourByOneMux(
    input [31:0] mux_input_0,
    input [31:0] mux_input_1,
    input [31:0] mux_input_2,
    input [31:0] mux_input_3,
    input [1:0] selection_bits,
    output reg [31:0] mux_out
    );
    
    always@(*) begin
        case(selection_bits)
            0:mux_out = mux_input_0;
            1:mux_out = mux_input_1;
            2:mux_out = mux_input_2;
            3:mux_out = mux_input_3;
            default: mux_out = mux_input_0;
        endcase 
    end

endmodule