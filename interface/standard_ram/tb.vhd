library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.CONSTANTS.all;

entity tb_only_buffer is
end tb_only_buffer;

architecture test of tb_only_buffer is 

component top_level
		
  PORT (Clk, Rst            : in std_logic;
		DataIn              : in std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
		cpu_addr        	: in std_logic_vector(ADD_WIDTH-1 downto 0);
		cpu_noe    			: in std_logic;	
		cpu_nwe    			: in std_logic;		
		cpu_ne1    			: in std_logic;	
		cpu_read_completed : out std_logic;
		cpu_write_completed: out std_logic;
        received_all_inputs : out std_logic);
		
	end component;

signal clock_s, reset_s: std_logic;
signal DataIn_s: std_logic_vector(DATA_WIDTH-1 downto 0);
signal cpu_addr_s: std_logic_vector(ADD_WIDTH-1 downto 0);
signal cpu_noe_s, cpu_nwe_s, cpu_ne1_s: std_logic;
signal cpu_read_completed_s, cpu_write_completed_s, received_all_inputs_s: std_logic;

begin

comptotest: top_level port map (clock_s, reset_s, DataIn_s, cpu_addr_s, cpu_noe_s, cpu_nwe_s, cpu_ne1_s, cpu_read_completed_s, cpu_write_completed_s, received_all_inputs_s);


 Clk_proc: PROCESS
  BEGIN
    clock_s <= '1';
    WAIT FOR 10 ns;
    clock_s <= '0';
    WAIT FOR 10 ns;
  END PROCESS clk_proc;

  VectorProc: PROCESS
	begin
	
	    reset_s <= '1';
		wait for 3 ns;
	
	    reset_s <= '0';
	    DataIn_s <= "0000000000000001";
	    cpu_addr_s <= "00000000";
		cpu_ne1_s <= '0';
        cpu_nwe_s <= '0';
        
	    wait;
	
	end process VectorProc;
	
 
 
end test;
