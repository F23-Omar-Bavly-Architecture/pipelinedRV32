`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2023 11:41:42 AM
// Design Name: 
// Module Name: NBitRegister
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


module NBitRegister#(parameter N =32)(input clk, input rst,input load , input [N-1:0] D,output [N-1:0] Q);
    genvar i;
    wire [N-1:0] muxOut;
    generate
        for(i = 0; i<N ; i=i+1) begin
            TwoXOneMux mux_inst(.A(D[i]),.B(Q[i]),.S(load),.out(muxOut[i]));
            DFlipFlop DFF_inst(.clk(clk),.rst(rst),.D(muxOut[i]),.Q(Q[i]));
        end
    endgenerate
endmodule
