library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UniversalShiftRegister is
    generic (
       width : integer := 4   
        );
    Port ( Reg_Data_In_H         : in    STD_LOGIC_VECTOR (width-1 downto 0);
           Reg_Data_Out_H        : inout STD_LOGIC_VECTOR (width-1 downto 0);
           Func_Sel_H            : in  STD_LOGIC_VECTOR (1 downto 0);
           Shift_Left_In_H      : in  STD_LOGIC; -- enters into register as the lets significant bit when shifting left 
           Shift_Right_In_H     : in  STD_LOGIC; -- enters into register as the most significant bit when shifting right
           Shift_Left_Out_H     : out STD_LOGIC; -- leaves the register from the most significant position when shifting left
           Shift_Right_Out_H    : out STD_LOGIC; -- leaves the register fomr the least siginicant positon when shifting right 
           Clk_H                : in  STD_LOGIC;
           Rst_L                : in  STD_LOGIC
          );
end UniversalShiftRegister;

architecture Beh of UniversalShiftRegister is

begin -- architecture block begins here

    process ( Clk_H ) is
    Begin
        -- no output can change unless we have the rising edge of the clock 
        if rising_edge(Clk_H)   -- ( Clk_H'event AND (Clk_H = '1') )  -- detect the rising_edge(Clk_H)  
                                -- this makes the Syntesizer infer FFs in the synthesized model
        then
            if (Rst_L = '0') -- now check first for the highest priority function which is Reset
            then 
                    Reg_Data_Out_H <= ( others => '0' ) after 2 ns; -- because we do not know a-priori how many bits Reg_Data_Out_H has
            elsif (Func_Sel_H = "00")  -- this is function where register holds current value
            then    
                    Reg_Data_Out_H <= Reg_Data_Out_H after 2 ns;
            elsif (Func_Sel_H = "01") -- this is shift right
            then  
                    Reg_Data_Out_H <=  Shift_Right_In_H & Reg_Data_Out_H( width-1 downto 1) after 2 ns;
            elsif (Func_Sel_H = "10") -- this is for a shift left
            then
                    Reg_Data_Out_H <= Reg_Data_Out_H (width - 2 downto 0) & Shift_Left_In_H after 2 ns;
            elsif (Func_Sel_H = "11" ) -- this is for Parallel loading 
            then
                    Reg_Data_Out_H <= Reg_Data_In_H after 2 ns;
            end if;
        end if;
        
        Shift_Left_Out_H <= Reg_Data_Out_H(width - 2 ) after 2 ns;
        Shift_Right_Out_H <=Reg_Data_Out_H(1) after 2 ns;
    End process;
    
        
        
end Beh;
