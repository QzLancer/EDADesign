`timescale 1ns/1fs
module testSPWMGenerator;
reg CLK, RST, CP, CCW;
reg [3:0] SubLevel;
wire [11:0]PWM;

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
	CP = 0;
	forever #200 CP = !CP;
end

initial
begin
	CCW = 1;
end

initial
begin
	SubLevel = 4'b1011;
end

wire PH, PL;
Interface Inst_Interface0(.CLK(CLK), .rst(RST), .CP(CP), .CCW(CCW), .SubLevel(SubLevel), .REFA(PWM));
SPWMGenerator SPWM0(.CLK(CLK), .RST(RST), .PWM(PWM), .PH(PH), .PL(PL));
endmodule