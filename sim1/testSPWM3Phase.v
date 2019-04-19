`timescale 1ns/1fs
module testSPWM3Phase;
reg CLK, RST, CCW;
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
	CCW = 1;
end

initial
begin
	SW = 5'b11111;
end

wire PHA, PLA, PHB, PLB, PHC, PLC;
SPWM_3Phase S3P0(.CLK(CLK), .RST(RST), .SW(SW), .CCW(CCW), .PHA(PHA), .PLA(PLA), .PHB(PHB), .PLB(PLB), .PHC(PHC), .PLC(PLC));
endmodule