`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2025 14:21:55
// Design Name: 
// Module Name: mux2v1
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


module mux2v1(
    input logic A,B,sel,
    output logic S
);
    always_comb begin
        if(sel == 1'b0) S = A;
        else if(sel==1'b1) S = B;
    end
endmodule
