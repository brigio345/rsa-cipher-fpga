library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.CONSTANTS.all;

entity data_buffer is

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
                
        
end entity data_buffer;

architecture arch of data_buffer is

	-- states of the FSM
	type stateType is (IDLE, WAIT_ADDSET, MEMORY_OPERATION, WAIT_DATAST_WR);
	signal state : stateType;

	-- internal counter to keep track of waiting states
	signal cnt : integer := 0;
	
	-- internal counter to keep track of how many 16 blocks of bits have been saved
	signal cnt_1 : integer := 0;
	
	-- internal register to keep the address to access the RAM
	signal address : std_logic_vector(ADD_WIDTH-1 downto 0);

begin

	process(clock) 
	begin
	
		if(reset = '1') then
		
			state <= IDLE;
			cnt <= 0;
			cnt_1 <= 0;
            received_all_inputs <= '0';
			address	<= (others => '0');		
            
		elsif(rising_edge(clock)) then
		
			case(state) is
			
				when IDLE =>
				
                    cpu_write_completed <= '0';
                    cpu_read_completed <= '0';	
                    RW <= '0';	
                    			
					if(cpu_ne1 = '0') then 
						state <= WAIT_ADDSET;
					else
						state <= IDLE;
				    end if;
				    
					if(cnt_1 = 192) then       -- all inputs required by the multiplier have been stored in RAM
					   received_all_inputs <= '1';
					   state <= IDLE;
			           cnt_1 <= 0;
                    end if;
				    
				    
				when WAIT_ADDSET => 
				
					if(cnt = ADDSET-1) then
						cnt <= 0;
						--address <= cpu_addr;
						--ram_addr <= cpu_addr;
						state <= MEMORY_OPERATION;	
					else
						cnt <= cnt + 1;
						state <= WAIT_ADDSET;
					end if;		
					
					
				when MEMORY_OPERATION =>
				
					if(cpu_nwe = '0') then
						state <= WAIT_DATAST_WR;
					else
					--	cpu_data <= mem(to_integer(unsigned(address)));
					--	state <= WAIT_DATAST_RD;
					end if;	
					
				when WAIT_DATAST_WR =>
				
					if(cnt >= DATAST-1 or cpu_ne1 = '1') then      -- !! was AND, set to OR for easier debug !! --
						cnt <= 0;
						ram_data <= cpu_data;
						RW <= '1';
                        ram_addr <= address;
						address <= std_logic_vector(unsigned(address) + 1);
						cpu_write_completed <= '1';
                        cnt_1 <= cnt_1 + 1;
						state <= IDLE;
					else
						cnt <= cnt + 1;
						state <= WAIT_DATAST_WR;
					end if;	
					
														           
			end case;
		end if;
	end process; 


end architecture arch;

