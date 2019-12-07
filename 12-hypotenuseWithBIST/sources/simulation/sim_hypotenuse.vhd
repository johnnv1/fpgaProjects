----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.12.2019 16:09:57
-- Design Name: 
-- Module Name: sim_hypotenuse - rtl
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
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.MATH_REAL.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sim_hypotenuse is
end sim_hypotenuse;

architecture rtl of sim_hypotenuse is

    component top
    Port(  clk : in STD_LOGIC;
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
    end component top;
    
    signal clk              :  STD_LOGIC                        := '0';
    signal rst_n            :  STD_LOGIC                        := '0';
    signal a_i              :  STD_LOGIC_VECTOR (3 downto 0)    := "0100"; -- 4
    signal b_i              :  STD_LOGIC_VECTOR (3 downto 0)    := "0011"; -- 3
    signal test_enable      :  STD_LOGIC                        := '0';
    signal value_out        :  STD_LOGIC_VECTOR (3 downto 0)    := "0000";
    signal error_flag       :  STD_LOGIC                        := '0';
    signal error_place      :  STD_LOGIC_VECTOR (1 downto 0)    := "00";
    signal test_A_sqr       :  STD_LOGIC_VECTOR (7 downto 0)    := "00010000"; -- 16
    signal test_B_sqr       :  STD_LOGIC_VECTOR (7 downto 0)    := "00001001"; -- 9 
    signal test_sum         :  STD_LOGIC_VECTOR (7 downto 0)    := "00011001"; -- 25       
    signal test_sqrt        :  STD_LOGIC_VECTOR (3 downto 0)    := "0101"; -- 5
    signal sqr_a_res        :  STD_LOGIC_VECTOR (7 downto 0);
    signal sqr_b_res        :  STD_LOGIC_VECTOR (7 downto 0);
    signal sum_res          :  STD_LOGIC_VECTOR (7 downto 0);
    signal sqrt_res         :  STD_LOGIC_VECTOR (3 downto 0);
    
    signal cont             :  STD_LOGIC_VECTOR (15 downto 0);
begin
    
    clk <= not clk after 5 ns;
    rst_n <= '1' after 40 ns;
    test_enable <= '1' after 30 ns;
    
    calcHypo: top port map (
        clk         => clk,
        rst_n       => rst_n,
        a_i         => a_i,
        b_i         => b_i,
        test_enable => test_enable,
        value_out   => value_out,
        error_flag  => error_flag,
        error_place => error_place, 
        test_A_sqr  => test_A_sqr,
        test_B_sqr  => test_B_sqr,
        test_sum    => test_sum,
        test_sqrt   => test_sqrt,
        sqr_a_res   => sqr_a_res,
        sqr_b_res   => sqr_b_res,
        sum_res     => sum_res,
        sqrt_res    => sqrt_res
    );
    
    
    process(clk)
    begin
    if(clk'event and clk='1') then
        if(rst_n='1') then
            cont <= cont + 1;
            if (cont = 20) then
                a_i             <= "0001"; -- 1
                b_i             <= "0011"; -- 3
                test_A_sqr      <= "00000001"; -- 1
                test_B_sqr      <= "00001001"; -- 9 
                test_sum        <= "00001010"; -- 10       
                test_sqrt       <= "0011"; -- 3
            elsif (cont = 40) then
                a_i             <= "0101"; -- 5
                b_i             <= "0010"; -- 2
                test_A_sqr      <= "00011001"; -- 25
                test_B_sqr      <= "00000100"; -- 4 
                test_sum        <= "00011101"; -- 29       
                test_sqrt       <= "1001"; -- 9 ou 10
            elsif (cont = 60) then
                a_i             <= "0100"; -- 4
                b_i             <= "0011"; -- 3
                test_A_sqr      <= "00001111"; -- 16 --- adicionado uma comparação errada aqui ou seja ta testando = 15
                test_B_sqr      <= "00001001"; -- 9 
                test_sum        <= "00011001"; -- 25       
                test_sqrt       <= "0101"; -- 5
            end if;
        else
             cont <= (others => '0');
        end if;            
    end if;
    end process;
end rtl;
