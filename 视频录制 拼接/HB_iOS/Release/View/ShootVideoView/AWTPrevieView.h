//
//  AWTPrevieView.h
//  AWT_iOS
//
//  Created by apple on 2019/10/27.
//  Copyright © 2019年 wtoip_mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol THPreviewViewDelegate <NSObject>

- (void)tappedToFocusAtPoint:(CGPoint)point;
- (void)tappedToExposeAtPoint:(CGPoint)point;
//重置对焦、曝光
- (void)tappedToResetFocusAndExposure;
@end


@interface AWTPrevieView : UIView

@property(nonatomic, strong)AVCaptureSession *session;

@property (weak, nonatomic) id<THPreviewViewDelegate> delegate;
@property (nonatomic) BOOL tapToFocusEnabled;

@property (nonatomic) BOOL tapToExposeEnabled;


@end


