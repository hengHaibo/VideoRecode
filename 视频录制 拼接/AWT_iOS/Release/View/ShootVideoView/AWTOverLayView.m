//
//  AWTOverLayView.m
//  AWT_iOS
//
//  Created by apple on 2019/10/27.
//  Copyright © 2019年 wtoip_mac. All rights reserved.
//

#import "AWTOverLayView.h"
#import "UIView+AWTView.h"
#import "UIColor+Hex.h"
#import "UIView+AWTView.h"

@interface AWTOverLayView()

@property (nonatomic, assign) CameraModel cameraModel;
@property (nonatomic, strong) UIButton *selectButton;

@property (weak, nonatomic) IBOutlet UIView *photoManagerView; //底下的View
@property (nonatomic, strong) UIView *buttonBackView;
@property (strong, nonatomic) NSMutableArray *buttonArray;
@property (weak, nonatomic) IBOutlet UIButton *complete;
@property (weak, nonatomic) IBOutlet UIButton *delete;

@end

@implementation AWTOverLayView



-(void)awakeFromNib{
    [super awakeFromNib];
    
    
    [self setupView];
    
    
    [[NSNotificationCenter defaultCenter]addObserverForName:@"DeviceDegress" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSString *degress = note.userInfo[@"degress"];
        UIButton *video = self.buttonArray[0];
        UIButton *pic = self.buttonArray[1];
        UIButton *photo = self.buttonArray[2];
        if ([degress isEqualToString:@"right"] || [degress isEqualToString:@"left"]) {

            [video transformVertical];
            [pic transformVertical];
            [photo transformVertical];
            [self.complete transformVertical];
            [self.delete transformVertical360];
        }else{
            [video transformIdentity];
            [pic transformIdentity];
            [photo transformIdentity];
             [self.complete transformIdentity];
             [self.delete transformIdentity];
        }
    }];
    
    
}

-(void)setupView{
    self.buttonArray = [NSMutableArray array];
    //默认视频
    self.cameraModel = Video;
    CGFloat width = 56;
    CGFloat height = 21;
    UIView *buttonBackView = [[UIView alloc]init];
    buttonBackView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 45);
    [self.photoManagerView addSubview:buttonBackView];
    self.buttonBackView = buttonBackView;
    
    UIView *dian = [[UIView alloc]init];
    dian.backgroundColor = [UIColor whiteColor];
    dian.frame = CGRectMake(0, CGRectGetMaxY(buttonBackView.frame), 5, 5);
    dian.layer.cornerRadius = 2.5;
    dian.centerX = [UIScreen mainScreen].bounds.size.width/2;
    [self.photoManagerView addSubview:dian];
    NSArray *titleArray = @[@"相册", @"照片", @"视频"];
    for (int i = 0; i < titleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.frame = CGRectMake(i * (26 + width), 15, width, height);
        [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [button setTitleColor:[UIColor colorWithHexString:@"8a8a8a"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateDisabled];
        [buttonBackView addSubview:button];
        [self.buttonArray addObject:button];
        if (i == 2) {
            
            [self clickBtn:button];
        }
    }
    
}
-(void)clickBtn:(UIButton *)button{
    self.selectButton.enabled = true;
    button.enabled = false;
    self.selectButton = button;
    
    if ([button.titleLabel.text isEqualToString:@"照片"]) {
        if ([self.delegate respondsToSelector:@selector(clickButtonWithModel:)]) {
            [self.delegate clickButtonWithModel:Picture];
        }
        if (self.cameraModel == Photos) {
            [UIView animateWithDuration:0.28f delay:0.0f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 self.buttonBackView.x -= 75;
                             } completion:^(BOOL complete) {
                                 self.cameraModel = Picture;
                             }];
        }else{
            [UIView animateWithDuration:0.28f delay:0.0f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 self.buttonBackView.x += 75;
                             } completion:^(BOOL complete) {
                                 self.cameraModel = Picture;
                             }];
        }
        
    }else if([button.titleLabel.text isEqualToString:@"相册"]){
        if ([self.delegate respondsToSelector:@selector(clickButtonWithModel:)]) {
            [self.delegate clickButtonWithModel:Photos];
        }
        if (self.cameraModel == Picture) {
            [UIView animateWithDuration:0.28f delay:0.0f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 self.buttonBackView.x += 75;
                             } completion:^(BOOL complete) {
                                 self.cameraModel = Photos;
                             }];
        }else{
            [UIView animateWithDuration:0.28f delay:0.0f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 self.buttonBackView.x += 160;
                             } completion:^(BOOL complete) {
                                 self.cameraModel = Photos;
                             }];
        }
        
    }else{
        if ([self.delegate respondsToSelector:@selector(clickButtonWithModel:)]) {
            [self.delegate clickButtonWithModel:Video];
        }
        [UIView animateWithDuration:0.28f delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.buttonBackView.x = 0;
                         } completion:^(BOOL complete) {
                             self.cameraModel = Video;
                         }];
    }
}
//点击聚焦打开
//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//    if ([self.statusView pointInside:[self convertPoint:point toView:self.statusView] withEvent:event] ) {
//        return YES;
//    }
//    return NO;
//}



@end
