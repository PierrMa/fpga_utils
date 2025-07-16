`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2025 17:02:08
// Design Name: 
// Module Name: demux1v4
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


module demux1v4(
    input logic E,
    input logic[1:0] sel,
    output logic[3:0] S
    );
    
    always_comb begin
        S = 4'b0000;
        case(sel) 
        2'b00: S[0] = E;
        2'b01: S[1] = E;
        2'b10: S[2] = E;
        2'b11: S[3] = E;
        default : S = 4'b0000;
        endcase
    end
endmodule
