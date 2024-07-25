`timescale 1ns / 1ps
`define DLY #1
module gtp_exdes
(
    output tx0_clk,
    output gt0_txfsmresetdone,
    input[31:0] tx0_data,
    input[3:0] tx0_kchar,
    output rx0_clk,
    output[31:0] rx0_data,
    output[3:0] rx0_kchar,
    
    
    output tx1_clk,
    output gt1_txfsmresetdone,
    input[31:0] tx1_data,
    input[3:0] tx1_kchar,
    output rx1_clk,
    output[31:0] rx1_data,
    output[3:0] rx1_kchar,
    
    
    output tx2_clk,
    output gt2_txfsmresetdone,
    input[31:0] tx2_data,
    input[3:0] tx2_kchar,
    output rx2_clk,
    output[31:0] rx2_data,
    output[3:0] rx2_kchar,
    
    output tx3_clk,
    output gt3_txfsmresetdone,
    input[31:0] tx3_data,
    input[3:0] tx3_kchar,
    output rx3_clk,
    output[31:0] rx3_data,
    output[3:0] rx3_kchar,
    
    
    input wire  Q0_CLK0_GTREFCLK_PAD_N_IN,
    input wire  Q0_CLK0_GTREFCLK_PAD_P_IN,
    
    input drp_clk,
    //input wire  DRP_CLK_IN_P,
    //input wire  DRP_CLK_IN_N,
    input  wire [3:0]   RXN_IN,
    input  wire [3:0]   RXP_IN,
    output wire [3:0]   TXN_OUT,
    output wire [3:0]   TXP_OUT
);
    wire soft_reset_i;
    wire soft_reset_vio_i;

//************************** Register Declarations ****************************
wire            gt_txfsmresetdone_i;
wire            gt_rxfsmresetdone_i;
(* ASYNC_REG = "TRUE" *)reg             gt_txfsmresetdone_r;
(* ASYNC_REG = "TRUE" *)reg             gt_txfsmresetdone_r2;
wire            gt0_txfsmresetdone_i;
wire            gt0_rxfsmresetdone_i;
(* ASYNC_REG = "TRUE" *)reg             gt0_txfsmresetdone_r;
(* ASYNC_REG = "TRUE" *)reg             gt0_txfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt0_rxfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt0_rxfsmresetdone_r2;
(* ASYNC_REG = "TRUE" *)reg             gt0_rxresetdone_r;
(* ASYNC_REG = "TRUE" *)reg             gt0_rxresetdone_r2;
(* ASYNC_REG = "TRUE" *)reg             gt0_rxresetdone_r3;

wire            gt1_txfsmresetdone_i;
wire            gt1_rxfsmresetdone_i;
(* ASYNC_REG = "TRUE" *)reg             gt1_txfsmresetdone_r;
(* ASYNC_REG = "TRUE" *)reg             gt1_txfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt1_rxfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt1_rxfsmresetdone_r2;
(* ASYNC_REG = "TRUE" *)reg             gt1_rxresetdone_r;
(* ASYNC_REG = "TRUE" *)reg             gt1_rxresetdone_r2;
(* ASYNC_REG = "TRUE" *)reg             gt1_rxresetdone_r3;

wire            gt2_txfsmresetdone_i;
wire            gt2_rxfsmresetdone_i;
(* ASYNC_REG = "TRUE" *)reg             gt2_txfsmresetdone_r;
(* ASYNC_REG = "TRUE" *)reg             gt2_txfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt2_rxfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt2_rxfsmresetdone_r2;
(* ASYNC_REG = "TRUE" *)reg             gt2_rxresetdone_r;
(* ASYNC_REG = "TRUE" *)reg             gt2_rxresetdone_r2;
(* ASYNC_REG = "TRUE" *)reg             gt2_rxresetdone_r3;

wire            gt3_txfsmresetdone_i;
wire            gt3_rxfsmresetdone_i;
(* ASYNC_REG = "TRUE" *)reg             gt3_txfsmresetdone_r;
(* ASYNC_REG = "TRUE" *)reg             gt3_txfsmresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt3_rxfsmresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt3_rxfsmresetdone_r2;
(* ASYNC_REG = "TRUE" *)reg             gt3_rxresetdone_r;
(* ASYNC_REG = "TRUE" *)reg             gt3_rxresetdone_r2;
(* ASYNC_REG = "TRUE" *)reg             gt3_rxresetdone_r3;


//**************************** Wire Declarations ******************************//
    //------------------------ GT Wrapper Wires ------------------------------
    //________________________________________________________________________
    //________________________________________________________________________
    //GT0  (X0Y0)
    //-------------------------- Channel - DRP Ports  --------------------------
    wire    [8:0]   gt0_drpaddr_i;
    wire    [15:0]  gt0_drpdi_i;
    wire    [15:0]  gt0_drpdo_i;
    wire            gt0_drpen_i;
    wire            gt0_drprdy_i;
    wire            gt0_drpwe_i;
    //----------------------------- Loopback Ports -----------------------------
    wire    [2:0]   gt0_loopback_i;
    //---------------------------- Power-Down Ports ----------------------------
    wire    [1:0]   gt0_rxpd_i;
    wire    [1:0]   gt0_txpd_i;
    //------------------- RX Initialization and Reset Ports --------------------
    wire            gt0_eyescanreset_i;
    wire            gt0_rxuserrdy_i;
    //------------------------ RX Margin Analysis Ports ------------------------
    wire            gt0_eyescandataerror_i;
    wire            gt0_eyescantrigger_i;
    //----------------------- Receive Ports - CDR Ports ------------------------
    wire            gt0_rxcdrhold_i;
    wire            gt0_rxcdrovrden_i;
    //----------------- Receive Ports - Clock Correction Ports -----------------
    wire    [1:0]   gt0_rxclkcorcnt_i;
    //---------------- Receive Ports - FPGA RX Interface Ports -----------------
    wire    [31:0]  gt0_rxdata_i;
    //----------------- Receive Ports - Pattern Checker Ports ------------------
    wire            gt0_rxprbserr_i;
    wire    [2:0]   gt0_rxprbssel_i;
    //----------------- Receive Ports - Pattern Checker ports ------------------
    wire            gt0_rxprbscntreset_i;
    //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
    wire    [3:0]   gt0_rxchariscomma_i;
    wire    [3:0]   gt0_rxcharisk_i;
    wire    [3:0]   gt0_rxdisperr_i;
    wire    [3:0]   gt0_rxnotintable_i;
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    wire            gt0_gtprxn_i;
    wire            gt0_gtprxp_i;
    //----------------- Receive Ports - RX Buffer Bypass Ports -----------------
    wire            gt0_rxbufreset_i;
    wire    [2:0]   gt0_rxbufstatus_i;
    //------------ Receive Ports - RX Byte and Word Alignment Ports ------------
    wire            gt0_rxbyteisaligned_i;
    wire            gt0_rxbyterealign_i;
    wire            gt0_rxcommadet_i;
    wire            gt0_rxmcommaalignen_i;
    wire            gt0_rxpcommaalignen_i;
    //---------- Receive Ports - RX Decision Feedback Equalizer(DFE) -----------
    wire    [14:0]  gt0_dmonitorout_i;
    //------------------ Receive Ports - RX Equailizer Ports -------------------
    wire            gt0_rxlpmhfhold_i;
    wire            gt0_rxlpmhfovrden_i;
    wire            gt0_rxlpmlfhold_i;
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    wire            gt0_rxoutclk_i;
    wire            gt0_rxoutclkfabric_i;
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
    wire            gt0_gtrxreset_i;
    wire            gt0_rxlpmreset_i;
    wire            gt0_rxpcsreset_i;
    wire            gt0_rxpmareset_i;
    //--------------- Receive Ports - RX Polarity Control Ports ----------------
    wire            gt0_rxpolarity_i;
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
    wire            gt0_rxresetdone_i;
    //---------------------- TX Configurable Driver Ports ----------------------
    wire    [4:0]   gt0_txpostcursor_i;
    wire    [4:0]   gt0_txprecursor_i;
    //------------------- TX Initialization and Reset Ports --------------------
    wire            gt0_gttxreset_i;
    wire            gt0_txuserrdy_i;
    //---------------- Transmit Ports - FPGA TX Interface Ports ----------------
    wire    [31:0]  gt0_txdata_i;
    //---------------- Transmit Ports - Pattern Generator Ports ----------------
    wire            gt0_txprbsforceerr_i;
    //---------------- Transmit Ports - TX 8B/10B Encoder Ports ----------------
    wire    [3:0]   gt0_txchardispmode_i;
    wire    [3:0]   gt0_txchardispval_i;
    wire    [3:0]   gt0_txcharisk_i;
    //-------------------- Transmit Ports - TX Buffer Ports --------------------
    wire    [1:0]   gt0_txbufstatus_i;
    //------------- Transmit Ports - TX Configurable Driver Ports --------------
    wire            gt0_gtptxn_i;
    wire            gt0_gtptxp_i;
    wire    [3:0]   gt0_txdiffctrl_i;
    wire    [6:0]   gt0_txmaincursor_i;
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    wire            gt0_txoutclk_i;
    wire            gt0_txoutclkfabric_i;
    wire            gt0_txoutclkpcs_i;
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
    wire            gt0_txpcsreset_i;
    wire            gt0_txpmareset_i;
    wire            gt0_txresetdone_i;
    //--------------- Transmit Ports - TX Polarity Control Ports ---------------
    wire            gt0_txpolarity_i;
    //---------------- Transmit Ports - pattern Generator Ports ----------------
    wire    [2:0]   gt0_txprbssel_i;

    //________________________________________________________________________
    //________________________________________________________________________
    //GT1  (X0Y1)
    //-------------------------- Channel - DRP Ports  --------------------------
    wire    [8:0]   gt1_drpaddr_i;
    wire    [15:0]  gt1_drpdi_i;
    wire    [15:0]  gt1_drpdo_i;
    wire            gt1_drpen_i;
    wire            gt1_drprdy_i;
    wire            gt1_drpwe_i;
    //----------------------------- Loopback Ports -----------------------------
    wire    [2:0]   gt1_loopback_i;
    //---------------------------- Power-Down Ports ----------------------------
    wire    [1:0]   gt1_rxpd_i;
    wire    [1:0]   gt1_txpd_i;
    //------------------- RX Initialization and Reset Ports --------------------
    wire            gt1_eyescanreset_i;
    wire            gt1_rxuserrdy_i;
    //------------------------ RX Margin Analysis Ports ------------------------
    wire            gt1_eyescandataerror_i;
    wire            gt1_eyescantrigger_i;
    //----------------------- Receive Ports - CDR Ports ------------------------
    wire            gt1_rxcdrhold_i;
    wire            gt1_rxcdrovrden_i;
    //----------------- Receive Ports - Clock Correction Ports -----------------
    wire    [1:0]   gt1_rxclkcorcnt_i;
    //---------------- Receive Ports - FPGA RX Interface Ports -----------------
    wire    [31:0]  gt1_rxdata_i;
    //----------------- Receive Ports - Pattern Checker Ports ------------------
    wire            gt1_rxprbserr_i;
    wire    [2:0]   gt1_rxprbssel_i;
    //----------------- Receive Ports - Pattern Checker ports ------------------
    wire            gt1_rxprbscntreset_i;
    //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
    wire    [3:0]   gt1_rxchariscomma_i;
    wire    [3:0]   gt1_rxcharisk_i;
    wire    [3:0]   gt1_rxdisperr_i;
    wire    [3:0]   gt1_rxnotintable_i;
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    wire            gt1_gtprxn_i;
    wire            gt1_gtprxp_i;
    //----------------- Receive Ports - RX Buffer Bypass Ports -----------------
    wire            gt1_rxbufreset_i;
    wire    [2:0]   gt1_rxbufstatus_i;
    //------------ Receive Ports - RX Byte and Word Alignment Ports ------------
    wire            gt1_rxbyteisaligned_i;
    wire            gt1_rxbyterealign_i;
    wire            gt1_rxcommadet_i;
    wire            gt1_rxmcommaalignen_i;
    wire            gt1_rxpcommaalignen_i;
    //---------- Receive Ports - RX Decision Feedback Equalizer(DFE) -----------
    wire    [14:0]  gt1_dmonitorout_i;
    //------------------ Receive Ports - RX Equailizer Ports -------------------
    wire            gt1_rxlpmhfhold_i;
    wire            gt1_rxlpmhfovrden_i;
    wire            gt1_rxlpmlfhold_i;
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    wire            gt1_rxoutclk_i;
    wire            gt1_rxoutclkfabric_i;
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
    wire            gt1_gtrxreset_i;
    wire            gt1_rxlpmreset_i;
    wire            gt1_rxpcsreset_i;
    wire            gt1_rxpmareset_i;
    //--------------- Receive Ports - RX Polarity Control Ports ----------------
    wire            gt1_rxpolarity_i;
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
    wire            gt1_rxresetdone_i;
    //---------------------- TX Configurable Driver Ports ----------------------
    wire    [4:0]   gt1_txpostcursor_i;
    wire    [4:0]   gt1_txprecursor_i;
    //------------------- TX Initialization and Reset Ports --------------------
    wire            gt1_gttxreset_i;
    wire            gt1_txuserrdy_i;
    //---------------- Transmit Ports - FPGA TX Interface Ports ----------------
    wire    [31:0]  gt1_txdata_i;
    //---------------- Transmit Ports - Pattern Generator Ports ----------------
    wire            gt1_txprbsforceerr_i;
    //---------------- Transmit Ports - TX 8B/10B Encoder Ports ----------------
    wire    [3:0]   gt1_txchardispmode_i;
    wire    [3:0]   gt1_txchardispval_i;
    wire    [3:0]   gt1_txcharisk_i;
    //-------------------- Transmit Ports - TX Buffer Ports --------------------
    wire    [1:0]   gt1_txbufstatus_i;
    //------------- Transmit Ports - TX Configurable Driver Ports --------------
    wire            gt1_gtptxn_i;
    wire            gt1_gtptxp_i;
    wire    [3:0]   gt1_txdiffctrl_i;
    wire    [6:0]   gt1_txmaincursor_i;
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    wire            gt1_txoutclk_i;
    wire            gt1_txoutclkfabric_i;
    wire            gt1_txoutclkpcs_i;
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
    wire            gt1_txpcsreset_i;
    wire            gt1_txpmareset_i;
    wire            gt1_txresetdone_i;
    //--------------- Transmit Ports - TX Polarity Control Ports ---------------
    wire            gt1_txpolarity_i;
    //---------------- Transmit Ports - pattern Generator Ports ----------------
    wire    [2:0]   gt1_txprbssel_i;

    //________________________________________________________________________
    //________________________________________________________________________
    //GT2  (X0Y2)
    //-------------------------- Channel - DRP Ports  --------------------------
    wire    [8:0]   gt2_drpaddr_i;
    wire    [15:0]  gt2_drpdi_i;
    wire    [15:0]  gt2_drpdo_i;
    wire            gt2_drpen_i;
    wire            gt2_drprdy_i;
    wire            gt2_drpwe_i;
    //----------------------------- Loopback Ports -----------------------------
    wire    [2:0]   gt2_loopback_i;
    //---------------------------- Power-Down Ports ----------------------------
    wire    [1:0]   gt2_rxpd_i;
    wire    [1:0]   gt2_txpd_i;
    //------------------- RX Initialization and Reset Ports --------------------
    wire            gt2_eyescanreset_i;
    wire            gt2_rxuserrdy_i;
    //------------------------ RX Margin Analysis Ports ------------------------
    wire            gt2_eyescandataerror_i;
    wire            gt2_eyescantrigger_i;
    //----------------------- Receive Ports - CDR Ports ------------------------
    wire            gt2_rxcdrhold_i;
    wire            gt2_rxcdrovrden_i;
    //----------------- Receive Ports - Clock Correction Ports -----------------
    wire    [1:0]   gt2_rxclkcorcnt_i;
    //---------------- Receive Ports - FPGA RX Interface Ports -----------------
    wire    [31:0]  gt2_rxdata_i;
    //----------------- Receive Ports - Pattern Checker Ports ------------------
    wire            gt2_rxprbserr_i;
    wire    [2:0]   gt2_rxprbssel_i;
    //----------------- Receive Ports - Pattern Checker ports ------------------
    wire            gt2_rxprbscntreset_i;
    //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
    wire    [3:0]   gt2_rxchariscomma_i;
    wire    [3:0]   gt2_rxcharisk_i;
    wire    [3:0]   gt2_rxdisperr_i;
    wire    [3:0]   gt2_rxnotintable_i;
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    wire            gt2_gtprxn_i;
    wire            gt2_gtprxp_i;
    //----------------- Receive Ports - RX Buffer Bypass Ports -----------------
    wire            gt2_rxbufreset_i;
    wire    [2:0]   gt2_rxbufstatus_i;
    //------------ Receive Ports - RX Byte and Word Alignment Ports ------------
    wire            gt2_rxbyteisaligned_i;
    wire            gt2_rxbyterealign_i;
    wire            gt2_rxcommadet_i;
    wire            gt2_rxmcommaalignen_i;
    wire            gt2_rxpcommaalignen_i;
    //---------- Receive Ports - RX Decision Feedback Equalizer(DFE) -----------
    wire    [14:0]  gt2_dmonitorout_i;
    //------------------ Receive Ports - RX Equailizer Ports -------------------
    wire            gt2_rxlpmhfhold_i;
    wire            gt2_rxlpmhfovrden_i;
    wire            gt2_rxlpmlfhold_i;
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    wire            gt2_rxoutclk_i;
    wire            gt2_rxoutclkfabric_i;
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
    wire            gt2_gtrxreset_i;
    wire            gt2_rxlpmreset_i;
    wire            gt2_rxpcsreset_i;
    wire            gt2_rxpmareset_i;
    //--------------- Receive Ports - RX Polarity Control Ports ----------------
    wire            gt2_rxpolarity_i;
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
    wire            gt2_rxresetdone_i;
    //---------------------- TX Configurable Driver Ports ----------------------
    wire    [4:0]   gt2_txpostcursor_i;
    wire    [4:0]   gt2_txprecursor_i;
    //------------------- TX Initialization and Reset Ports --------------------
    wire            gt2_gttxreset_i;
    wire            gt2_txuserrdy_i;
    //---------------- Transmit Ports - FPGA TX Interface Ports ----------------
    wire    [31:0]  gt2_txdata_i;
    //---------------- Transmit Ports - Pattern Generator Ports ----------------
    wire            gt2_txprbsforceerr_i;
    //---------------- Transmit Ports - TX 8B/10B Encoder Ports ----------------
    wire    [3:0]   gt2_txchardispmode_i;
    wire    [3:0]   gt2_txchardispval_i;
    wire    [3:0]   gt2_txcharisk_i;
    //-------------------- Transmit Ports - TX Buffer Ports --------------------
    wire    [1:0]   gt2_txbufstatus_i;
    //------------- Transmit Ports - TX Configurable Driver Ports --------------
    wire            gt2_gtptxn_i;
    wire            gt2_gtptxp_i;
    wire    [3:0]   gt2_txdiffctrl_i;
    wire    [6:0]   gt2_txmaincursor_i;
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    wire            gt2_txoutclk_i;
    wire            gt2_txoutclkfabric_i;
    wire            gt2_txoutclkpcs_i;
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
    wire            gt2_txpcsreset_i;
    wire            gt2_txpmareset_i;
    wire            gt2_txresetdone_i;
    //--------------- Transmit Ports - TX Polarity Control Ports ---------------
    wire            gt2_txpolarity_i;
    //---------------- Transmit Ports - pattern Generator Ports ----------------
    wire    [2:0]   gt2_txprbssel_i;

    //________________________________________________________________________
    //________________________________________________________________________
    //GT3  (X0Y3)
    //-------------------------- Channel - DRP Ports  --------------------------
    wire    [8:0]   gt3_drpaddr_i;
    wire    [15:0]  gt3_drpdi_i;
    wire    [15:0]  gt3_drpdo_i;
    wire            gt3_drpen_i;
    wire            gt3_drprdy_i;
    wire            gt3_drpwe_i;
    //----------------------------- Loopback Ports -----------------------------
    wire    [2:0]   gt3_loopback_i;
    //---------------------------- Power-Down Ports ----------------------------
    wire    [1:0]   gt3_rxpd_i;
    wire    [1:0]   gt3_txpd_i;
    //------------------- RX Initialization and Reset Ports --------------------
    wire            gt3_eyescanreset_i;
    wire            gt3_rxuserrdy_i;
    //------------------------ RX Margin Analysis Ports ------------------------
    wire            gt3_eyescandataerror_i;
    wire            gt3_eyescantrigger_i;
    //----------------------- Receive Ports - CDR Ports ------------------------
    wire            gt3_rxcdrhold_i;
    wire            gt3_rxcdrovrden_i;
    //----------------- Receive Ports - Clock Correction Ports -----------------
    wire    [1:0]   gt3_rxclkcorcnt_i;
    //---------------- Receive Ports - FPGA RX Interface Ports -----------------
    wire    [31:0]  gt3_rxdata_i;
    //----------------- Receive Ports - Pattern Checker Ports ------------------
    wire            gt3_rxprbserr_i;
    wire    [2:0]   gt3_rxprbssel_i;
    //----------------- Receive Ports - Pattern Checker ports ------------------
    wire            gt3_rxprbscntreset_i;
    //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
    wire    [3:0]   gt3_rxchariscomma_i;
    wire    [3:0]   gt3_rxcharisk_i;
    wire    [3:0]   gt3_rxdisperr_i;
    wire    [3:0]   gt3_rxnotintable_i;
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    wire            gt3_gtprxn_i;
    wire            gt3_gtprxp_i;
    //----------------- Receive Ports - RX Buffer Bypass Ports -----------------
    wire            gt3_rxbufreset_i;
    wire    [2:0]   gt3_rxbufstatus_i;
    //------------ Receive Ports - RX Byte and Word Alignment Ports ------------
    wire            gt3_rxbyteisaligned_i;
    wire            gt3_rxbyterealign_i;
    wire            gt3_rxcommadet_i;
    wire            gt3_rxmcommaalignen_i;
    wire            gt3_rxpcommaalignen_i;
    //---------- Receive Ports - RX Decision Feedback Equalizer(DFE) -----------
    wire    [14:0]  gt3_dmonitorout_i;
    //------------------ Receive Ports - RX Equailizer Ports -------------------
    wire            gt3_rxlpmhfhold_i;
    wire            gt3_rxlpmhfovrden_i;
    wire            gt3_rxlpmlfhold_i;
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    wire            gt3_rxoutclk_i;
    wire            gt3_rxoutclkfabric_i;
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
    wire            gt3_gtrxreset_i;
    wire            gt3_rxlpmreset_i;
    wire            gt3_rxpcsreset_i;
    wire            gt3_rxpmareset_i;
    //--------------- Receive Ports - RX Polarity Control Ports ----------------
    wire            gt3_rxpolarity_i;
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
    wire            gt3_rxresetdone_i;
    //---------------------- TX Configurable Driver Ports ----------------------
    wire    [4:0]   gt3_txpostcursor_i;
    wire    [4:0]   gt3_txprecursor_i;
    //------------------- TX Initialization and Reset Ports --------------------
    wire            gt3_gttxreset_i;
    wire            gt3_txuserrdy_i;
    //---------------- Transmit Ports - FPGA TX Interface Ports ----------------
    wire    [31:0]  gt3_txdata_i;
    //---------------- Transmit Ports - Pattern Generator Ports ----------------
    wire            gt3_txprbsforceerr_i;
    //---------------- Transmit Ports - TX 8B/10B Encoder Ports ----------------
    wire    [3:0]   gt3_txchardispmode_i;
    wire    [3:0]   gt3_txchardispval_i;
    wire    [3:0]   gt3_txcharisk_i;
    //-------------------- Transmit Ports - TX Buffer Ports --------------------
    wire    [1:0]   gt3_txbufstatus_i;
    //------------- Transmit Ports - TX Configurable Driver Ports --------------
    wire            gt3_gtptxn_i;
    wire            gt3_gtptxp_i;
    wire    [3:0]   gt3_txdiffctrl_i;
    wire    [6:0]   gt3_txmaincursor_i;
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    wire            gt3_txoutclk_i;
    wire            gt3_txoutclkfabric_i;
    wire            gt3_txoutclkpcs_i;
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
    wire            gt3_txpcsreset_i;
    wire            gt3_txpmareset_i;
    wire            gt3_txresetdone_i;
    //--------------- Transmit Ports - TX Polarity Control Ports ---------------
    wire            gt3_txpolarity_i;
    //---------------- Transmit Ports - pattern Generator Ports ----------------
    wire    [2:0]   gt3_txprbssel_i;

    //____________________________COMMON PORTS________________________________
    //------------------------ Common Block - PLL Ports ------------------------
    wire            gt0_pll0lock_i;
    wire            gt0_pll0refclklost_i;
    wire            gt0_pll0reset_i;


    //----------------------------- Global Signals -----------------------------

wire            drpclk_in_i;
wire            DRPCLK_IN;
wire            gt0_tx_system_reset_c;
wire            gt0_rx_system_reset_c;
wire            gt1_tx_system_reset_c;
wire            gt1_rx_system_reset_c;
wire            gt2_tx_system_reset_c;
wire            gt2_rx_system_reset_c;
wire            gt3_tx_system_reset_c;
wire            gt3_rx_system_reset_c;
wire            tied_to_ground_i;
wire    [63:0]  tied_to_ground_vec_i;
wire            tied_to_vcc_i;
wire    [7:0]   tied_to_vcc_vec_i;
wire            GTTXRESET_IN;
wire            GTRXRESET_IN;
wire            PLL0RESET_IN;
wire            PLL1RESET_IN;

     //--------------------------- User Clocks ---------------------------------
 wire            gt0_txusrclk_i; 
 wire            gt0_txusrclk2_i; 
 wire            gt0_rxusrclk_i; 
 wire            gt0_rxusrclk2_i; 
 wire            gt1_txusrclk_i; 
 wire            gt1_txusrclk2_i; 
 wire            gt1_rxusrclk_i; 
 wire            gt1_rxusrclk2_i; 
 wire            gt2_txusrclk_i; 
 wire            gt2_txusrclk2_i; 
 wire            gt2_rxusrclk_i; 
 wire            gt2_rxusrclk2_i; 
 wire            gt3_txusrclk_i; 
 wire            gt3_txusrclk2_i; 
 wire            gt3_rxusrclk_i; 
 wire            gt3_rxusrclk2_i; 
wire            gt0_txmmcm_lock_i;
wire            gt0_txmmcm_reset_i;
wire            gt0_rxmmcm_lock_i; 
wire            gt0_rxmmcm_reset_i;
wire            gt1_txmmcm_lock_i;
wire            gt1_txmmcm_reset_i;
wire            gt1_rxmmcm_lock_i; 
wire            gt1_rxmmcm_reset_i;
wire            gt2_txmmcm_lock_i;
wire            gt2_txmmcm_reset_i;
wire            gt2_rxmmcm_lock_i; 
wire            gt2_rxmmcm_reset_i;
wire            gt3_txmmcm_lock_i;
wire            gt3_txmmcm_reset_i;
wire            gt3_rxmmcm_lock_i; 
wire            gt3_rxmmcm_reset_i;
 
 
    //--------------------------- Reference Clocks ----------------------------
wire            q0_clk0_refclk_i;


    //--------------------- Frame check/gen Module Signals --------------------
wire            gt0_matchn_i;
    wire    [3:0]   gt0_txcharisk_float_i;
wire    [15:0]  gt0_txdata_float16_i;
    wire    [31:0]  gt0_txdata_float_i;
wire            gt0_block_sync_i;
wire            gt0_track_data_i;
wire    [7:0]   gt0_error_count_i;
wire            gt0_frame_check_reset_i;
wire            gt0_inc_in_i;
wire            gt0_inc_out_i;
wire    [31:0]  gt0_unscrambled_data_i;

wire            gt1_matchn_i;
    wire    [3:0]   gt1_txcharisk_float_i;
wire    [15:0]  gt1_txdata_float16_i;
    wire    [31:0]  gt1_txdata_float_i;
wire            gt1_block_sync_i;
wire            gt1_track_data_i;
wire    [7:0]   gt1_error_count_i;
wire            gt1_frame_check_reset_i;
wire            gt1_inc_in_i;
wire            gt1_inc_out_i;
wire    [31:0]  gt1_unscrambled_data_i;

wire            gt2_matchn_i;
    wire    [3:0]   gt2_txcharisk_float_i;
wire    [15:0]  gt2_txdata_float16_i;
    wire    [31:0]  gt2_txdata_float_i;
wire            gt2_block_sync_i;
wire            gt2_track_data_i;
wire    [7:0]   gt2_error_count_i;
wire            gt2_frame_check_reset_i;
wire            gt2_inc_in_i;
wire            gt2_inc_out_i;
wire    [31:0]  gt2_unscrambled_data_i;

wire            gt3_matchn_i;
    wire    [3:0]   gt3_txcharisk_float_i;
wire    [15:0]  gt3_txdata_float16_i;
    wire    [31:0]  gt3_txdata_float_i;
wire            gt3_block_sync_i;
wire            gt3_track_data_i;
wire    [7:0]   gt3_error_count_i;
wire            gt3_frame_check_reset_i;
wire            gt3_inc_in_i;
wire            gt3_inc_out_i;
wire    [31:0]  gt3_unscrambled_data_i;

wire            reset_on_data_error_i;
wire            track_data_out_i;

//**************************** Main Body of Code *******************************

    //  Static signal Assigments    
    assign tied_to_ground_i      = 1'b0;
    assign tied_to_ground_vec_i  = 64'h0000000000000000;
    assign tied_to_vcc_i         = 1'b1;
    assign tied_to_vcc_vec_i     = 8'hff;

    assign zero_vector_rx_80 = 0;
    assign zero_vector_rx_8 = 0;


    //***********************************************************************//
    //                                                                       //
    //--------------------------- The GT Wrapper ----------------------------//
    //                                                                       //
    //***********************************************************************//
    
    // Use the instantiation template in the example directory to add the GT wrapper to your design.
    // In this example, the wrapper is wired up for basic operation with a frame generator and frame 
    // checker. The GTs will reset, then attempt to align and transmit data. If channel bonding is 
    // enabled, bonding should occur after alignment.

assign tx0_clk = gt0_txusrclk2_i;
assign rx0_clk = gt0_rxusrclk2_i;
assign  rx0_data = gt0_rxdata_i;
assign  rx0_kchar = gt0_rxcharisk_i;
assign gt0_txfsmresetdone = gt0_txfsmresetdone_i;


assign tx1_clk = gt1_txusrclk2_i;
assign rx1_clk = gt1_rxusrclk2_i;
assign  rx1_data = gt1_rxdata_i;
assign  rx1_kchar = gt1_rxcharisk_i;
assign gt1_txfsmresetdone = gt1_txfsmresetdone_i;

assign tx2_clk = gt2_txusrclk2_i;
assign rx2_clk = gt2_rxusrclk2_i;
assign  rx2_data = gt2_rxdata_i;
assign  rx2_kchar = gt2_rxcharisk_i;
assign gt2_txfsmresetdone = gt2_txfsmresetdone_i;

assign tx3_clk = gt3_txusrclk2_i;
assign rx3_clk = gt3_rxusrclk2_i;
assign  rx3_data = gt3_rxdata_i;
assign  rx3_kchar = gt3_rxcharisk_i;
assign gt3_txfsmresetdone = gt3_txfsmresetdone_i;


    gtp_support #
    (
        .EXAMPLE_SIM_GTRESET_SPEEDUP    ("FALSE"),
        .STABLE_CLOCK_PERIOD            (10)
    )
    gtp_support_i
    (
        .soft_reset_tx_in               (soft_reset_i),
        .soft_reset_rx_in               (soft_reset_i),
        .dont_reset_on_data_error_in    (tied_to_ground_i),
    .q0_clk0_gtrefclk_pad_n_in(Q0_CLK0_GTREFCLK_PAD_N_IN),
    .q0_clk0_gtrefclk_pad_p_in(Q0_CLK0_GTREFCLK_PAD_P_IN),
        .gt0_tx_mmcm_lock_out           (gt0_txmmcm_lock_i),
        .gt0_rx_mmcm_lock_out           (gt0_rxmmcm_lock_i),
        .gt0_tx_fsm_reset_done_out      (gt0_txfsmresetdone_i),
        .gt0_rx_fsm_reset_done_out      (gt0_rxfsmresetdone_i),
        .gt0_data_valid_in              (1'b1),
        .gt1_tx_mmcm_lock_out           (gt1_txmmcm_lock_i),
        .gt1_rx_mmcm_lock_out           (gt1_rxmmcm_lock_i),
        .gt1_tx_fsm_reset_done_out      (gt1_txfsmresetdone_i),
        .gt1_rx_fsm_reset_done_out      (gt1_rxfsmresetdone_i),
        .gt1_data_valid_in              (1'b1),
        .gt2_tx_mmcm_lock_out           (gt2_txmmcm_lock_i),
        .gt2_rx_mmcm_lock_out           (gt2_rxmmcm_lock_i),
        .gt2_tx_fsm_reset_done_out      (gt2_txfsmresetdone_i),
        .gt2_rx_fsm_reset_done_out      (gt2_rxfsmresetdone_i),
        .gt2_data_valid_in              (1'b1),
        .gt3_tx_mmcm_lock_out           (gt3_txmmcm_lock_i),
        .gt3_rx_mmcm_lock_out           (gt3_rxmmcm_lock_i),
        .gt3_tx_fsm_reset_done_out      (gt3_txfsmresetdone_i),
        .gt3_rx_fsm_reset_done_out      (gt3_rxfsmresetdone_i),
        .gt3_data_valid_in              (1'b1),
 
    .gt0_txusrclk_out(gt0_txusrclk_i),
    .gt0_txusrclk2_out(gt0_txusrclk2_i),
    .gt0_rxusrclk_out(gt0_rxusrclk_i),
    .gt0_rxusrclk2_out(gt0_rxusrclk2_i),
 
    .gt1_txusrclk_out(gt1_txusrclk_i),
    .gt1_txusrclk2_out(gt1_txusrclk2_i),
    .gt1_rxusrclk_out(gt1_rxusrclk_i),
    .gt1_rxusrclk2_out(gt1_rxusrclk2_i),
 
    .gt2_txusrclk_out(gt2_txusrclk_i),
    .gt2_txusrclk2_out(gt2_txusrclk2_i),
    .gt2_rxusrclk_out(gt2_rxusrclk_i),
    .gt2_rxusrclk2_out(gt2_rxusrclk2_i),
 
    .gt3_txusrclk_out(gt3_txusrclk_i),
    .gt3_txusrclk2_out(gt3_txusrclk2_i),
    .gt3_rxusrclk_out(gt3_rxusrclk_i),
    .gt3_rxusrclk2_out(gt3_rxusrclk2_i),


        //_____________________________________________________________________
        //_____________________________________________________________________
        //GT0  (X0Y0)

        //-------------------------- Channel - DRP Ports  --------------------------
        .gt0_drpaddr_in                 (gt0_drpaddr_i),
        .gt0_drpdi_in                   (gt0_drpdi_i),
        .gt0_drpdo_out                  (gt0_drpdo_i),
        .gt0_drpen_in                   (gt0_drpen_i),
        .gt0_drprdy_out                 (gt0_drprdy_i),
        .gt0_drpwe_in                   (gt0_drpwe_i),
        //----------------------------- Loopback Ports -----------------------------
        .gt0_loopback_in                (gt0_loopback_i),
        //---------------------------- Power-Down Ports ----------------------------
        .gt0_rxpd_in                    (gt0_rxpd_i),
        .gt0_txpd_in                    (gt0_txpd_i),
        //------------------- RX Initialization and Reset Ports --------------------
        .gt0_eyescanreset_in            (tied_to_ground_i),
        .gt0_rxuserrdy_in               (tied_to_ground_i),
        //------------------------ RX Margin Analysis Ports ------------------------
        .gt0_eyescandataerror_out       (gt0_eyescandataerror_i),
        .gt0_eyescantrigger_in          (tied_to_ground_i),
        //----------------------- Receive Ports - CDR Ports ------------------------
        .gt0_rxcdrhold_in               (gt0_rxcdrhold_i),
        .gt0_rxcdrovrden_in             (tied_to_ground_i),
        //----------------- Receive Ports - Clock Correction Ports -----------------
        .gt0_rxclkcorcnt_out            (gt0_rxclkcorcnt_i),
        //---------------- Receive Ports - FPGA RX Interface Ports -----------------
        .gt0_rxdata_out                 (gt0_rxdata_i),
        //----------------- Receive Ports - Pattern Checker Ports ------------------
        .gt0_rxprbserr_out              (gt0_rxprbserr_i),
        .gt0_rxprbssel_in               (gt0_rxprbssel_i),
        //----------------- Receive Ports - Pattern Checker ports ------------------
        .gt0_rxprbscntreset_in          (gt0_rxprbscntreset_i),
        //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
        .gt0_rxchariscomma_out          (gt0_rxchariscomma_i),
        .gt0_rxcharisk_out              (gt0_rxcharisk_i),
        .gt0_rxdisperr_out              (gt0_rxdisperr_i),
        .gt0_rxnotintable_out           (gt0_rxnotintable_i),
        //---------------------- Receive Ports - RX AFE Ports ----------------------
        .gt0_gtprxn_in                  (RXN_IN[0]),
        .gt0_gtprxp_in                  (RXP_IN[0]),
        //----------------- Receive Ports - RX Buffer Bypass Ports -----------------
        .gt0_rxbufreset_in              (gt0_rxbufreset_i),
        .gt0_rxbufstatus_out            (gt0_rxbufstatus_i),
        //------------ Receive Ports - RX Byte and Word Alignment Ports ------------
        .gt0_rxbyteisaligned_out        (gt0_rxbyteisaligned_i),
        .gt0_rxbyterealign_out          (gt0_rxbyterealign_i),
        .gt0_rxcommadet_out             (gt0_rxcommadet_i),
        .gt0_rxmcommaalignen_in         (1'b1),
        .gt0_rxpcommaalignen_in         (1'b1),
        //---------- Receive Ports - RX Decision Feedback Equalizer(DFE) -----------
        .gt0_dmonitorout_out            (gt0_dmonitorout_i),
        //------------------ Receive Ports - RX Equailizer Ports -------------------
        .gt0_rxlpmhfhold_in             (tied_to_ground_i),
        .gt0_rxlpmhfovrden_in           (gt0_rxlpmhfovrden_i),
        .gt0_rxlpmlfhold_in             (tied_to_ground_i),
        //------------- Receive Ports - RX Fabric Output Control Ports -------------
        .gt0_rxoutclkfabric_out         (gt0_rxoutclkfabric_i),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .gt0_gtrxreset_in               (tied_to_ground_i),
        .gt0_rxlpmreset_in              (gt0_rxlpmreset_i),
        .gt0_rxpcsreset_in              (tied_to_ground_i),
        .gt0_rxpmareset_in              (gt0_rxpmareset_i),
        //--------------- Receive Ports - RX Polarity Control Ports ----------------
        .gt0_rxpolarity_in              (gt0_rxpolarity_i),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .gt0_rxresetdone_out            (gt0_rxresetdone_i),
        //---------------------- TX Configurable Driver Ports ----------------------
        .gt0_txpostcursor_in            (gt0_txpostcursor_i),
        .gt0_txprecursor_in             (gt0_txprecursor_i),
        //------------------- TX Initialization and Reset Ports --------------------
        .gt0_gttxreset_in               (tied_to_ground_i),
        .gt0_txuserrdy_in               (tied_to_ground_i),
        //---------------- Transmit Ports - FPGA TX Interface Ports ----------------
        .gt0_txdata_in                  (tx0_data),
        //---------------- Transmit Ports - Pattern Generator Ports ----------------
        .gt0_txprbsforceerr_in          (gt0_txprbsforceerr_i),
        //---------------- Transmit Ports - TX 8B/10B Encoder Ports ----------------
        .gt0_txchardispmode_in          (gt0_txchardispmode_i),
        .gt0_txchardispval_in           (gt0_txchardispval_i),
        .gt0_txcharisk_in               (tx0_kchar),
        //-------------------- Transmit Ports - TX Buffer Ports --------------------
        .gt0_txbufstatus_out            (gt0_txbufstatus_i),
        //------------- Transmit Ports - TX Configurable Driver Ports --------------
        .gt0_gtptxn_out                 (TXN_OUT[0]),
        .gt0_gtptxp_out                 (TXP_OUT[0]),
        .gt0_txdiffctrl_in              (gt0_txdiffctrl_i),
        .gt0_txmaincursor_in            (gt0_txmaincursor_i),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .gt0_txoutclkfabric_out         (gt0_txoutclkfabric_i),
        .gt0_txoutclkpcs_out            (gt0_txoutclkpcs_i),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .gt0_txpcsreset_in              (tied_to_ground_i),
        .gt0_txresetdone_out            (gt0_txresetdone_i),
        //--------------- Transmit Ports - TX Polarity Control Ports ---------------
        .gt0_txpolarity_in              (gt0_txpolarity_i),
        //---------------- Transmit Ports - pattern Generator Ports ----------------
        .gt0_txprbssel_in               (gt0_txprbssel_i),


        //_____________________________________________________________________
        //_____________________________________________________________________
        //GT1  (X0Y1)

        //-------------------------- Channel - DRP Ports  --------------------------
        .gt1_drpaddr_in                 (gt1_drpaddr_i),
        .gt1_drpdi_in                   (gt1_drpdi_i),
        .gt1_drpdo_out                  (gt1_drpdo_i),
        .gt1_drpen_in                   (gt1_drpen_i),
        .gt1_drprdy_out                 (gt1_drprdy_i),
        .gt1_drpwe_in                   (gt1_drpwe_i),
        //----------------------------- Loopback Ports -----------------------------
        .gt1_loopback_in                (gt1_loopback_i),
        //---------------------------- Power-Down Ports ----------------------------
        .gt1_rxpd_in                    (gt1_rxpd_i),
        .gt1_txpd_in                    (gt1_txpd_i),
        //------------------- RX Initialization and Reset Ports --------------------
        .gt1_eyescanreset_in            (tied_to_ground_i),
        .gt1_rxuserrdy_in               (tied_to_ground_i),
        //------------------------ RX Margin Analysis Ports ------------------------
        .gt1_eyescandataerror_out       (gt1_eyescandataerror_i),
        .gt1_eyescantrigger_in          (tied_to_ground_i),
        //----------------------- Receive Ports - CDR Ports ------------------------
        .gt1_rxcdrhold_in               (gt1_rxcdrhold_i),
        .gt1_rxcdrovrden_in             (tied_to_ground_i),
        //----------------- Receive Ports - Clock Correction Ports -----------------
        .gt1_rxclkcorcnt_out            (gt1_rxclkcorcnt_i),
        //---------------- Receive Ports - FPGA RX Interface Ports -----------------
        .gt1_rxdata_out                 (gt1_rxdata_i),
        //----------------- Receive Ports - Pattern Checker Ports ------------------
        .gt1_rxprbserr_out              (gt1_rxprbserr_i),
        .gt1_rxprbssel_in               (gt1_rxprbssel_i),
        //----------------- Receive Ports - Pattern Checker ports ------------------
        .gt1_rxprbscntreset_in          (gt1_rxprbscntreset_i),
        //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
        .gt1_rxchariscomma_out          (gt1_rxchariscomma_i),
        .gt1_rxcharisk_out              (gt1_rxcharisk_i),
        .gt1_rxdisperr_out              (gt1_rxdisperr_i),
        .gt1_rxnotintable_out           (gt1_rxnotintable_i),
        //---------------------- Receive Ports - RX AFE Ports ----------------------
        .gt1_gtprxn_in                  (RXN_IN[1]),
        .gt1_gtprxp_in                  (RXP_IN[1]),
        //----------------- Receive Ports - RX Buffer Bypass Ports -----------------
        .gt1_rxbufreset_in              (gt1_rxbufreset_i),
        .gt1_rxbufstatus_out            (gt1_rxbufstatus_i),
        //------------ Receive Ports - RX Byte and Word Alignment Ports ------------
        .gt1_rxbyteisaligned_out        (gt1_rxbyteisaligned_i),
        .gt1_rxbyterealign_out          (gt1_rxbyterealign_i),
        .gt1_rxcommadet_out             (gt1_rxcommadet_i),
        .gt1_rxmcommaalignen_in         (1'b1),
        .gt1_rxpcommaalignen_in         (1'b1),
        //---------- Receive Ports - RX Decision Feedback Equalizer(DFE) -----------
        .gt1_dmonitorout_out            (gt1_dmonitorout_i),
        //------------------ Receive Ports - RX Equailizer Ports -------------------
        .gt1_rxlpmhfhold_in             (tied_to_ground_i),
        .gt1_rxlpmhfovrden_in           (gt1_rxlpmhfovrden_i),
        .gt1_rxlpmlfhold_in             (tied_to_ground_i),
        //------------- Receive Ports - RX Fabric Output Control Ports -------------
        .gt1_rxoutclkfabric_out         (gt1_rxoutclkfabric_i),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .gt1_gtrxreset_in               (tied_to_ground_i),
        .gt1_rxlpmreset_in              (gt1_rxlpmreset_i),
        .gt1_rxpcsreset_in              (tied_to_ground_i),
        .gt1_rxpmareset_in              (gt1_rxpmareset_i),
        //--------------- Receive Ports - RX Polarity Control Ports ----------------
        .gt1_rxpolarity_in              (gt1_rxpolarity_i),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .gt1_rxresetdone_out            (gt1_rxresetdone_i),
        //---------------------- TX Configurable Driver Ports ----------------------
        .gt1_txpostcursor_in            (gt1_txpostcursor_i),
        .gt1_txprecursor_in             (gt1_txprecursor_i),
        //------------------- TX Initialization and Reset Ports --------------------
        .gt1_gttxreset_in               (tied_to_ground_i),
        .gt1_txuserrdy_in               (tied_to_ground_i),
        //---------------- Transmit Ports - FPGA TX Interface Ports ----------------
        .gt1_txdata_in                  (tx1_data),
        //---------------- Transmit Ports - Pattern Generator Ports ----------------
        .gt1_txprbsforceerr_in          (gt1_txprbsforceerr_i),
        //---------------- Transmit Ports - TX 8B/10B Encoder Ports ----------------
        .gt1_txchardispmode_in          (gt1_txchardispmode_i),
        .gt1_txchardispval_in           (gt1_txchardispval_i),
        .gt1_txcharisk_in               (tx1_kchar),
        //-------------------- Transmit Ports - TX Buffer Ports --------------------
        .gt1_txbufstatus_out            (gt1_txbufstatus_i),
        //------------- Transmit Ports - TX Configurable Driver Ports --------------
        .gt1_gtptxn_out                 (TXN_OUT[1]),
        .gt1_gtptxp_out                 (TXP_OUT[1]),
        .gt1_txdiffctrl_in              (gt1_txdiffctrl_i),
        .gt1_txmaincursor_in            (gt1_txmaincursor_i),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .gt1_txoutclkfabric_out         (gt1_txoutclkfabric_i),
        .gt1_txoutclkpcs_out            (gt1_txoutclkpcs_i),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .gt1_txpcsreset_in              (tied_to_ground_i),
        .gt1_txresetdone_out            (gt1_txresetdone_i),
        //--------------- Transmit Ports - TX Polarity Control Ports ---------------
        .gt1_txpolarity_in              (gt1_txpolarity_i),
        //---------------- Transmit Ports - pattern Generator Ports ----------------
        .gt1_txprbssel_in               (gt1_txprbssel_i),


        //_____________________________________________________________________
        //_____________________________________________________________________
        //GT2  (X0Y2)

        //-------------------------- Channel - DRP Ports  --------------------------
        .gt2_drpaddr_in                 (gt2_drpaddr_i),
        .gt2_drpdi_in                   (gt2_drpdi_i),
        .gt2_drpdo_out                  (gt2_drpdo_i),
        .gt2_drpen_in                   (gt2_drpen_i),
        .gt2_drprdy_out                 (gt2_drprdy_i),
        .gt2_drpwe_in                   (gt2_drpwe_i),
        //----------------------------- Loopback Ports -----------------------------
        .gt2_loopback_in                (gt2_loopback_i),
        //---------------------------- Power-Down Ports ----------------------------
        .gt2_rxpd_in                    (gt2_rxpd_i),
        .gt2_txpd_in                    (gt2_txpd_i),
        //------------------- RX Initialization and Reset Ports --------------------
        .gt2_eyescanreset_in            (tied_to_ground_i),
        .gt2_rxuserrdy_in               (tied_to_ground_i),
        //------------------------ RX Margin Analysis Ports ------------------------
        .gt2_eyescandataerror_out       (gt2_eyescandataerror_i),
        .gt2_eyescantrigger_in          (tied_to_ground_i),
        //----------------------- Receive Ports - CDR Ports ------------------------
        .gt2_rxcdrhold_in               (gt2_rxcdrhold_i),
        .gt2_rxcdrovrden_in             (tied_to_ground_i),
        //----------------- Receive Ports - Clock Correction Ports -----------------
        .gt2_rxclkcorcnt_out            (gt2_rxclkcorcnt_i),
        //---------------- Receive Ports - FPGA RX Interface Ports -----------------
        .gt2_rxdata_out                 (gt2_rxdata_i),
        //----------------- Receive Ports - Pattern Checker Ports ------------------
        .gt2_rxprbserr_out              (gt2_rxprbserr_i),
        .gt2_rxprbssel_in               (gt2_rxprbssel_i),
        //----------------- Receive Ports - Pattern Checker ports ------------------
        .gt2_rxprbscntreset_in          (gt2_rxprbscntreset_i),
        //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
        .gt2_rxchariscomma_out          (gt2_rxchariscomma_i),
        .gt2_rxcharisk_out              (gt2_rxcharisk_i),
        .gt2_rxdisperr_out              (gt2_rxdisperr_i),
        .gt2_rxnotintable_out           (gt2_rxnotintable_i),
        //---------------------- Receive Ports - RX AFE Ports ----------------------
        .gt2_gtprxn_in                  (RXN_IN[2]),
        .gt2_gtprxp_in                  (RXP_IN[2]),
        //----------------- Receive Ports - RX Buffer Bypass Ports -----------------
        .gt2_rxbufreset_in              (gt2_rxbufreset_i),
        .gt2_rxbufstatus_out            (gt2_rxbufstatus_i),
        //------------ Receive Ports - RX Byte and Word Alignment Ports ------------
        .gt2_rxbyteisaligned_out        (gt2_rxbyteisaligned_i),
        .gt2_rxbyterealign_out          (gt2_rxbyterealign_i),
        .gt2_rxcommadet_out             (gt2_rxcommadet_i),
        .gt2_rxmcommaalignen_in         (1'b1),
        .gt2_rxpcommaalignen_in         (1'b1),
        //---------- Receive Ports - RX Decision Feedback Equalizer(DFE) -----------
        .gt2_dmonitorout_out            (gt2_dmonitorout_i),
        //------------------ Receive Ports - RX Equailizer Ports -------------------
        .gt2_rxlpmhfhold_in             (tied_to_ground_i),
        .gt2_rxlpmhfovrden_in           (gt2_rxlpmhfovrden_i),
        .gt2_rxlpmlfhold_in             (tied_to_ground_i),
        //------------- Receive Ports - RX Fabric Output Control Ports -------------
        .gt2_rxoutclkfabric_out         (gt2_rxoutclkfabric_i),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .gt2_gtrxreset_in               (tied_to_ground_i),
        .gt2_rxlpmreset_in              (gt2_rxlpmreset_i),
        .gt2_rxpcsreset_in              (tied_to_ground_i),
        .gt2_rxpmareset_in              (gt2_rxpmareset_i),
        //--------------- Receive Ports - RX Polarity Control Ports ----------------
        .gt2_rxpolarity_in              (gt2_rxpolarity_i),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .gt2_rxresetdone_out            (gt2_rxresetdone_i),
        //---------------------- TX Configurable Driver Ports ----------------------
        .gt2_txpostcursor_in            (gt2_txpostcursor_i),
        .gt2_txprecursor_in             (gt2_txprecursor_i),
        //------------------- TX Initialization and Reset Ports --------------------
        .gt2_gttxreset_in               (tied_to_ground_i),
        .gt2_txuserrdy_in               (tied_to_ground_i),
        //---------------- Transmit Ports - FPGA TX Interface Ports ----------------
        .gt2_txdata_in                  (tx2_data),
        //---------------- Transmit Ports - Pattern Generator Ports ----------------
        .gt2_txprbsforceerr_in          (gt2_txprbsforceerr_i),
        //---------------- Transmit Ports - TX 8B/10B Encoder Ports ----------------
        .gt2_txchardispmode_in          (gt2_txchardispmode_i),
        .gt2_txchardispval_in           (gt2_txchardispval_i),
        .gt2_txcharisk_in               (tx2_kchar),
        //-------------------- Transmit Ports - TX Buffer Ports --------------------
        .gt2_txbufstatus_out            (gt2_txbufstatus_i),
        //------------- Transmit Ports - TX Configurable Driver Ports --------------
        .gt2_gtptxn_out                 (TXN_OUT[2]),
        .gt2_gtptxp_out                 (TXP_OUT[2]),
        .gt2_txdiffctrl_in              (gt2_txdiffctrl_i),
        .gt2_txmaincursor_in            (gt2_txmaincursor_i),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .gt2_txoutclkfabric_out         (gt2_txoutclkfabric_i),
        .gt2_txoutclkpcs_out            (gt2_txoutclkpcs_i),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .gt2_txpcsreset_in              (tied_to_ground_i),
        .gt2_txresetdone_out            (gt2_txresetdone_i),
        //--------------- Transmit Ports - TX Polarity Control Ports ---------------
        .gt2_txpolarity_in              (gt2_txpolarity_i),
        //---------------- Transmit Ports - pattern Generator Ports ----------------
        .gt2_txprbssel_in               (gt2_txprbssel_i),


        //_____________________________________________________________________
        //_____________________________________________________________________
        //GT3  (X0Y3)

        //-------------------------- Channel - DRP Ports  --------------------------
        .gt3_drpaddr_in                 (gt3_drpaddr_i),
        .gt3_drpdi_in                   (gt3_drpdi_i),
        .gt3_drpdo_out                  (gt3_drpdo_i),
        .gt3_drpen_in                   (gt3_drpen_i),
        .gt3_drprdy_out                 (gt3_drprdy_i),
        .gt3_drpwe_in                   (gt3_drpwe_i),
        //----------------------------- Loopback Ports -----------------------------
        .gt3_loopback_in                (gt3_loopback_i),
        //---------------------------- Power-Down Ports ----------------------------
        .gt3_rxpd_in                    (gt3_rxpd_i),
        .gt3_txpd_in                    (gt3_txpd_i),
        //------------------- RX Initialization and Reset Ports --------------------
        .gt3_eyescanreset_in            (tied_to_ground_i),
        .gt3_rxuserrdy_in               (tied_to_ground_i),
        //------------------------ RX Margin Analysis Ports ------------------------
        .gt3_eyescandataerror_out       (gt3_eyescandataerror_i),
        .gt3_eyescantrigger_in          (tied_to_ground_i),
        //----------------------- Receive Ports - CDR Ports ------------------------
        .gt3_rxcdrhold_in               (gt3_rxcdrhold_i),
        .gt3_rxcdrovrden_in             (tied_to_ground_i),
        //----------------- Receive Ports - Clock Correction Ports -----------------
        .gt3_rxclkcorcnt_out            (gt3_rxclkcorcnt_i),
        //---------------- Receive Ports - FPGA RX Interface Ports -----------------
        .gt3_rxdata_out                 (gt3_rxdata_i),
        //----------------- Receive Ports - Pattern Checker Ports ------------------
        .gt3_rxprbserr_out              (gt3_rxprbserr_i),
        .gt3_rxprbssel_in               (gt3_rxprbssel_i),
        //----------------- Receive Ports - Pattern Checker ports ------------------
        .gt3_rxprbscntreset_in          (gt3_rxprbscntreset_i),
        //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
        .gt3_rxchariscomma_out          (gt3_rxchariscomma_i),
        .gt3_rxcharisk_out              (gt3_rxcharisk_i),
        .gt3_rxdisperr_out              (gt3_rxdisperr_i),
        .gt3_rxnotintable_out           (gt3_rxnotintable_i),
        //---------------------- Receive Ports - RX AFE Ports ----------------------
        .gt3_gtprxn_in                  (RXN_IN[3]),
        .gt3_gtprxp_in                  (RXP_IN[3]),
        //----------------- Receive Ports - RX Buffer Bypass Ports -----------------
        .gt3_rxbufreset_in              (gt3_rxbufreset_i),
        .gt3_rxbufstatus_out            (gt3_rxbufstatus_i),
        //------------ Receive Ports - RX Byte and Word Alignment Ports ------------
        .gt3_rxbyteisaligned_out        (gt3_rxbyteisaligned_i),
        .gt3_rxbyterealign_out          (gt3_rxbyterealign_i),
        .gt3_rxcommadet_out             (gt3_rxcommadet_i),
        .gt3_rxmcommaalignen_in         (1'b1),
        .gt3_rxpcommaalignen_in         (1'b1),
        //---------- Receive Ports - RX Decision Feedback Equalizer(DFE) -----------
        .gt3_dmonitorout_out            (gt3_dmonitorout_i),
        //------------------ Receive Ports - RX Equailizer Ports -------------------
        .gt3_rxlpmhfhold_in             (tied_to_ground_i),
        .gt3_rxlpmhfovrden_in           (gt3_rxlpmhfovrden_i),
        .gt3_rxlpmlfhold_in             (tied_to_ground_i),
        //------------- Receive Ports - RX Fabric Output Control Ports -------------
        .gt3_rxoutclkfabric_out         (gt3_rxoutclkfabric_i),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .gt3_gtrxreset_in               (tied_to_ground_i),
        .gt3_rxlpmreset_in              (gt3_rxlpmreset_i),
        .gt3_rxpcsreset_in              (tied_to_ground_i),
        .gt3_rxpmareset_in              (gt3_rxpmareset_i),
        //--------------- Receive Ports - RX Polarity Control Ports ----------------
        .gt3_rxpolarity_in              (gt3_rxpolarity_i),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .gt3_rxresetdone_out            (gt3_rxresetdone_i),
        //---------------------- TX Configurable Driver Ports ----------------------
        .gt3_txpostcursor_in            (gt3_txpostcursor_i),
        .gt3_txprecursor_in             (gt3_txprecursor_i),
        //------------------- TX Initialization and Reset Ports --------------------
        .gt3_gttxreset_in               (tied_to_ground_i),
        .gt3_txuserrdy_in               (tied_to_ground_i),
        //---------------- Transmit Ports - FPGA TX Interface Ports ----------------
        .gt3_txdata_in                  (tx3_data),
        //---------------- Transmit Ports - Pattern Generator Ports ----------------
        .gt3_txprbsforceerr_in          (gt3_txprbsforceerr_i),
        //---------------- Transmit Ports - TX 8B/10B Encoder Ports ----------------
        .gt3_txchardispmode_in          (gt3_txchardispmode_i),
        .gt3_txchardispval_in           (gt3_txchardispval_i),
        .gt3_txcharisk_in               (tx3_kchar),
        //-------------------- Transmit Ports - TX Buffer Ports --------------------
        .gt3_txbufstatus_out            (gt3_txbufstatus_i),
        //------------- Transmit Ports - TX Configurable Driver Ports --------------
        .gt3_gtptxn_out                 (TXN_OUT[3]),
        .gt3_gtptxp_out                 (TXP_OUT[3]),
        .gt3_txdiffctrl_in              (gt3_txdiffctrl_i),
        .gt3_txmaincursor_in            (gt3_txmaincursor_i),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .gt3_txoutclkfabric_out         (gt3_txoutclkfabric_i),
        .gt3_txoutclkpcs_out            (gt3_txoutclkpcs_i),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .gt3_txpcsreset_in              (tied_to_ground_i),
        .gt3_txresetdone_out            (gt3_txresetdone_i),
        //--------------- Transmit Ports - TX Polarity Control Ports ---------------
        .gt3_txpolarity_in              (gt3_txpolarity_i),
        //---------------- Transmit Ports - pattern Generator Ports ----------------
        .gt3_txprbssel_in               (gt3_txprbssel_i),


    //____________________________COMMON PORTS________________________________
    .gt0_pll0reset_out(),
    .gt0_pll0outclk_out(),
    .gt0_pll0outrefclk_out(),
    .gt0_pll0lock_out(),
    .gt0_pll0refclklost_out(),    
    .gt0_pll1outclk_out(),
    .gt0_pll1outrefclk_out(),

   .sysclk_in(drpclk_in_i)

    );


//    IBUFDS IBUFDS_DRP_CLK
//     (
//        .I  (DRP_CLK_IN_P),
//        .IB (DRP_CLK_IN_N),
//        .O  (DRPCLK_IN)
//     );

//    BUFG DRP_CLK_BUFG
//    (
//        .I                              (DRPCLK_IN),
//        .O                              (drpclk_in_i) 
//    );

assign drpclk_in_i = drp_clk;
    //***********************************************************************//
    //                                                                       //
    //--------------------------- User Module Resets-------------------------//
    //                                                                       //
    //***********************************************************************//
    // All the User Modules i.e. FRAME_GEN, FRAME_CHECK and the sync modules
    // are held in reset till the RESETDONE goes high. 
    // The RESETDONE is registered a couple of times on *USRCLK2 and connected 
    // to the reset of the modules
always @(posedge  gt0_rxusrclk2_i or negedge gt0_rxresetdone_i)
    begin
        if (!gt0_rxresetdone_i)
        begin
            gt0_rxresetdone_r    <=   `DLY 1'b0;
            gt0_rxresetdone_r2   <=   `DLY 1'b0;
            gt0_rxresetdone_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt0_rxresetdone_r    <=   `DLY gt0_rxresetdone_i;
            gt0_rxresetdone_r2   <=   `DLY gt0_rxresetdone_r;
            gt0_rxresetdone_r3   <=   `DLY gt0_rxresetdone_r2;
        end
    end

always @(posedge gt0_txusrclk2_i or negedge gt0_txfsmresetdone_i)
    begin
        if (!gt0_txfsmresetdone_i)
        begin
            gt0_txfsmresetdone_r    <=   `DLY 1'b0;
            gt0_txfsmresetdone_r2   <=   `DLY 1'b0;
        end
        else
        begin
            gt0_txfsmresetdone_r    <=   `DLY gt0_txfsmresetdone_i;
            gt0_txfsmresetdone_r2   <=   `DLY gt0_txfsmresetdone_r;
        end
    end

always @(posedge  gt1_rxusrclk2_i or negedge gt1_rxresetdone_i)
    begin
        if (!gt1_rxresetdone_i)
        begin
            gt1_rxresetdone_r    <=   `DLY 1'b0;
            gt1_rxresetdone_r2   <=   `DLY 1'b0;
            gt1_rxresetdone_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt1_rxresetdone_r    <=   `DLY gt1_rxresetdone_i;
            gt1_rxresetdone_r2   <=   `DLY gt1_rxresetdone_r;
            gt1_rxresetdone_r3   <=   `DLY gt1_rxresetdone_r2;
        end
    end

always @(posedge gt1_txusrclk2_i or negedge gt1_txfsmresetdone_i)
    begin
        if (!gt1_txfsmresetdone_i)
        begin
            gt1_txfsmresetdone_r    <=   `DLY 1'b0;
            gt1_txfsmresetdone_r2   <=   `DLY 1'b0;
        end
        else
        begin
            gt1_txfsmresetdone_r    <=   `DLY gt1_txfsmresetdone_i;
            gt1_txfsmresetdone_r2   <=   `DLY gt1_txfsmresetdone_r;
        end
    end

always @(posedge  gt2_rxusrclk2_i or negedge gt2_rxresetdone_i)
    begin
        if (!gt2_rxresetdone_i)
        begin
            gt2_rxresetdone_r    <=   `DLY 1'b0;
            gt2_rxresetdone_r2   <=   `DLY 1'b0;
            gt2_rxresetdone_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt2_rxresetdone_r    <=   `DLY gt2_rxresetdone_i;
            gt2_rxresetdone_r2   <=   `DLY gt2_rxresetdone_r;
            gt2_rxresetdone_r3   <=   `DLY gt2_rxresetdone_r2;
        end
    end

always @(posedge gt2_txusrclk2_i or negedge gt2_txfsmresetdone_i)
    begin
        if (!gt2_txfsmresetdone_i)
        begin
            gt2_txfsmresetdone_r    <=   `DLY 1'b0;
            gt2_txfsmresetdone_r2   <=   `DLY 1'b0;
        end
        else
        begin
            gt2_txfsmresetdone_r    <=   `DLY gt2_txfsmresetdone_i;
            gt2_txfsmresetdone_r2   <=   `DLY gt2_txfsmresetdone_r;
        end
    end

always @(posedge  gt3_rxusrclk2_i or negedge gt3_rxresetdone_i)
    begin
        if (!gt3_rxresetdone_i)
        begin
            gt3_rxresetdone_r    <=   `DLY 1'b0;
            gt3_rxresetdone_r2   <=   `DLY 1'b0;
            gt3_rxresetdone_r3   <=   `DLY 1'b0;
        end
        else
        begin
            gt3_rxresetdone_r    <=   `DLY gt3_rxresetdone_i;
            gt3_rxresetdone_r2   <=   `DLY gt3_rxresetdone_r;
            gt3_rxresetdone_r3   <=   `DLY gt3_rxresetdone_r2;
        end
    end

always @(posedge gt3_txusrclk2_i or negedge gt3_txfsmresetdone_i)
    begin
        if (!gt3_txfsmresetdone_i)
        begin
            gt3_txfsmresetdone_r    <=   `DLY 1'b0;
            gt3_txfsmresetdone_r2   <=   `DLY 1'b0;
        end
        else
        begin
            gt3_txfsmresetdone_r    <=   `DLY gt3_txfsmresetdone_i;
            gt3_txfsmresetdone_r2   <=   `DLY gt3_txfsmresetdone_r;
        end
    end
//-------------------------------------------------------------------------------------

//------------ optional Ports assignments --------------
assign  gt0_rxprbscntreset_i                 =  tied_to_ground_i;
assign  gt0_rxprbssel_i                      =  0;
assign  gt0_loopback_i                       =  0;
 
assign  gt0_txdiffctrl_i                     =  0;
assign  gt0_rxbufreset_i                     =  tied_to_ground_i;
assign  gt0_rxcdrhold_i                      =  tied_to_ground_i;
assign  gt0_rxlpmhfovrden_i                  =  tied_to_ground_i;
assign  gt0_rxpmareset_i                     =  tied_to_ground_i;
assign  gt0_rxpolarity_i                     =  tied_to_ground_i;
assign  gt0_rxpd_i                           =  0;
assign  gt0_txprecursor_i                    =  0;
assign  gt0_txpostcursor_i                   =  0;
assign  gt0_txmaincursor_i                   =  0;
assign  gt0_txchardispmode_i                 =  0;
assign  gt0_txchardispval_i                  =  0;
assign  gt0_txpolarity_i                     =  tied_to_ground_i;
assign  gt0_txpd_i                           =  0;
assign  gt0_txprbsforceerr_i                 =  tied_to_ground_i;
assign  gt0_txprbssel_i                      =  0;
assign  gt1_rxprbscntreset_i                 =  tied_to_ground_i;
assign  gt1_rxprbssel_i                      =  0;
assign  gt1_loopback_i                       =  0;
 
assign  gt1_txdiffctrl_i                     =  0;
assign  gt1_rxbufreset_i                     =  tied_to_ground_i;
assign  gt1_rxcdrhold_i                      =  tied_to_ground_i;
assign  gt1_rxlpmhfovrden_i                  =  tied_to_ground_i;
assign  gt1_rxpmareset_i                     =  tied_to_ground_i;
assign  gt1_rxpolarity_i                     =  tied_to_ground_i;
assign  gt1_rxpd_i                           =  0;
assign  gt1_txprecursor_i                    =  0;
assign  gt1_txpostcursor_i                   =  0;
assign  gt1_txmaincursor_i                   =  0;
assign  gt1_txchardispmode_i                 =  0;
assign  gt1_txchardispval_i                  =  0;
assign  gt1_txpolarity_i                     =  tied_to_ground_i;
assign  gt1_txpd_i                           =  0;
assign  gt1_txprbsforceerr_i                 =  tied_to_ground_i;
assign  gt1_txprbssel_i                      =  0;
assign  gt2_rxprbscntreset_i                 =  tied_to_ground_i;
assign  gt2_rxprbssel_i                      =  0;
assign  gt2_loopback_i                       =  0;
 
assign  gt2_txdiffctrl_i                     =  0;
assign  gt2_rxbufreset_i                     =  tied_to_ground_i;
assign  gt2_rxcdrhold_i                      =  tied_to_ground_i;
assign  gt2_rxlpmhfovrden_i                  =  tied_to_ground_i;
assign  gt2_rxpmareset_i                     =  tied_to_ground_i;
assign  gt2_rxpolarity_i                     =  tied_to_ground_i;
assign  gt2_rxpd_i                           =  0;
assign  gt2_txprecursor_i                    =  0;
assign  gt2_txpostcursor_i                   =  0;
assign  gt2_txmaincursor_i                   =  0;
assign  gt2_txchardispmode_i                 =  0;
assign  gt2_txchardispval_i                  =  0;
assign  gt2_txpolarity_i                     =  tied_to_ground_i;
assign  gt2_txpd_i                           =  0;
assign  gt2_txprbsforceerr_i                 =  tied_to_ground_i;
assign  gt2_txprbssel_i                      =  0;
assign  gt3_rxprbscntreset_i                 =  tied_to_ground_i;
assign  gt3_rxprbssel_i                      =  0;
assign  gt3_loopback_i                       =  0;
 
assign  gt3_txdiffctrl_i                     =  0;
assign  gt3_rxbufreset_i                     =  tied_to_ground_i;
assign  gt3_rxcdrhold_i                      =  tied_to_ground_i;
assign  gt3_rxlpmhfovrden_i                  =  tied_to_ground_i;
assign  gt3_rxpmareset_i                     =  tied_to_ground_i;
assign  gt3_rxpolarity_i                     =  tied_to_ground_i;
assign  gt3_rxpd_i                           =  0;
assign  gt3_txprecursor_i                    =  0;
assign  gt3_txpostcursor_i                   =  0;
assign  gt3_txmaincursor_i                   =  0;
assign  gt3_txchardispmode_i                 =  0;
assign  gt3_txchardispval_i                  =  0;
assign  gt3_txpolarity_i                     =  tied_to_ground_i;
assign  gt3_txpd_i                           =  0;
assign  gt3_txprbsforceerr_i                 =  tied_to_ground_i;
assign  gt3_txprbssel_i                      =  0;
//------------------------------------------------------

    // assign resets for frame_gen modules
    assign  gt0_tx_system_reset_c = !gt0_txfsmresetdone_r2;
    assign  gt1_tx_system_reset_c = !gt1_txfsmresetdone_r2;
    assign  gt2_tx_system_reset_c = !gt2_txfsmresetdone_r2;
    assign  gt3_tx_system_reset_c = !gt3_txfsmresetdone_r2;

    // assign resets for frame_check modules
    assign  gt0_rx_system_reset_c = !gt0_rxresetdone_r3;
    assign  gt1_rx_system_reset_c = !gt1_rxresetdone_r3;
    assign  gt2_rx_system_reset_c = !gt2_rxresetdone_r3;
    assign  gt3_rx_system_reset_c = !gt3_rxresetdone_r3;

//-------------------------------------------------------------

assign gt0_rxlpmreset_i = 1'b0;
assign gt0_drpaddr_i = 9'd0;
assign gt0_drpdi_i = 16'd0;
assign gt0_drpen_i = 1'b0;
assign gt0_drpwe_i = 1'b0;
assign gt1_rxlpmreset_i = 1'b0;
assign gt1_drpaddr_i = 9'd0;
assign gt1_drpdi_i = 16'd0;
assign gt1_drpen_i = 1'b0;
assign gt1_drpwe_i = 1'b0;
assign gt2_rxlpmreset_i = 1'b0;
assign gt2_drpaddr_i = 9'd0;
assign gt2_drpdi_i = 16'd0;
assign gt2_drpen_i = 1'b0;
assign gt2_drpwe_i = 1'b0;
assign gt3_rxlpmreset_i = 1'b0;
assign gt3_drpaddr_i = 9'd0;
assign gt3_drpdi_i = 16'd0;
assign gt3_drpen_i = 1'b0;
assign gt3_drpwe_i = 1'b0;

assign soft_reset_i = tied_to_ground_i;


endmodule
    
