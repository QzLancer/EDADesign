`timescale 1ns/1fs
module testTimePulseGen;
reg CLK, RST;
reg [4:0] SW;

initial
begin
	RST = 0;
	#1 RST = 1;
end

initial
begin
	CLK = 0;
	forever #1 CLK = !CLK;
end

initial
begin
	SW = 5'b00000;
	#2000 SW = 5'b00010;
	#2000 SW = 5'b00100;
	#2000 SW = 5'b01000;
	#2000 SW = 5'b10000;
end

wire CP;
wire [3:0]Sublevel;
TimePulGenerator T0(.CLK(CLK), .RST(RST), .SW(SW), .CP(CP), .Sublevel(Sublevel));
endmodule