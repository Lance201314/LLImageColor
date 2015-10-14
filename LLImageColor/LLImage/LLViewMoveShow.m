//
//  LLViewMoveShow.m
//  LLImageColor
//
//  Created by Lance on 15/10/14.
//  Copyright © 2015年 Lance. All rights reserved.
//

#import "LLViewMoveShow.h"

@interface LLViewMoveShow () {
    UIView *_parentView;
    
    CGFloat _zoomScale;
    CGPoint _start;
    
    // center view;
    UIView *_centerView;
}

@end

@implementation LLViewMoveShow

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _zoomScale = 14;
        
        self.backgroundColor = [UIColor clearColor];
        [self setClipsToBounds:YES];
        
        _centerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 5, 5)];
        _centerView.layer.borderWidth = 3.0;
        _centerView.layer.cornerRadius = CGRectGetWidth(_centerView.frame) / 2.0;
        _centerView.layer.masksToBounds = YES;
        _centerView.backgroundColor = [UIColor redColor];
        _centerView.layer.borderColor = [UIColor blackColor].CGColor;
        _centerView.center = CGPointMake(CGRectGetWidth(frame) / 2.0, CGRectGetHeight(frame) / 2.0);
        [self addSubview:_centerView];
    }
    
    return self;
}

- (void)setCircle {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = CGRectGetWidth(self.frame) / 2.0;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 0.5;
}

- (void)setZoomScale:(CGFloat)zoomScale {
    _zoomScale = zoomScale;
    
    [self setNeedsDisplay];
}

/**
 *  will call everytime when addSubView()
 *
 *  @param newSuperview
 */
- (void)willMoveToSuperview:(UIView *)newSuperview {
    _parentView = newSuperview;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // zoom scale the parentView
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight(self.frame) / 2.0);
    CGContextScaleCTM(context, _zoomScale, _zoomScale);
    CGContextTranslateCTM(context, -CGRectGetMidX(self.frame), -CGRectGetMidY(self.frame));
    
    [self setHidden:YES];
    [_parentView.layer renderInContext:context];
    [self setHidden:NO];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    _start = [touch locationInView:_parentView];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:_parentView];
    
    CGPoint center = self.center;
    center.x += (point.x - _start.x);
    center.y += (point.y - _start.y);
    
    [self adjustPoint:&center withFrame:_parentView.frame];
    
    self.center = center;
    
    
    [self setNeedsDisplay];
    
    _start = point;
    
    if (self.centerPoint) {
        self.centerPoint(self.center);
    }
}

- (void)adjustPoint:(CGPoint *)point withFrame:(CGRect)frame {
    
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    if ((*point).x > width) {
        (*point).x = width ;
    }
    if ((*point).x < 0) {
        (*point).x = 0;
    }
    
    if ((*point).y < 0) {
        (*point).y = 0;
    }
    if ((*point).y > height) {
        (*point).y = height;
    }
}

@end
