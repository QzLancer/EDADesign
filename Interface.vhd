library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Interface is
Port ( CLK : in std_logic;
	rst : in std_logic;
	CP,CCW : in std_logic;
	SubLevel: in std_logic_vector(3 downto 0);
	REFA,REFB,REFC : out std_logic_vector(11 downto 0)
);
end entity;

architecture behav of Interface is
	COMPONENT sin
	PORT
	(
		address : IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		clock : IN STD_LOGIC ;
		q : OUT STD_LOGIC_VECTOR (10 DOWNTO 0)
	);
END COMPONENT;

signal addrcnta,addrcntb,addrcntc,addrcnt : std_logic_vector(11 downto 0);
signal dataouta,dataoutb,dataoutc,dataout : std_logic_vector(10 downto 0);
signal update_a,update_b,update_c : std_logic;

signal lstage : std_logic_vector(3 downto 0) := "0000";

signal SubLevel_r : std_logic_vector(3 downto 0);

signal CPr_1,CP_en,CPr_3,CPr_2: std_logic;
signal CPr :std_logic_vector(15 downto 0) := "0000000000000000";
signal full_cur:std_logic:='0';
signal cnt:std_logic_vector(3 downto 0);
signal cnt_flag:std_logic;

begin
------------------------------------------
		SubLevel_r <= SubLevel; 
		full_cur <= '0';
-------------------------------------------

process(clk, CP)
begin
	if clk='1' and clk'event then
		CPr(0) <= CP;
	end if;
end process;

process(clk, CPr(0))
begin
	if clk='1' and clk'event then
		CPr(1) <= CPr(0);
	end if;
end process;

process(clk, CPr(1))
	begin
		if clk='1' and clk'event then
		CPr(2) <= CPr(1);
	end if;
end process;

process(clk, CPr(2))
	begin
	if clk='1' and clk'event then
		CPr(3) <= CPr(2);
	end if;
end process;

process(clk, CPr(3))
begin
	if clk='1' and clk'event then
		CPr(4) <= CPr(3);
	end if;
end process;

process(clk, CPr(4))
begin
	if clk='1' and clk'event then
		CPr(5) <= CPr(4);
	end if;
end process;

process(clk, CPr(5))
begin
	if clk='1' and clk'event then
		CPr(6) <= CPr(5);
	end if;
end process;

process(clk, CPr(6))
	begin
	if clk='1' and clk'event then
		CPr(7) <= CPr(6);
	end if;
end process;

process(clk, CPr(7))
	begin
	if clk='1' and clk'event then
		CPr(8) <= CPr(7);
	end if;
end process;

process(clk, CPr(8))
	begin
	if clk='1' and clk'event then
		CPr(9) <= CPr(8);
	end if;
	end process;
	
process(clk, CPr(9))
	begin
	if clk='1' and clk'event then
		CPr(10) <= CPr(9);
	end if;
end process;

process(clk, CPr(10))
	begin
	if clk='1' and clk'event then
		CPr(11) <= CPr(10);
	end if;
end process;

process(clk, CPr(11))
	begin
	if clk='1' and clk'event then
		CPr(12) <= CPr(11);
	end if;
end process;

process(clk, CPr(12))
	begin
	if clk='1' and clk'event then
		CPr(13) <= CPr(12);
	end if;
end process;

process(clk, CPr(13))
	begin
	if clk='1' and clk'event then
		CPr(14) <= CPr(13);
	end if;
end process;

process(clk, CPr(14))
	begin
	if clk='1' and clk'event then
		CPr(15) <= CPr(14);
	end if;
end process;

CPr_1 <= CPr(0) and not CPr(15);

process(clk, CPr_1)
	begin
	if clk='1' and clk'event then
		CP_en <= CPr_1;
	end if;
end process;

----------------------MODIFIED,in 2010 3.18-----------------------------
--Sine ROM Address input Generation
process(clk,lstage) --ROM 地址线分时复用：把三相地址依次送到addrcnt
						  --addrcnt 最后送到正弦数据表ROM 的地址端
begin
	if(clk'event and clk='1') then
		if (lstage = "0001" ) then
			addrcnt <= addrcnta;
		elsif(lstage = "0101" ) then
			addrcnt <= addrcntb ;
		elsif(lstage = "1001" ) then
			addrcnt <= addrcntc;
		else
			addrcnt <= addrcnt;
		end if;
	end if;
end process;
------------------------------------------------------------
-- Sine ROM data output assignment --ROM 数据线分时复用：依次把正弦数据送给三相
dataouta <= dataout when lstage = ("0010" OR "0011" );
dataoutb <= dataout when lstage = ("0110" OR "0111" );
dataoutc <= dataout when lstage = ("1001" OR "1010" );
------------------------------------------------------------
-- Reference value output register enable: --生成各相更新信号，表明正弦数据有更新
update_a <= '1' when lstage = ("0010" OR "0011" ) else
'0';
update_b <= '1' when lstage = ("0110" OR "0111" ) else
'0';
update_c <= '1' when lstage = ("1001" OR "1010" )else
'0';
-------------------------------------------------------在正弦数据有更新时把数据送给端口信号输出
-- CW/CCW direction multiplexer & Register Update FDE
process (CLK, rst)
begin
	if rst = '0' then
	REFA <= (others=>'0');
		elsif CLK='1' and CLK'event then
		if update_a = '1' then
			if(full_cur='1') then
				REFA <= dataouta&'0'; --&相当于verilog 中的拼接运算
			else
				REFA<= '0'&dataouta;
			end if;
		end if;
	end if;
end process;

process (CLK, rst)
begin
	if rst = '0' then
		REFB <= (others=>'0');
	elsif CLK='1' and CLK'event then
		if update_b = '1' then
			if(full_cur='1') then
				REFB <= dataoutb&'0';
			else
				REFB<= '0'&dataoutb;
			end if;
		end if;
	end if;
end process;

process (CLK, rst)
begin
	if rst = '0' then
		REFC <= (others=>'0');
	elsif CLK='1' and CLK'event then
		if update_c = '1' then
			if(full_cur='1') then
				REFC <= dataoutc&'0';
			else
				REFC<= '0'&dataoutc;
			end if;
		end if;
	end if;
end process;

------------------------------------------------------------下列是生成三相地址，用于寻址ROM 表
-- 14 bits address counter
process (CLK,rst,CCW,addrcnta,cp_en)
begin
	if rst='0' then
		addrcnta <= "000000000000";
	elsif CP_en = '1' and cp_en'event then
		if CCW = '0' then
			case SubLevel_r is
			when "0100" => ---------------- 16 levels subdivide
				addrcnta <= addrcnta + 128;
			when "0101" => ------------------ 32 levels subdivide
				addrcnta <= addrcnta + 64;
			when "0110" => ------------------ 64 levels subdivide
				addrcnta <= addrcnta + 32;
			when "0111" => ------------------ 128 levels subdivide
				addrcnta <= addrcnta + 16;
			when "1000" => ------------------ 256 levels subdivide
				addrcnta <= addrcnta + 8;
			when "1001" => ------------------ 512 levels subdivide
				addrcnta <= addrcnta + 4;
			when "1010" => ------------------ -- 1024 levels subdivide
				addrcnta <= addrcnta + 2;
			when "1011" => -- ----------------2048 levels subdivide
				addrcnta <= addrcnta + 1;
			when others => ------------------ 4096 levels subdivide
				addrcnta <= addrcnta + 1;
			end case;
		elsif CCW ='1' then
			case SubLevel_r is
			when "0100" => ------------------ 16 levels subdivide
				addrcnta <= addrcnta - 128;
			when "0101" => ------------------ 32 levels subdivide
				addrcnta <= addrcnta - 64;
			when "0110" => ------------------ 64 levels subdivide
				addrcnta <= addrcnta - 28;
			when "0111" => ------------------ 128 levels subdivide
				addrcnta <= addrcnta - 16;
			when "1000" => ------------------ 256 levels subdivide
				addrcnta <= addrcnta - 8;
			when "1001" => ------------------ 512 levels subdivide
				addrcnta <= addrcnta - 4;
			when "1010" => ------------------ 1024 levels subdivide
				addrcnta <= addrcnta - 2;
			when "1011" => ------------------ 2048 levels subdivide
				addrcnta <= addrcnta - 1;
			when others => ------------------ 4096 levels subdivide
				addrcnta <= addrcnta - 1;
			end case;
		end if;
	end if;
end process;

process (CLK,rst,CCW,addrcntb,CP_en)
begin
	if rst='0' then
		addrcntb <= "010101010101";
	elsif CP_en = '1' and cp_en'event then
		if CCW = '0' then
			case SubLevel_r is
			when "0100" => ------------------ 16 levels subdivide
				addrcntb <= addrcntb + 128;
			when "0101" => ------------------ 32 levels subdivide
				addrcntb <= addrcntb + 64;
			when "0110" => ------------------ 64 levels subdivide
				addrcntb <= addrcntb + 32;
			when "0111" => ------------------ 128 levels subdivide
				addrcntb <= addrcntb + 16;
			when "1000" => ------------------ 256 levels subdivide
				addrcntb <= addrcntb + 8;
			when "1001" => ------------------ 512 levels subdivide
				addrcntb <= addrcntb + 4;
			when "1010" => ------------------ 1024 levels subdivide
				addrcntb <= addrcntb + 2;
			when "1011" => ------------------ 2048 levels subdivide
				addrcntb <= addrcntb + 1;
			when others => ------------------ 4096 levels subdivide
				addrcntb <= addrcntb + 1;
			end case;
		elsif CCW ='1' then
			case SubLevel_r is
			when "0100" => ------------------- 16 levels subdivide
				addrcntb <= addrcntb - 128;
			when "0101" => ------------------ 32 levels subdivide
				addrcntb <= addrcntb - 64;
			when "0110" => ------------------ 64 levels subdivide
				addrcntb <= addrcntb - 32;
			when "0111" => ------------------ 128 levels subdivide
				addrcntb <= addrcntb - 16;
			when "1000" => ------------------ 256 levels subdivide
				addrcntb <= addrcntb - 8;
			when "1001" => ------------------ 512 levels subdivide
				addrcntb <= addrcntb - 4;
			when "1010" => ------------------ 1024 levels subdivide
				addrcntb <= addrcntb - 2;
			when "1011" => ------------------ 2048 levels subdivide
				addrcntb <= addrcntb - 1;
			when others => ------------------ 4096 levels subdivide
				addrcntb <= addrcntb - 1;
			end case;
		end if;
	end if;
end process;

process (CLK,rst,CCW,addrcntc,Cp_en)
begin
	if rst='0' then
		addrcntc <= "101010101011";
	elsif CP_en = '1' and cp_en'event then
		if CCW = '0' then
			case SubLevel_r is
			when "0100" => ------------------ 16 levels subdivide
				addrcntc <= addrcntc + 128;
			when "0101" => ------------------ 32 levels subdivide
				addrcntc <= addrcntc + 64;
			when "0110" => ------------------ 64 levels subdivide
				addrcntc <= addrcntc + 32;
			when "0111" => ------------------ 128 levels subdivide
				addrcntc <= addrcntc + 16;
			when "1000" => ------------------ 256 levels subdivide
				addrcntc <= addrcntc + 8;
			when "1001" => ------------------ 512 levels subdivide
				addrcntc <= addrcntc + 4;
			when "1010" => ------------------ 1024 levels subdivide
				addrcntc <= addrcntc + 2;
			when "1011" => ------------------ 2048 levels subdivide
				addrcntc <= addrcntc + 1;
			when others => ------------------ 4096 levels subdivide
				addrcntc <= addrcntc + 1;
			end case;
		elsif CCW ='1' then
			case SubLevel_r is
			when "0100" => ------------------ 16 levels subdivide
				addrcntc <= addrcntc - 128;
			when "0101" => ------------------ 32 levels subdivide
				addrcntc <= addrcntc - 64;
			when "0110" => ------------------ 64 levels subdivide
				addrcntc <= addrcntc - 32;
			when "0111" => ------------------ 128 levels subdivide
				addrcntc <= addrcntc - 16;
			when "1000" => ------------------ 256 levels subdivide
				addrcntc <= addrcntc - 8;
			when "1001" => ------------------ 512 levels subdivide
				addrcntc <= addrcntc - 4;
			when "1010" => ------------------ 1024 levels subdivide
				addrcntc <= addrcntc - 2;
			when "1011" => ------------------ 2048 levels subdivide
				addrcntc <= addrcntc - 1;
			when others =>
				addrcntc <= addrcntc - 1;
			end case;
			end if;
	end if;
end process;

-----------------------------------------------
--sequencially lookup in the sine rom	--生成Istage信号，用于控制分时复用
process(CLK,rst)
begin
	if rst = '0' then
		lstage <= (others => '0');
	elsif CLK = '1' and CLK'event then
		if lstage /= "0000" then
			lstage <= lstage + 1;
		elsif(CP_en='1')then
			lstage <= lstage + 1;
		end if;
	end if;
end process;

-----------------------------------------------调用ROM模块，生成正弦数据表
Inst_SineROM:sin PORT MAP(
	clock=>CLK,
	address=>addrcnt,
	q=>dataout
);

end behav;