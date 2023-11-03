`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2023 11:35:02 AM
// Design Name: 
// Module Name: RegFile
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


module RegFile #(parameter N =32)(
    input clk,
    input reset,
    input [N-1:0] write_data,
    input [4:0] read_reg_1,
    input [4:0] read_reg_2,
    input [4:0] write_reg,
    input RegWrite,
    output [N-1:0] read_data_1,
    output [N-1:0] read_data_2
    );
    reg [N-1:0] reg_file[31:0];
    integer j;
    always @(posedge clk) begin //if async add 
        if(reset) begin
            for(j=0;j<32;j=j+1) begin 
                reg_file[j]<=0;
            end
        end
        else begin
            if(RegWrite && write_reg != 0) reg_file[write_reg] <= write_data;
        end
    end
    assign read_data_1 = reg_file [read_reg_1]; 
    assign read_data_2 = reg_file [read_reg_2]; 
endmodule
