`timescale 1ns/1ps
module aes128_tb;
reg clk,rst_n,start;reg[127:0]key,plaintext;wire[127:0]ciphertext;wire busy,done;integer errors;
aes128_iterative dut(.clk(clk),.rst_n(rst_n),.start(start),.key(key),.plaintext(plaintext),.ciphertext(ciphertext),.busy(busy),.done(done));
always #5 clk=~clk;
task automatic test;input[127:0]k,p,e;begin @(negedge clk);key=k;plaintext=p;start=1;@(posedge clk);#1;start=0;wait(done);#1;if(ciphertext!==e)begin $error("AES FAIL expected=%032h got=%032h",e,ciphertext);errors=errors+1;end else $display("AES PASS %032h",ciphertext);@(negedge clk);end endtask
initial begin clk=0;rst_n=0;start=0;key=0;plaintext=0;errors=0;$dumpfile("aes.vcd");$dumpvars(0,aes128_tb);repeat(2)@(posedge clk);rst_n=1;test(128'h000102030405060708090a0b0c0d0e0f,128'h00112233445566778899aabbccddeeff,128'h69c4e0d86a7b0430d8cdb78070b4c55a);if(errors==0)$display("ALL AES TESTS PASSED");else $display("AES TEST FAILED: %0d",errors);$finish;end
endmodule
