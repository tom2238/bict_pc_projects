--------------------------------------------------------------------------------
-- Brno University of Technology, Department of Radio Electronics
--------------------------------------------------------------------------------
-- Author: Tomas Fryza (tomas.fryza@vut.cz)
-- Date: 2019-02-22 6:29
-- Design: top
-- Description: Implementation of 3-bit adder.
--------------------------------------------------------------------------------
-- TODO: Use input devices from CPLD expansion board, implement 3-bit full
--       adder, and display result on seven-segment LED display.
--
-- NOTE: Copy "hex_to_sseg.vhd", "one_of_four.vhd", and "coolrunner.ucf" files
--       from previous lab to current working folder.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------------------------
-- Entity declaration for top level
--------------------------------------------------------------------------------
entity top is
    port(
        -- Global input signals at CPLD expansion board
        cpld_sw_i : in std_logic_vector(16-1 downto 0);     -- switches or push buttons

        -- Global output signals at CPLD expansion board
        cpld_led_o : out std_logic_vector(16-1 downto 0);   -- active-high

        -- Global output signals at Coolrunner-II board
        disp_digit_o : out std_logic_vector(4-1 downto 0);  -- active-low
        disp_sseg_o  : out std_logic_vector(7-1 downto 0)   -- active-low cathodes
    );
end top;

--------------------------------------------------------------------------------
-- Architecture declaration for top level
--------------------------------------------------------------------------------
architecture Behavioral of top is
    signal s_hex : std_logic_vector(4-1 downto 0);  -- internal 4-bit data
    signal s_c0, s_c1 : std_logic;  -- internal carry bits
    signal a01, b01 : std_logic_vector(2 downto 0);
begin
    a01 <= cpld_sw_i(2 downto 0);
    b01 <= cpld_sw_i(10 downto 8);
    -- sub-blocks of three full_adders
    
    FA0: entity work.full_adder
        port map('0', b01(0), a01(0), s_c0, s_hex(0)); 
    FA1: entity work.full_adder
        port map(s_c0, b01(1), a01(1), s_c1, s_hex(1));  
    FA2: entity work.full_adder
        port map(s_c1, b01(2), a01(2), s_hex(3), s_hex(2));  

    -- show input data on CPLD expansion LEDs
    cpld_led_o <= cpld_sw_i;
    -- WRITE YOUR CODE HERE

    -- sub-block of hex_to_sseg entity
    HEX2SSEG: entity work.hex_to_sseg
        port map(
            s_hex,          -- 4-bit data to decode
            disp_sseg_o     -- 7-bit signal for 7-segment display
        );

    -- sub-block of one_of_four entity
    ONEOFFOUR: entity work.one_of_four
        port map(
            "00",           -- control signals for decoder
            disp_digit_o    -- display select signals
        );
end Behavioral;
