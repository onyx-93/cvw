///////////////////////////////////////////
// gpio_apb.sv
//
// Written: David_Harris@hmc.edu 14 January 2021
// Modified: bbracker@hmc.edu 15 Apr. 2021
//
// Purpose: General Purpose I/O peripheral
//   See FE310-G002-Manual-v19p05 for specifications
//   No interrupts, drive strength, or pull-ups supported
// 
// Documentation: RISC-V System on Chip Design Chapter 15
//
// A component of the CORE-V-WALLY configurable RISC-V project.
// https://github.com/openhwgroup/cvw
// 
// Copyright (C) 2021-23 Harvey Mudd College & Oklahoma State University
//
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Licensed under the Solderpad Hardware License v 2.1 (the “License”); you may not use this file 
// except in compliance with the License, or, at your option, the Apache License version 2.0. You 
// may obtain a copy of the License at
//
// https://solderpad.org/licenses/SHL-2.1/
//
// Unless required by applicable law or agreed to in writing, any work distributed under the 
// License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
// either express or implied. See the License for the specific language governing permissions 
// and limitations under the License.
////////////////////////////////////////////////////////////////////////////////////////////////

module gpio_apb import cvw::*;  #(parameter cvw_t P) (
  input  logic                PCLK, PRESETn,
  input  logic                PSEL,
  input  logic [7:0]          PADDR, 
  input  logic [P.XLEN-1:0]   PWDATA,
  input  logic [P.XLEN/8-1:0] PSTRB,
  input  logic                PWRITE,
  input  logic                PENABLE,
  output logic [P.XLEN-1:0]   PRDATA,
  output logic                PREADY,
  input  logic [31:0]         iof0, iof1,
  input  logic [31:0]         GPIOIN,
  output logic [31:0]         GPIOOUT, GPIOEN,
  output logic                GPIOIntr
);

  logic [31:0]                input0d, input1d, input2d, input3d;
  logic [31:0]                input_val, input_en, output_en, output_val;
  logic [31:0]                rise_ie, rise_ip, fall_ie, fall_ip, high_ie, high_ip, low_ie, low_ip; 
  logic [31:0]                out_xor, iof_en, iof_sel, iof_out, gpio_out;
  logic [7:0]                 entry;
  logic [31:0]                Din, Dout;
  logic                       memwrite;
  
  // APB I/O
  assign entry    = {PADDR[7:2],2'b00};       // 32-bit word-aligned accesses
  assign memwrite = PWRITE & PENABLE & PSEL;  // only write in access phase
  assign PREADY   = 1'b1;                     // GPIO never takes >1 cycle to respond

  // account for subword read/write circuitry
  // -- Note GPIO registers are 32 bits no matter what; access them with LW SW.
  assign Din = PWDATA[31:0]; 
  if (P.XLEN == 64) assign PRDATA = {Dout, Dout}; 
  else              assign PRDATA = Dout;    

  // register access
  always_ff @(posedge PCLK, negedge PRESETn)
    if (~PRESETn) begin // asynch reset
      input_en  <= 0;
      output_en <= 0;
      // *** synch reset not yet implemented [DH: can we delete this comment?  Check if a sync reset is required]
      output_val <= #1 0;
      rise_ie    <= #1 0;
      rise_ip    <= #1 0;
      fall_ie    <= #1 0;
      fall_ip    <= #1 0;
      high_ie    <= #1 0;
      high_ip    <= #1 0;
      low_ie     <= #1 0;
      low_ip     <= #1 0;
      iof_en     <= #1 0;
      iof_sel    <= #1 0;
      out_xor    <= #1 0;
    end else begin     // writes
        // According to FE310 spec: Once the interrupt is pending, it will remain set until a 1 is written to the *_ip register at that bit.
        /* verilator lint_off CASEINCOMPLETE */
      if (memwrite) 
        case(entry)
          8'h04: input_en   <= #1 Din;
          8'h08: output_en  <= #1 Din;
          8'h0C: output_val <= #1 Din;
          8'h18: rise_ie    <= #1 Din;
          8'h20: fall_ie    <= #1 Din;
          8'h28: high_ie    <= #1 Din;
          8'h30: low_ie     <= #1 Din;
          8'h38: iof_en     <= #1 Din;
          8'h3C: iof_sel    <= #1 Din;
          8'h40: out_xor    <= #1 Din;
        endcase
        /* verilator lint_on CASEINCOMPLETE */

      // interrupts can be cleared by writing corresponding bits to a register
      if (memwrite & entry == 8'h1C)   rise_ip <= rise_ip & ~Din;
      else                             rise_ip <= rise_ip | (input2d & ~input3d);
      if (memwrite & (entry == 8'h24)) fall_ip <= fall_ip & ~Din;
      else                             fall_ip <= fall_ip | (~input2d & input3d);
      if (memwrite & (entry == 8'h2C)) high_ip <= high_ip & ~Din;
      else                             high_ip <= high_ip | input3d;
      if (memwrite & (entry == 8'h34)) low_ip  <= low_ip  & ~Din;
      else                             low_ip  <= low_ip  | ~input3d;

      case(entry) // flop to sample inputs
        8'h00: Dout   <= #1 input_val;
        8'h04: Dout   <= #1 input_en;
        8'h08: Dout   <= #1 output_en;
        8'h0C: Dout   <= #1 output_val;
        8'h18: Dout   <= #1 rise_ie;
        8'h1C: Dout   <= #1 rise_ip;
        8'h20: Dout   <= #1 fall_ie;
        8'h24: Dout   <= #1 fall_ip;
        8'h28: Dout   <= #1 high_ie;
        8'h2C: Dout   <= #1 high_ip;
        8'h30: Dout   <= #1 low_ie;
        8'h34: Dout   <= #1 low_ip;
        8'h38: Dout   <= #1 iof_en;
        8'h3C: Dout   <= #1 iof_sel;
        8'h40: Dout   <= #1 out_xor; 
        default: Dout <= #1 0;
      endcase
    end

  // chip i/o
  // connect OUT to IN for loopback testing
  if (P.GPIO_LOOPBACK_TEST) assign input0d = ((output_en & GPIOOUT) | (~output_en & GPIOIN)) & input_en;
  else                      assign input0d = GPIOIN & input_en;

  // synchroninzer for inputs
  flop #(32) sync1(PCLK,input0d,input1d);
  flop #(32) sync2(PCLK,input1d,input2d);
  flop #(32) sync3(PCLK,input2d,input3d);
  assign input_val = input3d;
  assign iof_out   = iof_sel & iof1 | ~iof_sel & iof0;        // per-bit mux between iof1 and iof0
  assign gpio_out  = iof_en & iof_out | ~iof_en & output_val; // per-bit mux between IOF and output_val
  assign GPIOOUT   = gpio_out ^ out_xor;                      // per-bit flip output polarity
  assign GPIOEN    = output_en;

  assign GPIOIntr  = |{(rise_ip & rise_ie),(fall_ip & fall_ie),(high_ip & high_ie),(low_ip & low_ie)};
endmodule
