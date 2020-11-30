//
//  UIView+Layout.m
//
//  Created by 谭真 on 15/2/24.
//  Copyright © 2015年 谭真. All rights reserved.
//

#import "UIView+Layout.h"

@implementation UIView (Layout)

- (CGFloat)tz_left {
    return self.frame.origin.x;
}

- (void)setTz_left:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)tz_top {
    return self.frame.origin.y;
}

- (void)setTz_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)tz_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setTz_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)tz_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setTz_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)tz_width {
    return self.frame.size.width;
}

- (void)setTz_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)tz_height {
    return self.frame.size.height;
}

- (void)setTz_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)tz_centerX {
    return self.center.x;
}

- (void)setTz_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)tz_centerY {
    return self.center.y;
}

- (void)setTz_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)tz_origin {
    return self.frame.origin;
}

- (void)setTz_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)tz_size {
    return self.frame.size;
}

- (void)setTz_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

-(void)setTz_x:(CGFloat)tz_x{
  CGRect frame = self.frame;
  frame.origin.x = tz_x;
  self.frame = frame;
}
-(CGFloat)tz_x{
  return self.frame.origin.x;
}

-(void)setTz_y:(CGFloat)tz_y{
  CGRect frame = self.frame;
  frame.origin.y = tz_y;
  self.frame = frame;
}
-(CGFloat)tz_y{
  return self.frame.origin.x;
}

+ (void)showOscillatoryAnimationWithLayer:(CALayer *)layer type:(TZOscillatoryAnimationType)type{
    NSNumber *animationScale1 = type == TZOscillatoryAnimationToBigger ? @(1.15) : @(0.5);
    NSNumber *animationScale2 = type == TZOscillatoryAnimationToBigger ? @(0.92) : @(1.15);
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        [layer setValue:animationScale1 forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            [layer setValue:animationScale2 forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                [layer setValue:@(1.0) forKeyPath:@"transform.scale"];
            } completion:nil];
        }];
    }];
}

-(void)transformVertical{
  [UIView beginAnimations:@"clockwiseAnimation" context:NULL];
  [UIView setAnimationDuration:0.5f];
  [UIView setAnimationDelegate:self];
  self.transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
  [UIView commitAnimations];
}
-(void)transformVertical360{
  [UIView beginAnimations:@"clockwiseAnimation" context:NULL];
  [UIView setAnimationDuration:0.5f];
  [UIView setAnimationDelegate:self];
  self.transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
  [UIView commitAnimations];
}
-(void)transformIdentity{
  [UIView beginAnimations:@"counterclockwiseAnimation"context:NULL];
  [UIView setAnimationDuration:0.5f];
  self.transform = CGAffineTransformIdentity;
  [UIView commitAnimations];
}

-(void)colorGradientChange{
  CAGradientLayer *gradient = [CAGradientLayer layer];
  gradient.frame = self.bounds;
  gradient.colors = @[(id)[UIColor colorWithRed:255/255.0f green:191/255.0f blue:78/255.0f alpha:1.0f].CGColor,(id)[UIColor colorWithRed:255/255.0f green:46/255.0f blue:111/255.0f alpha:1.0f].CGColor];
  gradient.startPoint = CGPointMake(0, 1);
  gradient.endPoint = CGPointMake(1, 0);
  [self.layer addSublayer:gradient];
}

@end
