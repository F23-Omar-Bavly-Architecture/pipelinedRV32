`timescale 1ns / 1ps
`include "defines.v"
/*******************************************************************
*
* Module: RISCV_CPU_tb.v
* Project: SingleCycleRV32I
* Author: Omar Elfouly omarelfouly@aucegypt.edu and Bavly Remon bavly.remon2004@aucegypt.edu
* Description: module responsible for simulating our code
*
* Change history:   11/5/2023 - Created file
*
**********************************************************************/



module RISCV_CPU_tb();

    localparam period = 100;
    reg clk;
    reg reset;
    reg [1:0] ledSel;
    reg [3:0] ssdSel;
    wire [15:0] leds;
    wire [12:0] ssd;
    
    RISCV_CPU  ut(clk,reset,ledSel,ssdSel,leds,ssd);
    
    initial begin
        clk =1'b0;
        forever #(period/2) clk = ~clk;
    end
    
    initial begin
        ssdSel =0;
        reset =1;
        #(period);
        reset =0;
        #(period*100);
       
        
        $finish;
        
    end

endmodule
