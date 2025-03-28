//==========================================================================
// Copyright (C) 2024 Chili.CHIPS*ba
//--------------------------------------------------------------------------
//                      PROPRIETARY INFORMATION
//
// The information contained in this file is the property of CHILI CHIPS LLC.
// Except as specifically authorized in writing by CHILI CHIPS LLC, the holder
// of this file: (1) shall keep all information contained herein confidential;
// and (2) shall protect the same in whole or in part from disclosure and
// dissemination to all third parties; and (3) shall use the same for operation
// and maintenance purposes only.
//--------------------------------------------------------------------------
// Description:
//   Minimal UART BFM, with all serial parameters fixed to:
//     - 115.2kbps (i.e. one bit period is 8.68usec)
//     - 8 Data bits
//     - 1 Stop bit
//     - 0 Parity
//
//  It provides the following Tx tasks:
//     - send_char  (<byte>);
//     - send_string(<string>);
//
//  along with always-on monitoring of Rx wire.
//
//  Use +define+UART_DEBUG for printout of debug messages.
//==========================================================================

`timescale 1ns / 1ns

module bfm_uart (
   input  logic  uart_rx,
   output logic  uart_tx
);

   localparam int BITIME_NS = 8_680; // time for one bit in ns (8.68us)

//--------------------------------------
// Send
//--------------------------------------
   task send_char (input byte char);
     //START
      uart_tx = 1'b0;
      #(BITIME_NS * 1ns);

     //D0..7, LSB goes out first
      for (int i=0; i<8; i++) begin
         uart_tx = char[i];
         #(BITIME_NS * 1ns);
      end

     //STOP
      uart_tx = 1'b1;
      #(BITIME_NS * 1ns);
   endtask: send_char

//- - - - - - - - - - - - - - - - - - -
   task send_cmd (input string cmd);
   `ifdef UART_BFM_DEBUG
      $display("\n%t --START-- %m '$%s'\n", $time, cmd);
   `endif

     // Send Start-of-Command character
      send_char (.char("$"));

     // Send Command itself
      for (int i=0; i<cmd.len; i++) begin
         send_char (.char(cmd[i]));
      end

     // Send End-of-Command characters
      send_char (.char("\r"));
      send_char (.char("\n"));

   `ifdef UART_BFM_DEBUG
      $display("\n%t -- END -- %m '$%s'\n", $time, cmd);
   `endif
   endtask: send_cmd


//- - - - - - - - - - - - - - - - - - -
   task send_string (input string text);
   `ifdef UART_BFM_DEBUG
      $display("\n%t --START-- %m '%s'\n", $time, text);
   `endif

      for (int i=0; i<text.len; i++) begin
         send_char (.char(text[i]));
      end

     // Send 'C' End-of-String character
      send_char (.char(8'h0));

   `ifdef UART_BFM_DEBUG
      $display("\n%t -- END -- %m '%s'\n", $time, text);
   `endif
   endtask: send_string


//--------------------------------------
// Initial greeting
//--------------------------------------
   int recv_byte_cnt; // number of received bytes

   initial begin: _init
      recv_byte_cnt = 0;

      uart_tx = 1'b1; // drive STOP bit
      #(BITIME_NS * 1ns);

     //__for UART test
     //send_string ("Mi smo FPGA raja\r\n");
     //send_string ("Mi nismo mehke koze\n");

     //__for Command parsing and dispatch test
       send_cmd ("2,1,1");
       send_cmd ("2 ");
       send_cmd ("2,1,0");
       send_cmd ("2");
       send_cmd ("2,1,1");
       //#(1 * 10us);
       send_cmd ("2,1,0");

       send_cmd ("3,10,5");   // DAC#1
       send_cmd ("4,23,73");  // DAC#2
       //
       //send_cmd ("1,0,0");    // ADC#1.Corner1
       //send_cmd ("2,1,0");    // ADC#2.Corner2
       //
       //send_cmd ("3,100,10"); // DAC#1
       //send_cmd ("4,3,11");   // DAC#2
       //
       send_cmd ("1,3,1");    // ADC#1
       send_cmd ("2,11,1");   // ADC#2
   end


//--------------------------------------
// Receive
//--------------------------------------
   byte recv_data;

   initial forever begin: receiver

     //___START: Look for the first input negedge
      @(negedge uart_rx);

     // wait till the middle of START bit, then check if valid
      #(BITIME_NS / 2 * 1ns);
      if (uart_rx !== 1'b0) begin
         $display("%t %m RX_ERROR: START bit not 0", $time);
      end

     //___DATA0-7: Collect 8 data bits (LSB comes in first)
      for (int i=0; i<8; i++) begin
         #(BITIME_NS * 1ns);
         recv_data[i] = uart_rx;
      end

     //___STOP: Wait till the middle of STOP bit to check if valid
      #(BITIME_NS * 1ns);
      if (uart_rx !== 1'b1) begin
         $display("%t %m RX_ERROR: STOP bit not 1", $time);
      end

     // ... and report transaction
   `ifdef UART_BFM_DEBUG
      recv_byte_cnt++;
      $display("%t %m Char#%0d \t%0h (%s)", $time,
               recv_byte_cnt, recv_data, string'(recv_data));
      recv_data = 'X;
   `endif
   end: receiver

endmodule: bfm_uart


/*
-----------------------------------------------------------------------------
Version History:
-----------------------------------------------------------------------------
 2024/3/3 JI: original creation
*/
