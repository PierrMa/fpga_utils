`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2025 17:19:11
// Design Name: 
// Module Name: demux1v4_tb
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


module demux1v4_tb;
    bit E;
    bit[1:0]sel;
    bit[3:0]S;

    demux1v4 dut(
        .E(E),
        .sel(sel),
        .S(S)
    );

    task print();
        $display("E = %0d, sel = %0d, S = %0h",E,sel,S);
    endtask

    initial begin
        for(int i=0; i<4; i++)begin
            sel = i;
            E = 1'b0; #10;
            print();
            E = 1'b1; #10;
            print();
        end
    end
endmodule
