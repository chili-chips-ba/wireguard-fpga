//=====================================================================
//
// VProcClass.h                                       Date: 2023/12/29
//
// Copyright (c) 2023-2024 Simon Southwell.
//
// This file is part of VProc.
//
// VProc is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// VProc is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with VProc. If not, see <http://www.gnu.org/licenses/>.
//
//=====================================================================
// C++ API class wrapper for VProc C API
//=====================================================================

#ifndef _VPROCCLASS_H_
#define _VPROCCLASS_H_

extern "C"
{
#include "VUser.h"
}

class VProc
{
public:
         // Constructor
         VProc        (const unsigned   nodeIn) : node(nodeIn) {};

    // API methods
    int  write        (const unsigned   addr,     const unsigned    data, const int      delta=0)    {return VWrite        (addr,  data, delta,  node);};
    int  read         (const unsigned   addr,           unsigned   *data, const int      delta=0)    {return VRead         (addr,  data, delta,  node);};

    int  writeByte    (const unsigned   byteaddr, const unsigned    data, const int      delta=0)    {return VWriteBE      (byteaddr & ~(0x3), data << (8*(byteaddr&0x3)), 0x1 << (byteaddr&0x3), delta, node);};
    int  writeHword   (const unsigned   byteaddr, const unsigned    data, const int      delta=0)    {return VWriteBE      (byteaddr & ~(0x3), data << (8*(byteaddr&0x2)), 0x3 << (byteaddr&0x2), delta, node);};
    int  writeWord    (const unsigned   byteaddr, const unsigned    data, const int      delta=0)    {return VWriteBE      (byteaddr & ~(0x3), data, 0xf, delta, node);};

    int  readByte     (const unsigned   byteaddr,       unsigned   *data, const int      delta=0)    { int status; unsigned word;
                                                                                                       status = VRead(byteaddr & ~(0x3), &word, delta, node);
                                                                                                       *data  = (word >> (8*(byteaddr&0x3))) & 0xff;
                                                                                                       return status;};

    int  readHword    (const unsigned   byteaddr,       unsigned   *data, const int      delta=0)    { int status; unsigned word;
                                                                                                       status = VRead(byteaddr & ~(0x3), &word, delta, node);
                                                                                                       *data  = (word >> (8*(byteaddr&0x2))) & 0xffff;
                                                                                                       return status;};

    int  readWord     (const unsigned   byteaddr,       unsigned   *data, const int      delta=0)    { int status; unsigned word;
                                                                                                       status = VRead(byteaddr & ~(0x3), &word, delta, node);
                                                                                                       *data  = word;
                                                                                                       return status;};

    int  burstWrite      (const unsigned   addr,           void    *data, const unsigned wordlen)    {return VBurstWrite     (addr,      data, wordlen, node);};
    int  burstRead       (const unsigned   addr,           void    *data, const unsigned wordlen)    {return VBurstRead      (addr,      data, wordlen, node);};
    int  tick            (const unsigned   ticks)                                                    {return VTick           (ticks,                    node);};
    void regIrq          (const pVUserIrqCB_t func)                                                  {       VRegIrq         (func,                     node);};
    void regInterrupt    (const int        level,  const pVUserInt_t func)                           {       VRegInterrupt   (level,     func,          node);};
    void regUser         (const pVUserCB_t func)                                                     {       VRegUser        (func,                     node);};


    int  burstWriteBytes (const unsigned   byteaddr,       void    *data, const unsigned bytelen) {unsigned foff, loff;
                                                                                                   unsigned wlen = calcWordLen(byteaddr, bytelen, foff, loff);
                                                                                                   for (int idx  = 0; idx < bytelen; idx++)
                                                                                                       ((uint8_t*)bytebuf)[idx + (byteaddr&0x3)] = ((uint8_t*)data)[idx];

                                                                                                   return VBurstWriteBE   (byteaddr & ~(0x3),
                                                                                                                           bytebuf,
                                                                                                                           wlen,
                                                                                                                           (0xf << foff) & 0xf,
                                                                                                                           0xf >> ((loff == 3) ? 0 : (3 - loff)),
                                                                                                                           node);
                                                                                                   };

    int burstReadBytes   (const unsigned byteaddr,         void    *data, const unsigned bytelen) {unsigned foff, loff, wlen = calcWordLen(byteaddr, bytelen, foff, loff);
                                                                                                   
                                                                                                   int status = VBurstRead ((byteaddr & ~(0x3)), bytebuf, wlen, node);
                                                                                                   
                                                                                                   for (int idx  = 0; idx < bytelen; idx++)
                                                                                                       ((uint8_t*)data)[idx] = ((uint8_t*)bytebuf)[idx + (byteaddr & 0x3)];
                                                                                                   return status;
                                                                                                  };

private:

    // VProc node number this object is accessing
    unsigned node;
    
    // Internal byte buffer
    uint32_t bytebuf [(MAXBURSTLEN+1) * 4];

    // Calculate the required word length, and first and last offsets, for given byte length with address offset
    unsigned calcWordLen(const unsigned byteaddr, const unsigned bytelen, unsigned &foff, unsigned &loff) {
                 loff    = (byteaddr + bytelen - 1) & 0x3;
                 foff    = byteaddr & 0x3;
        int      diffoff = loff - foff;
        return bytelen/4 + ((diffoff < 0) ? 1 : 0) + ((bytelen%4) ? 1 : 0);
    };
};

#endif