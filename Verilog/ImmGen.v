`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2023 11:38:02 AM
// Design Name: 
// Module Name: ImmGen
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


module ImmGen(output reg [31:0] gen_out, input [31:0] inst);
    //reg [31:0] gen_out;
    always@(*) begin
        if(inst[6]==1'b1) begin
        // beq
        gen_out[11:0] = {inst[31], inst[7], inst[30:25], inst[11:8]};
        end else if(inst[5]==1'b1) begin
        // sw
        gen_out[11:0] = {inst[31:25],inst[11:7]};
        end else begin
        // lw
        gen_out[11:0] = inst[31:20];
        end
        gen_out[31:12] = {20{gen_out[11]}};
    end
endmodule
