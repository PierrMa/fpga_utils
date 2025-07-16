`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2025 15:37:09
// Design Name: 
// Module Name: mux8v1
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


module mux8v1 (
    input  logic [7:0] D,      // 8 entrées de données : D[0] à D[7]
    input  logic [2:0] sel,    // Sélecteur 3 bits (pour choisir l'une des 8 entrées)
    output logic       Y       // Sortie
);

    always_comb begin
        case (sel)
            3'd0: Y = D[0];
            3'd1: Y = D[1];
            3'd2: Y = D[2];
            3'd3: Y = D[3];
            3'd4: Y = D[4];
            3'd5: Y = D[5];
            3'd6: Y = D[6];
            3'd7: Y = D[7];
            default: Y = 1'b0; // Par sécurité
        endcase
    end

endmodule

