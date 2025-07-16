`timescale 1ns / 1ps

module nbits_ripple_adder #(parameter N=4)(
    input logic[N-1:0] a,b,
    input logic cin,
    output logic[N-1:0]s, 
    output logic cout
    );
    
    logic [N:0]c;
    assign c[0] = cin;
    assign cout = c[N];
    
    genvar i;
    generate
        for(i = 0; i<N; i++) begin
            full_adder fa_i(a[i],b[i],c[i],s[i],c[i+1]);
        end
    endgenerate
endmodule
