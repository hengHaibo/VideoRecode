//
//  IWTAlertView.h
//  iwutong
//
//  Created by 司晓鑫 on 2019/11/16.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

@interface IWTAlertView : UIView






+ (void)showLoadingWithText:(NSString *)text;


+ (void)hideLoadingView;


+ (void)showLoadingWithText:(NSString *)text view:(UIView *)view;


#pragma mark ---- 在屏幕上找一个point显示
/**
 toast框
 @param text xmsg
 @param time 消失的时间
 @param point 在屏幕上的位置
 */
+ (void)showWithText:(NSString*)text afterDely:(NSTimeInterval)time atPoint:(CGPoint)point;

#pragma mark ---- 默认显示在屏幕中间

+ (void)showWithText:(NSString*)text;//系统默认的2s结束
+ (void)showWithText:(NSString*)text afterDely:(NSTimeInterval)time;
+ (void)showWithText:(NSString *)text autoDismissAtDely:(NSTimeInterval)time complete:(dispatch_block_t)dismiss;
+ (void)dismissWithComplete:(dispatch_block_t)dismiss;

@end

NS_ASSUME_NONNULL_END
