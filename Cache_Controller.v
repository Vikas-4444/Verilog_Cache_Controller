`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/09/2025 11:36:17 PM
// Design Name: 
// Module Name: Cache_Controller
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


module cache_controller (
    input clk,
    input reset,
    input read_en,
    input write_en,
    input [7:0] address,
    input [7:0] write_data,
    output reg [7:0] read_data,
    output reg hit,

    // Main memory interface
    output reg mem_read_en,
    output reg mem_write_en,
    output reg [7:0] mem_address,
    output reg [7:0] mem_write_data,
    input      [7:0] mem_read_data
);

    // Cache: 4 sets, 2 ways
    reg [7:0] cache_data [0:3][0:1];
    reg [3:0] tag_array [0:3][0:1];
    reg       valid [0:3][0:1];
    reg       lru [0:3];  // 0 = way 0 is LRU, 1 = way 1 is LRU

    wire [1:0] index = address[3:2];
    wire [3:0] tag = address[7:4];

    integer i, j;

    initial begin
        for (i = 0; i < 4; i = i + 1)
            for (j = 0; j < 2; j = j + 1)
                valid[i][j] = 0;
    end

    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 4; i = i + 1) begin
                lru[i] <= 0;
                for (j = 0; j < 2; j = j + 1) begin
                    valid[i][j] <= 0;
                    cache_data[i][j] <= 0;
                    tag_array[i][j] <= 0;
                end
            end
            hit <= 0;
            read_data <= 0;
        end
        else begin
            mem_read_en <= 0;
            mem_write_en <= 0;
            hit <= 0;

            mem_address <= address;
            mem_write_data <= write_data;

            if (read_en) begin
                if (valid[index][0] && tag_array[index][0] == tag) begin
                    read_data <= cache_data[index][0];
                    hit <= 1;
                    lru[index] <= 1;
                end else if (valid[index][1] && tag_array[index][1] == tag) begin
                    read_data <= cache_data[index][1];
                    hit <= 1;
                    lru[index] <= 0;
                end else begin
                    hit <= 0;
                    mem_read_en <= 1;
                    #1; // small delay
                    read_data <= mem_read_data;

                    if (lru[index] == 0) begin
                        cache_data[index][0] <= mem_read_data;
                        tag_array[index][0] <= tag;
                        valid[index][0] <= 1;
                        lru[index] <= 1;
                    end else begin
                        cache_data[index][1] <= mem_read_data;
                        tag_array[index][1] <= tag;
                        valid[index][1] <= 1;
                        lru[index] <= 0;
                    end
                end
            end
            else if (write_en) begin
                mem_write_en <= 1;

                if (valid[index][0] && tag_array[index][0] == tag) begin
                    cache_data[index][0] <= write_data;
                    hit <= 1;
                    lru[index] <= 1;
                end else if (valid[index][1] && tag_array[index][1] == tag) begin
                    cache_data[index][1] <= write_data;
                    hit <= 1;
                    lru[index] <= 0;
                end else begin
                    if (lru[index] == 0) begin
                        cache_data[index][0] <= write_data;
                        tag_array[index][0] <= tag;
                        valid[index][0] <= 1;
                        lru[index] <= 1;
                    end else begin
                        cache_data[index][1] <= write_data;
                        tag_array[index][1] <= tag;
                        valid[index][1] <= 1;
                        lru[index] <= 0;
                    end
                end
            end
        end
    end
endmodule

