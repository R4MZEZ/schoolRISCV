`timescale 1ns / 1ps

module root (
    input clk_i,
    input rst_i,
    input [ 7 : 0 ] x_bi,
    input start_i,
    output busy_o,
    output reg [ 7 : 0 ] y_bo
);
    localparam IDLE = 1'b0;
    localparam WORK = 1'b1;
    
    reg [7:0] m;
    wire [7:0] b;
    wire check1, check2;
    reg [7:0] x;
    reg [7:0] y;
    reg state;
    
    assign busy_o = state ;
    assign check1 = (m == 0);
    assign check2 = (x >= b);
    assign b = y | m;

    always @(posedge clk_i)
        if ( rst_i ) begin
            m <= 1 << 6;
            y <= 0;
            state <= IDLE;
        end else begin
        case ( state )
            IDLE :
                if (start_i) begin
                    state <= WORK;
                    x <= x_bi;
                    m <= 1 << 6;
                    y <= 0;
                end
            WORK:
                begin
                    if (check1) begin
                        state <= IDLE;
                        y_bo <= y;
                    end else begin
                      
                        if (check2) begin
                            x <= x - b;
                            y <= y >> 1 | m;
                        end
                        else begin
                            y <= y >> 1;   
                        end
                        m <= m >> 2;
                    end
                end
        endcase
    end
endmodule

