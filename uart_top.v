`timescale 1ns / 1ps

module uart_top
#(
    parameter CLKS_PER_BIT = 868
)
(
    input  wire       i_clk,
    input  wire       i_tx_dv,
    input  wire [7:0] i_tx_byte,
    output wire       o_tx_serial,
    output wire       o_tx_done,
    input  wire       i_rx_serial,
    output wire       o_rx_dv,
    output wire [7:0] o_rx_byte
);

    wire w_tx_active;
    uart_tx #(.CLKS_PER_BIT(CLKS_PER_BIT)) uart_tx_inst (
        .i_clk(i_clk),
        .i_tx_dv(i_tx_dv),
        .i_tx_byte(i_tx_byte),
        .o_tx_active(w_tx_active),
        .o_tx_serial(o_tx_serial),
        .o_tx_done(o_tx_done)
    );

    uart_rx #(.CLKS_PER_BIT(CLKS_PER_BIT)) uart_rx_inst (
        .i_clk(i_clk),
        .i_rx_serial(i_rx_serial),
        .o_rx_dv(o_rx_dv),
        .o_rx_byte(o_rx_byte)
    );

endmodule
