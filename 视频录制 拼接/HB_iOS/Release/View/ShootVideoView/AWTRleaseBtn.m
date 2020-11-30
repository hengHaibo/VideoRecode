//
//  AWTRleaseBtn.m
//  AWT_iOS
//
//  Created by wtoip_mac on 2019/10/25.
//  Copyright © 2019 wtoip_mac. All rights reserved.
//

#import "AWTRleaseBtn.h"
#import "UIView+Layout.h"


@interface AWTRleaseBtn()




@end

@implementation AWTRleaseBtn

-(void)layoutSubviews{
    [super layoutSubviews];
    
  
      
    self.imageView.tz_x = 0;
    self.imageView.tz_width = self.imageView.tz_height = 75;
    self.imageView.tz_centerX = self.frame.size.width/2;

    self.titleLabel.tz_y = CGRectGetMaxY(self.imageView.frame) + 10;
  self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.tz_width = self.imageView.tz_width;
    self.titleLabel.tz_height  = 21;
  self.titleLabel.tz_centerX = self.frame.size.width/2;
  
  
//    [self.titleLabel sizeToFit];
  
}

@end
