--------------------------------------------------------------------------------
-- Brno University of Technology, Department of Radio Electronics
--------------------------------------------------------------------------------
-- Author: Tomas Fryza (tomas.fryza@vut.cz)
-- Date: 2019-02-28 10:20
-- Design: bcd_cnt
-- Description: BCD counter with synchronous reset and carry output.
--------------------------------------------------------------------------------
-- TODO: Verify functionality of Up BCD counter and extend it to Up Down BCD
--       counter.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;    -- for +/- arithmetic operations

--------------------------------------------------------------------------------
-- Entity declaration for BCD counter
--------------------------------------------------------------------------------
entity bcd_cnt is
    port (
        -- Entity input signals
        -- WRITE YOUR CODE HERE     -- up =0: direction down
                                    --    =1: direction up
        clk_i   : in std_logic;
        rst_n_i : in std_logic;     -- reset =0: reset active
                                    --       =1: no reset
        smer_i : in std_logic;
        -- Entity output signals
        carry_n_o : out std_logic;  -- carry =0: carry active
                                    --       =1: no carry
        bcd_cnt_o : out std_logic_vector(4-1 downto 0)
        
    );
end bcd_cnt;

--------------------------------------------------------------------------------
-- Architecture declaration for BCD counter
--------------------------------------------------------------------------------
architecture Behavioral of bcd_cnt is
    signal s_reg  : std_logic_vector(4-1 downto 0);
    signal s_next_d, s_next_u, s_next_smer : std_logic_vector(4-1 downto 0);
    signal carry_n_o_d, carry_n_o_u : std_logic;
begin
    --------------------------------------------------------------------------------
    -- Register
    --------------------------------------------------------------------------------
    p_bcd_cnt: process(clk_i)
    begin
        if rising_edge(clk_i) then
            if rst_n_i = '0' then           -- synchronous reset
                s_reg <= (others => '0');   -- clear all bits in register
            else
                s_reg <= s_next_smer;            -- update register value
            end if;
        end if;
    end process p_bcd_cnt;

    --------------------------------------------------------------------------------
    -- Next-state logic
    --------------------------------------------------------------------------------
    -- down
    s_next_d <= "1001" when s_reg = "0000" else   -- down
              s_reg - 1;
    
    -- Up counter only
    s_next_u <= "0000" when s_reg = "1001" else   -- up
              s_reg + 1;

    s_next_smer <= s_next_d when smer_i = '0' else
                   s_next_u when smer_i = '1';
    --------------------------------------------------------------------------------
    -- Output logic
    --------------------------------------------------------------------------------
    bcd_cnt_o <= s_reg;
    -- down
    carry_n_o_d <= '0' when s_reg = "0000" else   -- down
                 '1';
    -- Up counter only
    carry_n_o_u <= '0' when s_reg = "1001" else   -- up
                 '1';
                 
    carry_n_o <= carry_n_o_d when smer_i = '0' else
                 carry_n_o_u when smer_i = '1';            
                 
end Behavioral;
