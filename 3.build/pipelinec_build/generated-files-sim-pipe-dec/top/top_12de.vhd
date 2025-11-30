library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.c_structs_pkg.all;
use work.global_wires_pkg.all;

  entity top_12de is
port(
-- All clocks
clk_80p0 : in std_logic;

-- IO for each main func
tb_return_output : out axis128_t_stream_t
  );
end top_12de;
architecture arch of top_12de is

attribute syn_keep : boolean;
attribute keep : string;
attribute dont_touch : string;


-- Global/clock crossing wires from modules to global area
signal module_to_global : module_to_global_t;
-- Global/clock crossing wires from the global area to modules
signal global_to_module : global_to_module_t;
signal clk_cross_verify_fifo_FIFO_return_output : verify_fifo_FIFO_read_t;














signal tb_return_output_output : axis128_t_stream_t;
signal tb_0CLK_837e73b8_return_output_output_reg : axis128_t_stream_t;
attribute syn_keep of tb_0CLK_837e73b8_return_output_output_reg : signal is true;
attribute keep of tb_0CLK_837e73b8_return_output_output_reg : signal is "true";
attribute dont_touch of tb_0CLK_837e73b8_return_output_output_reg : signal is "true";


begin

 -- IO regs
 process(clk_80p0) is
 begin
  if rising_edge(clk_80p0) then
  end if;
 end process;
 process(clk_80p0) is
 begin
  if rising_edge(clk_80p0) then
  end if;
 end process;
 process(clk_80p0) is
 begin
  if rising_edge(clk_80p0) then
  end if;
 end process;
 process(clk_80p0) is
 begin
  if rising_edge(clk_80p0) then
  end if;
 end process;
 process(clk_80p0) is
 begin
  if rising_edge(clk_80p0) then
  end if;
 end process;
 process(clk_80p0) is
 begin
  if rising_edge(clk_80p0) then
  end if;
 end process;
 process(clk_80p0) is
 begin
  if rising_edge(clk_80p0) then
  end if;
 end process;
 process(clk_80p0) is
 begin
  if rising_edge(clk_80p0) then
  end if;
 end process;
 process(clk_80p0) is
 begin
  if rising_edge(clk_80p0) then
  end if;
 end process;
 process(clk_80p0) is
 begin
  if rising_edge(clk_80p0) then
  end if;
 end process;
 process(clk_80p0) is
 begin
  if rising_edge(clk_80p0) then
  end if;
 end process;
 process(clk_80p0) is
 begin
  if rising_edge(clk_80p0) then
  end if;
 end process;
 process(clk_80p0) is
 begin
  if rising_edge(clk_80p0) then
  end if;
 end process;
 process(clk_80p0) is
 begin
  if rising_edge(clk_80p0) then
   tb_0CLK_837e73b8_return_output_output_reg <= tb_return_output_output;
  end if;
 end process;
 tb_return_output <= tb_0CLK_837e73b8_return_output_output_reg;

-- Instantiate each main
-- main functions are always clock enabled, always running
chacha20_decrypt_pipeline_no_handshake_30CLK_37747f67 : entity work.chacha20_decrypt_pipeline_no_handshake_30CLK_37747f67 port map (
clk_80p0,
to_unsigned(1,1),
global_to_module.chacha20_decrypt_pipeline_no_handshake,
module_to_global.chacha20_decrypt_pipeline_no_handshake);

chacha20_decrypt_pipeline_handshake_0CLK_61d00b9b : entity work.chacha20_decrypt_pipeline_handshake_0CLK_61d00b9b port map (
clk_80p0,
to_unsigned(1,1),
global_to_module.chacha20_decrypt_pipeline_handshake,
module_to_global.chacha20_decrypt_pipeline_handshake);

chacha20_decrypt_input_side_0CLK_3a428b31 : entity work.chacha20_decrypt_input_side_0CLK_3a428b31 port map (
clk_80p0,
to_unsigned(1,1),
global_to_module.chacha20_decrypt_input_side,
module_to_global.chacha20_decrypt_input_side);

chacha20_decrypt_output_side_0CLK_c26c3aac : entity work.chacha20_decrypt_output_side_0CLK_c26c3aac port map (
clk_80p0,
to_unsigned(1,1),
global_to_module.chacha20_decrypt_output_side,
module_to_global.chacha20_decrypt_output_side);

prep_auth_data_0CLK_41669ea5 : entity work.prep_auth_data_0CLK_41669ea5 port map (
clk_80p0,
to_unsigned(1,1),
global_to_module.prep_auth_data,
module_to_global.prep_auth_data);

poly1305_pipeline_3CLK_a31693b0 : entity work.poly1305_pipeline_3CLK_a31693b0 port map (
clk_80p0,
to_unsigned(1,1),
global_to_module.poly1305_pipeline,
module_to_global.poly1305_pipeline);

poly1305_mac_0CLK_caa1d5f6 : entity work.poly1305_mac_0CLK_caa1d5f6 port map (
clk_80p0,
to_unsigned(1,1),
global_to_module.poly1305_mac,
module_to_global.poly1305_mac);

poly1305_verify_decrypt_0CLK_08de2a73 : entity work.poly1305_verify_decrypt_0CLK_08de2a73 port map (
clk_80p0,
to_unsigned(1,1),
global_to_module.poly1305_verify_decrypt,
module_to_global.poly1305_verify_decrypt);

strip_auth_tag_0CLK_69e380ac : entity work.strip_auth_tag_0CLK_69e380ac port map (
clk_80p0,
to_unsigned(1,1),
global_to_module.strip_auth_tag,
module_to_global.strip_auth_tag);

verify_fifo_wr_stream_in_0CLK_a5a1cd4e : entity work.verify_fifo_wr_stream_in_0CLK_a5a1cd4e port map (
to_unsigned(1,1),
global_to_module.verify_fifo_wr_stream_in,
module_to_global.verify_fifo_wr_stream_in);

verify_fifo_rd_stream_out_0CLK_6f2c5aad : entity work.verify_fifo_rd_stream_out_0CLK_6f2c5aad port map (
to_unsigned(1,1),
global_to_module.verify_fifo_rd_stream_out,
module_to_global.verify_fifo_rd_stream_out);

wait_to_verify_0CLK_9d359dd9 : entity work.wait_to_verify_0CLK_9d359dd9 port map (
clk_80p0,
to_unsigned(1,1),
global_to_module.wait_to_verify,
module_to_global.wait_to_verify);

main_0CLK_fc74e538 : entity work.main_0CLK_fc74e538 port map (
global_to_module.main,
module_to_global.main);

tb_0CLK_837e73b8 : entity work.tb_0CLK_837e73b8 port map (
clk_80p0,
to_unsigned(1,1),
global_to_module.tb,
module_to_global.tb,
tb_return_output_output);


-- Instantiate each unidirectional data clock crossing
verify_fifo_FIFO : entity work.clk_cross_verify_fifo_FIFO port map
(
in_clk => clk_80p0,
in_clk_en => module_to_global.verify_fifo_wr_stream_in.verify_fifo_FIFO_WRITE_1_CLOCK_ENABLE,
write_data => module_to_global.verify_fifo_wr_stream_in.verify_fifo_FIFO_WRITE_1_write_data,
write_enable => module_to_global.verify_fifo_wr_stream_in.verify_fifo_FIFO_WRITE_1_write_enable,
wr_return_output => global_to_module.verify_fifo_wr_stream_in.verify_fifo_FIFO_WRITE_1_return_output,
out_clk => clk_80p0,
out_clk_en => module_to_global.verify_fifo_rd_stream_out.verify_fifo_FIFO_READ_1_CLOCK_ENABLE,
read_enable => module_to_global.verify_fifo_rd_stream_out.verify_fifo_FIFO_READ_1_read_enable,
rd_return_output => clk_cross_verify_fifo_FIFO_return_output
);
global_to_module.verify_fifo_rd_stream_out.verify_fifo_FIFO_READ_1_return_output <= clk_cross_verify_fifo_FIFO_return_output;


-- Directly connected global wires
global_to_module.main.chacha20poly1305_decrypt_key <= module_to_global.tb.chacha20poly1305_decrypt_key;

global_to_module.main.wait_to_verify_axis_in_ready <= module_to_global.wait_to_verify.wait_to_verify_axis_in_ready;

global_to_module.main.wait_to_verify_is_verified_out <= module_to_global.wait_to_verify.wait_to_verify_is_verified_out;

global_to_module.main.chacha20poly1305_decrypt_aad_len <= module_to_global.tb.chacha20poly1305_decrypt_aad_len;

global_to_module.main.chacha20_decrypt_poly_key <= module_to_global.chacha20_decrypt_output_side.chacha20_decrypt_poly_key;

global_to_module.main.wait_to_verify_axis_out <= module_to_global.wait_to_verify.wait_to_verify_axis_out;

global_to_module.chacha20_decrypt_pipeline_no_handshake.chacha20_decrypt_pipeline_no_handshake_in <= module_to_global.chacha20_decrypt_pipeline_handshake.chacha20_decrypt_pipeline_no_handshake_in;

global_to_module.wait_to_verify.wait_to_verify_axis_in <= module_to_global.main.wait_to_verify_axis_in;

global_to_module.wait_to_verify.verify_fifo_out <= module_to_global.verify_fifo_rd_stream_out.verify_fifo_out;

global_to_module.main.strip_auth_tag_axis_in_ready <= module_to_global.strip_auth_tag.strip_auth_tag_axis_in_ready;

global_to_module.chacha20_decrypt_pipeline_handshake.chacha20_decrypt_pipeline_no_handshake_out <= module_to_global.chacha20_decrypt_pipeline_no_handshake.chacha20_decrypt_pipeline_no_handshake_out;

global_to_module.poly1305_pipeline.poly1305_pipeline_in_valid <= module_to_global.poly1305_mac.poly1305_pipeline_in_valid;

global_to_module.main.prep_auth_data_axis_in_ready <= module_to_global.prep_auth_data.prep_auth_data_axis_in_ready;

global_to_module.chacha20_decrypt_input_side.chacha20_decrypt_pipeline_in_ready <= module_to_global.chacha20_decrypt_pipeline_handshake.chacha20_decrypt_pipeline_in_ready;

global_to_module.chacha20_decrypt_output_side.chacha20_decrypt_pipeline_out <= module_to_global.chacha20_decrypt_pipeline_handshake.chacha20_decrypt_pipeline_out;

global_to_module.chacha20_decrypt_pipeline_handshake.chacha20_decrypt_pipeline_out_ready <= module_to_global.chacha20_decrypt_output_side.chacha20_decrypt_pipeline_out_ready;

global_to_module.strip_auth_tag.strip_auth_tag_axis_in <= module_to_global.main.strip_auth_tag_axis_in;

global_to_module.chacha20_decrypt_input_side.chacha20_decrypt_axis_in <= module_to_global.main.chacha20_decrypt_axis_in;

global_to_module.poly1305_mac.poly1305_pipeline_out_valid <= module_to_global.poly1305_pipeline.poly1305_pipeline_out_valid;

global_to_module.poly1305_mac.poly1305_pipeline_out <= module_to_global.poly1305_pipeline.poly1305_pipeline_out;

global_to_module.strip_auth_tag.strip_auth_tag_auth_tag_out_ready <= module_to_global.main.strip_auth_tag_auth_tag_out_ready;

global_to_module.wait_to_verify.wait_to_verify_axis_out_ready <= module_to_global.main.wait_to_verify_axis_out_ready;

global_to_module.main.poly1305_mac_auth_tag <= module_to_global.poly1305_mac.poly1305_mac_auth_tag;

global_to_module.chacha20_decrypt_pipeline_handshake.chacha20_decrypt_pipeline_no_handshake_out_valid <= module_to_global.chacha20_decrypt_pipeline_no_handshake.chacha20_decrypt_pipeline_no_handshake_out_valid;

global_to_module.main.prep_auth_data_axis_out <= module_to_global.prep_auth_data.prep_auth_data_axis_out;

global_to_module.tb.chacha20poly1305_decrypt_axis_in_ready <= module_to_global.main.chacha20poly1305_decrypt_axis_in_ready;

global_to_module.poly1305_verify_decrypt.poly1305_verify_auth_tag <= module_to_global.main.poly1305_verify_auth_tag;

global_to_module.poly1305_mac.poly1305_mac_key <= module_to_global.main.poly1305_mac_key;

global_to_module.chacha20_decrypt_output_side.chacha20_decrypt_axis_out_ready <= module_to_global.main.chacha20_decrypt_axis_out_ready;

global_to_module.poly1305_mac.poly1305_mac_data_in <= module_to_global.main.poly1305_mac_data_in;

global_to_module.wait_to_verify.verify_fifo_in_ready <= module_to_global.verify_fifo_wr_stream_in.verify_fifo_in_ready;

global_to_module.main.poly1305_mac_key_ready <= module_to_global.poly1305_mac.poly1305_mac_key_ready;

global_to_module.main.wait_to_verify_verify_bit_ready <= module_to_global.wait_to_verify.wait_to_verify_verify_bit_ready;

global_to_module.verify_fifo_rd_stream_out.verify_fifo_out_ready <= module_to_global.wait_to_verify.verify_fifo_out_ready;

global_to_module.main.chacha20_decrypt_axis_out <= module_to_global.chacha20_decrypt_output_side.chacha20_decrypt_axis_out;

global_to_module.main.chacha20poly1305_decrypt_nonce <= module_to_global.tb.chacha20poly1305_decrypt_nonce;

global_to_module.main.poly1305_verify_calc_tag_ready <= module_to_global.poly1305_verify_decrypt.poly1305_verify_calc_tag_ready;

global_to_module.poly1305_mac.poly1305_mac_auth_tag_ready <= module_to_global.main.poly1305_mac_auth_tag_ready;

global_to_module.prep_auth_data.prep_auth_data_aad <= module_to_global.main.prep_auth_data_aad;

global_to_module.chacha20_decrypt_input_side.chacha20_decrypt_nonce <= module_to_global.main.chacha20_decrypt_nonce;

global_to_module.poly1305_pipeline.poly1305_pipeline_in <= module_to_global.poly1305_mac.poly1305_pipeline_in;

global_to_module.main.poly1305_verify_auth_tag_ready <= module_to_global.poly1305_verify_decrypt.poly1305_verify_auth_tag_ready;

global_to_module.strip_auth_tag.strip_auth_tag_axis_out_ready <= module_to_global.main.strip_auth_tag_axis_out_ready;

global_to_module.main.chacha20poly1305_decrypt_aad <= module_to_global.tb.chacha20poly1305_decrypt_aad;

global_to_module.main.chacha20poly1305_decrypt_axis_in <= module_to_global.tb.chacha20poly1305_decrypt_axis_in;

global_to_module.main.chacha20_decrypt_axis_in_ready <= module_to_global.chacha20_decrypt_input_side.chacha20_decrypt_axis_in_ready;

global_to_module.verify_fifo_wr_stream_in.verify_fifo_in <= module_to_global.wait_to_verify.verify_fifo_in;

global_to_module.poly1305_verify_decrypt.poly1305_verify_calc_tag <= module_to_global.main.poly1305_verify_calc_tag;

global_to_module.wait_to_verify.wait_to_verify_verify_bit <= module_to_global.main.wait_to_verify_verify_bit;

global_to_module.prep_auth_data.prep_auth_data_aad_len <= module_to_global.main.prep_auth_data_aad_len;

global_to_module.prep_auth_data.prep_auth_data_axis_in <= module_to_global.main.prep_auth_data_axis_in;

global_to_module.main.poly1305_mac_data_in_ready <= module_to_global.poly1305_mac.poly1305_mac_data_in_ready;

global_to_module.main.strip_auth_tag_axis_out <= module_to_global.strip_auth_tag.strip_auth_tag_axis_out;

global_to_module.chacha20_decrypt_pipeline_handshake.chacha20_decrypt_pipeline_in <= module_to_global.chacha20_decrypt_input_side.chacha20_decrypt_pipeline_in;

global_to_module.main.poly1305_verify_tags_match <= module_to_global.poly1305_verify_decrypt.poly1305_verify_tags_match;

global_to_module.prep_auth_data.prep_auth_data_axis_out_ready <= module_to_global.main.prep_auth_data_axis_out_ready;

global_to_module.main.strip_auth_tag_auth_tag_out <= module_to_global.strip_auth_tag.strip_auth_tag_auth_tag_out;

global_to_module.chacha20_decrypt_pipeline_no_handshake.chacha20_decrypt_pipeline_no_handshake_in_valid <= module_to_global.chacha20_decrypt_pipeline_handshake.chacha20_decrypt_pipeline_no_handshake_in_valid;

global_to_module.tb.chacha20poly1305_decrypt_axis_out <= module_to_global.main.chacha20poly1305_decrypt_axis_out;

global_to_module.main.chacha20poly1305_decrypt_axis_out_ready <= module_to_global.tb.chacha20poly1305_decrypt_axis_out_ready;

global_to_module.chacha20_decrypt_input_side.chacha20_decrypt_key <= module_to_global.main.chacha20_decrypt_key;

global_to_module.chacha20_decrypt_output_side.chacha20_decrypt_poly_key_ready <= module_to_global.main.chacha20_decrypt_poly_key_ready;

global_to_module.poly1305_verify_decrypt.poly1305_verify_tags_match_ready <= module_to_global.main.poly1305_verify_tags_match_ready;


end arch;
