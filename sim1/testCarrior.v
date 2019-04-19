`timescale 1ns/1fs
module testCarrior;
reg clk, rst;

initial
begin
	rst = 0;
	#1 rst = 1;
end

initial
begin
	clk = 0;
	forever #1 clk = !clk;
end

wire[11:0] counteout;
BaseCarrior B0(.clk(clk), .rst(rst), .counteout(counteout));
endmodule