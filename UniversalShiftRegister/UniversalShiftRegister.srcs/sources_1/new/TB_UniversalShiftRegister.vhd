library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library xil_defaultlib;
use     xil_defaultlib.UniversalShiftRegister;

entity TB_UniversalShiftRegister is
--  Port ( );
end TB_UniversalShiftRegister;

architecture Behavioral of TB_UniversalShiftRegister is

    --  Wiring signals for the 4-bit instantiation
    signal  wIns_4_Reg_Data_In_H    :   std_logic_vector(3 downto 0)    :=  "0000";
    signal  wIns_4_Reg_Data_Out_H   :   std_logic_vector(3 downto 0);
    signal  wIns_4_Func_Sel_H       :   std_logic_vector (1 downto 0)   :=  "00";
    signal  wIns_4_Shift_Left_In_H  :   std_logic   :=  '0';
    signal  wIns_4_Shift_Right_In_H :   std_logic   :=  '0';
    signal  wIns_4_Shift_Left_Out_H :   std_logic;
    signal  wIns_4_Shift_Right_Out_H:   std_logic;
    signal  wIns_4_Clk_H            :   std_logic   :=  '0';
    signal  wIns_4_Rst_L            :   std_logic   :=  '0';

    --  Wiring signals for the 8-bit instantiation
    signal  wIns_8_Reg_Data_In_H    :   std_logic_vector(7 downto 0)    :=  "00000000";
    signal  wIns_8_Reg_Data_Out_H   :   std_logic_vector(7 downto 0);
    signal  wIns_8_Func_Sel_H       :   std_logic_vector (1 downto 0)   :=  "00";
    signal  wIns_8_Shift_Left_In_H  :   std_logic   :=  '0';
    signal  wIns_8_Shift_Right_In_H :   std_logic   :=  '0';
    signal  wIns_8_Shift_Left_Out_H :   std_logic;
    signal  wIns_8_Shift_Right_Out_H:   std_logic;
    signal  wIns_8_Clk_H            :   std_logic;
    signal  wIns_8_Rst_L            :   std_logic   :=  '0';
 
    constant CLOCK_PERIOD   :   time    :=  10 ns;
 
begin

-- 4-bit instance of the USR
Instance_4: Entity xil_defaultlib.UniversalShiftRegister
            Generic Map( width => 4)
            Port Map (
                Reg_Data_In_H      =>  wIns_4_Reg_Data_In_H     ,
                Reg_Data_Out_H     =>  wIns_4_Reg_Data_Out_H    ,
                Func_Sel_H         =>  wIns_4_Func_Sel_H        ,
                Shift_Left_In_H    =>  wIns_4_Shift_Left_In_H   ,
                Shift_Right_In_H   =>  wIns_4_Shift_Right_In_H  ,
                Shift_Left_Out_H   =>  wIns_4_Shift_Left_Out_H  ,
                Shift_Right_Out_H  =>  wIns_4_Shift_Right_Out_H ,
                Clk_H              =>  wIns_4_Clk_H             ,
                Rst_L              =>  wIns_4_Rst_L             
            );

-- 8-bit instance of the USR
Instance_8: Entity xil_defaultlib.UniversalShiftRegister
            Generic Map( width => 8)
            Port Map (
                Reg_Data_In_H      =>  wIns_8_Reg_Data_In_H     ,
                Reg_Data_Out_H     =>  wIns_8_Reg_Data_Out_H    ,
                Func_Sel_H         =>  wIns_8_Func_Sel_H        ,
                Shift_Left_In_H    =>  wIns_8_Shift_Left_In_H   ,
                Shift_Right_In_H   =>  wIns_8_Shift_Right_In_H  ,
                Shift_Left_Out_H   =>  wIns_8_Shift_Left_Out_H  ,
                Shift_Right_Out_H  =>  wIns_8_Shift_Right_Out_H ,
                Clk_H              =>  wIns_8_Clk_H             ,
                Rst_L              =>  wIns_8_Rst_L             
            );

Stimulus_Ins_4_Clk: 
    process
    begin
        wIns_4_Clk_H  <= '1';
        wait for CLOCK_PERIOD  / 2;
        wIns_4_Clk_H <= '0';
        wait for CLOCK_PERIOD  / 2;
--        wIns_4_Clk_H <= (NOT wIns_4_Clk_H) after CLOCK_PERIOD / 2;
    end process;

Stimulus_Ins_8_Clk: 
    process
    begin
        wIns_8_Clk_H  <= '0';
        wait for CLOCK_PERIOD  / 2;
        wIns_8_Clk_H <= '1';
        wait for CLOCK_PERIOD  / 2;
--        wIns_8_Clk_H <= (NOT wIns_8_Clk_H) after CLOCK_PERIOD / 2;
    end process;

Stimulus_4_Instance:
    process
    begin
        -- Test parallel load non-zero value
        Ins_0_Test_0:
        wIns_4_Func_Sel_H           <=  "11";
        wIns_4_Reg_Data_In_H        <=  "0110";
        wait for 5 ns;
        
        -- Test reset func
        Ins_0_Test_1:
        wIns_4_Rst_L                <=  '0';
        wait for 5 ns;
        wIns_4_Rst_L <= '1';
        wait for 5 ns;
        
        -- Test parallel load function
        Ins_0_Test_2:
        wIns_4_Func_Sel_H           <=  "11";
        wIns_4_Reg_Data_In_H        <=  "1001";
        wait for 5 ns;
        
        -- Test holding func
        Ins_0_Test_3:
        wIns_4_Func_Sel_H <= "00";
        wait for 5 ns;
        
--      Test shift right
        Ins_0_Test_4:
        wIns_4_Func_Sel_H <= "01";
        wIns_4_Shift_Right_In_H <= '1';
        wait for 5 ns;

--      Test shift left
        Ins_0_Test_5:
        wIns_4_Func_Sel_H <= "10";
        wIns_4_Shift_Left_In_H <= '0';
        wait for 5 ns;
        
        wait;
end process;

Stimulus_8_Instance:
    process
    begin
        -- Test parallel load non-zero value
        Ins_0_Test_0:
        wIns_8_Func_Sel_H           <=  "11";
        wIns_8_Reg_Data_In_H        <=  "01000010";
        wait for 5 ns;
        
        -- Test reset func
        Ins_0_Test_1:
        wIns_8_Rst_L                <=  '0';
        wait for 5 ns;
        wIns_8_Rst_L <= '1';
        wait for 5 ns;
        
        -- Test parallel load function
        Ins_0_Test_2:
        wIns_8_Func_Sel_H           <=  "11";
        wIns_8_Reg_Data_In_H        <=  "10010110";
        wait for 5 ns;
        
        -- Test holding func
        Ins_0_Test_3:
        wIns_8_Func_Sel_H <= "00";
        wait for 5 ns;
        
--      Test shift right
        Ins_0_Test_4:
        wIns_8_Func_Sel_H <= "01";
        wIns_8_Shift_Right_In_H <= '1';
        wait for 5 ns;

--      Test shift left
        Ins_0_Test_5:
        wIns_8_Func_Sel_H <= "10";
        wIns_8_Shift_Left_In_H <= '0';
        wait for 5 ns;
        
        wait;
    end process;

end Behavioral;
