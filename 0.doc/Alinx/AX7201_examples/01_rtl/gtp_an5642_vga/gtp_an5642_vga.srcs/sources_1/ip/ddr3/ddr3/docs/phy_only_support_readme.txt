This file includes the information about the PHY layer support:

   - Folder "<component name>/user_design/rtl/phy" includes the PHY layer
     RTL modules.
   - The top-level PHY module to be instantiated is ddr_phy_top (ddr_phy_top.v)
   - PHY modules can be used in any environment by taking the RTL modules
     listed in "phy" folder and PHY layer needs to be connected to
     the memory controller.
   - Refer to User Guide (UG586) section "Physical Layer Interface (Non-Memory
     Controller Design)" for more details on PHY interface signaling,
     parameter(s) and timing information.

