----------------------------------------------------------------------------------
-- Company: Uergs
-- Engineer: Joao Leonardo Fragoso 
-- 
-- Create Date: 08/15/2019 15:00:00
-- Design Name: cronometer
-- Module Name: fifo - rtl
-- Project Name: Cronometer
-- Target Devices: Nexys 4 DDR (xc7a100tcsg324-1) Digilent Board
-- Tool Versions: Vivado 2017.3
-- Description: This a simple parametric fifo for synchronozing asynchronous
--				signals.
-- Dependencies: Board information on Vivado instalation
-- 
-- Revision: 0.02 - Added comments and formating
-- Revision 0.01 - File Created
-- Additional Comments:
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity seven_segments is
    port ( 
		clk     : in  std_logic; -- clock signal
		rst_n   : in  std_logic; -- synchronous reset active low
		value   : in  std_logic_vector(31 downto 0); -- hex data to display (4 bits per display)
		point   : in  std_logic_vector(7 downto 0);  -- point control
		an      : out std_logic_vector(7 downto 0); -- display anode selection
		segment : out std_logic_vector(7 downto 0) -- segments control
	);
end seven_segments;

architecture rtl of seven_segments is
	signal   sample_delay     : std_logic_vector(16 downto 0);
	signal   s_anodes         : std_logic_vector(7 downto 0);
	signal   value_to_display : std_logic_vector(3 downto 0);
	signal   next_display     : std_logic;
	attribute keep_hierarchy : string;
    attribute keep_hierarchy of rtl : architecture is "yes";
begin
	-- process for sample display
	-- change to next one (~1ms delay)
	process(clk)
	begin
		if (clk'event and clk = '1') then
            sample_delay <= sample_delay + 1;
		end if;
	end process;
	
	process(sample_delay)
	begin
		if (sample_delay = "11111111111111111") then
			next_display <= '1';
		else
			next_display <= '0';
		end if;
	end process;

	process(clk)
	begin
	   if (clk'event and clk = '1') then
			if (rst_n = '0') then
				s_anodes <= "11111110";
			else
				if (next_display = '1') then
					s_anodes <= s_anodes(6 downto 0) & s_anodes(7); -- rotate left
				end if;
           	end if;
       end if;
    end process;

	value_to_display <= value(31 downto 28) when s_anodes = "0-------" else
						value(27 downto 24) when s_anodes = "-0------" else
						value(23 downto 20) when s_anodes = "--0-----" else
						value(19 downto 16) when s_anodes = "---0----" else
						value(15 downto 12) when s_anodes = "----0---" else
						value(11 downto 8)  when s_anodes = "-----0--" else
						value(7 downto 4)   when s_anodes = "------0-" else
						value(3 downto 0);

	segment(0) <= point(7) when s_anodes(7) = '0' else
				  point(6) when s_anodes(6) = '0' else
				  point(5) when s_anodes(5) = '0' else
				  point(4) when s_anodes(4) = '0' else
				  point(3) when s_anodes(3) = '0' else
				  point(2) when s_anodes(2) = '0' else
				  point(1) when s_anodes(1) = '0' else
				  point(0);
				  
    an <= s_anodes;
    
	with value_to_display select segment(7 downto 1) <=
				"0111000" when x"F",
				"0110000" when x"E",
				"1000010" when x"d",
				"0110001" when x"C",
				"1100000" when x"b",
				"0001000" when x"A",
				"0000100" when x"9",
				"0000000" when x"8",
				"0001111" when x"7",
				"0100000" when x"6",
				"0100100" when x"5",
				"1001100" when x"4",
				"0000110" when x"3",
				"0010010" when x"2",
				"1001111" when x"1",
				"0000001" when others;
			

end rtl;
