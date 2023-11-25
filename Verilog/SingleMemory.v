`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2023 10:52:41 PM
// Design Name: 
// Module Name: SingleMemory
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


module SingleMemory(input clk, input MemRead, input MemWrite, 
input [2:0] func3, input [31:0] addr, input [31:0] data_in, output reg [31:0] data_out
    );
    reg [7:0] mem [1024-1:0];
    
    always@(*) begin
        if(!(MemRead && MemWrite)) begin //fetching
            data_out = {mem[{addr[31:2],2'b11}],mem[{addr[31:2],2'b10}],mem[{addr[31:2],2'b01}],mem[{addr[31:2],2'b00}]};
        end else begin
            if(MemRead)
                case(func3) // read
                    0: data_out = {{24{mem[addr][7]}} , mem[addr]};
                    1: data_out = {{16{mem[addr+1][7]}},mem[addr+1],mem[addr]};
                    2: data_out = {mem[addr+3],mem[addr+2],mem[addr+1],mem[addr]};
                    4: data_out = {{24{1'b0}} , mem[addr]};
                    5: data_out = {{16{1'b0}},mem[addr+1],mem[addr]};
                    default: data_out = 0;
                endcase
            else data_out = 0; // dont read
        end
    end
    
    always@(posedge clk) begin
        if(MemWrite) begin
            case(func3) 
                0: mem[addr] <= data_in[7:0];
                1: begin
                   mem[addr] <= data_in[7:0];
                   mem[addr+1] <= data_in[15:8];
                end
                2: begin
                    mem[addr+3] <= data_in[31:24] ;
                    mem[addr+2] <= data_in[23:16];
                    mem[addr+1] <= data_in[15:8];
                    mem[addr] <= data_in[7:0];
                end
                default: mem[addr] <= data_in[7:0];
            endcase
        end
    end
    
    initial begin
        
        {mem[3],mem[2],mem[1],mem[0]}     = 32'b0000000_00000_00000_000_00000_0110011;  //add x0, x0, x0
        
        {mem[7],mem[6],mem[5],mem[4]}     = 32'b00000110010000000010000010000011; //lw x1, 100(x0) 
        
        {mem[11],mem[10],mem[9],mem[8]}   = 32'b00000110100000000010000100000011 ; //lw x2, 104(x0) 
        
        {mem[15],mem[14],mem[13],mem[12]} = 32'b00000110110000000010000110000011 ; //lw x3, 108(x0) 
        
        {mem[19],mem[18],mem[17],mem[16]} = 32'b0000000_00010_00001_110_00100_0110011 ; //or x4, x1, x2 
        
        {mem[23],mem[22],mem[21],mem[20]} = 32'b00000000001100100000010001100011; //beq x4, x3, 16 
        
        {mem[27],mem[26],mem[25],mem[24]} = 32'b0000000_00010_00001_000_00011_0110011 ; //add x3, x1, x2
        
        {mem[31],mem[30],mem[29],mem[28]} = 32'b0000000_00010_00011_000_00101_0110011 ; //add x5, x3, x2
        
        {mem[35],mem[34],mem[33],mem[32]} = 32'b00000110010100000010100000100011; //sw x5, 112(x0) 
        
        {mem[39],mem[38],mem[37],mem[36]} = 32'b00000111000000000010001100000011 ; //lw x6, 112(x0)
        
        {mem[43],mem[42],mem[41],mem[40]} = 32'b0000000_00001_00110_111_00111_0110011 ; //and x7, x6, x1 
        
        {mem[47],mem[46],mem[45],mem[44]} = 32'b0100000_00010_00001_000_01000_0110011 ; //sub x8, x1, x2    
        
        {mem[51],mem[50],mem[49],mem[48]} = 32'b0000000_00010_00001_000_00000_0110011 ; //add x0, x1, x2 
        
        {mem[55],mem[54],mem[53],mem[52]} = 32'b0000000_00001_00000_000_01001_0110011 ; //add x9, x0, x1
        
        {mem[103],mem[102],mem[101],mem[100]}=32'd17;
        {mem[107],mem[106],mem[105],mem[104]}=32'd9;
        {mem[111],mem[110],mem[109],mem[108]}=32'd25;
    end
    
endmodule
