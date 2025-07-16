`timescale 1ns / 1ps
module d_flip_flop(
    input logic D, rst, clk,
    output logic Q
    );
    
    always_ff @(posedge clk or posedge rst) begin
        if(rst==1) Q <= 0;
        else Q <= D;
    end
endmodule
