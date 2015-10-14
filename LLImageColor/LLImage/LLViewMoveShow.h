//
//  LLViewMoveShow.h
//  LLImageColor
//
//  Created by Lance on 15/10/14.
//  Copyright © 2015年 Lance. All rights reserved.
//

/**
 *  useage
 *  need call touch begin, moving,  on the view or viewController
 */
#import <UIKit/UIKit.h>

@interface LLViewMoveShow : UIView

@property (nonatomic, strong) void (^centerPoint)(CGPoint point);

/**
 *  set zoom scale of view
 *
 *  @param zoomScale 
 */
- (void)setZoomScale:(CGFloat)zoomScale;

- (void)setCircle;

@end
