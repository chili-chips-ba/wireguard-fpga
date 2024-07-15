--------------------------------------------------------------------------------

This software code and all associated documentation, comments or other 
information (collectively "Software") is provided "AS IS" without 
warranty of any kind. MICRON TECHNOLOGY, INC. ("MTI") EXPRESSLY 
DISCLAIMS ALL WARRANTIES EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED 
TO, NONINFRINGEMENT OF THIRD PARTY RIGHTS, AND ANY IMPLIED WARRANTIES 
OF MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. MTI DOES NOT 
WARRANT THAT THE SOFTWARE WILL MEET YOUR REQUIREMENTS, OR THAT THE 
OPERATION OF THE SOFTWARE WILL BE UNINTERRUPTED OR ERROR-FREE. 
FURTHERMORE, MTI DOES NOT MAKE ANY REPRESENTATIONS REGARDING THE USE OR 
THE RESULTS OF THE USE OF THE SOFTWARE IN TERMS OF ITS CORRECTNESS, 
ACCURACY, RELIABILITY, OR OTHERWISE. THE ENTIRE RISK ARISING OUT OF USE 
OR PERFORMANCE OF THE SOFTWARE REMAINS WITH YOU. IN NO EVENT SHALL MTI, 
ITS AFFILIATED COMPANIES OR THEIR SUPPLIERS BE LIABLE FOR ANY DIRECT, 
INDIRECT, CONSEQUENTIAL, INCIDENTAL, OR SPECIAL DAMAGES (INCLUDING, 
WITHOUT LIMITATION, DAMAGES FOR LOSS OF PROFITS, BUSINESS INTERRUPTION, 
OR LOSS OF INFORMATION) ARISING OUT OF YOUR USE OF OR INABILITY TO USE 
THE SOFTWARE, EVEN IF MTI HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH 
DAMAGES. Because some jurisdictions prohibit the exclusion or 
limitation of liability for consequential or incidental damages, the 
above limitation may not apply to you.

Copyright 2005 Micron Technology, Inc. All rights reserved.

--------------------------------------------------------------------------------

Example usage for SDR SDRAM Verilog model:

    ncverilog +define+den256Mb +define+sg75 +define+x8 sdr.v
       |                 |             |            |    |_____ SDR SDRAM Verilog model
       |                 |             |            |__________ Configuration (x4, 8, 16)
       |                 |             |_______________________ Speed rate(6a, 75, 7e)
       |                 |_____________________________________ Density (64, 128, 256, 512)
       |_______________________________________________________ Verilog simulator
       

Example usage for SDR SDRAM Module Verilog model:

    ncverilog +define+den256Mb +define+sg75 +define+x8 +define+dual_rank sdr.v sdr_module.v
       |                 |              |           |         |          |         |___ SDR SDRAM module wrapper
       |                 |              |           |         |          |_____________ SDR SDRAM Verilog model
       |                 |              |           |         |________________________ Module rank (single, dual)
       |                 |              |           |__________________________________ Component configuration (x4, 8, 16)
       |                 |              |______________________________________________ Component speed rate (6a, 75, 7e)
       |                 |_____________________________________________________________ Component density (64, 128, 256, 512)
       |_______________________________________________________________________________ Verilog simulator
       
