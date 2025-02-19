----死区模块实体设计代码
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--定义库的使用

entity dead is
port(
	clk,rst,px: in std_logic;
	xh,xl	: out std_logic;
	dead_time	: in std_logic_vector(6 downto 0)
);
end dead;
--定义死区控制模块，名为dead，输入端口为：clk：系统时钟；rst：复位信号；
--px：脉宽调制信号输入；dead_time：死区时间；
--输出信号：xh：上桥臂输出信号；xl：下桥臂输出信号；

architecture Behavioral of dead is

	signal qup,qdown: std_logic_vector(6 downto 0) := (others => '0');
	signal dt1,dt2: std_logic_vector(6 downto 0);
	signal top,bottom : std_logic;
	signal irst1,irst2 : std_logic;
	signal ipx : std_logic;

begin

---------------------------------------------------------
-- time domain sync
	process(clk,rst)
	begin
	if rst = '0' then
		ipx <= '0';
	elsif clk = '1' and clk'event then
		ipx <= px;
	end if;
	end process;
--表示当clk的上升沿到来时，将px的值赋予ipx，ipx为输入信号px的寄存器；
---------------------------------------------------------
-- comparators
	top <= '1' when qup = dt1 else '0';
	bottom <= '1' when qdown = dt2 else '0';
--表示qup = dt1时，top为1，不然为0；dt1为上桥臂的死区时间，qup为上桥臂计数--器，当qup计数器的值等于死区时间设定值时，top才能等于1，表示上桥臂的死区设--定结束；
-- qdown = dt2时，down为1，不然为0；dt2为下桥臂的死区时间，qdown为下桥臂计--数器，当qdown计数器的值等于死区时间设定值时，down等于1，表示下桥臂的死
--区设定结束；
---------------------------------------------------------
-- reset
	irst1 <= (not ipx) or rst;
	irst2 <= ipx or rst;

---------------------------------------------------------
-- Generate phase high and phase low output
xh <= '1' when (ipx='1' and top='1') else
		'0';
xl <= '1' when (ipx='0' and bottom='1') else
		'0';
--ipx为px的寄存器，当ipx=1，且top=1，表示上桥臂高电平信号死区结束，输出高电平；
--当ipx=0，bottom=1，表示下桥臂高电平信号死区结束，输出高电平；
---------------------------------------------------------
-- high delay counter
process(clk, irst1)
begin
	if irst1 = '0' then
		qup <= (others=>'0');
	elsif (clk'event and clk = '1') then
		if (ipx = '1' and top = '0') then
			qup <= qup + 1;
		end if;
	end if;
end process;
--上桥臂的死区时间计数器；

---------------------------------------------------------
-- low dealy counter
process(clk, irst2)
begin
	if irst2 = '0' then
		qdown <= (others=>'0');
	elsif (clk'event and clk = '1') then
		if (ipx = '0' and bottom = '0') then
			qdown <= qdown + 1;
		end if;
	end if;
end process;
--下桥臂的死区时间计数器；

---------------------------------------------------------
-- update dead_time register
process(clk, rst)
begin
	if rst = '0' then
		dt1 <= (others => '1');
	elsif (clk'event and clk = '1') then
		if ipx = '1' then
			dt1<= dead_time;
		end if;
	end if;
end process;
--设定上桥臂的死区时间；

process(clk, rst)
begin
	if rst = '0' then
		dt2 <= (others => '1');
	elsif (clk'event and clk = '1') then
		if ipx = '0' then
			dt2 <= dead_time;
		end if;
	end if;
end process;
--设定下桥臂的死区时间；
end Behavioral;
