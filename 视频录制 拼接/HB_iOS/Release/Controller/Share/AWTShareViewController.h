//
//  AWTShareViewController.h
//  AWT_iOS
//
//  Created by wtoip_mac on 2019/11/5.
//  Copyright © 2019 wtoip_mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWTShareViewController : UIViewController

@property(nonatomic, strong)NSString *imageStr;

@property(nonatomic, assign)BOOL isVideo;//判断是哪个页面

@property(nonatomic, assign)BOOL isNetwork;

@property (nonatomic, strong) NSString *workid;

@end

NS_ASSUME_NONNULL_END
