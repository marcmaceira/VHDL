----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/07/2022 06:26:18 PM
-- Design Name: 
-- Module Name: WaterTankControllerFSM - Behavioral
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

entity WaterTankControllerFSM is
    Port ( HWL_H : in STD_LOGIC;    -- High Water Level when High 
           LWL_H : in STD_LOGIC;    -- Low Water Level when High
           HPL_H : in STD_LOGIC;    -- High Pressure Level when High
           LPL_H : in STD_LOGIC;    -- Low Pressure Level when High
           Clk_H : in STD_LOGIC;
           Rst_L : in STD_LOGIC;
           -- Outputs
           TCO_H : out STD_LOGIC;   -- Turn Compressor ON when asserted to High
           TPO_H : out STD_LOGIC    -- Turn Pump ON when asserted to High
          );
end WaterTankControllerFSM;

architecture Behavioral of WaterTankControllerFSM is
   --Use descriptive names for the states, like st1_reset, st2_search
   type state_type is (st1_InitialState, st2_Pump_ON, st3_Comp_ON, st4_Pump_and_Comp_ON);
   signal state, next_state : state_type;

begin -- begin of architecture Block 
-- We will use three processes to model a Finite State Machine (FSM)
  SYNC_PROC: process (Clk_H)  -- This process models the behaviour of the State Flip Flops
   begin
      if (Clk_H'event and Clk_H = '1') then     -- both reset and the loading of the new state 
         if (Rst_L = '0') then                  -- are synchronous to the rising edge of the clock
            state <= st1_InitialState;
         else
            state <= next_state;
         end if;
      end if;
      -- Note that we exit inmediately after entering if we are NOT at the Rising Edge of the clock
   end process;

   --MOORE State-Machine - Outputs based on state only
   OUTPUT_DECODE: process (state)
   begin
      if (state = st1_InitialState) then
         TCO_H <= '0';
         TPO_H <= '0';
      elsif (state = st2_Pump_ON) then
         TCO_H <= '0';
         TPO_H <= '1';
      elsif (state = st3_Comp_ON) then
         TCO_H <= '1';
         TPO_H <= '0';
      elsif (state = st4_Pump_and_Comp_ON) then
         TCO_H <= '1';
         TPO_H <= '1';
      else 
         TCO_H <= '0';
         TPO_H <= '0';
      end if;
   end process;

   NEXT_STATE_DECODE: process (state, LWL_H, HWL_H, LPL_H, HPL_H)
   begin
      --declare default state for next_state to avoid latches
      next_state <= state;  --default is to stay in current state
      --insert statements to decode next_state
      -- , , 
      case (state) is   --- Note there are 4 transitions from each state, which are selected by the if()... elsif()...etc.
         when st1_InitialState =>
            if (LWL_H= '0') AND (LPL_H= '0') then  -- 
                Next_State <= st1_InitialState; 
            elsif (LWL_H= '1') AND (LPL_H= '0')   then
                Next_State <= st2_Pump_ON;
            elsif (LWL_H= '0') AND (LPL_H= '1') then
                Next_State <= st3_Comp_ON ;
            elsif (LWL_H= '1') AND (LPL_H= '1') then
                Next_State <= st4_Pump_and_Comp_ON;
            end if;
            
         when st2_Pump_ON =>
            if (HWL_H= '1') AND (LPL_H= '0')        then
                Next_State <= st1_InitialState;
            elsif (HWL_H= '0') AND (LPL_H= '0')     then
                Next_State <= st2_Pump_ON;
            elsif (HWL_H= '1') AND (LPL_H= '1')     then
                Next_State <= st3_Comp_ON ;
            elsif (HWL_H= '0') AND (LPL_H= '1') then
                Next_State <= st4_Pump_and_Comp_ON;
            end if;
            
         when st3_Comp_ON =>
           if (LWL_H= '0') AND (HPL_H= '1') then
               Next_State <= st1_InitialState;
           elsif (LWL_H= '1') AND (HPL_H= '1')   then
               Next_State <= st2_Pump_ON;
           elsif (LWL_H= '0') AND (HPL_H= '0') then
               Next_State <= st3_Comp_ON ;
           elsif (LWL_H= '1') AND (HPL_H= '0') then
               Next_State <= st4_Pump_and_Comp_ON;
           end if;
                        
         when st4_Pump_and_Comp_ON => 
            if (HWL_H= '1') AND (HPL_H= '1') then
                Next_State <= st1_InitialState;
            elsif (HWL_H= '0') AND (HPL_H= '1')   then
                Next_State <= st2_Pump_ON;
            elsif (HWL_H= '1') AND (HPL_H= '0') then
                Next_State <= st3_Comp_ON ;
            elsif (HWL_H= '0') AND (HPL_H= '0') then
                Next_State <= st4_Pump_and_Comp_ON;
            end if;
            
         when others =>
            next_state <= st1_InitialState;
      end case;
   end process;

end Behavioral;
