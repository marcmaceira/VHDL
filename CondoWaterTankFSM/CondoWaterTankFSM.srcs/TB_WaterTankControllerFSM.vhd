----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/12/2022 05:56:52 PM
-- Design Name: 
-- Module Name: TB_WaterTankControllerFSM - Behavioral
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

entity TB_WaterTankControllerFSM is
--  Port ( );
end TB_WaterTankControllerFSM;

architecture Behavioral of TB_WaterTankControllerFSM is
-- Declare the Model to be Tested or Model Under Test (MUT) 
-- as a Component
component WaterTankControllerFSM is 
    Port ( HWL_H : in STD_LOGIC; 
           LWL_H : in STD_LOGIC; 
           HPL_H : in STD_LOGIC; 
           LPL_H : in STD_LOGIC; 
           Clk_H : in STD_LOGIC; 
           Rst_L : in STD_LOGIC; 
           -- Outputs            
           TCO_H : out STD_LOGIC;
           TPO_H : out STD_LOGIC 
          );                     
end component;  

-- Declare wiring signals to be attached to the MUT Instance within the Architecture block    
    signal wHWL_H : std_Logic := '0';
    signal wLWL_H : std_Logic := '0';
    signal wHPL_H : std_Logic := '0';
    signal wLPL_H : std_Logic := '0';
    signal wClk_H : std_Logic := '0';
    signal wRst_L : std_Logic := '0';
    signal wTCO_H : std_Logic ;
    signal wTPO_H : std_Logic ;

-- Declare clock period as a constant
    constant CLOCK_PERIOD : time := 20 ns;


begin  -- begin of architecture block
-- Create Instance of Model Under Test, and attach or map the wiring signals to the model port signals
MUT_Instance: WaterTankControllerFSM 
            Port Map (    
                HWL_H => wHWL_H ,
                LWL_H => wLWL_H ,
                HPL_H => wHPL_H ,
                LPL_H => wLPL_H ,
                Clk_H => wClk_H ,
                Rst_L => wRst_L ,
                TCO_H => wTCO_H ,
                TPO_H => wTPO_H 
            );
-- Now we will apply stimulus to the input signals of the MUT
-- But we will use a separate process to apply stimulus to the Clock signal
ClockStimulus: Process (wClk_H)
        Begin  
            wClk_H <= NOT(wClk_H) after CLOCK_PERIOD/2; 
        End process;

StimulusProcess: Process -- process without senstivity list, thus it must have WAIT statements
    Begin
    wait until rising_edge(wClk_H); -- wait until (wClk_H'Event AND wClk_H = '1'), i.e. synchronize with the clock that is running freely
    wait for CLOCK_PERIOD/3 ;  -- move an OFFSET away from the clock active 
    
    -- Test Case 0 : Check Reset operation
    wHWL_H <= '0';
    wLWL_H <= '0';
    wHPL_H <= '0';
    wLPL_H <= '0';
    wRst_L <= '0'; -- Reset or force the Finite state maachine to the initial state
    wait for CLOCK_PERIOD; -- allow the inputs to compute the next state, and the next clock transition to change to that next state, 
                           -- and let the offset pass before checking outputs
    assert ( wTCO_H = '0' AND wTPO_H = '0' ) 

    report "Failed to reset to the initial state where both TCO and TPO are unasserted" 
    severity FAILURE;
    
    -- Test Case 1: Test Transition from InitialState to Initial State
    wHWL_H <= '0';                                                                                                                                              
    wLWL_H <= '0';                                                                                                                                              
    wHPL_H <= '0';                                                                                                                                              
    wLPL_H <= '0';                                                                                                                                              
    wRst_L <= '1';  -- Release reset so that FSM can transition between states                                                                                    End process;

    wait for CLOCK_PERIOD; -- allow the inputs to compute the next state and the next clock transition to change to that next state and let an offset pass  

    assert ( wTCO_H = '0' AND wTPO_H = '0' )                                                                                                                    
    report "Failed to loop-back to the initial state where both TCO and TPO are unasserted"
    severity FAILURE;
    
    -- Test Case 2:
    wHWL_H <= '0';
    wLWL_H <= '1';
    wHPL_H <= '1';
    wLPL_H <= '0';
    wRst_L <= '1';  -- Release reset so that FSM can transition between states                                                                                    End process;

    wait for CLOCK_PERIOD; -- allow the inputs to compute the next state and the next clock transition to change to that next state and let an offset pass  

    assert ( wTCO_H = '0' AND wTPO_H = '1' )                                                                                                                    
    report "Water pump off or compressor on"
    severity FAILURE;
    
    -- Test Case 3: 
    wHWL_H <= '0';
    wLWL_H <= '1';
    wHPL_H <= '1';
    wLPL_H <= '0';
    wRst_L <= '1';  -- Release reset so that FSM can transition between states                                                                                    End process;

    wait for CLOCK_PERIOD; -- allow the inputs to compute the next state and the next clock transition to change to that next state and let an offset pass  

    assert ( wTCO_H = '0' AND wTPO_H = '1' )                                                                                                                    
    report "Water pump off or compressor on"
    severity FAILURE;
    
    -- Test Case 4: 
    wHWL_H <= '1';
    wLWL_H <= '0';
    wHPL_H <= '0';
    wLPL_H <= '1';
    wRst_L <= '1';  -- Release reset so that FSM can transition between states                                                                                    End process;

    wait for CLOCK_PERIOD; -- allow the inputs to compute the next state and the next clock transition to change to that next state and let an offset pass  

    assert ( wTCO_H = '1' AND wTPO_H = '0' )                                                                                                                    
    report "Water pump on or compressor off"
    severity FAILURE;
    
    -- Test Case 5: 
    wHWL_H <= '1';
    wLWL_H <= '0';
    wHPL_H <= '0';
    wLPL_H <= '1';
    wRst_L <= '1';  -- Release reset so that FSM can transition between states                                                                                    End process;

    wait for CLOCK_PERIOD; -- allow the inputs to compute the next state and the next clock transition to change to that next state and let an offset pass  

    assert ( wTCO_H = '1' AND wTPO_H = '0' )                                                                                                                    
    report "Water pump on or compressor off"
    severity FAILURE;
    
    -- Test Case 6: 
    wHWL_H <= '0';
    wLWL_H <= '1';
    wHPL_H <= '1';
    wLPL_H <= '0';
    wRst_L <= '1';  -- Release reset so that FSM can transition between states                                                                                    End process;

    wait for CLOCK_PERIOD; -- allow the inputs to compute the next state and the next clock transition to change to that next state and let an offset pass  

    assert ( wTCO_H = '0' AND wTPO_H = '1' )                                                                                                                    
    report "Water pump off or compressor on"
    severity FAILURE;
    
    -- Test Case 7: 
    wHWL_H <= '0';
    wLWL_H <= '1';
    wHPL_H <= '0';
    wLPL_H <= '1';
    wRst_L <= '1';  -- Release reset so that FSM can transition between states                                                                                    End process;

    wait for CLOCK_PERIOD; -- allow the inputs to compute the next state and the next clock transition to change to that next state and let an offset pass  

    assert ( wTCO_H = '1' AND wTPO_H = '1' )                                                                                                                    
    report "Water pump off or compressor off"
    severity FAILURE;
    
    -- Test Case 8: 
    wHWL_H <= '0';
    wLWL_H <= '1';
    wHPL_H <= '0';
    wLPL_H <= '1';
    wRst_L <= '1';  -- Release reset so that FSM can transition between states                                                                                    End process;

    wait for CLOCK_PERIOD; -- allow the inputs to compute the next state and the next clock transition to change to that next state and let an offset pass  

    assert ( wTCO_H = '1' AND wTPO_H = '1' )                                                                                                                    
    report "Water pump off or compressor off"
    severity FAILURE;
    
    -- Test Case 9: 
    wHWL_H <= '1';
    wLWL_H <= '0';
    wHPL_H <= '0';
    wLPL_H <= '1';
    wRst_L <= '1';  -- Release reset so that FSM can transition between states                                                                                    End process;

    wait for CLOCK_PERIOD; -- allow the inputs to compute the next state and the next clock transition to change to that next state and let an offset pass  

    assert ( wTCO_H = '1' AND wTPO_H = '0' )                                                                                                                    
    report "Water pump on or compressor off"
    severity FAILURE;
    
    -- Test Case 10: 
    wHWL_H <= '0';
    wLWL_H <= '1';
    wHPL_H <= '0';
    wLPL_H <= '1';
    wRst_L <= '1';  -- Release reset so that FSM can transition between states                                                                                    End process;

    wait for CLOCK_PERIOD; -- allow the inputs to compute the next state and the next clock transition to change to that next state and let an offset pass  

    assert ( wTCO_H = '1' AND wTPO_H = '1' )                                                                                                                    
    report "Water pump off or compressor off"
    severity FAILURE;
    
    -- Test Case 11: 
    wHWL_H <= '0';
    wLWL_H <= '1';
    wHPL_H <= '1';
    wLPL_H <= '0';
    wRst_L <= '1';  -- Release reset so that FSM can transition between states                                                                                    End process;

    wait for CLOCK_PERIOD; -- allow the inputs to compute the next state and the next clock transition to change to that next state and let an offset pass  

    assert ( wTCO_H = '0' AND wTPO_H = '1' )                                                                                                                    
    report "Water pump off or compressor on"
    severity FAILURE;
    
    -- Test Case 12: 
    wHWL_H <= '1';
    wLWL_H <= '0';
    wHPL_H <= '1';
    wLPL_H <= '0';
    wRst_L <= '1';  -- Release reset so that FSM can transition between states                                                                                    End process;

    wait for CLOCK_PERIOD; -- allow the inputs to compute the next state and the next clock transition to change to that next state and let an offset pass  

    assert ( wTCO_H = '0' AND wTPO_H = '0' )                                                                                                                    
    report "Water pump oon or compressor on"
    severity FAILURE;
    
    -- Test Case 13: 
    wHWL_H <= '1';
    wLWL_H <= '0';
    wHPL_H <= '0';
    wLPL_H <= '1';
    wRst_L <= '1';  -- Release reset so that FSM can transition between states                                                                                    End process;

    wait for CLOCK_PERIOD; -- allow the inputs to compute the next state and the next clock transition to change to that next state and let an offset pass  

    assert ( wTCO_H = '1' AND wTPO_H = '0' )                                                                                                                    
    report "Water pump oon or compressor off"
    severity FAILURE;
    
    -- Test Case 14: 
    wHWL_H <= '1';
    wLWL_H <= '0';
    wHPL_H <= '1';
    wLPL_H <= '0';
    wRst_L <= '1';  -- Release reset so that FSM can transition between states                                                                                    End process;

    wait for CLOCK_PERIOD; -- allow the inputs to compute the next state and the next clock transition to change to that next state and let an offset pass  

    assert ( wTCO_H = '0' AND wTPO_H = '0' )                                                                                                                    
    report "Water pump oon or compressor on"
    severity FAILURE;
    
    -- Test Case 15: 
    wHWL_H <= '0';
    wLWL_H <= '1';
    wHPL_H <= '0';
    wLPL_H <= '1';
    wRst_L <= '1';  -- Release reset so that FSM can transition between states                                                                                    End process;

    wait for CLOCK_PERIOD; -- allow the inputs to compute the next state and the next clock transition to change to that next state and let an offset pass  

    assert ( wTCO_H = '1' AND wTPO_H = '1' )                                                                                                                    
    report "Water pump off or compressor off"
    severity FAILURE;
    
    -- Test Case 16: 
    wHWL_H <= '1';
    wLWL_H <= '0';
    wHPL_H <= '1';
    wLPL_H <= '0';
    wRst_L <= '1';  -- Release reset so that FSM can transition between states                                                                                    End process;

    wait for CLOCK_PERIOD; -- allow the inputs to compute the next state and the next clock transition to change to that next state and let an offset pass  

    assert ( wTCO_H = '0' AND wTPO_H = '0' )                                                                                                                    
    report "Water pump on or compressor on"
    severity FAILURE;

end Process;


end Behavioral;








