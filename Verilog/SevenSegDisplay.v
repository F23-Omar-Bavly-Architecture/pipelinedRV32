`timescale 1ns / 1ps
`include "defines.v"
/*******************************************************************
*
* Module: SevenSegDisplay.v
* Project: SingleCycleRV32I
* Author: Omar Elfouly omarelfouly@aucegypt.edu and Bavly Remon bavly.remon2004@aucegypt.edu
* Description: module responsible for displaying outputs on Seven segment display
*
* Change history:   11/3/2023 - Import from lab 6
*                   11/3/2023 - Adds Comment and includes define
*
**********************************************************************/


module SevenSegDisplay(
    input clk,
    input [12:0] num,
    output reg [7:0] anode_active,
    output reg [6:0] segments
    );
     
    wire [3:0] Thousands;
    wire [3:0] Hundreds;
    wire [3:0] Tens;
    wire [3:0] Ones;
    BinaryToBCD bcd_inst( .num(num), .Thousands(Thousands), .Hundreds(Hundreds), .Tens(Tens), .Ones(Ones));
    
    reg [3:0] LED_BCD;
    reg [19:0] refresh_counter = 0; // 20-bit counter
    wire [1:0] LED_activating_counter;
    always @(posedge clk)
        begin
            refresh_counter <= refresh_counter + 1;
        end
        
    assign LED_activating_counter = refresh_counter[19:18];
    always @(*)
    begin
        anode_active [7:4] = 4'b1111;
        case(LED_activating_counter)
            2'b00: begin
                anode_active [3:0] = 4'b0111;
                LED_BCD = Thousands ;
            end
            
            2'b01: begin
                anode_active[3:0] = 4'b1011;
                LED_BCD = Hundreds ;
            end
            
            2'b10: begin
                anode_active[3:0] = 4'b1101;
                LED_BCD = Tens ;
            end
            
            2'b11: begin
                anode_active[3:0] = 4'b1110;
                LED_BCD = Ones ;
            end
        
        endcase
    end
    always @(*)
        begin
            case(LED_BCD)
                4'b0000: segments = 7'b0000001; // "0"
                4'b0001: segments = 7'b1001111; // "1"
                4'b0010: segments = 7'b0010010; // "2"
                4'b0011: segments = 7'b0000110; // "3"
                4'b0100: segments = 7'b1001100; // "4"
                4'b0101: segments = 7'b0100100; // "5"
                4'b0110: segments = 7'b0100000; // "6"
                4'b0111: segments = 7'b0001111; // "7"
                4'b1000: segments = 7'b0000000; // "8"   
                4'b1001: segments = 7'b0000100; // "9"
                default: segments = 7'b0000001; // "0"
            endcase
        end
    
endmodule
