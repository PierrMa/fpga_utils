`timescale 1ns / 1ps


module full_adder_tb;
logic a,b,cin,s,cout;
full_adder dut(a,b,cin,s,cout);
initial begin
    a = 1'b0; b = 1'b0; cin = 1'b0; #10;
    assert (s==0 & cout==0) else $error("0+0+0!=0");
    a = 1'b0; b = 1'b1; cin = 1'b0; #10;
    assert (s==1 & cout==0) else $error("0+1+0!=1");
    a = 1'b1; b = 1'b0; cin = 1'b0; #10;
    assert (s==1 & cout==0) else $error("1+0+0!=1");
    a = 1'b1; b = 1'b1; cin = 1'b0; #10;
    assert (s==0 & cout==1) else $error("1+1+0!=10");
    a = 1'b0; b = 1'b0; cin = 1'b1; #10;
    assert (s==1 & cout==0) else $error("0+0+1!=1");
    a = 1'b0; b = 1'b1; cin = 1'b1; #10;
    assert (s==0 & cout==1) else $error("0+1+1!=10");
    a = 1'b1; b = 1'b0; cin = 1'b1; #10;
    assert (s==0 & cout==1) else $error("1+0+1!=10");
    a = 1'b1; b = 1'b1; cin = 1'b1; #10;
    assert (s==1 & cout==1) else $error("1+1+1!=11");
end;
endmodule
