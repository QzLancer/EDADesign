module sintest(clk, rst, q);
input clk, rst;
output [10:0]q;
reg [11:0] address;

always @(posedge clk or negedge rst)
begin
	if(!rst)
		begin
			address <= 12'b0;
		end
	else if(address < 12'b111111111111)
		address <= address + 1;
	else
		begin
			address <= 12'b0;
		end
end

sin Inst_sin(.address(address), .clock(clk), .q(q));
endmodule