//
//  IWTAlertView.m
//  iwutong
//
//  Created by 司晓鑫 on 2019/11/16.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "IWTAlertView.h"
#import "IWTConstants.h"



#define TOASTDISMISSTIMEINTERVAL 2.0
const CGFloat containerWidth = 255.0;
@interface IWTAlertView ()

@property (strong, nonatomic) UILabel* textLabel;
@property (strong, nonatomic) UIView* backDarkView;
@property (strong, nonatomic) UIView* containerView;
@property (copy, nonatomic) NSString* toastText;
@property (assign, nonatomic) CGPoint showInPoint;
@end

static IWTAlertView* toast = nil;
static MBProgressHUD * hud = nil;

@implementation IWTAlertView




+ (void)showLoadingWithText:(NSString *)text{
  UIView * view = [UIApplication sharedApplication].keyWindow;
  [self showLoadingWithText:text view:view];
}



+ (void)showLoadingWithText:(NSString *)text view:(UIView *)view{
  if (!hud) {
    hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
  }
  hud.label.text = text;
}



+ (void)hideLoadingView{
  hud = nil;
  [hud removeFromSuperview];
//  [hud removeFromSuperViewOnHide];
  [hud hideAnimated:YES];
}




+ (void)showWithText:(NSString *)text afterDely:(NSTimeInterval)time atPoint:(CGPoint)point{
  [self showWithText:text autoDismissAtDely:time atPoint:point complete:nil];
}

+ (void)showWithText:(NSString*)text{
  [self showWithText:text afterDely:TOASTDISMISSTIMEINTERVAL];
}
+ (void)showWithText:(NSString*)text afterDely:(NSTimeInterval)time{
  [self showWithText:text autoDismissAtDely:time complete:nil];
}
+ (void)showWithText:(NSString *)text autoDismissAtDely:(NSTimeInterval)time complete:(dispatch_block_t)dismiss{
  [self showWithText:text autoDismissAtDely:time atPoint:CGPointZero complete:dismiss];
}
+ (void)showWithText:(NSString *)text autoDismissAtDely:(NSTimeInterval)time atPoint:(CGPoint)point  complete:(dispatch_block_t)dismiss{
  dispatch_async(dispatch_get_main_queue(),^(void){
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      if (!toast) {
        toast = [[IWTAlertView alloc]initWithFrame:CGRectZero];
      }
    });
    [toast setShowInPoint:point];
    [toast setToastText:text];
    [[UIApplication sharedApplication].keyWindow addSubview:toast];
    if (time <= 3600) {
      [self performSelector:@selector(dismissWithComplete:) withObject:dismiss afterDelay:time];
    }
  });
  
  
}
+ (void)dismissWithComplete:(dispatch_block_t)dismiss{
  dispatch_async(dispatch_get_main_queue(),^(void){
    [toast removeFromSuperview];
  });
  if (dismiss) {
    dispatch_async(dispatch_get_main_queue(), dismiss);
  }
}

- (instancetype)initWithFrame:(CGRect)frame{
  frame = (CGRect){0, 0, SCREEN_WIDTH, SCREEN_HEIGHT};
  if (self = [super initWithFrame:frame]) {
    [self configSubview];
  }
  return self;
}
- (void)configSubview{
  self.backgroundColor = UIColor.clearColor;
  [self addSubview:self.backDarkView];
  [self addSubview:self.containerView];
  [self addSubview:self.textLabel];
}
- (void)setToastText:(NSString *)toastText{
  _toastText = toastText;
  if (!toastText) {
    toastText = @"";
  }
  self.textLabel.text = toastText;
  CGFloat textHeight = [toastText boundingRectWithSize:(CGSize){containerWidth - 40, 300} options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:IWTFONTPFSCMedium(14)} context:nil].size.height;
  if (textHeight < 20.0) {
    textHeight = 20.0;
  }
  if (!CGPointEqualToPoint(self.showInPoint, CGPointZero)) {
    CGFloat pointX = self.showInPoint.x;
    if (pointX + containerWidth > self.bounds.size.width) {
      pointX = self.bounds.size.width - (pointX + containerWidth);
    }
    CGFloat pointY = self.showInPoint.y;
    if (pointY + textHeight + 20 > self.bounds.size.height) {
      pointY = self.bounds.size.height - (pointY + textHeight + 20);
    }
    [self.containerView setFrame:(CGRect){pointX, pointY, containerWidth, textHeight + 20}];
    [self.textLabel setFrame:(CGRect){pointX + 20, pointY + 10, containerWidth - 40, textHeight}];
  }else{
    [self.containerView setFrame:(CGRect){(self.bounds.size.width - containerWidth) / 2.0, (self.bounds.size.height - textHeight + 20) / 2.0, containerWidth, textHeight + 20}];
    [self.textLabel setFrame:(CGRect){(self.bounds.size.width - containerWidth) / 2.0 + 20, CGRectGetMinY(self.containerView.frame) + 10, containerWidth - 40, textHeight}];
  }
  
}

- (UILabel *)textLabel{
  if (!_textLabel) {
    _textLabel = [[UILabel alloc]init];
    _textLabel.textColor = UIColor.whiteColor;
    _textLabel.font = IWTFONTPFSCMedium(14.0);
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.numberOfLines = 0;
  }
  return _textLabel;
}
- (UIView *)backDarkView{
  if (!_backDarkView) {
    _backDarkView = [[UIView alloc]initWithFrame:(CGRect){0, 0, SCREEN_WIDTH, SCREEN_HEIGHT}];
    _backDarkView.backgroundColor = UIColor.blackColor;
    _backDarkView.alpha = 0;
  }
  return _backDarkView;
}
- (UIView *)containerView{
  if (!_containerView) {
    _containerView = [[UIView alloc]init];
    _containerView.backgroundColor = UIColor.blackColor;
    _containerView.alpha = 0.5;
    _containerView.layer.cornerRadius = 4;
  }
  return _containerView;
}


@end
