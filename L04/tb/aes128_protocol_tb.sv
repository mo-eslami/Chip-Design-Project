`timescale 1ns/1ps

module aes128_protocol_tb;

    logic         clk;
    logic         rst_n;
    logic         start;
    logic [127:0] key;
    logic [127:0] plaintext;

    wire [127:0] ciphertext;
    wire         busy;
    wire         done;

    aes128_iterative dut (
        .clk        (clk),
        .rst_n      (rst_n),
        .start      (start),
        .key        (key),
        .plaintext  (plaintext),
        .ciphertext (ciphertext),
        .busy       (busy),
        .done       (done)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    task automatic reset_dut;
        begin
            rst_n     = 1'b0;
            start     = 1'b0;
            key       = 128'h0;
            plaintext = 128'h0;

            repeat (3) @(posedge clk);

            rst_n = 1'b1;

            @(posedge clk);
        end
    endtask

    initial begin

        reset_dut();

        key       = 128'h000102030405060708090a0b0c0d0e0f;
        plaintext = 128'h00112233445566778899aabbccddeeff;

        // --------------------------------------------------------
        // Test 1: start should be accepted while idle
        // --------------------------------------------------------
        @(negedge clk);
        start = 1'b1;

        @(negedge clk);
        start = 1'b0;

        @(posedge clk);
        #1;

        if (!busy) begin
            $error("FAIL: DUT did not become busy after start.");
        end
        else begin
            $display("PASS: DUT accepted start and became busy.");
        end

        // --------------------------------------------------------
        // Test 2: start should not restart the operation while busy
        // --------------------------------------------------------
        repeat (2) @(negedge clk);

        if (!busy) begin
            $error("FAIL: DUT became idle unexpectedly.");
        end

        start = 1'b1;

        @(negedge clk);
        start = 1'b0;

        $display("Second start request applied while busy.");

        // --------------------------------------------------------
        // Test 3: wait for completion
        // --------------------------------------------------------
        wait (done);

        #1;

        if (!done) begin
            $error("FAIL: completion was not detected.");
        end
        else begin
            $display("PASS: completion detected.");
        end

        // --------------------------------------------------------
        // Test 4: done should normally be a one-cycle pulse
        // --------------------------------------------------------
        @(posedge clk);
        #1;

        if (done) begin
            $error("FAIL: done remained asserted for another cycle.");
        end
        else begin
            $display("PASS: done returned low.");
        end

        // --------------------------------------------------------
        // Test 5: busy should return low after completion
        // --------------------------------------------------------
        if (busy) begin
            $error("FAIL: busy remained asserted after completion.");
        end
        else begin
            $display("PASS: busy returned low.");
        end

        $display("");
        $display("Protocol test completed.");

        #20;
        $finish;
    end

    initial begin
        $dumpfile("aes128_protocol.vcd");
        $dumpvars(0, aes128_protocol_tb);
    end

endmodule
