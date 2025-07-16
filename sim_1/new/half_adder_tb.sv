`timescale 1ns / 1ps

interface intf(logic clk);
    logic a,b,s,c;
    modport tb(output a,b, input s,c);
    modport rtl(input a,b, output s,c);
    
    clocking cb @(posedge clk);
        default input #2 output #2;
        input s,c;
        output a,b;
    endclocking
endinterface: intf

module half_adder_tb;
    intf ha_itf();
    bit clk = 1'b0;
    bit rst = 1'b1;
    half_adder dut(ha_itf,clk,rst);
    
    always #5ns clk = ~clk;
    
    initial begin
        ha_itf.tb.a = 1'b0; ha_itf.tb.b = 1'b0; 
        #10
        rst = 0;
        #10;
        assert (ha_itf.tb.s==0 && ha_itf.tb.c == 0) else $error("0+0!=0");
        ha_itf.tb.a = 1'b0; ha_itf.tb.b = 1'b1;
        #10;
        assert (ha_itf.tb.s==1 && ha_itf.tb.c == 0) else $error("0+1!=1");
        ha_itf.tb.a = 1'b1; ha_itf.tb.b = 1'b0;
        #10;
        assert (ha_itf.tb.s==1 && ha_itf.tb.c == 0) else $error("1+0!=1");
        ha_itf.tb.a = 1'b1; ha_itf.tb.b = 1'b1;
        #10;
        assert (ha_itf.s==0 && ha_itf.c == 1) else $error("1+1!=10");
        #10;
    end
endmodule
