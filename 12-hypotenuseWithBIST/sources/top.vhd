----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.11.2019 12:25:43
-- Design Name: 
-- Module Name: top - rtl
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

entity top is
    Port ( clk : in STD_LOGIC;
           rst_n : in STD_LOGIC;
           a_i : in STD_LOGIC_VECTOR (3 downto 0);
           b_i : in STD_LOGIC_VECTOR (3 downto 0);
           test_enable : in STD_LOGIC;
           value_out : out STD_LOGIC_VECTOR (3 downto 0);
           error_flag : out STD_LOGIC;
           error_place : out STD_LOGIC_VECTOR (1 downto 0);
           test_A_sqr: in STD_LOGIC_VECTOR (7 downto 0);
           test_B_sqr: in STD_LOGIC_VECTOR (7 downto 0);       
           test_sum: in STD_LOGIC_VECTOR (7 downto 0);       
           test_sqrt: in STD_LOGIC_VECTOR (3 downto 0);
           sqr_a_res  : out STD_LOGIC_VECTOR (7 downto 0);
           sqr_b_res  : out STD_LOGIC_VECTOR (7 downto 0);
           sum_res      : out STD_LOGIC_VECTOR (7 downto 0);
           sqrt_res      : out STD_LOGIC_VECTOR (3 downto 0));
end top;

architecture rtl of top is  

signal a                : STD_LOGIC_VECTOR (3 downto 0);
signal b                : STD_LOGIC_VECTOR (3 downto 0);
signal square_a_result  : STD_LOGIC_VECTOR (7 downto 0);
signal square_b_result  : STD_LOGIC_VECTOR (7 downto 0);
signal sum_result       : STD_LOGIC_VECTOR (7 downto 0);
signal sqrt_result      : STD_LOGIC_VECTOR (3 downto 0);
signal a_SQR_flag       : std_logic;
signal b_SQR_flag       : std_logic;
signal sum_flag         : std_logic;
signal sqrt_flag        : std_logic;

component square
port( 
clk         : in std_logic;
rst_n       : in std_logic;
data_in     : in std_logic_vector(3 downto 0);
out_flag    : out std_logic;
data_out    : out std_logic_vector(7 downto 0));
end component square;

component sum
port( 
clk         : in std_logic;
rst_n       : in std_logic;
a_i         : in std_logic_vector(7 downto 0);
b_i         : in std_logic_vector(7 downto 0);
out_flag    : out std_logic;
data_out    : out std_logic_vector(7 downto 0));
end component sum;

component sqrt
port( 
clock      : in std_logic;  
rst_n      : in std_logic;
data_in    : in std_logic_vector(7 downto 0); 
out_flag    : out std_logic;
data_out   : out std_logic_vector(3 downto 0));
end component sqrt;


begin

    squareofa : square
    port map( 
        clk         => clk,  
        rst_n       => rst_n,
        data_in     => a, 
        out_flag    => a_SQR_flag,
        data_out    => square_a_result
    );

    squareofb : square
    port map( 
        clk         => clk,  
        rst_n       => rst_n,
        data_in     => b, 
        out_flag    => b_SQR_flag,
        data_out    => square_b_result
    );

    sumof : sum
    port map( 
        clk => clk,  
        rst_n => rst_n,
        a_i => square_a_result, 
        b_i => square_b_result, 
        out_flag    => sum_flag,
        data_out => sum_result
    );

    sqrtof : sqrt
    port map( 
        clock => clk,  
        rst_n => rst_n,
        data_in => sum_result, 
        out_flag    => sqrt_flag,
        data_out => sqrt_result
    );
    
    
    process(clk)
    begin
        if(clk'event and clk = '1') then
            if (test_enable = '1') then
                if(a_SQR_flag = '1') then
                    if (square_a_result /= test_A_sqr) then
                        error_flag <= '1';
                        error_place <= "00";
                    end if;
                end if;
                if(b_SQR_flag = '1') then
                    if (square_b_result /= test_B_sqr) then
                        error_flag <= '1';
                        error_place <= "01";
                    end if;
                end if;
                if(sum_flag = '1') then
                    if (sum_result /= test_sum) then
                        error_flag <= '1';
                        error_place <= "10";
                    end if;
                end if;
                if(sqrt_flag = '1') then
                    if (sqrt_result /= test_sqrt) then
                        error_flag <= '1';
                        error_place <= "11";
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    value_out <= sqrt_result;
    a <= a_i;
    b <= b_i;
    sqr_a_res <= square_a_result;
    sqr_b_res <= square_b_result;
    sum_res <= sum_result;
    sqrt_res <= sqrt_result; 
end rtl;
