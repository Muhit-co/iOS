//
//  UIView+Layout.h
//  FTLibrary
//
//  Created by Simon Lee on 21/12/2009.
//  Copyright 2009 Fuerte International. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIView (Layout)

- (double)width;

- (UIView *)setWidth:(double)width;

- (double)height;

- (UIView *)setHeight:(double)height;

- (CGFloat)bottomPosition;

- (CGFloat)rightPosition;

- (CGSize)size;

- (UIView *)setSize:(CGSize)size;

- (CGPoint)origin;

- (UIView *)setOrigin:(CGPoint)point;

- (double)xPosition;

- (double)yPosition;

- (CGFloat)baselinePosition;

- (UIView *)positionAtX:(double)xValue;

- (UIView *)positionAtY:(double)yValue;

- (UIView *)positionAtX:(double)xValue andY:(double)yValue;

- (UIView *)positionAtX:(double)xValue andY:(double)yValue withWidth:(double)width;

- (UIView *)positionAtX:(double)xValue andY:(double)yValue withHeight:(double)height;

- (UIView *)positionAtX:(double)xValue withHeight:(double)height;

- (UIView *)transformFrameByDifference:(CGRect)differenceRect;

- (UIView *)removeSubviews;

- (UIView *)centerInSuperView;

- (UIView *)aestheticCenterInSuperView;

- (UIView *)bringToFront;

- (UIView *)sendToBack;

- (UIView *)centerAtX;

- (UIView *)centerAtY;

- (UIView *)moveYWith:(double)value;

- (UIView *)moveXWith:(double)value;

- (UIView *)centerAtXQuarter;

- (UIView *)centerAtX3Quarter;

- (UIView *)alignToRight:(double)offset;

- (UIView *)alignToBottom:(double)offset;

@end