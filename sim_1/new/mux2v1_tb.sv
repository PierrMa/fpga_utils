`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2025 15:17:36
// Design Name: 
// Module Name: mux2v1_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mux2v1_tb;
    logic A, B, sel, S;
    mux2v1 dut(A,B,sel,S);
    
    function print();
     $display("A = %0d, B = %0d, sel = %0d, S = %0d",A,B,sel,S);
    endfunction
    
    initial begin
        A=0;B=0;
        sel = 1; #10;
        print();
        sel = 0; #10;
        print();
        
        A=0;B=1;
        sel = 1; #10;
        print();
        sel = 0; #10;
        print();
        
        A=1;B=0;
        sel = 1; #10;
        print();
        sel = 0; #10;
        print();
        
        A=1;B=1;
        sel = 1; #10;
        print();
        sel = 0; #10;
        print();
    end
endmodule
