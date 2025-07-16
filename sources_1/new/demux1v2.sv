`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2025 16:35:15
// Design Name: 
// Module Name: demux1v2
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


module demux1v2(
    input logic E, sel,
    output logic[1:0] S
    );
    
    always_comb begin
        if(sel==0) begin
        S[1] = 0;
        S[0] = E;
        end
        else begin
        S[0] = 0;
        S[1] = E;
        end
    end
endmodule
