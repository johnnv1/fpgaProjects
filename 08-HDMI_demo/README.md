# Zybo HDMI in demo

* [Link to the project wiki](https://reference.digilentinc.com/learn/programmable-logic/tutorials/zybo-hdmi-demo/start)
* [Link to the project github](https://github.com/Digilent/Zybo-hdmi-in)

Officially it's a digilent project, but [it](https://github.com/Digilent/Zybo-hdmi-in) doesn't work in lived 2019.1, so I updated the project with the current **ips**** and the *C* project was fixed in 

Author: João Amorim

Author email: joao-amorim@uergs.edu.br

Date: Nov-06-2019

**Abstract**

 This project is to get the HDMI from a source and put in the VGA 

# Table of content
* [License](../LICENSE)
* [Project Description](#Description)
* [Usage](#Usage)
* [Project Details](#Details)

# Some specification

This specification is copy from the students: Marco Lucarella, Enrico Gioia taken from [gitlab repository](https://gitlab.eurecom.fr/lucarell/HdmiAcquisition4Zybo)


### <a name="Description"></a>Project Description
The goal is to design a digital hardware for HDMI acquisition that allows to manipulate each pixel and then print the output on the VGA interface.

As reference and start point, we used an open source [project](https://reference.digilentinc.com/zybo:hdmidemo) provided by Digilent.  
The entire work is made up of several modules which are implemented either on the FPGA logic or on the CPU. Among them there are:

* **HDMI Acquisition (dvi2rgb)** : module created by Digilent able to interpret the HDMI protocol. It decodes the video stream and outputs 24-bit RGB video data along with the pixel clock and synchronization signals;
* **VGA writer (rgb2dvi)**: module to provide a properly blanked vga signal from an rgb interface
* **RGB to AXI**: module created by Digilent able to load the image on the RAM to be accessible from the CPU.


### <a name="Usage"></a>Usage

#### Gather your materials

Begin by gathering the materials:

* Zybo board (Zynq-7000 Development Board)
* Xilinx Vivado® Design Suite: Design Edition
* Micro USB cable
* 5V 2.5A switching power supply
* VGA Cable to connect to a monitor
* Monitor with a VGA Input
* HDMI cable
* HDMI video source (most modern laptop computers work or a GoPro)

![Data flow](figures/ZyboDetails.png)

### <a name="Details"></a>Project Details

#### Blocks overview

Among all blocks, the critical ones are described below:
* **dvi2rgb**: this is the block that read the HDMI interface.
	* the input TMDS is the name of the HDMI interface dedicated for video;
	* the output DDC is an I2C interface used by the devices connected to the HDMI in order to detect the resolution supported by the Zybo. This interface allows the peripheral to read a ROM stored in this block that can be configured using the block options;
	* the output RGB is composed of several signals:
		* vid_pData is contains the information on the pixel color coded using one byte for each color in the order BRG;
		* vid_pHSync and vid_pVSync represet the vertical and orizzontal sync signals;
		* vid_pVDE indicated if the video is enabled or not;
	* the output PixelClk is the clock extracted from the HDMI and it depends on the resolution used;
	* the output aPixelClkLckd is set to one when the block finish to detect the PixelClk;
	* the optional output SerialClk can be enabled from the block configuration and is equal to the PixelClk but five time faster.
* **v_vid_in_axi4s**: this is the block that creates the AXI interface in order to transmit the pixel to the RAM.
	* the input vid_io_in was originally connected to the RGB port of dvi2rgb and has the same pin.

#### CPU project

The CPU project provided different features:
* initialize the frames: inside the RAM are stored 3 frames, using the UART interface is possible to select what you want to write in each frame and witch frame do you want to visualize on the VGA;
* attach a callback on the HDMI status: every time the HDMI changes status a callback is executed to update the UART menu and if the HDMI is detected it starts automatically the streaming on the VGA;
* sample image: there are two sample image that is possible to show on the VGA using the UART menu. Other sample images can be added modifying the C code;
* adjust the resolution: using the UART menu is possible to select the resolution to use on both HDMI and VGA.
* capture a frame: is possible to capture a frame of the HDMI stream and do some software modification. The color inversion filter is already implemented and can be enabled from the UART menu.
