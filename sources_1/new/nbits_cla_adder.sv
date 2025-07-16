`timescale 1ns / 1ps

module nbits_cla_adder #(parameter N=4)(
    input logic[N-1:0]a,b,
    input logic cin,
    output logic[N-1:0]s,
    output logic cout
    );
    
    logic [N:0] c;
    
    assign c[0] = cin;
    assign cout = c[N];
    
    genvar i;
    generate
        for(i=0;i<N;i++) begin
            full_adder full_adder_i(a[i],b[i],c[i],s[i],c[i+1]);
        end 
    endgenerate
    
    initial begin
        for(int i=1;i<=N;i++) begin
            c[i] = (a[i-1]&b[i-1])|((a[i-1]^b[i-1])&c[i-1]);
        end
    end
endmodule
