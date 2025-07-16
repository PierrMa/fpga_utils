`timescale 1ns / 1ps
module muxNv1#(parameter N = 4)(
    input logic[N-1:0] E,
    output logic S,
    input logic[$clog2(N)-1:0] sel
    );
    
    assign S = E[sel];
endmodule
