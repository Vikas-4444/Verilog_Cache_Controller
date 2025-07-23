`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/09/2025 11:34:19 PM
// Design Name: 
// Module Name: MainMemory
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


module main_memory (
    input clk,
    input read_en,
    input write_en,
    input [7:0] address,
    input [7:0] write_data,
    output reg [7:0] read_data
);

    reg [7:0] memory [0:255];

    initial begin
        memory[8'h10] = 8'hA1;
        memory[8'h20] = 8'hB2;
        memory[8'h30] = 8'hC3;
        memory[8'h40] = 8'hD4;
    end

    always @(posedge clk) begin
        if (read_en)
            read_data <= memory[address];
        if (write_en)
            memory[address] <= write_data;
    end

endmodule

