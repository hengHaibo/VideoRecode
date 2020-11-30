//
//  AWTSendVideoViewController.h
//  AWT_iOS
//
//  Created by wtoip_mac on 2019/10/28.
//  Copyright © 2019 wtoip_mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWTSendVideoViewController : UIViewController

@property(nonatomic, copy) NSURL *videoUrl;
@property(nonatomic, strong)UIImage *image;

@end

NS_ASSUME_NONNULL_END
