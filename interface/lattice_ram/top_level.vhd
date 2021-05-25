library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.CONSTANTS.all;


ENTITY top_level IS

  PORT (Clk, Rst: in std_logic;
		DataIn: in std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
		cpu_addr: in std_logic_vector(ADD_WIDTH-1 downto 0);	
		cpu_noe: in std_logic;	
		cpu_nwe: in std_logic;		
		cpu_ne1: in std_logic;	
		cpu_read_completed: out std_logic;
		cpu_write_completed: out std_logic;
		RdClockEn: in std_logic;
		WrClockEn: in std_logic	;
        received_all_inputs : out std_logic);
		
END top_level;

ARCHITECTURE Struct OF top_level IS 
  
  COMPONENT RAM IS
    port (
        WrAddress: in  std_logic_vector(ADD_WIDTH-1 downto 0); 
        RdAddress: in  std_logic_vector(ADD_WIDTH-1 downto 0); 
        Data: in  std_logic_vector(DATA_WIDTH-1 downto 0); 
        WE: in  std_logic; 
        RdClock: in  std_logic; 
        RdClockEn: in  std_logic; 
        Reset: in  std_logic; 
        WrClock: in  std_logic; 
        WrClockEn: in  std_logic; 
        Q: out  std_logic_vector(DATA_WIDTH-1 downto 0));
  END COMPONENT;
  
  
    
  COMPONENT DATA_BUFFER IS
  
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
  
  SIGNAL dataIn_s: std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL data_to_ram_s: std_logic_vector(DATA_WIDTH-1 DOWNTO 0);  
  SIGNAL ram_addr_s: std_logic_vector(ADD_WIDTH-1 DOWNTO 0);  
  SIGNAL cpu_addr_s: std_logic_vector(ADD_WIDTH-1 DOWNTO 0);
  signal address_to_ram_s: std_logic_vector(ADD_WIDTH-1 DOWNTO 0);
  SIGNAL cpu_noe_s, cpu_nwe_s, cpu_ne1_s, RW_s: std_logic;
  SIGNAL Q_s: std_logic_vector(DATA_WIDTH-1 downto 0);

  
BEGIN

  Unit_U1: DATA_BUFFER PORT MAP(Clk, Rst, dataIn_s, cpu_addr_s, cpu_noe, cpu_nwe, cpu_ne1, cpu_read_completed, cpu_write_completed, data_to_ram_s, ram_addr_s, RW_s, received_all_inputs);
  RAM_U1: RAM PORT MAP(address_to_ram_s, address_to_ram_s, data_to_ram_s, RW_s, Clk, RdClockEn, Rst, Clk, WrClockEn, Q_s);
   
 
END Struct;

