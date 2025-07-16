`timescale 1ns / 1ps

module binaryToGrayConverter_tb;
    logic [3:0] E, S;
    
    binaryToGrayConverter dut(E,S);
    bit[3:0] expected;
    initial begin
        E = 4'b0000; #10;
        
        for(byte i=0;i<16;i++) begin
            E = E + 1;#1;
            expected = {E[3], E[3]^E[2], E[2]^E[1], E[1]^E[0]};
            assert (S==expected) else $error("E = %0b, S = %0b, expected = %0b",E,S,expected);
            #9;
        end
    end
endmodule
