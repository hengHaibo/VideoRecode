//
//  AWTSendPhotoViewController.h
//  AWT_iOS
//
//  Created by apple on 2019/11/3.
//  Copyright © 2019年 wtoip_mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWTSendPhotoViewController : UIViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topH;
@property(nonatomic, strong)NSArray<UIImage *> *photos;
@property(nonatomic, strong)NSArray *assets;
@end

NS_ASSUME_NONNULL_END
