`timescale 1ns / 1ps

module nbits_ripple_adder_tb;

    logic[3:0] a, b;
    logic cin;
    logic [3:0] s;
    logic cout;
    logic[4:0] expected;

    //nbits_ripple_adder dut(a,b,cin,s,cout);
    nbits_cla_adder dut(a,b,cin,s,cout);
    
    initial begin;
        repeat(10) begin
            a <= $urandom_range(4'h0, 4'hF);
            b <= $urandom_range(4'h0, 4'hF);
            cin <= $urandom_range(1'b0, 1'b1);
            #10;
            expected = a+b+cin;
            assert({cout,s}==expected) else $error("Wrong result: a = %d, b = %d, cin = %d, cout = %d, s = %d, expected = %d",a,b,cin,cout,s,expected);
        end
        $finish;
    end
endmodule
