//
//  LLImageColorByPixel.h
//  LLImageColor
//
//  Created by Lance on 15/10/14.
//  Copyright © 2015年 Lance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLImageColorByPixel : NSObject

/**
 *  get color from image pixel with point
 *
 *  @param imageRef CGImage
 *  @param point    CGPoint
 *
 *  @return UIColor
 */
+ (UIColor *)getImagePixelColorByCGImageRef:(CGImageRef)imageRef withPoint:(CGPoint)point;

@end
