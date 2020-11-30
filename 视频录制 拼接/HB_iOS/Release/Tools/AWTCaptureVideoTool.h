//
//  AWTCaptureVideoTool.h
//  AWT_iOS
//
//  Created by apple on 2019/10/26.
//  Copyright © 2019年 wtoip_mac. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWTCaptureVideoTool : NSObject

@property (nonatomic, strong, readonly) AVCaptureSession *captureSession;
//录制视频完成回调
@property (copy, nonatomic) void (^videoCompleteBlock)(NSURL *url);
@property (copy, nonatomic) void (^startRecord)(void);
//拍照回调
@property (copy, nonatomic) void (^picCompleteBlock)(UIImage *image);
//Session设置
- (BOOL)setupSession:(NSError **)error;
- (void)startSession;
- (void)stopSession;

//摄像头
- (BOOL)switchCameras;
- (BOOL)canSwitchCameras;

//拍照
- (void)captureStillImage;

//闪光灯和手电筒
@property (nonatomic, assign) BOOL cameraHasFlash;
@property (nonatomic, assign) BOOL cameraHasTorch;
@property (nonatomic) AVCaptureTorchMode torchMode;
@property (nonatomic) AVCaptureFlashMode flashMode;

//视频录制
- (void)startRecording;
- (void)stopRecording;
- (BOOL)isRecording;

//记录时间
- (CMTime)recordedDuration;

//焦点曝光
- (void)focusAtPoint:(CGPoint)point;
- (void)exposeAtPoint:(CGPoint)point;
//重置对焦、曝光模式 暂时没用
- (void)resetFocusAndExposureModes;



@end

NS_ASSUME_NONNULL_END
