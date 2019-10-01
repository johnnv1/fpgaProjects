----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.09.2019 14:50:49
-- Design Name: 
-- Module Name: useI2CwithTempSensor - rtl
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

entity useI2CwithTempSensor is
    Port ( 
        clk : in STD_LOGIC;
        reset_n : in STD_LOGIC
        );
end useI2CwithTempSensor;

architecture rtl of useI2CwithTempSensor is

signal ena       :      STD_LOGIC;                    --latch in command
signal addr      :      STD_LOGIC_VECTOR(6 DOWNTO 0); --address of target slave
signal rw        :      STD_LOGIC;                    --'0' is write, '1' is read
signal data_wr   :      STD_LOGIC_VECTOR(7 DOWNTO 0); --data to write to slave
signal busy      :      STD_LOGIC;                    --indicates transaction in progress
signal data_rd   :      STD_LOGIC_VECTOR(7 DOWNTO 0); --data read from slave
signal ack_error :      STD_LOGIC;                    --flag if improper acknowledge from slave
signal sda       :      STD_LOGIC;                    --serial data output of i2c bus
signal scl       :      STD_LOGIC;
    
component i2c_master
  GENERIC(
    input_clk : INTEGER := 50_000_000; --input clock speed from user logic in Hz
    bus_clk   : INTEGER := 400_000);   --speed the i2c bus (scl) will run at in Hz
  PORT(
    clk       : IN     STD_LOGIC;                    --system clock
    reset_n   : IN     STD_LOGIC;                    --active low reset
    ena       : IN     STD_LOGIC;                    --latch in command
    addr      : IN     STD_LOGIC_VECTOR(6 DOWNTO 0); --address of target slave
    rw        : IN     STD_LOGIC;                    --'0' is write, '1' is read
    data_wr   : IN     STD_LOGIC_VECTOR(7 DOWNTO 0); --data to write to slave
    busy      : OUT    STD_LOGIC;                    --indicates transaction in progress
    data_rd   : OUT    STD_LOGIC_VECTOR(7 DOWNTO 0); --data read from slave
    ack_error : BUFFER STD_LOGIC;                    --flag if improper acknowledge from slave
    sda       : INOUT  STD_LOGIC;                    --serial data output of i2c bus
    scl       : INOUT  STD_LOGIC);                   --serial clock output of i2c bus
end component i2c_master;

begin
    
    i2c: i2c_master
        generic map(
            input_clk => 100000000
            )
        port map(
            clk       => clk,
            reset_n   => reset_n,
            ena       => ena,
            addr      => addr,
            rw        => rw,
            data_wr   => data_wr,
            busy      => busy,
            data_rd   => data_rd,
            ack_error => ack_error,
            sda       => sda,
            scl       => scl
        );

end rtl;
