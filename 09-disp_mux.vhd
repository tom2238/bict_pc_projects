--------------------------------------------------------------------------------
-- Brno University of Technology, Department of Radio Electronics
--------------------------------------------------------------------------------
-- Author: Tomas Fryza (tomas.fryza@vut.cz)
-- Date: 2019-03-14 08:51
-- Design: top
-- Description: Implementation of 7-segment display time-multiplexing module.
--------------------------------------------------------------------------------
-- TODO: Verify 7-segment display time-multiplexing module on Coolrunner-II
--       board. Use seven-segment LED display, on-board clock signal with
--       frequency of 10 kHz, and switches on CPLD expansion board as
--       input data.
--
-- NOTE: Copy "hex_to_sseg.vhd", "one_of_four.vhd", and "coolrunner.ucf"
--       files from previous lab(s) to current working folder.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------------------------
-- Entity declaration for top level
--------------------------------------------------------------------------------
entity top is
    port (
        -- Global input signals at CPLD expansion board
        cpld_sw_i : in std_logic_vector(16-1 downto 0);     -- 4-bit data channels

        -- Global input signals at Coolrunner-II board
        clk_i : in std_logic;   -- use jumpers and select 10 kHz clock

        -- Global output signals at Coolrunner-II board
        disp_digit_o : out std_logic_vector(4-1 downto 0);  -- 7-segment
        disp_sseg_o  : out std_logic_vector(7-1 downto 0)
    );
end top;

--------------------------------------------------------------------------------
-- Architecture declaration for top level
--------------------------------------------------------------------------------
architecture Behavioral of top is
    -- WRITE YOUR CODE HERE
    signal data0, data1, data2, data3 : std_logic_vector(4-1 downto 0);
begin
    -- WRITE YOUR CODE HERE
    data0 <= cpld_sw_i(15 downto 12);
    data1 <= cpld_sw_i(11 downto 8);
    data2 <= cpld_sw_i(7 downto 4);
    data3 <= cpld_sw_i(3 downto 0);
    
    -- sub-block of display multiplexer
    DISP_MUX: entity work.disp_mux
      port map (
      -- Entity input signals
        data3_i => data3,
        data2_i => data2,
        data1_i => data1,
        data0_i => data0,
        clk_i =>  clk_i,
        -- Entity output signals
        an_o  => disp_digit_o,    -- 1-of-4 decoder
        sseg_o => disp_sseg_o     -- 7-segment display
      );
    -- WRITE YOUR CODE HERE
end Behavioral;
