
library IEEE;
use IEEE.std_logic_1164.all;

package temp_sensor_pkg is
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
    END component i2c_master;

    component seven_segments
    port ( 
		clk     : in  std_logic; -- clock signal
		rst_n   : in  std_logic; -- synchronous reset active low
		value   : in  std_logic_vector(31 downto 0); -- hex data to display (4 bits per display)
        dot_i   : in  std_logic_vector(7 downto 0);  -- point control
		anode   : out std_logic_vector(7 downto 0); -- display anode selection
        segment : out std_logic_vector(6 downto 0); -- segments control
        dot     : out STD_LOGIC             -- dot control
	);
    end component seven_segments;

    function all_bits_in_one(slv : in std_logic_vector) return std_logic;

end temp_sensor_pkg;

package body temp_sensor_pkg is
    function all_bits_in_one(slv : in std_logic_vector) return std_logic is
        variable result : std_logic := '1';
    begin
        for i in slv'range loop
            result := result and slv(i);
        end loop;
        return result;
    end function;

end temp_sensor_pkg;

