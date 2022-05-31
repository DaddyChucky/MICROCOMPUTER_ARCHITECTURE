library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.simple_risc_def.all;
use work.simple_risc_programs.all;

entity simple_risc_cu is
   port(
      rst            : in  std_logic;
      clk            : in  std_logic;
      IR             : in  std_logic_vector(im_dw - 1 downto 0);
      N              : in  std_logic;
      Z              : in  std_logic;
      wmem_confirmed : in  std_logic;
      rmem_confirmed : in  std_logic;
      wPC            : out std_logic;
      wIR            : out std_logic;
      wFLAG          : out std_logic;
      wmem           : out std_logic;
      rmem           : out std_logic;
      wreg           : out std_logic;
      doBranch       : out std_logic;
      choixSource    : out integer range 0 to 3
   );
end simple_risc_cu;

architecture arch of simple_risc_cu is
   signal state     : state_type;
   signal jmp       : br_type   := nbr;
   signal inst      : inst_type := inst_stop;
   signal fetched   : std_logic := '0';
   signal s_op_ual  : std_logic := '0';
   signal s_op_ldi  : std_logic := '0';
   signal s_op_wmem : std_logic := '0';
   signal s_op_rmem : std_logic := '0';
begin

   -- *******************************************************************
   --
   -- Circuits seuqnetiels (signaux registres)
   --
   -- *******************************************************************   
   -- A modifier
   process (clk, rst)
   begin
      if rst = '1' then
         state    <= start;
         fetched  <=  '0';
      elsif rising_edge(clk) then
         fetched  <=  '0';
         case state is
            when start =>
               state <= fetch;
            when fetch =>
               state <= decode;
               fetched  <=  '1';
            when decode =>
               case inst is
                  when inst_alu       => state <= op_alu;
                  when inst_read_mem  => state <= fetch;
                  when inst_write_mem => state <= write_mem;
                  when inst_loadi     => state <= ldi;
                  when inst_branch    => state <= jump;
                  when inst_stop      => state <= stop;
                  when others         => state <= stop;
               end case;
            when read_mem =>
               if( rmem_confirmed = '1' ) then
                  state <= fetch;
               end if;
            when write_mem =>
               if( wmem_confirmed = '1' ) then
                  state <= fetch;
               end if;
            when op_alu | ldi =>
               state <= fetch;
            when jump =>
               state <= fetch;
            when stop =>
               state <= stop;
            when others =>
               state <= start;
         end case;
      end if;
   end process;
   
   -- Ne pas modifier de preference
   process (clk)
   begin
      if rst = '1' then
         wmem <= '0';
         rmem <= '0';
      elsif rising_edge(clk) then
         wmem <= s_op_wmem;
         rmem <= s_op_rmem;
      end if;
   end process;
   
   -- *******************************************************************
   --
   -- Circuits seuqnetiels (signaux registres)
   --
   -- *******************************************************************
   -- A modifier
   process( state, rmem_confirmed ) is
   begin
      wFLAG <= '0';
      if( state = op_alu ) then
         choixSource <= 0;
         wreg        <= '1';
         wFLAG       <= '1';
      elsif( rmem_confirmed = '1' ) then
         choixSource <= 1;
         wreg        <= '1';
      elsif( state = ldi ) then
         choixSource <= 2;
         wreg        <= '1';
      else
         choixSource <= 3;
         wreg        <= '0';
      end if;
   end process;

   -- Ne pas modifier de preference
   with IR(19 downto 16) select jmp <= 
      br   when "0000", 
      brz  when "0001", 
      brnz when "0010", 
      brs  when "0011", 
      brns when "0100", 
      nbr  when others;

   process( IR ) is
   begin
      if (IR(27) = '0') then
         inst <= inst_alu;
      else
         case IR(26 downto 24) is
            when "000"  => inst <= inst_read_mem;  -- 8
            when "001"  => inst <= inst_write_mem; -- 9
            when "010"  => inst <= inst_loadi;     -- A
            when "100"  => inst <= inst_branch;    -- C
            when "111"  => inst <= inst_stop;      -- F
            when others => inst <= inst_stop;
         end case;
      end if;
   end process;
   
   process(fetched, inst)is
   begin
      s_op_ual  <= '0';
      s_op_ldi  <= '0';
      s_op_rmem <= '0';
      s_op_wmem <= '0';
      
      if( fetched = '1' )then
         if( inst = inst_alu ) then
            s_op_ual  <= '1';
         elsif( inst = inst_loadi )then
            s_op_ldi  <= '1'; 
         elsif( inst = inst_read_mem )then
            s_op_rmem <= '1'; 
         elsif( inst = inst_write_mem )then
            s_op_wmem <= '1'; 
         end if;
      end if;
   end process;
   
   wIR <= '1' when state = fetch else '0';
   
   process( state, Z, N )is
   begin
      if( state = fetch )then
         wPC      <= '1';
         doBranch <= '0';
      elsif( state = jump ) then
         if ( jmp = br ) or               -- branchement sans condition
            ( jmp = brz  and Z = '1' ) or -- si = 0
            ( jmp = brnz and Z = '0' ) or -- si /= 0
            ( jmp = brs  and N = '1' ) or -- si < 0
            ( jmp = brns and N = '0' )    -- si >= 0
               then
            wPC      <= '1';
            doBranch <= '1';
         else
            wPC      <= '0';
            doBranch <= '0';
         end if;
      else
         wPC      <= '0';
         doBranch <= '0';
      end if;
   end process;
   
end arch;