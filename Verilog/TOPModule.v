`timescale 1ns / 1ps
`include "defines.v"
/*******************************************************************
*
* Module: TOPModule.v
* Project: SingleCycleRV32I
* Author: Omar Elfouly omarelfouly@aucegypt.edu and Bavly Remon bavly.remon2004@aucegypt.edu
* Description: module responsible for organising RISCV and SevenSegDisplay inputs and outputs
*
* Change history:   11/3/2023 - Import from lab 6
*                   11/3/2023 - Adds Comment and includes define
*
**********************************************************************/


module topModule(
    input clk,
    input rst,
    input [1:0] led_Selection,
    input [3:0] ssd_Selection,
    input clk_ssd_button,
    output [15:0] leds,
    output [7:0] anode_active,
    output [6:0] segments
    );
    wire [12:0] sevenSegDisplayInput;
    SevenSegDisplay sevenSeg(.clk(clk_ssd_button),.num(sevenSegDisplayInput),.anode_active(anode_active),.segments(segments));
    RISCV_CPU computer(.clk(clk),.rst(rst),.led_Selection(led_Selection),.ssd_Selection(ssd_Selection),.leds(leds),.ssd(sevenSegDisplayInput));
    
    endmodule 
