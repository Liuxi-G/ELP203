library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fsm is
    Port (
			  H, NR : in STD_LOGIC;
			  start : in STD_LOGIC;
			  lancer : in STD_LOGIC;
        en-module5 : in STD_LOGIC;
        sel_de : in STD_LOGIC_VECTOR(2 downto 0);

			  active_de : out STD_LOGIC_VECTOR(2 downto 0);
			  );
end entity fsm;

architecture archi_fsm of fsm is

	type State is (arrete, Initial, compte6_1, compte6_2, compte6_3, Enregistre, Termine);
	signal c_state : State;
	signal n_state : State;

begin

	-- Process de mise a jour de l'etat
	process(H)
	begin
		if rising_edge(H) then
			c_state<=n_state;
		end if;
	end process;

	-- Process de la determination l'état futur
	process(c_state, start, lancer, en-module5, sel_de)
	begin
		case c_state is
			when arrete => if (start = '1') then
								n_state <= Initial;
							else
								n_state <= arrete;
							end if;

            when Initial => if (lancer = '1' and en-module5 = '0') then
								n_state <= compte6_1;
                            else
								n_state <= Initial;
                            end if;

            when compte6_1 => if (lancer = '1' and en-module5 = '0') then
								n_state <= compte6_2;
							  elsif (lancer = '0' and en-module5 = '1') then
								n_state <= Enregistre;
							  else
								n_state <= compte6_1;
                              end if;

			when compte6_2 => if (lancer = '1' and en-module5 = '0') then
								n_state <= compte6_3;
							  elsif (lancer = '0' and en-module5 = '1') then
								n_state <= Enregistre;
							  else
								n_state <= compte6_2;
                              end if;

			when compte6_3 => if (lancer = '0' ) then
								n_state <= Enregistre;
							  else
								n_state <= compte6_3;
                              end if;

			when Enregistre => if (lancer = '1') then
								n_state <= Termine;
                            else
								n_state <= Enregistre;
                            end if;

			when Termine => if (sel_de[0] = '1' and sel_de[1] = '1' and sel_de[2] = '1') then
								n_state <= arrete;
                            else
								n_state <= Initial;
                            end if;

			when others => n_state <= arrete;

		end case;
	end process;

  -- Process de la determination des sorties
  active_de <= sel_de;
