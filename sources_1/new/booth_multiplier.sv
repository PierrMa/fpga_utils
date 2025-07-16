`timescale 1ns / 1ps

module booth_multiplier #(parameter N=4)(
    input logic signed[N-1:0] a,b,
    output logic signed[2*N-1:0] s,
    input logic start,clk,rst
    );
    
    typedef enum {IDLE, INIT, ANALYZE, ADD, SUB, SHIFT, CHECK, DONE} state_type;
    state_type actual_st, next_st;
    logic signed [N-1:0] m,q,acc;
    logic q_1,ready;
    logic[$clog2(N+1)-1:0] count;
    
    always_ff @( posedge clk) begin
        if(rst==1)begin
          actual_st  <= IDLE;
          acc    <= 0;
          q      <= 0;
          m      <= 0;
          q_1    <= 0;
          count  <= 0;
          ready  <= 0;
          s      <= 0;
        end else actual_st <= next_st;
    end
    
    always_comb begin
      case(actual_st)
        IDLE: begin
          ready = 1;
          if(start == 1) begin
            next_st = INIT;
            ready = 0;
          end
        end
        
        INIT: begin
          m     = a;
          q     = b;
          acc   = 0;
          q_1   = 0;
          count = N;
          next_st = ANALYZE;
        end
        
        ANALYZE : begin
          if (q[0] == 1 && q_1 == 0) next_st = SUB;
          else if (q[0] == 0 && q_1 == 1) next_st = ADD;
          else next_st = SHIFT;
        end
        
        ADD : begin
          acc = acc + m;
          next_st = SHIFT;
        end
        
        SUB : begin
          acc = acc - m;
          next_st = SHIFT;
        end
        
        SHIFT : begin
          q_1 = q[0];
          q   = {acc[0],q[N-1:1]};
          acc = {acc[N-1],acc[N-1:1]};
          count = count - 1;
          next_st = CHECK;
        end
        
        CHECK : begin
          if(count == 0) next_st = DONE;
          else next_st = ANALYZE;
        end
        
        DONE : begin
          s = {acc,q};
          ready = 1;
          next_st = IDLE;
        end

        default : next_st = IDLE;
      endcase
    end
endmodule
