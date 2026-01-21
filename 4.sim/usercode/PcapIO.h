// SPDX-FileCopyrightText: 2026 Chili.CHIPS*ba
//
// SPDX-License-Identifier: BSD-3-Clause

//========================================================================== 
// Wireguard-1GE FPGA * NLnet-sponsored open-source implementation   
//--------------------------------------------------------------------------
//                   Copyright (C) 2026 Chili.CHIPS*ba
// 
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions 
// are met:
//
// 1. Redistributions of source code must retain the above copyright 
// notice, this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright 
// notice, this list of conditions and the following disclaimer in the 
// documentation and/or other materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its 
// contributors may be used to endorse or promote products derived
// from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS 
// IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED 
// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
// PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
// HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//              https://opensource.org/license/bsd-3-clause
//--------------------------------------------------------------------------
// Description: Minimal C++ helper for reading/writing PCAP files in the
//              system-level VProc testbench.
//==========================================================================

#pragma once

#include <cstdint>
#include <cstdio>
#include <vector>
#include <string>

namespace pcapio {

enum class TimeRes { Micros, Nanos };

struct GlobalHdr {
   uint32_t magic;
   uint16_t ver_major;
   uint16_t ver_minor;
   int32_t  thiszone;
   uint32_t sigfigs;
   uint32_t snaplen;
   uint32_t network; // 1 = Ethernet
};

struct RecHdr {
   uint32_t ts_sec;
   uint32_t ts_frac; // usec or nsec depending on magic
   uint32_t incl_len;
   uint32_t orig_len;
};

class Reader {
public:
   Reader() = default;
   ~Reader() { close(); }

   bool open(const std::string &path) {
      close();
      f_ = std::fopen(path.c_str(), "rb");
      if (!f_)
         return false;
      if (std::fread(&gh_, sizeof(gh_), 1, f_) != 1) {
         close();
         return false;
      }
      detect_endian_and_res();
      return ok_;
   }

   void close() {
      if (f_) {
         std::fclose(f_);
         f_ = nullptr;
      }
      ok_ = false;
   }

   bool good() const { return ok_; }
   TimeRes time_res() const { return res_; }

   struct Packet { uint32_t ts_sec, ts_frac; std::vector<uint8_t> data; };

   bool next(Packet &pkt) {
      if (!ok_)
         return false;
      RecHdr rh{};
      if (std::fread(&rh, sizeof(rh), 1, f_) != 1)
         return false;
      fix_rec_hdr(rh);
      pkt.ts_sec  = rh.ts_sec;
      pkt.ts_frac = rh.ts_frac;
      pkt.data.resize(rh.incl_len);
      if (rh.incl_len > 0) {
         if (std::fread(pkt.data.data(), 1, rh.incl_len, f_) != rh.incl_len)
               return false;
      }
      return true;
   }

private:
   void detect_endian_and_res() {
      // Known magics
      // 0xa1b2c3d4  native, micros; 0xd4c3b2a1 swapped, micros
      // 0xa1b23c4d  native, nanos;  0x4d3cb2a1 swapped, nanos
      ok_ = true;
      swap_ = false;
      res_ = TimeRes::Micros;
      switch (gh_.magic) {
         case 0xa1b2c3d4:
            swap_ = false;
            res_ = TimeRes::Micros;
            break;
         case 0xd4c3b2a1:
            swap_ = true;
            res_ = TimeRes::Micros;
            break;
         case 0xa1b23c4d:
            swap_ = false;
            res_ = TimeRes::Nanos;
            break;
         case 0x4d3cb2a1:
            swap_ = true;
            res_ = TimeRes::Nanos;
            break;
         default:
            ok_ = false;
            break;
      }
      if (swap_)
      {
         swap_global();
      }
      if (gh_.network != 1) {
         // Not Ethernet; still allow but warn via ok_ flag if desired.
      }
   }

   static uint16_t bswap16(uint16_t v) {
      return (uint16_t)((v>>8) | (v<<8));
   }
   static uint32_t bswap32(uint32_t v) {
      return (v>>24) | ((v>>8)&0x0000FF00) | ((v<<8)&0x00FF0000) | (v<<24);
   }

   void swap_global() {
      gh_.magic     = bswap32(gh_.magic);
      gh_.ver_major = bswap16(gh_.ver_major);
      gh_.ver_minor = bswap16(gh_.ver_minor);
      gh_.thiszone  = (int32_t)bswap32((uint32_t)gh_.thiszone);
      gh_.sigfigs   = bswap32(gh_.sigfigs);
      gh_.snaplen   = bswap32(gh_.snaplen);
      gh_.network   = bswap32(gh_.network);
   }

   void fix_rec_hdr(RecHdr &rh) const {
      if (!swap_)
         return;
      rh.ts_sec  = bswap32(rh.ts_sec);
      rh.ts_frac = bswap32(rh.ts_frac);
      rh.incl_len= bswap32(rh.incl_len);
      rh.orig_len= bswap32(rh.orig_len);
   }

   FILE     *f_ = nullptr;
   GlobalHdr gh_{};
   bool      ok_ = false;
   bool      swap_ = false;
   TimeRes   res_ = TimeRes::Micros;
};

class Writer {
public:
   Writer() = default;
   ~Writer() { close(); }

   bool open(const std::string &path, TimeRes res = TimeRes::Nanos, uint32_t snaplen = 0x00040000) {
      close();
      f_ = std::fopen(path.c_str(), "wb");
      if (!f_)
         return false;
      res_ = res;
      GlobalHdr gh{};
      gh.magic     = (res == TimeRes::Nanos) ? 0xa1b23c4d : 0xa1b2c3d4; // little-endian
      gh.ver_major = 2;
      gh.ver_minor = 4;
      gh.thiszone  = 0;
      gh.sigfigs   = 0;
      gh.snaplen   = snaplen;
      gh.network   = 1; // Ethernet
      if (std::fwrite(&gh, sizeof(gh), 1, f_) != 1) {
         close();
         return false;
      }
      ok_ = true;
      return true;
   }

   void close() {
      if (f_) { std::fclose(f_); f_ = nullptr; }
      ok_ = false;
   }

   bool good() const {
      return ok_;
   }
   TimeRes time_res() const {
      return res_;
   }

   bool write(uint32_t ts_sec, uint32_t ts_frac, const uint8_t* data, uint32_t len) {
      if (!ok_)
         return false;
      RecHdr rh { ts_sec, ts_frac, len, len };
      if (std::fwrite(&rh, sizeof(rh), 1, f_) != 1)
         return false;
      if (len && std::fwrite(data, 1, len, f_) != len)
         return false;
      std::fflush(f_);
      return true;
   }

   bool write(uint32_t ts_sec, uint32_t ts_frac, const std::vector<uint8_t> &data) {
      return write(ts_sec, ts_frac, data.data(), (uint32_t)data.size());
   }

private:
   FILE   *f_ = nullptr;
   bool    ok_ = false;
   TimeRes res_ = TimeRes::Nanos;
};

} // namespace pcapio
