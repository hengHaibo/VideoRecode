//
//  HWCircleView.m
//  dome
//
//  Created by apple on 2019/10/27.
//  Copyright © 2019年 Mr Liu. All rights reserved.
//

#import "AWTPhotoView.h"


@interface AWTPhotoView ()


//进度条的宽度
@property(nonatomic,assign) CGFloat progerWidth;


@end

@implementation AWTPhotoView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self setupView];
}


-(void)setupView{
    self.backgroundColor = [UIColor clearColor];
    //默认颜色
    self.progerssBackgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    self.progerssColor = [UIColor whiteColor];
   
    //默认进度条宽度
    self.progerWidth = 5;

    //百分比标签
    UIButton *photoBTn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    photoBTn.layer.cornerRadius = 35;
//    [photoBTn setImage:[UIImage imageNamed:@"video"] forState:UIControlStateNormal];
    [photoBTn setBackgroundImage:[UIImage imageNamed:@"backcolor"] forState:UIControlStateNormal];
//    [photoBTn setImage:[UIImage imageNamed:@"发布_摄像_长安摄像"] forState:UIControlStateNormal];
  [photoBTn setImage:[UIImage imageNamed:@"发布_摄像_摄影"] forState:UIControlStateNormal];
    
    photoBTn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:photoBTn];
    self.photoBTn = photoBTn;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    int p = (int)floor(progress * 100);
    if (p >= 100) {
        return;
    }
//    [self.photoBTn setTitle:[NSString stringWithFormat:@"%d%%", (int)floor(progress * 100)] forState:UIControlStateNormal];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
 
    UIBezierPath *backgroundPath = [[UIBezierPath alloc] init];
    backgroundPath.lineWidth = self.progerWidth;
    [self.progerssBackgroundColor set];
    backgroundPath.lineCapStyle = kCGLineCapRound;
    backgroundPath.lineJoinStyle = kCGLineJoinRound;
    CGFloat radius = (MIN(rect.size.width, rect.size.height) - self.progerWidth) * 0.5;
    [backgroundPath addArcWithCenter:(CGPoint){rect.size.width * 0.5, rect.size.height * 0.5} radius:radius startAngle:M_PI * 1.5 endAngle:M_PI * 1.5 + M_PI * 2  clockwise:YES];
    [backgroundPath stroke];
    
    
    UIBezierPath *progressPath = [[UIBezierPath alloc] init];
    progressPath.lineWidth = self.progerWidth;
    [self.progerssColor set];
    progressPath.lineCapStyle = kCGLineCapRound;
    progressPath.lineJoinStyle = kCGLineJoinRound;
    [progressPath addArcWithCenter:(CGPoint){rect.size.width * 0.5, rect.size.height * 0.5} radius:radius startAngle:M_PI * 1.5 endAngle:M_PI * 1.5 + M_PI * 2 * _progress clockwise:YES];
    [progressPath stroke];
   
}











@end
