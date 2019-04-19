module TimePulGenerator(CLK, RST, SW, CP, Sublevel);
input CLK, RST;
input [4:0]SW;
output CP;
output reg [3:0]Sublevel;
reg [15:0]Count;
reg [15:0]CountMAX;
reg div_CLK;
//根据表格来确定计数器和Sublevel
always@(posedge CLK)
begin
	case(SW)
		5'b00000: 
		begin
			CountMAX = 16'd7324;
			Sublevel = 4'b1011;
		end
		
		5'b00001: 
		begin
			CountMAX = 16'd3662;
			Sublevel = 4'b1011;
		end
		
		5'b00010:
	   begin
			CountMAX = 16'd1831;
			Sublevel = 4'b1011;
		end
		
		5'b00011: 
		begin
			CountMAX = 16'd1221;
			Sublevel = 4'b1011;
		end
		
		5'b00100: 
		begin
			CountMAX = 16'd916;
			Sublevel = 4'b1011;
		end
		
		5'b00101: 
		begin
			CountMAX = 16'd1465;
			Sublevel = 4'b1010;
		end
		
		5'b00110: 
		begin
			CountMAX = 16'd977;
			Sublevel = 4'b1010;
		end
		
		5'b00111: 
		begin
			CountMAX = 16'd732;
			Sublevel = 4'b1010;
		end
		
		5'b01000: 
		begin
			CountMAX = 16'd586;
			Sublevel = 4'b1010;
		end
		
		5'b01001: 
		begin
			CountMAX = 16'd488;
			Sublevel = 4'b1010;
		end
		
		5'b01010: 
		begin
			CountMAX = 16'd837;
			Sublevel = 4'b1001;
		end
		
		5'b01011: 
		begin
			CountMAX = 16'd732;
			Sublevel = 4'b1001;
		end
		
		5'b01100: 
		begin
			CountMAX = 16'd651;
			Sublevel = 4'b1001;
		end
		
		5'b01101: 
		begin
			CountMAX = 16'd586;
			Sublevel = 4'b1001;
		end
		
		5'b01110: 
		begin
			CountMAX = 16'd533;
			Sublevel = 4'b1001;
		end
		
		5'b01111: 
		begin
			CountMAX = 16'd977;
			Sublevel = 4'b1000;
		end
		
		5'b10000: 
		begin
			CountMAX = 16'd901;
			Sublevel = 4'b1000;
		end
		
		5'b10001: 
		begin
			CountMAX = 16'd837;
			Sublevel = 4'b1000;
		end
		
		5'b10010: 
		begin
			CountMAX = 16'd781;
			Sublevel = 4'b1000;
		end
		
		5'b10011: 
		begin
			CountMAX = 16'd732;
			Sublevel = 4'b1000;
		end
		
		5'b10100: 
		begin
			CountMAX = 16'd1397;
			Sublevel = 4'b0111;
		end
		
		5'b10101: 
		begin
			CountMAX = 16'd1234;
			Sublevel = 4'b0111;
		end
		
		5'b10110: 
		begin
			CountMAX = 16'd1172;
			Sublevel = 4'b0111;
		end
		
		5'b10111: 
		begin
			CountMAX = 16'd1116;
			Sublevel = 4'b0111;
		end
		
		5'b11000: 
		begin
			CountMAX = 16'd1065;
			Sublevel = 4'b0111;
		end
		
		5'b11001: 
		begin
			CountMAX = 16'd1019;
			Sublevel = 4'b0111;
		end
		
		5'b11010: 
		begin
			CountMAX = 16'd977;
			Sublevel = 4'b0111;
		end
		
		5'b11011: 
		begin
			CountMAX = 16'd901;
			Sublevel = 4'b0111;
		end
		
		5'b11100: 
		begin
			CountMAX = 16'd868;
			Sublevel = 4'b0111;
		end
		
		5'b11101: 
		begin
			CountMAX = 16'd837;
			Sublevel = 4'b0111;
		end
		
		5'b11110: 
		begin
			CountMAX = 16'd808;
			Sublevel = 4'b0111;
		end
		
		5'b11111: 
		begin
			CountMAX = 16'd781;
			Sublevel = 4'b0111;
		end
		default:
		begin
			CountMAX = 16'd7324;
			Sublevel = 4'b1011;		
		end
	endcase
end

//根据计数器的值进行分频，产生分频信号
always @(posedge CLK or negedge RST)
begin
	if(!RST)
	begin
		Count <= 0;
		div_CLK <= 0;
	end
	else if(Count < CountMAX)
		Count <= Count + 1;
	else
	begin
		Count <= 0;
		div_CLK = ~div_CLK;
	end
end

assign CP = div_CLK;
endmodule