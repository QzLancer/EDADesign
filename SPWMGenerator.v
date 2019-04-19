module SPWMGenerator(CLK, RST, PWM, PH, PL);
input CLK, RST;
input [11:0]PWM;
output PH, PL;
wire [11:0]CarriorOut;
wire Out;
reg [6:0]DeadTime;
//实例化载波发生器
BaseCarrior Inst_BaseCarrior(.clk(CLK), .rst(RST), .counteout(CarriorOut));
//实例化比较器
comp Inst_comp(.clk(CLK), .A(PWM), .B(CarriorOut), .rst(RST), .c(Out));
//实例化死区发生器
dead Inst_dead(.clk(CLK), .rst(RST), .px(Out), .xh(PH), .xl(PL), .dead_time(DeadTime));

always@(posedge CLK)
begin
	DeadTime = 7'b0000001;
end
endmodule