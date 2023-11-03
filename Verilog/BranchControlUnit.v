`timescale 1ns / 1ps
`include "defines.v"
/*******************************************************************
*
* Module: BranchControlUnit.v
* Project: SingleCycleRV32I
* Author: Omar Elfouly omarelfouly@aucegypt.edu and Bavly Remon bavly.remon2004@aucegypt.edu
* Description: module responsible for deciding whether or not to branch
*
* Change history:   11/3/2023 - Import from Supproting Code
*                   11/3/2023 - Adds Comment and includes define
*
**********************************************************************/

module BranchControlUnit(
    input Branch, 
    input cf, 
    input zf,
    input vf, 
    input sf, 
    input [2:0] func3, 
    output reg branchMuxSelect
    );
    
    always@(*) begin
        if(Branch) begin
            case(func3)
                0: branchMuxSelect = zf;
                1: branchMuxSelect = ~zf;
                4: branchMuxSelect = sf != vf;
                5: branchMuxSelect = sf == vf;
                6: branchMuxSelect = ~cf;
                7: branchMuxSelect = cf;
            endcase
        end else begin
            branchMuxSelect =0;
        end
    
    end

endmodule