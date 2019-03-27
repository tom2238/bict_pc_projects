--------------------------------------------------------------------------------
-- Brno University of Technology, Department of Radio Electronics
--------------------------------------------------------------------------------
-- Author: Tomas Fryza (tomas.fryza@vut.cz)
-- Date: 2019-02-28 10:52
-- Design: top
-- Description: Implementation of Up Down BCD counter.
--------------------------------------------------------------------------------
-- TODO: Verify BCD counter on Coolrunner-II board. Use seven-segment LED
--       display and on-board clock signal with frequency of 10 kHz.
--
-- NOTE: Copy "hex_to_sseg.vhd", "one_of_four.vhd", and "coolrunner.ucf" files
--       from previous lab(s) to current working folder.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------------------------
-- Entity declaration for top level
--------------------------------------------------------------------------------
entity top is
    port (
        -- Global input signals at Coolrunner-II board
        clk_i : in std_logic;   -- use on-board jumper JP1 and select 10 kHz clock
        sw_i  : in std_logic_vector(2-1 downto 0);          -- up/down
        btn_i : in std_logic_vector(1-1 downto 0);          -- reset
        cpld_sw_i : in std_logic;
        -- Global output signals at Coolrunner-II board
        led_o        : out std_logic_vector(1-1 downto 0);  -- carry
        disp_digit_o : out std_logic_vector(4-1 downto 0);  -- 7-segment
        disp_sseg_o  : out std_logic_vector(7-1 downto 0)
    );
end top;

--------------------------------------------------------------------------------
-- Architecture declaration for top level
--------------------------------------------------------------------------------
architecture Behavioral of top is
    constant N_BIT : integer := 12; -- number of bits for clock prescaler
    signal s_clk_prescaler : std_logic_vector(N_BIT-1 downto 0);
    signal s_bcd_cnt_o : std_logic_vector(4-1 downto 0);
begin
    -- sub-block of binary counter (clock prescaler)
    BINCNT : entity work.bin_cnt
        generic map (
            N_BIT => N_BIT                  -- N_bit binary counter
        )
        port map (
            clk_i => clk_i,                 -- 10 kHz
            rst_n_i => '1',                 -- inactive reset
            bin_cnt_o => s_clk_prescaler    -- output bits
        );

    -- sub-block of BCD counter
    BCDCNT : entity work.bcd_cnt
        port map (
             -- <port_name> => <signal_name>,
             clk_i => s_clk_prescaler(11),
             rst_n_i => btn_i(0),
             carry_n_o => led_o(0),
             bcd_cnt_o => s_bcd_cnt_o,
             smer_i => cpld_sw_i
        );

    -- sub-block of hex_to_sseg entity
    HEX2SSEG : entity work.hex_to_sseg
        port map (
            hex_i => s_bcd_cnt_o,   -- 4-bit data to decode
            sseg_o => disp_sseg_o   -- 7-bit signal for 7-segment display
        );

    -- sub-block of one_of_four entity
    ONEOFFOUR : entity work.one_of_four
        port map (
            a_i => sw_i,            -- control signals for decoder
            y_o => disp_digit_o     -- display select signals
        );

end Behavioral;
