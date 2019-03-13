--------------------------------------------------------------------------------
-- Brno University of Technology, Department of Radio Electronics
--------------------------------------------------------------------------------
-- Author: Tomas Fryza (tomas.fryza@vut.cz)
-- Date: 2019-01-17 13:45:54
-- Design: top
-- Description: Hexadecimal digit to seven-segment LED decoder.
--------------------------------------------------------------------------------
-- TODO: Use input devices and display values 0 to F on seven-segment LED display.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------------------------
-- Entity declaration for top level
--------------------------------------------------------------------------------
entity top is
    port(
        -- Global input signals at Coolrunner-II board
        sw_i  : in std_logic_vector(2-1 downto 0);  -- slide switches
        btn_i : in std_logic_vector(2-1 downto 0);  -- push buttons

        -- Global output signals at Coolrunner-II board
        led_o        : out std_logic_vector(4-1 downto 0);  -- active-low
        disp_digit_o : out std_logic_vector(4-1 downto 0);  -- active-low
        disp_sseg_o  : out std_logic_vector(7-1 downto 0)   -- active-low cathodes
    );
end top;

--------------------------------------------------------------------------------
-- Architecture declaration for top level
--------------------------------------------------------------------------------
architecture Behavioral of top is
    signal s_hex : std_logic_vector(4-1 downto 0);  -- internal 4-bit data
begin
    -- combine inputs [sw1, sw0, btn1, btn0] to internal data
    s_hex(3) <= sw_i(1);
    s_hex(2) <= sw_i(0);
    s_hex(1) <= not btn_i(1);
    s_hex(0) <= not btn_i(0);

    -- sub-block of hex_to_sseg entity
    HEX2SSEG: entity work.hex_to_sseg
        port map(s_hex, disp_sseg_o);

    -- sub-block of one_of_four entity
    ONEOFFOUR: entity work.one_of_four
        port map(s_hex(3 downto 2), disp_digit_o);

    -- turn LED3 on for value 0
    led_o(3) <= s_hex(3) or s_hex(2) or s_hex(1) or s_hex(0);

    -- turn LED2 on for powers of 2, i.e. 1,2,4,8
    led_o(2) <= not((s_hex(0) and not(s_hex(1)) and not(s_hex(2)) and not(s_hex(3))) or (s_hex(1) and not(s_hex(0)) and not(s_hex(2)) and not(s_hex(3))) or (s_hex(3) and not(s_hex(1)) and not(s_hex(2)) and not(s_hex(0))) or (s_hex(2) and not(s_hex(1)) and not(s_hex(0)) and not(s_hex(3))));   -- WRITE YOUR CODE HERE

    -- turn LED1 on for odd values, i.e. 1,3,5,...
    led_o(1) <= not(s_hex(0));   -- WRITE YOUR CODE HERE

    -- turn LED0 on for values A,B,...,F
    led_o(0) <= not( ( s_hex(3) and s_hex(1)) or (s_hex(3) and s_hex(2) ));   -- WRITE YOUR CODE HERE
end Behavioral;
