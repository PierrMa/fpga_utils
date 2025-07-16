`timescale 1ns / 1ps
module d_flip_flop_tb;
    bit d,q,rst,clk=1;
    
    d_flip_flop dut(d,rst,clk,q);
    
    always #5 clk = ~clk;
    
    initial begin
        rst = 0;
        #15;
        rst = 1;
        #10;
        rst = 0;
    end
    
    initial begin
        d = 1; #30
        repeat(10) begin
            d = $urandom_range(0,1);
            #10;
            assert (d==q) else $error("d = %b, q = %b",d,q);
        end
        $finish;
    end
endmodule
