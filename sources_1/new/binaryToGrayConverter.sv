`timescale 1ns / 1ps

module binaryToGrayConverter(
    input logic[3:0]E,
    output logic[3:0]S
    );
    
    genvar i;
    generate
        for(i = 0 ;i<3;i++)begin
            assign S[i] = E[i]^E[i+1];
        end
    endgenerate
    
    assign S[3] = E[3];

endmodule
