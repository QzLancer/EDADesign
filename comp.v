module comp(clk, A, B, rst, c);
input clk, rst;
input [11:0]A;
input [11:0]B;
output reg c;


always @(posedge clk or negedge rst)
begin
	if(!rst)
		c <= 0;
	else if(A > B)
		c <= 1;
	else
		c <= 0;
end

endmodule