`timescale 1ns / 1ps

module func_calculator (
    input clk,
    input rst,
    input [ 7 : 0 ] a,
    input [ 7 : 0 ] b,
    input start,
    output busy_o,
    output reg [ 23 : 0 ] y
);
    localparam IDLE = 3'b000;
    localparam STEP_1 = 3'b001;
    localparam STEP_2_WAIT = 3'b010;
    localparam STEP_2_RES = 3'b011;
    localparam STEP_3 = 3'b100;
    
    
    reg [2:0] state;
    wire mult_busy;
    reg mult_start;
    
    wire root_busy;
    reg [23:0] a_res;
    reg [7:0] b_reg;
    reg [7:0] a_reg;
    wire [23:0] a_wire;
    wire [7:0] b_res;
    integer i;
    
    assign busy_o = (state != 0) ;
    
    root r (
    .clk_i(clk),
    .rst_i(rst),
    .x_bi(b_reg),
    .start_i(start),
    .y_bo(b_res),
    .busy_o(root_busy)
    );
    
    mult m (
    .clk_i(clk),
    .rst_i(rst),
    .a_bi(a_reg),
    .b_bi(a_res),
    .start_i(mult_start),
    .y_bo(a_wire),
    .busy_o(mult_busy)
    );

    always @(posedge clk or posedge rst)
        begin
        if (rst) begin
            i <= 0;
            y <= 0;
            a_res <= 1;
            b_reg <= 0;
            a_reg <= 0;
            mult_start <= 0;
            state <= IDLE;
        end 
        else begin
            case ( state )
                IDLE :
                    if (start & a_res == 1) begin
                        state <= STEP_1;
                    end
                STEP_1:
                    begin
                        b_reg <= b;
                        a_reg <= a;
                        mult_start <= 1;
                        state <= STEP_2_RES;
                    end
                STEP_2_WAIT:
                    begin
                        mult_start <= 0;
                        if (~mult_busy) begin
                            state <= STEP_2_RES;
                            i <= i+1;
                            mult_start <= 0;
                        end
                    end
                STEP_2_RES:
                    begin
                        mult_start <= 1;
                        a_res <= a_wire;
                        if (i == 3) begin
                            state <= STEP_3;
                            mult_start <= 0;
                        end else
                            state <= STEP_2_WAIT;
                    end
                STEP_3:
                    begin
                        y <= a_res + b_res;
                        i <= 0;
                        a_res <= 1;
                        state <= IDLE;
                    end
                default:
                    begin
                    end
            endcase
        end
    end
    
endmodule
