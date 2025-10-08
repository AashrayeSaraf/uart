`timescale 1ns / 1ps

module uart_rx
#(
    parameter CLKS_PER_BIT = 868
)
(
    input  wire       i_clk,
    input  wire       i_rx_serial,
    output reg        o_rx_dv,
    output reg [7:0]  o_rx_byte
);

    localparam IDLE         = 3'b000;
    localparam START_BIT    = 3'b001;
    localparam DATA_BITS    = 3'b010;
    localparam STOP_BIT     = 3'b011;
    localparam CLEANUP      = 3'b100;

    reg [2:0]    r_state = IDLE;
    reg [15:0]   r_clk_count = 0;
    reg [2:0]    r_bit_index = 0;
    reg [7:0]    r_rx_data   = 0;

    always @(posedge i_clk) begin
        case (r_state)
            IDLE: begin
                o_rx_dv     <= 1'b0;
                r_clk_count <= 0;
                r_bit_index <= 0;
                if (i_rx_serial == 1'b0)  // Start bit detect
                    r_state <= START_BIT;
            end

            START_BIT: begin
                if (r_clk_count == (CLKS_PER_BIT-1)/2) begin
                    if (i_rx_serial == 1'b0) begin
                        r_clk_count <= 0;
                        r_state     <= DATA_BITS;
                    end else begin
                        r_state <= IDLE;
                    end
                end else begin
                    r_clk_count <= r_clk_count + 1;
                end
            end

            DATA_BITS: begin
                if (r_clk_count < CLKS_PER_BIT-1) begin
                    r_clk_count <= r_clk_count + 1;
                end else begin
                    r_clk_count <= 0;
                    r_rx_data[r_bit_index] <= i_rx_serial;

                    if (r_bit_index < 7) begin
                        r_bit_index <= r_bit_index + 1;
                    end else begin
                        r_bit_index <= 0;
                        r_state     <= STOP_BIT;
                    end
                end
            end

            STOP_BIT: begin
                if (r_clk_count < CLKS_PER_BIT-1) begin
                    r_clk_count <= r_clk_count + 1;
                end else begin
                    o_rx_byte   <= r_rx_data;
                    o_rx_dv     <= 1'b1;
                    r_clk_count <= 0;
                    r_state     <= CLEANUP;
                end
            end

            CLEANUP: begin
                r_state <= IDLE;
                o_rx_dv <= 1'b0;
            end
        endcase
    end
endmodule

