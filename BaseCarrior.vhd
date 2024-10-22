----载波发生模块程序清单
library IEEE;
--定义使用IEEE标准库
use IEEE.STD_LOGIC_1164.ALL;
--定义使用IEEE标准库中的LOGIC_1164程序包
use IEEE.STD_LOGIC_ARITH.ALL;
--定义使用IEEE标准库中的STD_LOGIC_ARITH程序包
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--定义使用IEEE标准库中的STD_LOGIC_UNSINGED程序包

entity BaseCarrior is
Port ( clk 	: in std_logic;
rst 	: in std_logic;
regen	: out std_logic;
counteout: out std_logic_vector(11 downto 0)
);
end BaseCarrior;
--定义实体，名为BaseCarrior，输入端口为：clk：系统时钟输入；rst：复位信号输入；
--输出端口为：regen：当计数器为000_000_000_001，regen为1；counteout：三角波输出

architecture Behavioral of BaseCarrior is

signal reachtop,reachbottom : std_logic;
signal reachtop_c,reachbottom_c : std_logic;
signal upcnten : std_logic;
signal Basecnt  : std_logic_vector(11 downto 0);
-- reachtop为三角波输出到达顶部的标志；
-- reachbottom为三角波输出到达底部的标志；
-- upcnten为计数器输出使能选择，当upcnten为1时，加法计数器输出；当upcnten为0时，--减法计数器输出；
signal upq0,allone  : std_logic_vector(3 downto 0) := (others => '0');
signal upq1  : std_logic_vector(7 downto 0) := (others => '0');
signal upripplecarry : std_logic;
--upq0与upq1为加法计数器输出，upq0为低4位；upq1为高8位；
--upripplecarry为低4位进位；

signal downq0,allzero  : std_logic_vector(3 downto 0) := (others => '0');
signal downq1  : std_logic_vector(7 downto 0) := (others => '0');
signal downripplecarry : std_logic;
--downq0与downq1为减法计数器输出，downq0为低4位；downq1为高8位；
-- downripplecarry为低4为借位；


begin
counteout <= Basecnt ;
allone <= "1111";
allzero <= "0000";

---------------------------------------------------------
-- Generate regen output
process (CLK)
begin
if CLK='1' and CLK'event then
regen <= reachbottom;
end if;
end process;
--该进程表示三角波输出达到底部时，regen为1；
---------------------------------------------------------
-- Generate Base Counter output
process (CLK)
begin
if CLK='1' and CLK'event then
if upcnten='1' then
Basecnt	<= upq1 & upq0;
else
Basecnt	<= downq1 & downq0;
end if;
end if;
end process;
--该进程表示upcnten为1时，加法计数器输出；upcnten为0时，减法计数器输出；
---------------------------------------------------------
-- Generate Base Counter Direction
--reachtop <= '1' when Basecnt = "010011101110" else    --1250 to 10Khz of spwm;
--		 		'0';


reachtop <= '1' when Basecnt = "011111111110" else    --1250 to 10Khz of spwm;
'0';
reachbottom <= '1' when Basecnt = "000000000001" else
'0';
--三角波输出为011_111_111_110时，reachtop为1，不然为0；
--三角波输出为000_000_000_001时，reachbottom为1，不然为0；

process (CLK, rst)
begin
if rst='0' then
upcnten <= '1';
elsif CLK='1' and CLK'event then
if reachtop = '1' then
upcnten <= '0';
elsif reachbottom = '1' then
upcnten <= '1';
end if;
end if;
end process;
-- reachtop为1时，upcnten为0；reachbottom为1时，upcnten为1；
---------------------------------------------------------
-- upcnt implemented as prescaled counter
upripplecarry <= '1' when upq0 = allone else  '0';
-- upripplecarry为1，当upq0为1111；否则为0；

process (CLK, rst)
begin
if rst='0' then
upq0 <= "0001";
elsif CLK='1' and CLK'event then
if upcnten='1' then
upq0 <= upq0 + 1;
end if;
end if;
end process;
process (CLK, rst)
begin
if rst='0' then
upq1 <= (others => '0');
elsif CLK='1' and CLK'event then
if upripplecarry = '1' then
if upq1 = "01111111" then
upq1 <= "00000000";
else
upq1 <= upq1 + 1;
end if;
end if;
end if;
end process;
--三角波上升部分，加法计数器；

---------------------------------------------------------
-- downcnt implemented as prescaled counter
downripplecarry <= '1' when downq0 = allzero else  '0';
-- downripplecarry为1，当downq0为0000；否则为0；
process (CLK, rst)
begin
if rst='0' then
downq0 <= "1110";
elsif CLK='1' and CLK'event then
if upcnten='0' then
downq0 <= downq0 - 1;
end if;
end if;
end process;
process (CLK, rst)
begin
if rst='0' then
downq1 <= "01111111";
elsif CLK='1' and CLK'event then
if downripplecarry = '1' then
if downq1 = "00000000" then
downq1 <= "01111111";
else
downq1 <= downq1 - 1;
end if;
end if;
end if;
end process;
--三角波下降部分，加法计数器；
end Behavioral;
