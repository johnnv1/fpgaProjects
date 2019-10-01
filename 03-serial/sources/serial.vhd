----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.09.2019 14:50:16
-- Design Name: 
-- Module Name: serial - rtl
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity serial is
    -- BAUND RATE = BR = 115200
    -- CLK FREQ = 100MHz = 100.000.000
    -- 869 cycles for each bit, to make 115200 of baund rate
        -- 869 need 10 bits to count
    
    Port ( clk : in STD_LOGIC;
           rst: in STD_LOGIC;
           data : in STD_LOGIC_VECTOR (7 downto 0);
           send : in STD_LOGIC;
           busy : out std_logic;    -- enable when state != ocupado
           ledOut: out std_logic_vector(10 downto 0);
           tx : out STD_LOGIC
           );
end serial;

architecture rtl of serial is
    
    type states is (IDLE, start, b0, b1 , b2, b3, b4, b5, b6, b7, stop);
    signal currentState : states;
    signal delayFlag: std_logic;
    signal rstDelay: std_logic;
    
    component delay
        generic (
            --clock frequency (100MHz -> 0,00000001?s for cycle)
            CLK_FREQ            : integer := 100_000_000;

            --clock quantity of delay - baud rate = 115200 
                --f = 1/T
            DELAY_TIME          : integer := 100
        );
        
        port (
            clk                 : in STD_LOGIC;
            rst_n               : in STD_LOGIC;
            pulseOut            : out STD_LOGIC
        );

    end component delay;
    
begin
    idelay : delay
        generic map (
            DELAY_TIME => 115200
        )
        port map (
            clk         => clk,
            rst_n       => rstDelay,
            pulseOut    => delayFlag
        );
        
    process(clk)
    begin
        if (clk'event and clk='1') then
            if(rst='0') then
                currentState <= IDLE;
            else 
                case currentState is
                    when start =>
                        if (delayFlag = '1') then
                            currentState <= b0;
                        end if;
                    when b0 =>
                        if (delayFlag = '1') then
                            currentState <= b1;
                        end if;
                    when b1 =>
                        if (delayFlag = '1') then
                            currentState <= b2;
                        end if;
                    when b2 =>
                        if (delayFlag = '1') then
                            currentState <= b3;
                        end if;
                    when b3 =>
                        if (delayFlag = '1') then
                            currentState <= b4;
                        end if;
                    when b4 =>
                        if (delayFlag = '1') then
                            currentState <= b5;
                        end if;
                    when b5 =>
                        if (delayFlag = '1') then
                            currentState <= b6;
                        end if;
                    when b6 =>
                        if (delayFlag = '1') then
                            currentState <= b7;
                        end if;
                    when b7 =>
                        if (delayFlag = '1') then
                            currentState <= stop;
                        end if;
                    when stop =>
                        if (delayFlag = '1') then
                            currentState <= IDLE;
                        end if;
                    when others =>  -- idle
                        if (send='1') then
                            currentState <= start;
                        end if;
                end case;
            end if;
        end if;
    end process;

    rstDelay <= '0' when currentState=IDLE else '1';
    busy <= '0' when currentState=IDLE else '1';
        
    tx <= '0' when (currentState=start) else
           data(0) when (currentState=b0) else 
           data(1) when (currentState=b1) else 
           data(2) when (currentState=b2) else 
           data(3) when (currentState=b3) else 
           data(4) when (currentState=b4) else 
           data(5) when (currentState=b5) else 
           data(6) when (currentState=b6) else 
           data(7) when (currentState=b7) else
           '1'; 
   ledOut <= "00000000001" when (currentState=start) else
           "00000000010" when (currentState=b0) else 
           "00000000100" when (currentState=b1) else 
           "00000001000" when (currentState=b2) else 
           "00000010000" when (currentState=b3) else 
           "00000100000" when (currentState=b4) else 
           "00001000000" when (currentState=b5) else 
           "00010000000" when (currentState=b6) else 
           "00100000000" when (currentState=b7) else
           "01000000000" when (currentState=stop) else
           "10000000000"; 
end rtl;
