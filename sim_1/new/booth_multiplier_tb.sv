`timescale 1ns / 1ps
module booth_multiplier_tb #(parameter N=4);
    logic [N-1:0] a,b;
    logic [2*N-1:0] s;
    bit start;
    logic [2*N-1:0] expected;
    bit rst;
    bit clk = 1;
    always #5 clk = ~clk;
    
    booth_multiplier dut(a,b,s,start,clk,rst);
    
    initial begin
        rst = 1; #10
        rst = 0;
        start = 1;
        repeat(10) begin
            a <= $urandom_range(0,7);
            b <= $urandom_range(0,7);
            #1
            expected <= a*b;
            wait(dut.actual_st == 7); //7<=> DONE dans enum state_type
            assert(expected==s) else $error("a = %d, b = %d, s = %d, expected = %d",a,b,s,expected);
            #10;
        end
        repeat(10) begin
            a <= -$urandom_range(0,7);
            b <= -$urandom_range(0,7);
            #1
            expected <= a*b;
            wait(dut.actual_st == 7); //7<=> DONE dans enum state_type
            assert(expected==s) else $error("a = %d, b = %d, s = %d, expected = %d",a,b,s,expected);
            #10;
        end
        $finish;
    end
endmodule
