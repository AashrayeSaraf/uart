`timescale 1ns / 1ps

module uart_tx
#(
    parameter CLKS_PER_BIT = 868  // For 100MHz clk, baud=115200
)
(
    input  wire       i_clk,
    input  wire       i_tx_dv,
    input  wire [7:0] i_tx_byte,
    output reg        o_tx_active,
    output reg        o_tx_serial,
    output reg        o_tx_done
);

    // FSM states
    localparam IDLE         = 3'b000;
    localparam START_BIT    = 3'b001;
    localparam DATA_BITS    = 3'b010;
    localparam STOP_BIT     = 3'b011;
    localparam CLEANUP      = 3'b100;

    reg [2:0]    r_state = IDLE;
    reg [15:0]   r_clk_count = 0;
    reg [2:0]    r_bit_index = 0;
    reg [7:0]    r_tx_data   = 0;

    always @(posedge i_clk) begin
        case (r_state)
            IDLE: begin
                o_tx_serial  <= 1'b1;   // Line high when idle
                o_tx_done    <= 1'b0;
                r_clk_count  <= 0;
                r_bit_index  <= 0;

                if (i_tx_dv) begin
                    o_tx_active <= 1'b1;
                    r_tx_data   <= i_tx_byte;
                    r_state     <= START_BIT;
                end
                else begin
                    o_tx_active <= 1'b0;
                end
            end

            START_BIT: begin
                o_tx_serial <= 1'b0;
                if (r_clk_count < CLKS_PER_BIT-1) begin
                    r_clk_count <= r_clk_count + 1;
                end else begin
                    r_clk_count <= 0;
                    r_state     <= DATA_BITS;
                end
            end

            DATA_BITS: begin
                o_tx_serial <= r_tx_data[r_bit_index];
                if (r_clk_count < CLKS_PER_BIT-1) begin
                    r_clk_count <= r_clk_count + 1;
                end else begin
                    r_clk_count <= 0;
                    if (r_bit_index < 7) begin
                        r_bit_index <= r_bit_index + 1;
                    end else begin
                        r_bit_index <= 0;
                        r_state     <= STOP_BIT;
                    end
                end
            end

            STOP_BIT: begin
                o_tx_serial <= 1'b1;
                if (r_clk_count < CLKS_PER_BIT-1) begin
                    r_clk_count <= r_clk_count + 1;
                end else begin
                    r_clk_count <= 0;
                    o_tx_done   <= 1'b1;
                    r_state     <= CLEANUP;
                end
            end

            CLEANUP: begin
                o_tx_done   <= 1'b1;
                o_tx_active <= 1'b0;
                r_state     <= IDLE;
            end

            default: r_state <= IDLE;
        endcase
    end
endmodule
