`timescale 1ns/1ps

module aes128_bug_runner_tb;

    logic         clk;
    logic         rst_n;
    logic         start;
    logic [127:0] key;
    logic [127:0] plaintext;

    wire [127:0] ciphertext;
    wire         busy;
    wire         done;

    integer pass_count;
    integer fail_count;

    // ------------------------------------------------------------------------
    // DUT
    // The selected bug RTL must use the same module name and interface:
    //
    // module aes128_iterative (
    //     input  wire         clk,
    //     input  wire         rst_n,
    //     input  wire         start,
    //     input  wire [127:0] key,
    //     input  wire [127:0] plaintext,
    //     output reg  [127:0] ciphertext,
    //     output reg          busy,
    //     output reg          done
    // );
    // ------------------------------------------------------------------------

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

    // ------------------------------------------------------------------------
    // Clock
    // ------------------------------------------------------------------------

    initial begin
        clk = 1'b0;

        forever #5 clk = ~clk;
    end

    // ------------------------------------------------------------------------
    // Waveform
    // ------------------------------------------------------------------------

    initial begin
        $dumpfile("aes128_bug_runner.vcd");
        $dumpvars(0, aes128_bug_runner_tb);
    end

    // ------------------------------------------------------------------------
    // Reset
    // ------------------------------------------------------------------------

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

    // ------------------------------------------------------------------------
    // Run one AES test
    // ------------------------------------------------------------------------

    task automatic run_test;
        input [127:0] test_key;
        input [127:0] test_plaintext;
        input [127:0] expected_ciphertext;

        integer cycles;
        reg [127:0] actual_ciphertext;

        begin
            key       = test_key;
            plaintext = test_plaintext;

            // Start request is asserted for exactly one cycle.
            @(negedge clk);
            start = 1'b1;

            @(negedge clk);
            start = 1'b0;

            cycles = 0;

            // Wait for completion.
            while (!done && cycles < 100) begin
                @(posedge clk);
                cycles = cycles + 1;
            end

            if (!done) begin
                $display(
                    "FAIL: timeout after %0d cycles",
                    cycles
                );

                fail_count = fail_count + 1;
            end
            else begin
                actual_ciphertext = ciphertext;

                if (actual_ciphertext === expected_ciphertext) begin
                    $display(
                        "PASS: ciphertext = %032h  (%0d cycles)",
                        actual_ciphertext,
                        cycles
                    );

                    pass_count = pass_count + 1;
                end
                else begin
                    $display(
                        "FAIL: expected = %032h",
                        expected_ciphertext
                    );

                    $display(
                        "      actual   = %032h",
                        actual_ciphertext
                    );

                    $display(
                        "      latency  = %0d cycles",
                        cycles
                    );

                    fail_count = fail_count + 1;
                end
            end

            // Allow the DUT to return to idle before the next test.
            @(posedge clk);

            while (busy) begin
                @(posedge clk);
            end

            // Gap between tests.
            repeat (2) @(posedge clk);
        end
    endtask

    // ------------------------------------------------------------------------
    // Main test sequence
    // ------------------------------------------------------------------------

    initial begin
        pass_count = 0;
        fail_count = 0;

        reset_dut();

        $display("");
        $display("==============================================");
        $display(" AES-128 BUG RUNNER");
        $display("==============================================");
        $display("");

        // --------------------------------------------------------------------
        // AES-128 FIPS-197 known-answer test
        // --------------------------------------------------------------------

        $display("Test 1: FIPS-197 AES-128 known-answer test");

        run_test(
            128'h000102030405060708090a0b0c0d0e0f,
            128'h00112233445566778899aabbccddeeff,
            128'h69c4e0d86a7b0430d8cdb78070b4c55a
        );

        // --------------------------------------------------------------------
        // Second independent known-answer test
        // --------------------------------------------------------------------

        $display("");
        $display("Test 2: independent AES-128 known-answer test");

        run_test(
            128'h2b7e151628aed2a6abf7158809cf4f3c,
            128'h3243f6a8885a308d313198a2e0370734,
            128'h3925841d02dc09fbdc118597196a0b32
        );

        // --------------------------------------------------------------------
        // Summary
        // --------------------------------------------------------------------

        $display("");
        $display("==============================================");
        $display(" BUG RUNNER SUMMARY");
        $display("==============================================");
        $display("PASS: %0d", pass_count);
        $display("FAIL: %0d", fail_count);
        $display("");

        if (fail_count == 0) begin
            $display("RESULT: ALL TESTS PASSED");
            $finish(0);
        end
        else begin
            $display("RESULT: FUNCTIONAL FAILURE DETECTED");
            $finish(1);
        end
    end

endmodule
