LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY RAM IS
   GENERIC (n:  natural := 16;
            p:  integer := 192;
            k:  natural := 8);  
                     
   PORT (data_in: IN  std_logic_vector(n-1 DOWNTO 0);
         addr: IN  std_logic_vector(k-1 DOWNTO 0);
         Clr, RW, Clk: std_logic);
END RAM;

ARCHITECTURE Beh OF RAM IS

   SUBTYPE WordT IS std_logic_vector(n-1 DOWNTO 0);
   TYPE StorageT IS ARRAY(0 TO p-1) OF WordT;
   SIGNAL Memory: StorageT;

BEGIN
   WrProc: PROCESS (Clk)
   BEGIN
      IF (Clk'EVENT AND Clk = '1') THEN
         IF (Clr = '1') THEN
           Memory <= (OTHERS => (OTHERS =>'0'));                         
         ELSIF (RW = '1') THEN
            Memory(to_integer(unsigned(addr))) <= data_in; 
         END IF;
      END IF;
   END PROCESS;

   --RdProc: PROCESS (RW, A, Memory)
  -- BEGIN
  --    IF (RW = '0') THEN 
  --       Z <= Memory(to_integer(unsigned(A))) AFTER Td;
  --    END IF;
  -- END PROCESS; 
END Beh;
