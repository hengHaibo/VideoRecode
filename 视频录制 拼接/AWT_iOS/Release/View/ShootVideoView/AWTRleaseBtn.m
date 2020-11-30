//
//  AWTRleaseBtn.m
//  AWT_iOS
//
//  Created by wtoip_mac on 2019/10/25.
//  Copyright © 2019 wtoip_mac. All rights reserved.
//

#import "AWTRleaseBtn.h"
#import "UIView+AWTView.h"

@interface AWTRleaseBtn()




@end

@implementation AWTRleaseBtn

-(void)layoutSubviews{
    [super layoutSubviews];
    
    
    self.imageView.y = 0;
    self.imageView.width = self.imageView.height = 75;
    self.imageView.centerX = self.width/2;
    
    
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame) + 10;
    self.titleLabel.centerX = self.width/2;
    [self.titleLabel sizeToFit];
    
}

@end
