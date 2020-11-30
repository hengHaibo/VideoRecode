//
//  HWCircleView.h
//  dome
//
//  Created by apple on 2019/10/27.
//  Copyright © 2019年 Mr Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AWTPhotoView : UIView

@property (nonatomic, weak) UIButton *photoBTn;
@property (nonatomic, assign) CGFloat progress;
//进度条颜色
@property(nonatomic,strong) UIColor *progerssColor;
//进度条背景颜色
@property(nonatomic,strong) UIColor *progerssBackgroundColor;

@end


