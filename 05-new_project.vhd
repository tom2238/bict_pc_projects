--------------------------------------------------------------------------------
-- Brno University of Technology, Department of Radio Electronics
--------------------------------------------------------------------------------
-- Author: Tomas Fryza (tomas.fryza@vut.cz)
-- Date: 2019-01-14 10:24:01
-- Design: top
-- Description: Template for basic digital circuits.
--------------------------------------------------------------------------------
-- TODO: Verify active levels of on-board push buttons and LEDs.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------------------------
-- Entity declaration for top level
--------------------------------------------------------------------------------
entity top is
    port(
        -- Global input signals at Coolrunner-II board
        btn_i : in  std_logic_vector(2-1 downto 0); -- push buttons

        -- Global output signals at Coolrunner-II board
        led_o : out std_logic_vector(4-1 downto 0)  -- led =0: LED on
                                                    --     =1: LED off
    );
end top;

--------------------------------------------------------------------------------
-- Architecture declaration for top level
--------------------------------------------------------------------------------
architecture Behavioral of top is
begin
    led_o(3) <= '0';
    led_o(2) <= '1';
    led_o(1) <= btn_i(0) xor btn_i(1);
    led_o(0) <= (btn_i(0) and not(btn_i(1))) or
                (not(btn_i(0)) and btn_i(1));
end Behavioral;
