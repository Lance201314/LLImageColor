//
//  LLImageColorByPixel.m
//  LLImageColor
//
//  Created by Lance on 15/10/14.
//  Copyright © 2015年 Lance. All rights reserved.
//

#import "LLImageColorByPixel.h"

@implementation LLImageColorByPixel

/**
 *  get color from image pixel with point
 *
 *  @param imageRef CGImage
 *  @param point    CGPoint
 *
 *  @return UIColor
 */
+ (UIColor *)getImagePixelColorByCGImageRef:(CGImageRef)imageRef withPoint:(CGPoint)point {
    UIColor *color = nil;
    
    CGContextRef context = [LLImageColorByPixel getRGBContextByCGImageRef:imageRef];
    if (!context) {
        NSLog(@"create RGBA context fail \n");
        
        return nil;
    }
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    CGRect rect = {{0, 0}, {width, height}};
    
    CGContextDrawImage(context, rect, imageRef);
    // get images data
    unsigned char *dataPoint = CGBitmapContextGetData(context);
    size_t bytesBitmapAll = CGBitmapContextGetBytesPerRow(context) * height;
    if (dataPoint) {
        
        int offset = 4 * (round(point.y) * width + round(point.x));
        
        if (offset >= bytesBitmapAll || offset > bytesBitmapAll - 3) {
            return nil;
        }
        
        //  kCGImageAlphaPremultipliedFirst  For example, premultiplied ARGB
        int alpha = dataPoint[offset];
        int red = dataPoint[offset + 1];
        int green = dataPoint[offset + 2];
        int blue = dataPoint[offset + 3];
        
        NSLog(@"偏移地址: %i colors: RGBA %i %i %i  %i",offset,red,green,blue,alpha);
        
        color = [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha / 255.0];
    }
    
    /**
     *   release memory
     */
    CGContextRelease(context);
    if (dataPoint) {
        free(dataPoint);
    }
    
    return color;
}

+ (CGContextRef)getRGBContextByCGImageRef:(CGImageRef)imageRef {
    
    CGContextRef context = NULL;
    // bitmap data address
    void *bitmapData;
    // bytes per row
    size_t bitmapBytesPerRow;
    // bytes of image
    size_t bitmapByteCount;
    
    // image width, height
    size_t pixelsWidth = CGImageGetWidth(imageRef);
    size_t pixelsHeight = CGImageGetHeight(imageRef);
    
    // get the bytes per row
    bitmapBytesPerRow = 4 * pixelsWidth;
    // get all bytes
    bitmapByteCount = bitmapBytesPerRow * pixelsHeight;
    
    // color space  RGB
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (!colorSpace) {
        fprintf(stderr, "create color space fail \n");
        
        return NULL;
    }
    // alloc memory for bytesData
    bitmapData = malloc(bitmapByteCount);
    if (!bitmapData) {
        fprintf(stderr, "malloc memory fail \n");
        
        CGColorSpaceRelease(colorSpace);
        
        return NULL;
    }
    
    // For example, premultiplied ARGB
    context = CGBitmapContextCreate(bitmapData, pixelsWidth, pixelsHeight, 8, bitmapBytesPerRow, colorSpace, kCGImageAlphaPremultipliedFirst);
    if (!context) {
        fprintf(stderr, "create bitmapContext fail \n");
        free(bitmapData);
        
        return NULL;
    }
    CGColorSpaceRelease(colorSpace);
    
    return context;
}

@end
