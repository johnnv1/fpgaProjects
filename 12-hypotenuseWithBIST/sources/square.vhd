----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.12.2019 22:59:45
-- Design Name: 
-- Module Name: square - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library ieee; 
use ieee.std_logic_1164.all; 
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity square is
Port (
    clk : in std_logic;
    rst_n : in std_logic;
    data_in : in std_logic_vector(3 downto 0);
    out_flag : out std_logic;
    data_out : out std_logic_vector(7 downto 0)
);
end square;

architecture Behavioral of square is

--signal count    : std_logic_vector(1 downto 0);
signal value    : std_logic_vector(3 downto 0);
signal aux      : std_logic_vector(3 downto 0);
signal result   : std_logic_vector(7 downto 0);
signal res_tmp  : std_logic_vector(7 downto 0);

begin

    process(clk)
    begin
        if(clk'event and clk = '1') then
            if(rst_n = '0') then
                res_tmp <= (others => '0');
                aux <= (others => '0');
                value <= (others => '0');
--                count <= (others => '0');
--                result <= (others => '0');
            else
--                if(count = "00") then
                    value <= data_in;
                    aux <= data_in;
                    res_tmp <= value * aux;
--                end if;
            end if;
        end if;
    end process;

data_out <= res_tmp;

process(res_tmp)
begin
    if(rst_n = '1') then
        if (res_tmp'event) then
            out_flag <= '1';
        end if;
    else
        out_flag <= '0';
    end if;
end process;

end Behavioral;
