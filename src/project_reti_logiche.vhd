----------------------------------------------------------- Company:
-- Engineer:
--
-- Create Date: 03/09/2024 11:24:03 AM
-- Design Name:
-- Module Name: project_reti_logiche - Behavioral
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
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
ENTITY project_reti_logiche IS
	PORT
	(
		i_clk      : IN std_logic;
		i_rst      : IN std_logic;
		i_start    : IN std_logic;
		i_add      : IN std_logic_vector(15 DOWNTO 0);
		i_k        : IN std_logic_vector(9 DOWNTO 0);
		o_done     : OUT std_logic;
		o_mem_addr : OUT std_logic_vector(15 DOWNTO 0);
		i_mem_data : IN std_logic_vector(7 DOWNTO 0);
		o_mem_data : OUT std_logic_vector(7 DOWNTO 0);
		o_mem_we   : OUT std_logic;
		o_mem_en   : OUT std_logic
	);
END project_reti_logiche;
ARCHITECTURE Behavioral OF project_reti_logiche IS
	COMPONENT datapath IS
		PORT
		(
			i_clk      : IN STD_LOGIC;
			i_rst      : IN STD_LOGIC;
			i_mem_data : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			i_add      : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			i_k        : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
			r1_load    : IN STD_LOGIC;
			r2_load    : IN STD_LOGIC;
			r3_load    : IN STD_LOGIC;
			r4_load    : IN STD_LOGIC;
			m1_sel     : IN STD_LOGIC;
			m3_sel     : IN STD_LOGIC;
			m4_sel     : IN STD_LOGIC;
			m2_sel     : IN STD_LOGIC;
			o_mem_addr : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
			o_mem_data : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			o_end      : OUT STD_LOGIC;
			o_zero     : OUT STD_LOGIC
		);
	END COMPONENT;
	SIGNAL r1_load : STD_LOGIC;
	SIGNAL r2_load : STD_LOGIC;
	SIGNAL r3_load : STD_LOGIC;
	SIGNAL r4_load : STD_LOGIC;
	SIGNAL m1_sel  : STD_LOGIC;
	SIGNAL m3_sel  : STD_LOGIC;
	SIGNAL m4_sel  : STD_LOGIC;
	SIGNAL m2_sel  : STD_LOGIC;
	SIGNAL o_end   : STD_LOGIC;
	SIGNAL o_zero  : STD_LOGIC;
	TYPE S IS(reset, S1, F0, F1, F2, F3, F4, S2, S4, F5, S5, F6, F7, F10, F8, S6, F11, S7, F9, S8, S9, S3, F12, F13, F14);
	SIGNAL cur_state, next_state : S;
BEGIN
	DATAPATH0 : datapath
	PORT MAP
	(
		i_clk, i_rst,
		i_mem_data, i_add,
		i_k, r1_load,
		r2_load, r3_load,
		r4_load, m1_sel,
		m3_sel, m4_sel,
		m2_sel, o_mem_addr,
		o_mem_data, o_end,
		o_zero
	);
	PROCESS (i_clk, i_rst)
	BEGIN
		IF (i_rst = '1') THEN
			cur_state <= reset;
		ELSIF i_clk'EVENT AND i_clk = '1' THEN
			cur_state <= next_state;
		END IF;
	END PROCESS;
	PROCESS (cur_state, i_start, o_end, o_zero)
		BEGIN
			next_state <= cur_state;
			CASE cur_state IS
				WHEN reset =>
					IF i_start = '1' THEN
						next_state <= S1;
					END IF;
				WHEN S1 =>
					next_state <= F0;
				WHEN F0 =>
					next_state <= F1;
				WHEN F1 =>
					next_state <= F2;
				WHEN F2 =>
					next_state <= F3;
				WHEN F3 =>
					next_state <= F4;
				WHEN F4 =>
					IF o_zero = '0' THEN
						next_state <= S4;
					ELSE
						next_state <= S2;
					END IF;
				WHEN S4 =>
					next_state <= F5;
				WHEN F5 =>
					IF o_end = '0' THEN
						next_state <= S5;
					ELSE
						next_state <= S8;
					END IF;
				WHEN S5 =>
					next_state <= F6;
				WHEN F6 =>
					next_state <= F7;
				WHEN F7 =>
					next_state <= F8;
				WHEN F8 =>
					IF o_zero = '0' THEN
						next_state <= S6;
					ELSE
						next_state <= S7;
					END IF;
				WHEN S6 =>
					next_state <= F10;
				WHEN F10 =>
					next_state <= F11;
				WHEN F11 =>
					IF o_end = '0' THEN
						next_state <= S5;
					ELSE
						next_state <= S8;
					END IF;
				WHEN S7 =>
					next_state <= F9;
				WHEN F9 =>
					IF o_end = '0' THEN
						next_state <= S5;
					ELSE
						next_state <= S8;
					END IF;
				WHEN S8 =>
					IF i_start = '1' THEN
						next_state <= S8;
					ELSIF i_start = '0' THEN
						next_state <= S9;
					END IF;
				WHEN S9 =>
					IF i_start = '1' THEN
						next_state <= S1;
					ELSIF i_start = '0' THEN
						next_state <= S9;
					END IF;
				WHEN S2 =>
					IF o_end = '0' THEN
						next_state <= S3;
					ELSE
						next_state <= S8;
					END IF;
				WHEN S3 =>
					next_state <= F12;
				WHEN F12 =>
					next_state <= F13;
				WHEN F13 =>
					next_state <= F14;
				WHEN F14 =>
					IF o_zero = '0' THEN
						next_state <= S4;
					ELSE
						next_state <= S2;
					END IF;
				WHEN OTHERS =>
			END CASE;
		END PROCESS;
		PROCESS (cur_state)
			BEGIN
				o_mem_we <= '0';
				o_mem_en <= '0';
				r1_load  <= '0';
				r2_load  <= '0';
				r3_load  <= '0';
				r4_load  <= '0';
				m1_sel   <= '0';
				m3_sel   <= '0';
				m4_sel   <= '0';
				m2_sel   <= '0';
				--o_end <= '0';
				--o_zero <= '0';
				o_done <= '0';
				--o_mem_addr <= "0000000000000000";
				--o_mem_data <= "00000000";
				CASE cur_state IS
					WHEN reset =>
						o_mem_we <= '0';
						o_mem_en <= '0';
						r1_load  <= '0';
						r2_load  <= '0';
						r3_load  <= '0';
						m1_sel   <= '0';
						m3_sel   <= '0';
						m4_sel   <= '0';
						m2_sel   <= '0';
						o_done   <= '0';
					WHEN S1 =>
						o_mem_we <= '0';
						o_mem_en <= '0';
						r1_load  <= '0';
						r2_load  <= '0';
						r3_load  <= '0';
						r4_load  <= '0';
						m1_sel   <= '0';
						m3_sel   <= '0';
						m4_sel   <= '1';
						m2_sel   <= '0';
						o_done   <= '0';
					WHEN F0 =>
						o_mem_we <= '0';
						o_mem_en <= '0';
						r1_load  <= '0';
						r2_load  <= '0';
						r3_load  <= '1';
						r4_load  <= '0';
						m1_sel   <= '0';
						m3_sel   <= '0';
						m4_sel   <= '0';
						m2_sel   <= '0';
						o_done   <= '0';
					WHEN F1 =>
						o_mem_we <= '0';
						o_mem_en <= '1';
						r1_load  <= '0';
						r2_load  <= '0';
						r3_load  <= '0';
						r4_load  <= '0';
						m1_sel   <= '0';
						m3_sel   <= '0';
						m4_sel   <= '0';
						m2_sel   <= '0';
						o_done   <= '0';
					WHEN F2 =>
						o_mem_we <= '0';
						o_mem_en <= '0';
						r1_load  <= '1';
						r2_load  <= '1';
						r3_load  <= '0';
						r4_load  <= '0';
						m1_sel   <= '0';
						m3_sel   <= '0';
						m4_sel   <= '0';
						m2_sel   <= '0';
						o_done   <= '0';
					WHEN F3 =>
						o_mem_we <= '0';
						o_mem_en <= '0';
						r1_load  <= '0';
						r2_load  <= '0';
						r3_load  <= '0';
						r4_load  <= '1';
						m1_sel   <= '0';
						m3_sel   <= '0';
						m4_sel   <= '0';
						m2_sel   <= '0';
						o_done   <= '0';
					WHEN F4 =>
						r4_load <= '0';
						o_done  <= '0';
					WHEN S4 =>
						o_mem_we <= '0';
						o_mem_en <= '0';
						r1_load  <= '1';
						r2_load  <= '0';
						r3_load  <= '1';
						r4_load  <= '0';
						m1_sel   <= '0';
						m3_sel   <= '1';
						m4_sel   <= '0';
						m2_sel   <= '0';
						o_done   <= '0';
					WHEN F5 =>
						o_mem_we <= '1';
						o_mem_en <= '1';
						r1_load  <= '0';
						r2_load  <= '0';
						r3_load  <= '0';
						r4_load  <= '0';
						m1_sel   <= '1';
						m3_sel   <= '0';
						m4_sel   <= '0';
						m2_sel   <= '0';
						o_done   <= '0';
					WHEN S5 =>
						o_mem_we <= '0';
						o_mem_en <= '0';
						r1_load  <= '0';
						r2_load  <= '0';
						r3_load  <= '1';
						r4_load  <= '0';
						m1_sel   <= '0';
						m3_sel   <= '1';
						m4_sel   <= '0';
						m2_sel   <= '0';
						o_done   <= '0';
					WHEN F6 =>
						o_mem_we <= '0';
						o_mem_en <= '1';
						r1_load  <= '0';
						r2_load  <= '0';
						r3_load  <= '0';
						r4_load  <= '0';
						m1_sel   <= '0';
						m3_sel   <= '0';
						m4_sel   <= '0';
						m2_sel   <= '0';
						o_done   <= '0';
					WHEN F7 =>
						r2_load <= '1';
						o_done  <= '0';
					WHEN F8 =>
						r2_load <= '0';
						r4_load <= '0';
						o_done  <= '0';
					WHEN S7 =>
						o_mem_we <= '1';
						o_mem_en <= '1';
						r1_load  <= '1';
						r2_load  <= '0';
						r3_load  <= '1';
						r4_load  <= '0';
						m1_sel   <= '0';
						m3_sel   <= '1';
						m4_sel   <= '0';
						m2_sel   <= '1';
						o_done   <= '0';
					WHEN F9 =>
						o_mem_we <= '1';
						o_mem_en <= '1';
						r1_load  <= '0';
						r2_load  <= '0';
						r3_load  <= '0';
						r4_load  <= '0';
						m1_sel   <= '1';
						m3_sel   <= '0';
						m4_sel   <= '0';
						m2_sel   <= '0';
						o_done   <= '0';
					WHEN S6 =>
						o_mem_we <= '0';
						o_mem_en <= '0';
						r1_load  <= '0';
						r2_load  <= '0';
						r3_load  <= '0';
						r4_load  <= '1';
						m1_sel   <= '0';
						m3_sel   <= '0';
						m4_sel   <= '0';
						m2_sel   <= '0';
						o_done   <= '0';
					WHEN F10 =>
						o_mem_we <= '0';
						o_mem_en <= '0';
						r1_load  <= '1';
						r2_load  <= '0';
						r3_load  <= '1';
						r4_load  <= '0';
						m1_sel   <= '0';
						m3_sel   <= '1';
						m4_sel   <= '0';
						m2_sel   <= '0';
						o_done   <= '0';
					WHEN F11 =>
						o_mem_we <= '1';
						o_mem_en <= '1';
						r1_load  <= '0';
						r2_load  <= '0';
						r3_load  <= '0';
						r4_load  <= '0';
						m1_sel   <= '1';
						m3_sel   <= '0';
						m4_sel   <= '0';
						m2_sel   <= '0';
						o_done   <= '0';
					WHEN S8 =>
						o_mem_we <= '0';
						o_mem_en <= '0';
						r1_load  <= '0';
						r2_load  <= '0';
						r3_load  <= '0';
						m1_sel   <= '0';
						m3_sel   <= '0';
						m4_sel   <= '1';
						o_done   <= '1';
					WHEN S9 =>
						o_mem_we <= '0';
						o_mem_en <= '0';
						r1_load  <= '0';
						r2_load  <= '0';
						r3_load  <= '0';
						m1_sel   <= '0';
						m3_sel   <= '0';
						m4_sel   <= '1';
						o_done   <= '0';
					WHEN S2 =>
						o_mem_we <= '0';
						o_mem_en <= '0';
						r1_load  <= '0';
						r2_load  <= '0';
						r3_load  <= '1';
						r4_load  <= '0';
						m1_sel   <= '0';
						m3_sel   <= '1';
						m4_sel   <= '0';
						o_done   <= '0';
					WHEN S3 =>
						o_mem_we <= '0';
						o_mem_en <= '0';
						r1_load  <= '0';
						r2_load  <= '0';
						r3_load  <= '1';
						r4_load  <= '0';
						m1_sel   <= '0';
						m3_sel   <= '1';
						m4_sel   <= '0';
						o_done   <= '0';
					WHEN F12 =>
						o_mem_we <= '0';
						o_mem_en <= '1';
						r1_load  <= '0';
						r2_load  <= '0';
						r3_load  <= '0';
						r4_load  <= '0';
						m1_sel   <= '0';
						m3_sel   <= '0';
						m4_sel   <= '0';
						o_done   <= '0';
					WHEN F13 =>
						o_mem_we <= '0';
						o_mem_en <= '0';
						r1_load  <= '0';
						r2_load  <= '1';
						r3_load  <= '0';
						r4_load  <= '0';
						m1_sel   <= '0';
						m3_sel   <= '0';
						m4_sel   <= '0';
						o_done   <= '0';
					WHEN F14 =>
						o_mem_we <= '0';
						o_mem_en <= '0';
						r1_load  <= '0';
						r2_load  <= '0';
						r3_load  <= '0';
						r4_load  <= '1';
						m1_sel   <= '0';
						m3_sel   <= '0';
						m4_sel   <= '0';
						o_done   <= '0';
					WHEN OTHERS =>
				END CASE;
			END PROCESS;
			END Behavioral;
			LIBRARY IEEE;
			USE IEEE.STD_LOGIC_1164.ALL;
			USE IEEE.STD_LOGIC_UNSIGNED.ALL;
			ENTITY datapath IS
				PORT
				(
				i_clk      : IN STD_LOGIC;
				i_rst      : IN STD_LOGIC;
				i_mem_data : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
				i_add      : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
				i_k        : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
				r1_load    : IN STD_LOGIC;
				r2_load    : IN STD_LOGIC;
				r3_load    : IN STD_LOGIC;
				r4_load    : IN STD_LOGIC;
				m1_sel     : IN STD_LOGIC;
				m3_sel     : IN STD_LOGIC;
				m4_sel     : IN STD_LOGIC;
				m2_sel     : IN STD_LOGIC;
				o_mem_addr : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
				o_mem_data : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
				o_end      : OUT STD_LOGIC;
				o_zero     : OUT STD_LOGIC
				);
			END datapath;
			ARCHITECTURE Behavioral OF datapath IS
				--registri
				SIGNAL o_reg1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
				SIGNAL o_reg2 : STD_LOGIC_VECTOR (7 DOWNTO 0);
				SIGNAL o_reg3 : STD_LOGIC_VECTOR (15 DOWNTO 0);
				SIGNAL o_reg4 : STD_LOGIC_VECTOR (7 DOWNTO 0);
				--sommatori
				SIGNAL sum1 : STD_LOGIC_VECTOR (15 DOWNTO 0);
				SIGNAL sum2 : STD_LOGIC_VECTOR (9 DOWNTO 0);
				SIGNAL sum3 : STD_LOGIC_VECTOR (15 DOWNTO 0);
				--sotrattori
				SIGNAL sub1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
				SIGNAL sub2 : STD_LOGIC_VECTOR (15 DOWNTO 0);
				--comparatori
				SIGNAL o_c1 : STD_LOGIC;
				SIGNAL o_c2 : STD_LOGIC;
				SIGNAL o_c3 : STD_LOGIC;
				SIGNAL o_c4 : STD_LOGIC;
				--mux ingresso automatico
				SIGNAL m2   : STD_LOGIC_VECTOR (7 DOWNTO 0);
				SIGNAL mux3 : STD_LOGIC_VECTOR (7 DOWNTO 0);
				SIGNAL mux4 : STD_LOGIC;
				--mux ingresso FSM
				SIGNAL m1    : STD_LOGIC_VECTOR (7 DOWNTO 0);
				SIGNAL m3    : STD_LOGIC_VECTOR (15 DOWNTO 0);
				SIGNAL m4    : STD_LOGIC;
				SIGNAL prova : STD_LOGIC;
			BEGIN
				--registro 1
				PROCESS (i_clk, m4)
				BEGIN
					IF (m4 = '1') THEN
						o_reg1 <= "00000000";
					ELSIF i_clk'EVENT AND i_clk = '1' THEN
						IF (r1_load = '1') THEN
							o_reg1 <= m2;
						END IF;
					END IF;
				END PROCESS;
				--registro 2
				PROCESS (i_clk, m4)
					BEGIN
						IF (m4 = '1') THEN
							o_reg2 <= "00000000";
						ELSIF i_clk'EVENT AND i_clk = '1' THEN
							IF (r2_load = '1') THEN
								o_reg2 <= i_mem_data;
							END IF;
						END IF;
					END PROCESS;
					--registro 3
					PROCESS (i_clk, m4)
						BEGIN
							IF (m4 = '1') THEN
								o_reg3 <= "0000000000000000";
							ELSIF i_clk'EVENT AND i_clk = '1' THEN
								IF (r3_load = '1') THEN
									o_reg3 <= m3;
								END IF;
							END IF;
						END PROCESS;
						--registro 4
						PROCESS (i_clk, m4)
							BEGIN
								IF (m4 = '1') THEN
									o_reg4 <= "00000000";
								ELSIF i_clk'EVENT AND i_clk = '1' THEN
									IF (r4_load = '1') THEN
										o_reg4 <= o_reg2;
									END IF;
								END IF;
							END PROCESS;
							--c1
							o_c1 <= '1' WHEN (i_mem_data = "00000000") ELSE '0';
							--c2
							o_c2 <= '1' WHEN (o_reg1 = "00000000") ELSE '0';
							--c3
							o_c3 <= '1' WHEN (i_k = "0000000000") ELSE '0';
							--c4
							o_c4 <= '1' WHEN (sub2 = "0000000000000000") ELSE '0';
							--sum1
							sum1 <= o_reg3 + "0000000000000001";
							--sum2
							sum2 <= i_k + i_k;
							--sum3
							sum3 <= i_add + ("000000" & sum2);
							--sub1
							sub1 <= o_reg1 - "00000001";
							--sub3
							-- sub3 <= sum2 - 0;
							--sub2
							sub2 <= sum1 - sum3;
							--mux 2
							-- with o_c1 select
							-- m2 <= "00011111" when '0',
							-- mux3 when '1',
							-- "XXXXXXXX" when others;
							--mux 3
							WITH o_c2 SELECT
							mux3 <= sub1 WHEN '0',
							        o_reg1 WHEN '1',
							        "XXXXXXXX" WHEN OTHERS;
							--mux 4
							WITH o_c3 SELECT
							mux4 <= o_c4 WHEN '0',
							        '1' WHEN '1',
							        'X' WHEN OTHERS;
							--m1
							WITH m1_sel SELECT
							m1 <= o_reg4 WHEN '0',
							      o_reg1 WHEN '1',
							      "XXXXXXXX" WHEN OTHERS;
							--m3
							WITH m3_sel SELECT
							m3 <= i_add WHEN '0',
							      sum1 WHEN '1',
							      "XXXXXXXXXXXXXXXX" WHEN OTHERS;
							--m4
							WITH m4_sel SELECT
							m4 <= i_rst WHEN '0',
							      '1' WHEN '1',
							      'X' WHEN OTHERS;
							--m2
							WITH m2_sel SELECT
							m2 <= "00011111" WHEN '0',
							      mux3 WHEN '1',
							      "XXXXXXXX" WHEN OTHERS;
							--o_end
							o_end <= mux4;
							--o_zero
							o_zero <= o_c1;
							--o_mem_addr
							o_mem_addr <= o_reg3;
							--o_mem_data
							o_mem_data <= m1;

END Behavioral;