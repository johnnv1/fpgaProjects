/*
 * gimp_image.h
 *
 *  Created on: 3 de dez de 2019
 *      Author: jlfragoso
 */

#ifndef SRC_GIMP_IMAGE_H_
#define SRC_GIMP_IMAGE_H_

#include <xil_types.h>

typedef struct __gimp_image {
  u32  	 width;
  u32  	 height;
  u32  	 bytes_per_pixel; /* 2:RGB16, 3:RGB, 4:RGBA */
  u8 	 pixel_data[640 * 480 * 3 + 1];
} gimp_image;

extern const gimp_image image_uergs;
extern const gimp_image image2;


#endif /* SRC_GIMP_IMAGE_H_ */
