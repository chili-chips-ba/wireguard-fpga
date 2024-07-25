-- ************************************************************************
-- Copyright(C) 2005 by Xilinx, Inc. All rights reserved.
-- This text/file contains proprietary, confidential
-- information of Xilinx, Inc., is distributed under license
-- from Xilinx, Inc., and may be used, copied and/or
-- disclosed only pursuant to the terms of a valid license
-- agreement with Xilinx, Inc. Xilinx hereby grants you
-- a license to use this text/file solely for design, simulation,
-- implementation and creation of design files limited
-- to Xilinx devices or technologies. Use with non-Xilinx
-- devices or technologies is expressly prohibited and
-- immediately terminates your license unless covered by
-- a separate agreement.
--
-- Xilinx is providing this design, code, or information
-- "as is" solely for use in developing programs and
-- solutions for Xilinx devices. By providing this design,
-- code, or information as one possible implementation of
-- this feature, application or standard, Xilinx is making no
-- representation that this implementation is free from any
-- claims of infringement. You are responsible for
-- obtaining any rights you may require for your implementation.
-- Xilinx expressly disclaims any warranty whatsoever with
-- respect to the adequacy of the implementation, including
-- but not limited to any warranties or representations that this
-- implementation is free from claims of infringement, implied
-- warranties of merchantability or fitness for a particular
-- purpose.
--
-- Xilinx products are not intended for use in life support
-- appliances, devices, or systems. Use in such applications are
-- expressly prohibited.
--
-- This copyright and support notice must be retained as part
-- of this text at all times. (c) Copyright 2005 Xilinx, Inc.
-- All rights reserved.
--
-- Title - ImageXlib_utils.vhd
-- Author(s) - WC, Xilinx
-- Creation - Jan 2006
--
-- $RCSfile: ImageXlib_utils.vhd,v $ $Revision: 1.4 $ $Date: 2006/01/12 05:10:50 $
--
-- ************************************************************************
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;  

PACKAGE imagexlib_utils IS
-- ------------------------------------------------------------------------ 
-- TYPES:								    
-- ------------------------------------------------------------------------ 
  TYPE STD_LOGIC_VECTOR_ARRAY IS ARRAY ( NATURAL RANGE <>) OF std_logic_vector(255 downto 0);
  TYPE INTEGER_ARRAY IS ARRAY(NATURAL RANGE<>) OF INTEGER; 	
-- ------------------------------------------------------------------------ 
-- FUNCTIONS:								    
-- ------------------------------------------------------------------------   
   FUNCTION LOG2_BASE(NUMBER:INTEGER)
	RETURN INTEGER; 
   function extract_integer_array_from_str(array_size : integer; s : string ) 
   return INTEGER_ARRAY;
	
  END imagexlib_utils;

PACKAGE BODY imagexlib_utils IS


FUNCTION LOG2_BASE(NUMBER:INTEGER)
	RETURN INTEGER IS

    VARIABLE INDEX 	: INTEGER := NUMBER; 
    VARIABLE SUM    : INTEGER := 1; 

	BEGIN
    
		CASE INDEX IS
			WHEN 1|2 => SUM := 1;
			WHEN 3|4 => SUM := 2;
			WHEN 5|6|7|8 => SUM := 3;
			WHEN 9|10|11|12|13|14|15|16 => SUM := 4;
			WHEN 17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32 => SUM := 5;
			WHEN 33|34|35|36|37|38|39|40|41|42|43|44|45|46|47|48|49|50|51|52|53|54|55|56|57|58|59|60|61|62|63|64 => SUM := 6;
			WHEN 65 to 128 => SUM := 7;
			WHEN 129 to 256 => SUM := 8;   
			WHEN 257 to 512 => SUM := 9;
			WHEN 513 to 1024 => SUM := 10;
			WHEN 1025 to 2048 => SUM := 11;
			WHEN 2049 to 4096 => SUM := 12;
			WHEN 4097 to 8192 => SUM := 13;
			WHEN 8193 to 16384 => SUM := 14;
			WHEN 16385 to 32786 => SUM := 15;
			WHEN 32797 to 65536	=> SUM := 16;
			WHEN 65537 to 131072 => SUM := 17;
			WHEN 131073 to 262144 => SUM := 18;
			WHEN 262145 to 524288 => SUM := 19;
			WHEN 524289 to 1048576 => SUM := 20;
			WHEN 1048577 to 2097152 => SUM := 21;
			WHEN 2097153 to 4194304 => SUM := 22;
			WHEN 4194305 to 8388608 => SUM := 23;
			WHEN 8388609 to 16777216 => SUM := 24;
			WHEN OTHERS => SUM := 25;
			END CASE; 
		RETURN SUM;
   END LOG2_BASE;
    
   function extract_integer_array_from_str(array_size : integer; s : string ) return INTEGER_ARRAY is
      variable len : integer := s'length;
      variable ivalue : integer := 0;
      variable out_array : INTEGER_ARRAY((array_size-1) downto 0) := (others => 0);
      variable out_index : integer := 0;
      variable digit : integer;
      begin
         for i in 1 to len loop
            case s(i) is
               when '0' =>
                  digit := 0;
                  ivalue := ivalue * 10 + digit;
               when '1' =>
                  digit := 1;
                  ivalue := ivalue * 10 + digit;
               when '2' =>
                  digit := 2;
                  ivalue := ivalue * 10 + digit;
               when '3' =>
                  digit := 3;
                  ivalue := ivalue * 10 + digit;
               when '4' =>
                  digit := 4;
                  ivalue := ivalue * 10 + digit;
               when '5' =>
                  digit := 5;
                  ivalue := ivalue * 10 + digit;
               when '6' =>
                  digit := 6;
                  ivalue := ivalue * 10 + digit;
               when '7' =>
                  digit := 7;
                  ivalue := ivalue * 10 + digit;
               when '8' =>
                  digit := 8;
                  ivalue := ivalue * 10 + digit;
               when '9' =>
                  digit := 9;
                  ivalue := ivalue * 10 + digit;
               when others =>
                  out_array(out_index) := ivalue;
                  ivalue :=0;
                  out_index:= out_index + 1;
            end case;

         end loop;
      return(out_array);
      end;

END imagexlib_utils;

