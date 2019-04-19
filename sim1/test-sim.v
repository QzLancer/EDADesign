`timescale 1ns/1ns
module test;
  parameter DELAY=200;
  
  reg clk, rst;
  reg CCW;
  reg CP;

  initial
  begin
    rst = 1;
    #DELAY rst = 0;
  end
  
  initial
  begin
    clk = 0;
    forever #10 clk = !clk;  
    CP = 0;
    forever #10 CP = !CP;
    CCW = 0;
  end
  
  wire [3:0] SubLevel;
  wire [11:0] REFA, REFB, REFC;
  Interface Inst_Interface0(.CLK(clk), .rst(rst), .CP(CP), .CCW(CCW), .SubLevel(SubLevel),
                            .REFA(REFA), .REFB(REFB), .REFC(REFC));
endmodule
