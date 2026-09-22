module aes128_tb_bug_runner;
  logic clk=0; always #5 clk=~clk;
  logic rst_n, start; logic [127:0] key, plaintext;
  logic [127:0] ciphertext; logic busy, done;
  aes128_iterative dut(.clk(clk),.rst_n(rst_n),.start(start),.key(key),.plaintext(plaintext),.ciphertext(ciphertext),.busy(busy),.done(done));
  initial begin
    rst_n=0; start=0; key=128'h000102030405060708090a0b0c0d0e0f; plaintext=128'h00112233445566778899aabbccddeeff;
    repeat(2) @(posedge clk); rst_n=1; @(posedge clk); start=1; @(posedge clk); start=0;
    wait(done); #1;
    if (ciphertext===128'h69c4e0d86a7b0430d8cdb78070b4c55a) $display("PASS");
    else $display("FAIL: got %032h expected 69c4e0d86a7b0430d8cdb78070b4c55a", ciphertext);
    $finish;
  end
endmodule
