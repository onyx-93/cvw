///////////////////////////////////////////
// csrindextoaddr.sv
//
// Written: Rose Thompson ross1728@gmail.com
// Created: 24 January 2024
// Modified: 24 January 2024
//
// Purpose: Converts the rvvi CSR index into the CSR address
//
// Documentation: 
//
// A component of the CORE-V-WALLY configurable RISC-V project.
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

module csrindextoaddr #(parameter NUM_CSRS = 36) (
  input logic [ROWS-1:0]  CSRWen,
  output logic [11:0] CSRAddr);

  always_comb begin
    case(CSRWen) begin
      36'h0_0000_0000: CSRAddr = 13'h000;
      36'h0_0000_0001: CSRAddr = 13'h300;
      36'h0_0000_0002: CSRAddr = 13'h310;
      36'h0_0000_0004: CSRAddr = 13'h305;      
      36'h0_0000_0008: CSRAddr = 13'h341;      
      36'h0_0000_0010: CSRAddr = 13'h306;      
      36'h0_0000_0020: CSRAddr = 13'h320;      
      36'h0_0000_0040: CSRAddr = 13'h302;      
      36'h0_0000_0080: CSRAddr = 13'h303;      
      36'h0_0000_0100: CSRAddr = 13'h344;      
      36'h0_0000_0200: CSRAddr = 13'h304;      
      36'h0_0000_0400: CSRAddr = 13'h301;      
      36'h0_0000_0800: CSRAddr = 13'h30A;      
      36'h0_0000_1000: CSRAddr = 13'hF14;      
      36'h0_0000_2000: CSRAddr = 13'h340;
      36'h0_0000_4000: CSRAddr = 13'h342;
      36'h0_0000_8000: CSRAddr = 13'h343;
      36'h0_0001_0000: CSRAddr = 13'hF11;
      36'h0_0002_0000: CSRAddr = 13'hF12;
      36'h0_0004_0000: CSRAddr = 13'hF13;
      36'h0_0008_0000: CSRAddr = 13'hF15;
      36'h0_0010_0000: CSRAddr = 13'h34A;
      36'h0_0020_0000: CSRAddr = 13'h100;
      36'h0_0040_0000: CSRAddr = 13'h104;
      36'h0_0080_0000: CSRAddr = 13'h105;
      36'h0_0100_0000: CSRAddr = 13'h141;
      36'h0_0200_0000: CSRAddr = 13'h106;
      36'h0_0400_0000: CSRAddr = 13'h10A;
      36'h0_0800_0000: CSRAddr = 13'h180;
      36'h0_1000_0000: CSRAddr = 13'h140;
      36'h0_2000_0000: CSRAddr = 13'h143;
      36'h0_4000_0000: CSRAddr = 13'h142;
      36'h0_8000_0000: CSRAddr = 13'h144;
      36'h1_0000_0000: CSRAddr = 13'h14D;
      36'h2_0000_0000: CSRAddr = 13'h001;
      36'h4_0000_0000: CSRAddr = 13'h002;
      36'h8_0000_0000: CSRAddr = 13'h003;
      default        : CSRAddr = 13'h000;
    end
  end
endmodule
  
