`timescale 1ns/1ps

module aes128_tb;

    logic         clk;
    logic         rst_n;
    logic         start;
    logic [127:0] key;
    logic [127:0] plaintext;

    wire [127:0] ciphertext;
    wire         busy;
    wire         done;

    // ------------------------------------------------------------
    // DUT
    // ------------------------------------------------------------
    aes128_iterative dut (
        .clk        (clk),
        .rst_n      (rst_n),
        .start      (start),
        .key        (key),
        .plaintext  (plaintext),
        .ciphertext (ciphertext),
        .busy       (busy),
        .done        (done)
    );

    // ------------------------------------------------------------
    // Clock
    // ------------------------------------------------------------
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // ------------------------------------------------------------
    // Test statistics
    // ------------------------------------------------------------
    integer tests_run;
    integer tests_passed;

    // ------------------------------------------------------------
    // Reset
    // ------------------------------------------------------------
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

    // ------------------------------------------------------------
    // Run one AES encryption and check the result
    // ------------------------------------------------------------
    task automatic run_test;
        input [127:0] test_key;
        input [127:0] test_plaintext;
        input [127:0] expected_ciphertext;

        integer cycles;
        begin
            tests_run = tests_run + 1;

            key       = test_key;
            plaintext = test_plaintext;

            // Present the request for one clock cycle.
            @(negedge clk);
            start = 1'b1;

            @(negedge clk);
            start = 1'b0;

            // Wait for completion.
            cycles = 0;

            while (!done) begin
                @(posedge clk);
                cycles = cycles + 1;

                if (cycles > 30) begin
                    $display("ERROR: timeout waiting for AES completion.");
                    $display("       busy=%b done=%b round=%0d",
                             busy, done, dut.round);
                    $fatal;
                end
            end

            // Allow NBA updates to settle.
            #1;

            if (ciphertext === expected_ciphertext) begin
                tests_passed = tests_passed + 1;

                $display("");
                $display("TEST %0d: PASS", tests_run);
                $display("  Key        : %032h", test_key);
                $display("  Plaintext  : %032h", test_plaintext);
                $display("  Ciphertext : %032h", ciphertext);
                $display("  Expected   : %032h", expected_ciphertext);
                $display("  Cycles     : %0d", cycles);
            end
            else begin
                $display("");
                $display("TEST %0d: FAIL", tests_run);
                $display("  Key        : %032h", test_key);
                $display("  Plaintext  : %032h", test_plaintext);
                $display("  Ciphertext : %032h", ciphertext);
                $display("  Expected   : %032h", expected_ciphertext);
                $display("  Cycles     : %0d", cycles);
            end

            // Wait until the DUT is idle before starting another test.
            @(posedge clk);
            while (busy)
                @(posedge clk);
        end
    endtask

    // ------------------------------------------------------------
    // Main test sequence
    // ------------------------------------------------------------
    initial begin
        tests_run    = 0;
        tests_passed = 0;

        reset_dut();

        // --------------------------------------------------------
        // AES-128 FIPS-197 known-answer test
        // --------------------------------------------------------
        run_test(
            128'h000102030405060708090a0b0c0d0e0f,
            128'h00112233445566778899aabbccddeeff,
            128'h69c4e0d86a7b0430d8cdb78070b4c55a
        );

        // --------------------------------------------------------
        // Second known-answer test
        // --------------------------------------------------------
        run_test(
            128'h2b7e151628aed2a6abf7158809cf4f3c,
            128'h3243f6a8885a308d313198a2e0370734,
            128'h3925841d02dc09fbdc118597196a0b32
        );

        // --------------------------------------------------------
        // Summary
        // --------------------------------------------------------
        $display("");
        $display("========================================");
        $display("AES TEST SUMMARY");
        $display("========================================");
        $display("Tests run    : %0d", tests_run);
        $display("Tests passed : %0d", tests_passed);
        $display("Tests failed : %0d", tests_run - tests_passed);
        $display("========================================");

        if (tests_passed == tests_run)
            $display("RESULT: PASS");
        else
            $display("RESULT: FAIL");

        $display("");

        #20;
        $finish;
    end

    // ------------------------------------------------------------
    // Waveform dump
    // ------------------------------------------------------------
    initial begin
        $dumpfile("aes128.vcd");
        $dumpvars(0, aes128_tb);
    end

endmodule
