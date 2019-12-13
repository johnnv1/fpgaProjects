// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (lin64) Build 2405991 Thu Dec  6 23:36:41 MST 2018
// Date        : Tue Dec 10 11:51:07 2019
// Host        : cabernet running 64-bit CentOS release 6.10 (Final)
// Command     : write_verilog -force -mode synth_stub -rename_top bd_hdmi_in_rgb2vga_0 -prefix
//               bd_hdmi_in_rgb2vga_0_ hdmi_rgb2vga_0_0_stub.v
// Design      : hdmi_rgb2vga_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "rgb2vga,Vivado 2018.3" *)
module bd_hdmi_in_rgb2vga_0(rgb_pData, rgb_pVDE, rgb_pHSync, rgb_pVSync, 
  PixelClk, vga_pRed, vga_pGreen, vga_pBlue, vga_pHSync, vga_pVSync)
/* synthesis syn_black_box black_box_pad_pin="rgb_pData[23:0],rgb_pVDE,rgb_pHSync,rgb_pVSync,PixelClk,vga_pRed[4:0],vga_pGreen[5:0],vga_pBlue[4:0],vga_pHSync,vga_pVSync" */;
  input [23:0]rgb_pData;
  input rgb_pVDE;
  input rgb_pHSync;
  input rgb_pVSync;
  input PixelClk;
  output [4:0]vga_pRed;
  output [5:0]vga_pGreen;
  output [4:0]vga_pBlue;
  output vga_pHSync;
  output vga_pVSync;
endmodule
