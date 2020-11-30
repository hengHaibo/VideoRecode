//
//  CommonModule.m
//  iwutong
// 通用桥接类
//  Created by ronggang on 2019/10/31.
//  Copyright © 2019 Facebook. All rights reserved.
// RCT_EXPORT_METHOD 可导出方法
// 第一个参数为方法名
// 后面的参数
////

#import "CommonModule.h"
#import <StoreKit/StoreKit.h>
#import <React/RCTEventDispatcher.h>

@implementation CommonModule

// @synthesize bridge = _bridge;

RCT_EXPORT_MODULE(Common);

/**
（1）必须使用单例
（2）必须复写alloczone
 */
+(id)allocWithZone:(NSZone *)zone {
  static CommonModule *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [super allocWithZone:zone];
  });
  return sharedInstance;
}

- (NSArray<NSString *> *)supportedEvents { //所有需要调用的方法名
    return @[@"goToPage", @"acceptAppleInfo"];
}


-(void)startObserving{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptAppleInfo:) name:@"acceptAppleInfo" object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushCunZheng:) name:@"pushCunzheng" object:nil];
  
  [[NSNotificationCenter defaultCenter]addObserverForName:@"pushDetail" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
    NSDictionary *dic = note.userInfo;
    [self sendEventWithName:@"goToPage" body:dic];
  }];
}

- (void)pushCunZheng:(NSNotification *)noti{
  
  dispatch_async(dispatch_get_main_queue(), ^{
    [self sendEventWithName:@"goToPage" body:@{@"pageName":@"SaveEvidence"}];
  });
  
}

- (void)acceptAppleInfo:(NSNotification *)notification
{
  dispatch_async(dispatch_get_main_queue(), ^{
    [self sendEventWithName:@"acceptAppleInfo" body:@{@"userId":notification.userInfo[@"userId"],@"token":notification.userInfo[@"token"]}];
  });
}
/**
 获取app版本号
 */
RCT_EXPORT_METHOD(getAppVersion:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
{
  NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
  NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
  
  
  
  resolve(app_Version);
}

/**
 跳转appstore商店
 packageName  对应的id ，id+write-review 可跳转至评论页
 */
RCT_EXPORT_METHOD(goAppShop:(NSString *)packageName)
{
  if([packageName hasSuffix:@"write-review"]){// app评分
    // 10.3x以及以上的系统可以直接唤起评论
    if (@available(iOS 10.3, *)) {
        if ([SKStoreReviewController respondsToSelector:@selector(requestReview)]){
            //防止键盘遮挡
            [[UIApplication sharedApplication].keyWindow endEditing:YES];
            // iOS10.3+ 直接在App内弹出评分框
            // 此方式苹果允许的调用频率为3次/年
            [SKStoreReviewController requestReview];
        }
    }else {// 10.3以下的d跳转至应用商店
        NSString *appStoreReviewStr = [NSString stringWithFormat:@"%@%@%@", @"itms-apps://itunes.apple.com/app/id", packageName, @"?action=write-review"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreReviewStr]];
    }
  }else{ //单纯跳转应用商店
    NSString *appStoreReviewStr = [NSString stringWithFormat:@"%@%@", @"itms-apps://itunes.apple.com/app/id", packageName];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreReviewStr]];
  }
    
}

//-(void)test:(NSString *) pageName{
//  [self sendEventWithName:@"goToPage" body:pageName];
//}
@end
