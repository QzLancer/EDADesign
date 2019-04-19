module SPWM_3Phase(CLK, RST, SW, CCW, PHA, PLA ,PHB, PLB, PHC, PLC);
input CLK, RST, CCW;
input [4:0]SW;
output PHA, PLA, PHB, PLB, PHC, PLC;
wire CP;
wire [3:0]Sublevel;
wire [11:0]PWMA;
wire [11:0]PWMB;
wire [11:0]PWMC;

//实例化时钟脉冲发生器
TimePulGenerator Inst_TimePulGenerator(.CLK(CLK), .RST(RST), .SW(SW), .CP(CP), .Sublevel(Sublevel));
//实例化细分波形发生器
Interface Inst_Interface(.CLK(CLK), .rst(RST), .CP(CP), .CCW(CCW), .SubLevel(Sublevel), .REFA(PWMA), .REFB(PWMB), .REFC(PWMC));
//实例化脉宽调制信号发生器
SPWMGenerator SPWMGeneratorA(.CLK(CLK), .RST(RST), .PWM(PWMA), .PH(PHA), .PL(PLA));
SPWMGenerator SPWMGeneratorB(.CLK(CLK), .RST(RST), .PWM(PWMB), .PH(PHB), .PL(PLB));
SPWMGenerator SPWMGeneratorC(.CLK(CLK), .RST(RST), .PWM(PWMC), .PH(PHC), .PL(PLC));

endmodule