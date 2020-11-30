//
//  AWTNextViewController.h
//  AWT_iOS
//
//  Created by wtoip_mac on 2019/11/4.
//  Copyright © 2019 wtoip_mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWTNextViewController : UIViewController

@property(nonatomic, copy)NSURL *firstVideoUrl;
@property(nonatomic, copy)NSURL *videoUrl;
@property(nonatomic, strong)UIImage *image;
@property(nonatomic, copy)void(^remallobjectsBlock)(void);

@end

NS_ASSUME_NONNULL_END
