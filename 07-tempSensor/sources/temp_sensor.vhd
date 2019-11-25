----------------------------------------------------------------------------------
-- Company: Uergs
-- Engineer: Joao Leonardo Fragoso 
-- 
-- Create Date: 10/01/2019 10:00:00
-- Design Name: temp_sensor
-- Module Name: temp_sensor rtl
-- Project Name: Temperature Sensor
-- Target Devices: Nexys 4 DDR (xc7a100tcsg324-1) Digilent Board
-- Tool Versions: Vivado 2017.3
-- Description: This a temperature sensor reader.
-- Dependencies: Board information on Vivado instalation
-- 
-- Revision 0.01 - File Created
-- Additional Comments:
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.temp_sensor_pkg.all;

entity temp_sensor is
    port (
        clk : in std_logic;
        rst_n : in std_logic;
        sda : inout std_logic;
        scl : inout std_logic;
        segment : out std_logic_vector(7 downto 0);
        an : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of temp_sensor is
    signal value : std_logic_vector(31 downto 0);
    signal i2c_value : std_logic_vector(15 downto 0);
    alias temp : std_logic_vector(12 downto 0) is i2c_value(15 downto 3);
    type ctrl_states_type is (IDLE, WR, WAIT_WR, READ1, WAIT_RD1, READ2, WAIT_RD2, END_TRANSACTION );
    signal ctrl_state : ctrl_states_type;
    signal i2c_enable : std_logic;
    signal i2c_busy : std_logic;
    signal i2c_data_from : std_logic_vector(7 downto 0);
    signal i2c_read : std_logic;
    signal dummy : std_logic_vector(1 downto 0);
    signal negative : std_logic;
    signal anode_sig : std_logic;
    signal seg_ov : std_logic_vector(7 downto 0);
    signal rst_n_sync : std_logic_vector(0 to 2);
    
begin
    process(clk)
    begin
        if(clk'event and clk='1') then
            rst_n_sync <= rst_n_sync(1 to 2) & rst_n;
        end if;
    end process;
    
    display : seven_segments
    port map (
        clk => clk,
        rst_n => rst_n_sync(0),
        value => value,
        point => x"FB",
        an(7 downto 6) => dummy,
        an(5) => anode_sig,
        an(4 downto 0) => an(4 downto 0),
        segment => seg_ov
    );

    an(7 downto 6) <= "11";
    an(5) <= not (negative and not anode_sig);
    segment <= "11111101" when (anode_sig='0' and negative='1') else seg_ov;

    i2c : i2c_master
    generic map (
        input_clk => 100_000_000,
        bus_clk => 400_000
    )
    port map (
        clk => clk,
        reset_n => rst_n_sync(0),
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

    value(31 downto 20) <= x"000";
    t2bcd : temp2bcd
        port map (
            value_in => temp,
            negative => negative,
            bcd => value(19 downto 0)
        );

    ctrl : process(clk)
    begin
        if (clk'event and clk='1') then
            if (rst_n_sync(0) = '0') then -- reset
                i2c_enable <= '0';
                i2c_read <= '0';
                ctrl_state <= IDLE;
                i2c_value <= (others => '0');
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
                        i2c_value(15 downto 8) <= i2c_data_from;
                    end if;
                when READ2 =>
                    if (i2c_busy = '1') then
                        ctrl_state <= WAIT_RD2;
                    end if;
                when WAIT_RD2 =>
                    i2c_enable <= '0';
                    if (i2c_busy = '0') then
                        i2c_value(7 downto 0) <= i2c_data_from;
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

