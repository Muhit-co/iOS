//
//  UIView+Layout.m
//  FTLibrary
//
//  Created by Simon Lee on 21/12/2009.
//  Copyright 2009 Fuerte International. All rights reserved.
//

#import "UIView+Layout.h"

@implementation UIView (Layout)

- (UIView *)removeSubviews {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    return self;
}

- (double)width {
    CGRect frame = [self frame];
    return frame.size.width;
}

- (UIView *)setWidth:(double)value {
    CGRect frame = [self frame];
    frame.size.width = round(value);
    [self setFrame:frame];
    return self;
}

- (double)height {
    CGRect frame = [self frame];
    return frame.size.height;
}

- (UIView *)setHeight:(double)value {
    CGRect frame = [self frame];
    frame.size.height = round(value);
    [self setFrame:frame];
    return self;
}

- (CGFloat)bottomPosition {
    return ([self height] + [self yPosition]);
}

- (UIView *)setSize:(CGSize)size {
    CGRect frame = [self frame];
    frame.size.width  = round(size.width);
    frame.size.height = round(size.height);
    [self setFrame:frame];
    
    return self;
}

- (CGSize)size {
    CGRect frame = [self frame];
    return frame.size;
}

- (CGPoint)origin {
    CGRect frame = [self frame];
    return frame.origin;
}

- (UIView *)setOrigin:(CGPoint)point {
    CGRect frame = [self frame];
    frame.origin = point;
    [self setFrame:frame];
    return self;
}

- (double)xPosition {
    CGRect frame = [self frame];
    return frame.origin.x;
}

- (double)yPosition {
    CGRect frame = [self frame];
    return frame.origin.y;
}

- (CGFloat)baselinePosition {
    return [self yPosition] + [self height];
}

- (CGFloat)rightPosition {
    return [self xPosition] + [self width];
}

- (UIView *)positionAtX:(double)xValue {
    CGRect frame = [self frame];
    frame.origin.x = round(xValue);
    [self setFrame:frame];
    return self;
}

- (UIView *)positionAtY:(double)yValue {
    CGRect frame = [self frame];
    frame.origin.y = round(yValue);
    [self setFrame:frame];
    return self;
}

- (UIView *)positionAtX:(double)xValue andY:(double)yValue {
    CGRect frame = [self frame];
    frame.origin.x = round(xValue);
    frame.origin.y = round(yValue);
    [self setFrame:frame];
    return self;
}

- (UIView *)positionAtX:(double)xValue andY:(double)yValue withWidth:(double)width {
    CGRect frame = [self frame];
    frame.origin.x   = round(xValue);
    frame.origin.y   = round(yValue);
    frame.size.width = width;
    [self setFrame:frame];
    return self;
}

- (UIView *)positionAtX:(double)xValue andY:(double)yValue withHeight:(double)height {
    CGRect frame = [self frame];
    frame.origin.x    = round(xValue);
    frame.origin.y    = round(yValue);
    frame.size.height = height;
    [self setFrame:frame];
    return self;
}

- (UIView *)positionAtX:(double)xValue withHeight:(double)height {
    CGRect frame = [self frame];
    frame.origin.x    = round(xValue);
    frame.size.height = height;
    [self setFrame:frame];
    return self;
}

- (UIView *)transformFrameByDifference:(CGRect)differenceRect
{
    CGRect frame = [self frame];
    frame.origin.x    += differenceRect.origin.x;
    frame.origin.y    += differenceRect.origin.y;
    frame.size.width  += differenceRect.size.width;
    frame.size.height += differenceRect.size.height;
    [self setFrame:frame];
    return self;
}

- (UIView *)centerInSuperView {
    double xPos = round((self.superview.frame.size.width - self.frame.size.width) / 2.0);
    double yPos = round((self.superview.frame.size.height - self.frame.size.height) / 2.0);
    [self positionAtX:xPos andY:yPos];
    return self;
}

- (UIView *)aestheticCenterInSuperView {
    double xPos = round(([self.superview width] - [self width]) / 2.0);
    double yPos = round(([self.superview height] - [self height]) / 2.0) - ([self.superview height] / 8.0);
    [self positionAtX:xPos andY:yPos];
    return self;
}

- (UIView *)bringToFront {
    [self.superview bringSubviewToFront:self];
    return self;
}

- (UIView *)sendToBack {
    [self.superview sendSubviewToBack:self];
    return self;
}

//ZF

- (UIView *)centerAtX {
    double xPos = round((self.superview.width - self.width) / 2.0);
    [self positionAtX:xPos];
    return self;
}

- (UIView *)centerAtY {
    double yPos = round((self.superview.height - self.height) / 2.0);
    [self positionAtY:yPos];
    return self;
}

- (UIView *)moveYWith:(double)offset {
    [self positionAtY:self.yPosition + offset];
    return self;
}

- (UIView *)moveXWith:(double)offset {
    [self positionAtX:self.xPosition + offset];
    return self;
}

- (UIView *)centerAtXQuarter {
    double xPos = round((self.superview.frame.size.width / 4) - (self.frame.size.width / 2));
    [self positionAtX:xPos];
    return self;
}

- (UIView *)centerAtX3Quarter {
    [self centerAtXQuarter];
    double xPos = round((self.superview.frame.size.width / 2) + self.frame.origin.x);
    [self positionAtX:xPos];
    return self;
}

- (UIView *)alignToRight:(double)offset {
    double xPos = round((self.superview.width - self.width) + offset);
    [self positionAtX:xPos];
    return self;
}

- (UIView *)alignToBottom:(double)offset {
    double yPos = round((self.superview.height - self.height) + offset);
    [self positionAtY:yPos];
    
    return self;
}

@end