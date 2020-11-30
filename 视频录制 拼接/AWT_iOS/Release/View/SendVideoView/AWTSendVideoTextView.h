//
//  AWTSendVideoTextView.h
//  AWT_iOS
//
//  Created by wtoip_mac on 2019/11/1.
//  Copyright © 2019 wtoip_mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWTSendVideoTextView : UITextView

/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;

@end

NS_ASSUME_NONNULL_END
