----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.09.2019 14:50:49
-- Design Name: 
-- Module Name: useI2C_temp_sensor  - rtl
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

library work;
use work.temp_sensor_pkg.all;

entity useI2C_temp_sensor  is
    port (
        clk     : in std_logic;
        rst_n   : in std_logic;
        sda     : inout std_logic;
        scl     : inout std_logic;
        segment : out std_logic_vector(6 downto 0); -- segments control
        dot     : out STD_LOGIC;                    -- dot control
        anode   : out std_logic_vector(7 downto 0)
    );
end useI2C_temp_sensor ;

architecture rtl of useI2C_temp_sensor  is

    signal value : std_logic_vector(31 downto 0);
    type ctrl_states_type is (IDLE, WR, WAIT_WR, READ1, WAIT_RD1, READ2, WAIT_RD2, END_TRANSACTION );
    signal ctrl_state : ctrl_states_type;
    signal i2c_enable : std_logic;
    signal i2c_busy : std_logic;
    signal i2c_data_from : std_logic_vector(7 downto 0);
    signal i2c_read : std_logic;
    signal dummy : std_logic_vector(3 downto 0);


begin


    display : seven_segments
    port map (
        clk => clk,
        rst_n => rst_n,
        value => value,
        dot_i => x"FF",
        anode(7 downto 4) => dummy,
        anode(3 downto 0) => anode(3 downto 0),
        segment => segment,
        dot => dot
    );

    anode(7 downto 4) <= "1111";

    i2c : i2c_master
        generic map (
            input_clk => 100_000_000,
            bus_clk => 400_000
        )
        port map (
            clk => clk,
            reset_n => rst_n,
            ena => i2c_enable,
            addr => "1001011", -- 4b for sensor temp
            rw => i2c_read,
            data_wr => x"00",
            busy => i2c_busy,
            data_rd => i2c_data_from,
            ack_error => open,
            sda => sda,
            scl => scl
        );

    ctrl : process(clk)
    begin
        if (clk'event and clk='1') then
            if (rst_n = '0') then -- reset
                i2c_enable <= '0';
                i2c_read <= '0';
                ctrl_state <= IDLE;
                value <= (others => '0');
            else
                case ctrl_state is
                    when WR =>
                        i2c_enable <= '1';
                        if (i2c_busy = '1') then
                            ctrl_state <= WAIT_WR;
                        end if;
                    when WAIT_WR =>
                        i2c_enable <= '0';
                        if (i2c_busy = '0') then
                            ctrl_state <= READ1;
                        end if;
                    when READ1 =>
                        i2c_enable <= '1';
                        i2c_read <= '1';
                        if (i2c_busy = '1') then
                            ctrl_state <= WAIT_RD1;
                        end if;
                    when WAIT_RD1 =>
                        if (i2c_busy <= '0') then
                            ctrl_state <= READ2;
                            value(15 downto 8) <= i2c_data_from;
                        end if;
                    when READ2 =>
                        if (i2c_busy = '1') then
                            ctrl_state <= WAIT_RD2;
                        end if;
                    when WAIT_RD2 =>
                        i2c_enable <= '0';
                        if (i2c_busy = '0') then
                            value(7 downto 0) <= i2c_data_from;
                            ctrl_state <= END_TRANSACTION;
                        end if;
                    when END_TRANSACTION =>
                            ctrl_state <= IDLE;
                    when others => -- IDLE
                        ctrl_state <= WR;
                        i2c_enable <= '0';
                        i2c_read <= '0';
                end case;
            end if; -- reset
        end if; -- clk
    end process;
    
end rtl;
