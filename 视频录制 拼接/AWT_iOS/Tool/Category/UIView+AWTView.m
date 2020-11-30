//
//  UIView+AWTView.m
//  AWT_iOS
//
//  Created by wtoip_mac on 2019/10/25.
//  Copyright © 2019 wtoip_mac. All rights reserved.
//

#import "UIView+AWTView.h"
#import "UIColor+Hex.h"

@implementation UIView (AWTView)


-(void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
-(CGFloat)x{
    return self.frame.origin.x;
}
-(void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
-(CGFloat)y{
    return self.frame.origin.y;
}
-(void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
-(CGFloat)width{
    return self.frame.size.width;
}
-(void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
-(CGFloat)height{
    return self.frame.size.height;
}
-(void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
-(CGSize)size{
    return self.frame.size;
}
-(void)setCenterX:(CGFloat)centerX{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}
-(CGFloat)centerX{
    return self.center.x;
}
-(void)setCenterY:(CGFloat)centerY{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}
-(CGFloat)centerY{
    return self.center.y;
}
-(void)setBorderWidth:(CGFloat)borderWidth{
    if (borderWidth < 0) {
        return;
    }
    self.layer.borderWidth = borderWidth;
}
-(CGFloat)borderWidth{
    return self.borderWidth;
}
-(void)setBorderColor:(UIColor *)borderColor{
    self.layer.borderColor = borderColor.CGColor;
}
-(UIColor *)borderColor{
    return self.borderColor;
}
-(void)setCornerRadius:(CGFloat)cornerRadius{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = true;
}
-(CGFloat)cornerRadius{
    return self.cornerRadius;
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
    gradient.colors = @[(id)[UIColor colorWithHexString:@"FFBF4E"].CGColor,(id)[UIColor colorWithHexString:@"FF2E6F"].CGColor];
    gradient.startPoint = CGPointMake(0, 1);
    gradient.endPoint = CGPointMake(1, 0);
    [self.layer addSublayer:gradient];
}















@end
