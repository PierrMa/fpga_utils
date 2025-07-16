`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.07.2025 10:48:31
// Design Name: 
// Module Name: half_adder
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


module half_adder(intf ha_itf,
    //input logic a,b,
    //output logic s,c
    input clk,rst
    );
    
    always @(posedge clk) begin
        if(rst == 1) begin
            ha_itf.s = 0;
            ha_itf.c = 0;
        end else begin
            ha_itf.s = ha_itf.a ^ ha_itf.b;
            ha_itf.c = ha_itf.a & ha_itf.b;
        end;
    end
    
endmodule
