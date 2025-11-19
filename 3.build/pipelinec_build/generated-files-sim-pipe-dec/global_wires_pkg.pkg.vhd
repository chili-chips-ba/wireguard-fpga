
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.c_structs_pkg.all; -- User types
-- Clock crossings
package global_wires_pkg is

  type chacha20_decrypt_pipeline_no_handshake_global_to_module_t is record
         chacha20_decrypt_pipeline_no_handshake_in : chacha20_decrypt_loop_body_in_t;
     chacha20_decrypt_pipeline_no_handshake_in_valid : unsigned(0 downto 0);

  end record;

  type chacha20_decrypt_pipeline_handshake_global_to_module_t is record
         chacha20_decrypt_pipeline_in : chacha20_decrypt_loop_body_in_t_stream_t;
     chacha20_decrypt_pipeline_no_handshake_out_valid : unsigned(0 downto 0);
     chacha20_decrypt_pipeline_no_handshake_out : axis512_t;
     chacha20_decrypt_pipeline_out_ready : unsigned(0 downto 0);

  end record;

  type chacha20_decrypt_input_side_global_to_module_t is record
         chacha20_decrypt_axis_in : axis128_t_stream_t;
     chacha20_decrypt_key : uint8_t_32;
     chacha20_decrypt_nonce : uint8_t_12;
     chacha20_decrypt_pipeline_in_ready : unsigned(0 downto 0);

  end record;

  type chacha20_decrypt_output_side_global_to_module_t is record
         chacha20_decrypt_pipeline_out : axis512_t_stream_t;
     chacha20_decrypt_poly_key_ready : unsigned(0 downto 0);
     chacha20_decrypt_axis_out_ready : unsigned(0 downto 0);

  end record;

  type prep_auth_data_global_to_module_t is record
         prep_auth_data_axis_in : axis128_t_stream_t;
     prep_auth_data_aad_len : unsigned(7 downto 0);
     prep_auth_data_aad : uint8_t_32;
     prep_auth_data_axis_out_ready : unsigned(0 downto 0);

  end record;

  type poly1305_pipeline_global_to_module_t is record
         poly1305_pipeline_in : poly1305_mac_loop_body_in_t;
     poly1305_pipeline_in_valid : unsigned(0 downto 0);

  end record;

  type poly1305_mac_global_to_module_t is record
         poly1305_mac_key : uint256_t_stream_t;
     poly1305_mac_data_in : axis128_t_stream_t;
     poly1305_pipeline_out_valid : unsigned(0 downto 0);
     poly1305_pipeline_out : u320_t;
     poly1305_mac_auth_tag_ready : unsigned(0 downto 0);

  end record;

  type poly1305_verify_decrypt_global_to_module_t is record
         poly1305_verify_auth_tag : uint128_t_stream_t;
     poly1305_verify_calc_tag : uint128_t_stream_t;
     poly1305_verify_tags_match_ready : unsigned(0 downto 0);

  end record;

  type strip_auth_tag_global_to_module_t is record
         strip_auth_tag_axis_out_ready : unsigned(0 downto 0);
     strip_auth_tag_axis_in : axis128_t_stream_t;
     strip_auth_tag_auth_tag_out_ready : unsigned(0 downto 0);

  end record;

  type verify_fifo_wr_stream_in_global_to_module_t is record
         verify_fifo_FIFO_WRITE_1_return_output : verify_fifo_FIFO_write_t;
     verify_fifo_in : axis128_t_stream_t;

  end record;

  type verify_fifo_rd_stream_out_global_to_module_t is record
         verify_fifo_FIFO_READ_1_return_output : verify_fifo_FIFO_read_t;
     verify_fifo_out_ready : unsigned(0 downto 0);

  end record;

  type wait_to_verify_global_to_module_t is record
         wait_to_verify_axis_in : axis128_t_stream_t;
     verify_fifo_in_ready : unsigned(0 downto 0);
     verify_fifo_out : axis128_t_stream_t;
     wait_to_verify_verify_bit : uint1_t_stream_t;
     wait_to_verify_axis_out_ready : unsigned(0 downto 0);

  end record;

  type main_global_to_module_t is record
         chacha20poly1305_decrypt_axis_in : axis128_t_stream_t;
     strip_auth_tag_axis_in_ready : unsigned(0 downto 0);
     chacha20poly1305_decrypt_key : uint8_t_32;
     chacha20poly1305_decrypt_nonce : uint8_t_12;
     chacha20_decrypt_poly_key : uint256_t_stream_t;
     poly1305_mac_key_ready : unsigned(0 downto 0);
     prep_auth_data_axis_in_ready : unsigned(0 downto 0);
     chacha20_decrypt_axis_in_ready : unsigned(0 downto 0);
     strip_auth_tag_axis_out : axis128_t_stream_t;
     chacha20poly1305_decrypt_aad : uint8_t_32;
     chacha20poly1305_decrypt_aad_len : unsigned(7 downto 0);
     prep_auth_data_axis_out : axis128_t_stream_t;
     poly1305_mac_data_in_ready : unsigned(0 downto 0);
     strip_auth_tag_auth_tag_out : uint128_t_stream_t;
     poly1305_verify_auth_tag_ready : unsigned(0 downto 0);
     poly1305_mac_auth_tag : uint128_t_stream_t;
     poly1305_verify_calc_tag_ready : unsigned(0 downto 0);
     chacha20_decrypt_axis_out : axis128_t_stream_t;
     wait_to_verify_axis_in_ready : unsigned(0 downto 0);
     poly1305_verify_tags_match : uint1_t_stream_t;
     wait_to_verify_verify_bit_ready : unsigned(0 downto 0);
     wait_to_verify_axis_out : axis128_t_stream_t;
     chacha20poly1305_decrypt_axis_out_ready : unsigned(0 downto 0);
     wait_to_verify_is_verified_out : unsigned(0 downto 0);

  end record;

  type tb_global_to_module_t is record
         chacha20poly1305_decrypt_axis_in_ready : unsigned(0 downto 0);
     chacha20poly1305_decrypt_axis_out : axis128_t_stream_t;

  end record;

  type chacha20_decrypt_pipeline_no_handshake_module_to_global_t is record
         chacha20_decrypt_pipeline_no_handshake_out : axis512_t;
     chacha20_decrypt_pipeline_no_handshake_out_valid : unsigned(0 downto 0);

  end record;
  

  type chacha20_decrypt_pipeline_handshake_module_to_global_t is record
         chacha20_decrypt_pipeline_in_ready : unsigned(0 downto 0);
     chacha20_decrypt_pipeline_no_handshake_in_valid : unsigned(0 downto 0);
     chacha20_decrypt_pipeline_no_handshake_in : chacha20_decrypt_loop_body_in_t;
     chacha20_decrypt_pipeline_out : axis512_t_stream_t;

  end record;
  

  type chacha20_decrypt_input_side_module_to_global_t is record
         chacha20_decrypt_axis_in_ready : unsigned(0 downto 0);
     chacha20_decrypt_pipeline_in : chacha20_decrypt_loop_body_in_t_stream_t;

  end record;
  

  type chacha20_decrypt_output_side_module_to_global_t is record
         chacha20_decrypt_poly_key : uint256_t_stream_t;
     chacha20_decrypt_pipeline_out_ready : unsigned(0 downto 0);
     chacha20_decrypt_axis_out : axis128_t_stream_t;

  end record;
  

  type prep_auth_data_module_to_global_t is record
         prep_auth_data_axis_in_ready : unsigned(0 downto 0);
     prep_auth_data_axis_out : axis128_t_stream_t;

  end record;
  

  type poly1305_pipeline_module_to_global_t is record
         poly1305_pipeline_out : u320_t;
     poly1305_pipeline_out_valid : unsigned(0 downto 0);

  end record;
  

  type poly1305_mac_module_to_global_t is record
         poly1305_mac_key_ready : unsigned(0 downto 0);
     poly1305_mac_data_in_ready : unsigned(0 downto 0);
     poly1305_mac_auth_tag : uint128_t_stream_t;
     poly1305_pipeline_in : poly1305_mac_loop_body_in_t;
     poly1305_pipeline_in_valid : unsigned(0 downto 0);

  end record;
  

  type poly1305_verify_decrypt_module_to_global_t is record
         poly1305_verify_auth_tag_ready : unsigned(0 downto 0);
     poly1305_verify_calc_tag_ready : unsigned(0 downto 0);
     poly1305_verify_tags_match : uint1_t_stream_t;

  end record;
  

  type strip_auth_tag_module_to_global_t is record
         strip_auth_tag_axis_in_ready : unsigned(0 downto 0);
     strip_auth_tag_axis_out : axis128_t_stream_t;
     strip_auth_tag_auth_tag_out : uint128_t_stream_t;

  end record;
  

  type verify_fifo_wr_stream_in_module_to_global_t is record
         verify_fifo_FIFO_WRITE_1_CLOCK_ENABLE : unsigned(0 downto 0);
     verify_fifo_FIFO_WRITE_1_write_data : axis128_t_1;
     verify_fifo_FIFO_WRITE_1_write_enable : unsigned(0 downto 0);
     verify_fifo_in_ready : unsigned(0 downto 0);

  end record;
  

  type verify_fifo_rd_stream_out_module_to_global_t is record
         verify_fifo_FIFO_READ_1_CLOCK_ENABLE : unsigned(0 downto 0);
     verify_fifo_FIFO_READ_1_read_enable : unsigned(0 downto 0);
     verify_fifo_out : axis128_t_stream_t;

  end record;
  

  type wait_to_verify_module_to_global_t is record
         verify_fifo_in : axis128_t_stream_t;
     wait_to_verify_axis_in_ready : unsigned(0 downto 0);
     wait_to_verify_axis_out : axis128_t_stream_t;
     wait_to_verify_verify_bit_ready : unsigned(0 downto 0);
     verify_fifo_out_ready : unsigned(0 downto 0);
     wait_to_verify_is_verified_out : unsigned(0 downto 0);

  end record;
  

  type main_module_to_global_t is record
         strip_auth_tag_axis_in : axis128_t_stream_t;
     chacha20poly1305_decrypt_axis_in_ready : unsigned(0 downto 0);
     chacha20_decrypt_key : uint8_t_32;
     chacha20_decrypt_nonce : uint8_t_12;
     poly1305_mac_key : uint256_t_stream_t;
     chacha20_decrypt_poly_key_ready : unsigned(0 downto 0);
     prep_auth_data_axis_in : axis128_t_stream_t;
     chacha20_decrypt_axis_in : axis128_t_stream_t;
     strip_auth_tag_axis_out_ready : unsigned(0 downto 0);
     prep_auth_data_aad : uint8_t_32;
     prep_auth_data_aad_len : unsigned(7 downto 0);
     poly1305_mac_data_in : axis128_t_stream_t;
     prep_auth_data_axis_out_ready : unsigned(0 downto 0);
     poly1305_verify_auth_tag : uint128_t_stream_t;
     strip_auth_tag_auth_tag_out_ready : unsigned(0 downto 0);
     poly1305_verify_calc_tag : uint128_t_stream_t;
     poly1305_mac_auth_tag_ready : unsigned(0 downto 0);
     wait_to_verify_axis_in : axis128_t_stream_t;
     chacha20_decrypt_axis_out_ready : unsigned(0 downto 0);
     wait_to_verify_verify_bit : uint1_t_stream_t;
     poly1305_verify_tags_match_ready : unsigned(0 downto 0);
     chacha20poly1305_decrypt_axis_out : axis128_t_stream_t;
     wait_to_verify_axis_out_ready : unsigned(0 downto 0);

  end record;
  

  type tb_module_to_global_t is record
         chacha20poly1305_decrypt_axis_in : axis128_t_stream_t;
     chacha20poly1305_decrypt_key : uint8_t_32;
     chacha20poly1305_decrypt_nonce : uint8_t_12;
     chacha20poly1305_decrypt_aad : uint8_t_32;
     chacha20poly1305_decrypt_aad_len : unsigned(7 downto 0);
     chacha20poly1305_decrypt_axis_out_ready : unsigned(0 downto 0);

  end record;
  
type global_to_module_t is record
    chacha20_decrypt_pipeline_no_handshake : chacha20_decrypt_pipeline_no_handshake_global_to_module_t;
    chacha20_decrypt_pipeline_handshake : chacha20_decrypt_pipeline_handshake_global_to_module_t;
    chacha20_decrypt_input_side : chacha20_decrypt_input_side_global_to_module_t;
    chacha20_decrypt_output_side : chacha20_decrypt_output_side_global_to_module_t;
    prep_auth_data : prep_auth_data_global_to_module_t;
    poly1305_pipeline : poly1305_pipeline_global_to_module_t;
    poly1305_mac : poly1305_mac_global_to_module_t;
    poly1305_verify_decrypt : poly1305_verify_decrypt_global_to_module_t;
    strip_auth_tag : strip_auth_tag_global_to_module_t;
    verify_fifo_wr_stream_in : verify_fifo_wr_stream_in_global_to_module_t;
    verify_fifo_rd_stream_out : verify_fifo_rd_stream_out_global_to_module_t;
    wait_to_verify : wait_to_verify_global_to_module_t;
    main : main_global_to_module_t;
    tb : tb_global_to_module_t;
  end record;
  
  type module_to_global_t is record
    chacha20_decrypt_pipeline_no_handshake : chacha20_decrypt_pipeline_no_handshake_module_to_global_t;
    chacha20_decrypt_pipeline_handshake : chacha20_decrypt_pipeline_handshake_module_to_global_t;
    chacha20_decrypt_input_side : chacha20_decrypt_input_side_module_to_global_t;
    chacha20_decrypt_output_side : chacha20_decrypt_output_side_module_to_global_t;
    prep_auth_data : prep_auth_data_module_to_global_t;
    poly1305_pipeline : poly1305_pipeline_module_to_global_t;
    poly1305_mac : poly1305_mac_module_to_global_t;
    poly1305_verify_decrypt : poly1305_verify_decrypt_module_to_global_t;
    strip_auth_tag : strip_auth_tag_module_to_global_t;
    verify_fifo_wr_stream_in : verify_fifo_wr_stream_in_module_to_global_t;
    verify_fifo_rd_stream_out : verify_fifo_rd_stream_out_module_to_global_t;
    wait_to_verify : wait_to_verify_module_to_global_t;
    main : main_module_to_global_t;
    tb : tb_module_to_global_t;
  end record;
  
  
end global_wires_pkg;
