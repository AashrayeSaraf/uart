`timescale 1ns / 1ps

module uart_tb;

    parameter CLKS_PER_BIT = 868;
    parameter c_CLOCK_PERIOD_NS = 10;  // 100 MHz clock
    parameter c_BIT_PERIOD = 8680;     // in ns (868 * 10ns)

    reg r_clk = 0;
    reg r_tx_dv = 0;
    reg [7:0] r_tx_byte = 0;
    wire w_tx_serial;
    wire w_tx_done;
    wire w_rx_dv;
    wire [7:0] w_rx_byte;


    always #(c_CLOCK_PERIOD_NS/2) r_clk <= ~r_clk;

    uart_top #(.CLKS_PER_BIT(CLKS_PER_BIT)) DUT (
        .i_clk(r_clk),
        .i_tx_dv(r_tx_dv),
        .i_tx_byte(r_tx_byte),
        .o_tx_serial(w_tx_serial),
        .o_tx_done(w_tx_done),
        .i_rx_serial(w_tx_serial),  // Loopback
        .o_rx_dv(w_rx_dv),
        .o_rx_byte(w_rx_byte)
    );

    initial begin
        $display("UART Testbench Start");

        @(posedge r_clk);
        r_tx_byte <= 8'hA6; // In binary 10100101
        r_tx_dv   <= 1'b1;
        @(posedge r_clk);
        r_tx_dv   <= 1'b0;

        wait(w_tx_done);
        $display("TX Done at time %0t", $time);

        wait(w_rx_dv);
        $display("RX Data: %h at time %0t", w_rx_byte, $time);

        #200000;
        $finish;
    end
endmodule
