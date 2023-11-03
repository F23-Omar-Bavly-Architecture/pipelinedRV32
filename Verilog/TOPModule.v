`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2023 11:43:53 AM
// Design Name: 
// Module Name: TOPModule
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module topModule(
    input clk,
    input reset,
    input [1:0] ledSel,
    input [3:0] ssdSel,
    input SSD_clk,
    output [15:0] leds,
    output [7:0] Anode,
    output [6:0] LED_out
    );
    wire [12:0] sevenSegIn;
    SevenSegDisplay sevenSeg(.clk(SSD_clk),.num(sevenSegIn),.Anode(Anode),.LED_out(LED_out));
    RISCV computer(.clk(clk),.reset(reset),.ledSel(ledSel),.ssdSel(ssdSel),.leds(leds),.ssd(sevenSegIn));
    
    endmodule 
