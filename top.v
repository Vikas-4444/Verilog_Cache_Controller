`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/09/2025 11:34:41 PM
// Design Name: 
// Module Name: top
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


module top_module_tb;

    reg clk = 0;
    reg reset;
    reg read_en, write_en;
    reg [7:0] address, write_data;
    wire [7:0] read_data;
    wire hit;

    // Memory wires
    wire mem_read_en, mem_write_en;
    wire [7:0] mem_address, mem_write_data;
    wire [7:0] mem_read_data;

    // Instantiate main memory
    main_memory mem (
        .clk(clk),
        .read_en(mem_read_en),
        .write_en(mem_write_en),
        .address(mem_address),
        .write_data(mem_write_data),
        .read_data(mem_read_data)
    );

    // Instantiate cache controller
    cache_controller cache (
        .clk(clk),
        .reset(reset),
        .read_en(read_en),
        .write_en(write_en),
        .address(address),
        .write_data(write_data),
        .read_data(read_data),
        .hit(hit),
        .mem_read_en(mem_read_en),
        .mem_write_en(mem_write_en),
        .mem_address(mem_address),
        .mem_write_data(mem_write_data),
        .mem_read_data(mem_read_data)
    );

    always #5 clk = ~clk; // 10 time unit clock

    initial begin
        $display("=== Simple Cache Controller Test ===");
        reset = 1;
        #10 reset = 0;

        // Write to 0x10
        address = 8'h10; write_data = 8'hAA;
        write_en = 1; read_en = 0;
        #10 write_en = 0;

        // Read from 0x10
        read_en = 1;
        #10 read_en = 0;
        $display("Read 0x10 = %h | Hit = %b", read_data, hit);

        // Read from 0x20 (miss expected)
        address = 8'h20; read_en = 1;
        #10 read_en = 0;
        $display("Read 0x20 = %h | Hit = %b", read_data, hit);

        // Read from 0x10 again (should hit)
        address = 8'h10; read_en = 1;
        #10 read_en = 0;
        $display("Read 0x10 again = %h | Hit = %b", read_data, hit);

        #50 $finish;
    end

endmodule

