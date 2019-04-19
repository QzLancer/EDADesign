`timescale 1ns/1fs
module romtest;
reg clk, rst, CP, CCW;
reg [3:0] SubLevel;
initial
begin
    clk = 0;
    forever #1 clk = !clk;
end

initial 
begin
	rst = 0;
	#1 rst = 1;
end

initial
begin
	CP = 0;
	forever #20 CP = !CP;
end

initial
begin
	CCW = 1;
end

initial
begin
	SubLevel = 4'b1001;
end

wire [11:0] REFA, REFB, REFC;
Interface s0(.CLK(clk), .rst(rst), .CP(CP), .CCW(CCW), .SubLevel(SubLevel), .REFA(REFA), .REFB(REFB), .REFC(REFC));
endmodule