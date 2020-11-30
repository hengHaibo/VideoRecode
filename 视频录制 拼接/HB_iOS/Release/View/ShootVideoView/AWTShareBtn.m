//
//  AWTShareBtn.m
//  iwutong
//
//  Created by wtoip_mac on 2019/11/9.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "AWTShareBtn.h"
#import "UIView+Layout.h"

@implementation AWTShareBtn

-(void)layoutSubviews{
  [super layoutSubviews];
  
  
  
  self.imageView.tz_x = 0;
  self.imageView.tz_width = self.imageView.tz_height = 44;
  self.imageView.tz_centerX = self.frame.size.width/2;
  //
  //
  self.titleLabel.tz_y = CGRectGetMaxY(self.imageView.frame) + 5;
  self.titleLabel.textAlignment = NSTextAlignmentCenter;
  self.titleLabel.tz_width = self.imageView.tz_width;
  self.titleLabel.tz_height = 20;
  self.titleLabel.tz_centerX = self.frame.size.width/2;
//  [self.titleLabel sizeToFit];
  
}

@end
