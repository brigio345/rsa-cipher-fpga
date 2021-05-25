library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.CONSTANTS.all;

ENTITY top_level IS

  PORT (Clk, Rst            : in std_logic;
		DataIn              : in std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
		cpu_addr        	: in std_logic_vector(ADD_WIDTH-1 downto 0);
		cpu_noe    			: in std_logic;	
		cpu_nwe    			: in std_logic;		
		cpu_ne1    			: in std_logic;	
		cpu_read_completed : out std_logic;
		cpu_write_completed: out std_logic;
        received_all_inputs : out std_logic);
		
END top_level;

ARCHITECTURE arch OF top_level IS 

  COMPONENT RAM IS
   GENERIC (n:  natural := 16;
            p:  integer := 192;
            k:  natural := 8);  
                     
   PORT (data_in: IN  std_logic_vector(n-1 DOWNTO 0);
         addr: IN  std_logic_vector(k-1 DOWNTO 0);
         Clr, RW, Clk: std_logic);
         
  END COMPONENT;
  
  
  COMPONENT data_buffer IS
  
	generic (ADDSET : integer := 2;
			 DATAST : integer := 2);
			 
	port(clock           	: in std_logic;		
		reset				: in std_logic;				
		-- CPU INTERFACE
		cpu_data	    	: in std_logic_vector(DATA_WIDTH-1 downto 0);
		cpu_addr        	: in std_logic_vector(ADD_WIDTH-1 downto 0);
		cpu_noe    			: in std_logic;	
		cpu_nwe    			: in std_logic;		
		cpu_ne1    			: in std_logic;	
		cpu_read_completed 	: out std_logic;
		cpu_write_completed : out std_logic;
		-- RAM INTRERFACE
		ram_data   	        : out std_logic_vector(DATA_WIDTH-1 downto 0);
		ram_addr            : out std_logic_vector(ADD_WIDTH-1 downto 0);
        RW                  : out std_logic;
        -- EXTRA INTERFACE
        received_all_inputs : out std_logic);

 END COMPONENT;
  
  SIGNAL ram_data_s: std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL ram_addr_s: std_logic_vector(ADD_WIDTH-1 DOWNTO 0);
  SIGNAL cpu_addr_s: std_logic_vector(ADD_WIDTH-1 DOWNTO 0);
  
  SIGNAL RW_s: std_logic;
  
BEGIN

  logic_U1: data_buffer PORT MAP(Clk, Rst, DataIn, cpu_addr, cpu_noe, cpu_nwe, cpu_ne1, cpu_read_completed, cpu_write_completed, ram_data_s, ram_addr_s, RW_s, received_all_inputs);
  RAM_U1: RAM PORT MAP(ram_data_s, ram_addr_s, Rst, RW_s, Clk);
  
 
END arch;

