//
//  AWTCaptureVideoTool.m
//  AWT_iOS
//
//  Created by apple on 2019/10/26.
//  Copyright © 2019年 wtoip_mac. All rights reserved.
//

#import "AWTCaptureVideoTool.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "NSFileManager+Additions.h"
#import "DeviceDirection.h"

@interface AWTCaptureVideoTool()<AVCaptureFileOutputRecordingDelegate>

@property (strong,nonatomic) AVCaptureSession *captureSession;//负责输入和输出设置之间的数据传递
@property (strong,nonatomic) AVCaptureDeviceInput *activeVideoInput;//负责从AVCaptureDevice获得输入数据
@property (strong,nonatomic) AVCaptureMovieFileOutput *movieOutput;//视频输出流
@property (strong, nonatomic) AVCaptureStillImageOutput *imageOutput;//图片输出
@property (copy, nonatomic) NSURL *outputURL;


@property (nonatomic, strong) NSString * degress;

@end

@implementation AWTCaptureVideoTool

-(instancetype)init{
    if (self = [super init]) {
        
        
        [[NSNotificationCenter defaultCenter]addObserverForName:@"DeviceDegress" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            
            self.degress = note.userInfo[@"degress"];

        }];
        
        
    }
    return self;
}

- (BOOL)setupSession:(NSError **)error {
    
    self.captureSession = [[AVCaptureSession alloc] init];
    self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    AVCaptureDevice *videoDevice =
    [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *videoInput =
    [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:error];
    if (videoInput) {
        if ([self.
             captureSession canAddInput:videoInput]) {
            [self.captureSession addInput:videoInput];
            self.activeVideoInput = videoInput;
        }
    } else {
        return NO;
    }
    AVCaptureDevice *audioDevice =
    [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    AVCaptureDeviceInput *audioInput =
    [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:error];
    if (audioInput) {
        if ([self.captureSession canAddInput:audioInput]) {
            [self.captureSession addInput:audioInput];
        }
    } else {
        return NO;
    }

    self.imageOutput = [[AVCaptureStillImageOutput alloc] init];
    self.imageOutput.outputSettings = @{AVVideoCodecKey : AVVideoCodecJPEG};
    if ([self.captureSession canAddOutput:self.imageOutput]) {
        [self.captureSession addOutput:self.imageOutput];
    }
    self.movieOutput = [[AVCaptureMovieFileOutput alloc] init];             
    if ([self.captureSession canAddOutput:self.movieOutput]) {
        [self.captureSession addOutput:self.movieOutput];
    }
    
    return YES;
}
//异步开启会话
- (void)startSession{
    if (![self.captureSession isRunning]) {
        dispatch_async([self globalQueue], ^{
            [self.captureSession startRunning];
        });
    }
}
- (dispatch_queue_t)globalQueue {
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}
- (void)stopSession{
    if ([self.captureSession isRunning]) {                                  
        dispatch_async([self globalQueue], ^{
            [self.captureSession stopRunning];
        });
    }
}

//摄像头
- (BOOL)canSwitchCameras {
    return self.cameraCount > 1;
}

- (NSUInteger)cameraCount {
    return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
}

- (BOOL)switchCameras {
    
    if (![self canSwitchCameras]) {
        return NO;
    }
    
    NSError *error;
    AVCaptureDevice *videoDevice = [self inactiveCamera];
    AVCaptureDeviceInput *videoInput =
    [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    
    if (videoInput) {
        [self.captureSession beginConfiguration];
        //移除之前的input
        [self.captureSession removeInput:self.activeVideoInput];
        if ([self.captureSession canAddInput:videoInput]) {
            //添加新的
            [self.captureSession addInput:videoInput];
            self.activeVideoInput = videoInput;
        } else {
            [self.captureSession addInput:self.activeVideoInput];
        }
        [self.captureSession commitConfiguration];
        
    } else {
        NSLog(@"==%s====%@",__func__,error);
        return NO;
    }
    
    return YES;
}
- (AVCaptureDevice *)inactiveCamera {
    AVCaptureDevice *device = nil;
    if (self.cameraCount > 1) {
        if (self.activeVideoInput.device.position == AVCaptureDevicePositionBack) {
            device = [self cameraWithPosition:AVCaptureDevicePositionFront];
        } else {
            device = [self cameraWithPosition:AVCaptureDevicePositionBack];
        }
    }
    return device;
}
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}
#pragma mark - 拍照
- (void)captureStillImage {
    
    AVCaptureConnection *connection =
    [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
    
    if (connection.isVideoOrientationSupported) {
        if ([self.degress isEqualToString:@"right"]) {
            connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
        }else if ([self.degress isEqualToString:@"down"]){
            connection.videoOrientation = AVCaptureVideoOrientationPortrait;
        }else if ([self.degress isEqualToString:@"up"]){
            connection.videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
        }else if ([self.degress isEqualToString:@"left"]){
            connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
        }
    }
    
    id handler = ^(CMSampleBufferRef sampleBuffer, NSError *error) {
        if (sampleBuffer != NULL) {
            
            NSData *imageData =
            [AVCaptureStillImageOutput
             jpegStillImageNSDataRepresentation:sampleBuffer];
            
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            [library writeImageToSavedPhotosAlbum:image.CGImage
                                      orientation:(NSInteger)image.imageOrientation
                                  completionBlock:^(NSURL *assetURL, NSError *error) {
                                      NSLog(@"写入完成=====：%@",assetURL);
                                      if (!error) {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              if (self.picCompleteBlock) {
                                                  self.picCompleteBlock(image);
                                              }
                                              
                                          });
                                          
                                      } else {
                                          id message = [error localizedDescription];
                                          NSLog(@"Error: %@", message);
                                      }
                                  }];
            
        } else {
            NSLog(@"NULL sampleBuffer: %@", [error localizedDescription]);
        }
    };
    [self.imageOutput captureStillImageAsynchronouslyFromConnection:connection  completionHandler:handler];
}

#pragma mark - 视频录制
- (void)startRecording {
    
    if (![self isRecording]) {
        
        AVCaptureConnection *videoConnection =
        [self.movieOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([videoConnection isVideoOrientationSupported]) {
            if ([self.degress isEqualToString:@"right"]) {
                videoConnection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
            }else if ([self.degress isEqualToString:@"down"]){
                videoConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
            }else if ([self.degress isEqualToString:@"up"]){
                videoConnection.videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
            }else if ([self.degress isEqualToString:@"left"]){
                videoConnection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
            }
        }
        if ([videoConnection isVideoStabilizationSupported]) {
            videoConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
        
        AVCaptureDevice *device = [self activeCamera];
        
        if (device.isSmoothAutoFocusSupported) {
            NSError *error;
            if ([device lockForConfiguration:&error]) {
                device.smoothAutoFocusEnabled = NO;
                [device unlockForConfiguration];
            } else {
                NSLog(@"==%s====%@",__func__,error);
            }
        }
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *dirPath =
        [fileManager temporaryDirectoryWithTemplateString:@"AWT.XXXXXX"];
        
        if (dirPath) {
            NSString *filePath =
            [dirPath stringByAppendingPathComponent:@"kamera_movie.mov"];
            self.outputURL = [NSURL fileURLWithPath:filePath];
        }
        [self.movieOutput startRecordingToOutputFileURL:self.outputURL
                                      recordingDelegate:self];
        
    }
}


- (AVCaptureDevice *)activeCamera {
    return self.activeVideoInput.device;
}
- (void)stopRecording{
    if ([self isRecording]) {
        [self.movieOutput stopRecording];
    }
}
- (BOOL)isRecording{
    return self.movieOutput.isRecording;
}
- (CMTime)recordedDuration{
    return self.movieOutput.recordedDuration;
}
- (AVCaptureVideoOrientation)currentVideoOrientation {
    
    AVCaptureVideoOrientation orientation;
    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    switch (deviceOrientation) {
       
        case UIDeviceOrientationFaceDown:
            orientation = AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
           
            orientation = AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationLandscapeLeft:
            orientation = AVCaptureVideoOrientationLandscapeRight;
            break;
        case UIDeviceOrientationLandscapeRight:
            orientation = AVCaptureVideoOrientationLandscapeLeft;
            break;
        default:
            orientation = AVCaptureVideoOrientationPortrait;
            break;
    }
    return orientation;
}
#pragma mark - AVCaptureFileOutputRecordingDelegate
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections{
    NSLog(@"开始录制...");
}
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput
didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
      fromConnections:(NSArray *)connections
                error:(NSError *)error {
    NSLog(@"视频录制完成.");
       self.videoCompleteBlock(self.outputURL);
}
#pragma mark - 焦点曝光
- (void)focusAtPoint:(CGPoint)point{
    AVCaptureDevice *device = [self activeCamera];
    if (device.isFocusPointOfInterestSupported &&
        [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            device.focusPointOfInterest = point;
            device.focusMode = AVCaptureFocusModeAutoFocus;
            [device unlockForConfiguration];
        } else {
            NSLog(@"==%s====%@",__func__,error);
        }
    }
}

static const NSString *THCameraAdjustingExposureContext;
- (void)exposeAtPoint:(CGPoint)point{
    
    AVCaptureDevice *device = [self activeCamera];
    AVCaptureExposureMode exposureMode =
    AVCaptureExposureModeContinuousAutoExposure;
    if (device.isExposurePointOfInterestSupported &&
        [device isExposureModeSupported:exposureMode]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            device.exposurePointOfInterest = point;
            device.exposureMode = exposureMode;
            
            if ([device isExposureModeSupported:AVCaptureExposureModeLocked]) {
                [device addObserver:self
                         forKeyPath:@"adjustingExposure"
                            options:NSKeyValueObservingOptionNew
                            context:&THCameraAdjustingExposureContext];
            }
            
            [device unlockForConfiguration];
        } else {
            NSLog(@"==%s====%@",__func__,error);
        }
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if (context == &THCameraAdjustingExposureContext) {
        AVCaptureDevice *device = (AVCaptureDevice *)object;
        if (!device.isAdjustingExposure &&
            [device isExposureModeSupported:AVCaptureExposureModeLocked]) {
            
            [object removeObserver:self
                        forKeyPath:@"adjustingExposure"
                           context:&THCameraAdjustingExposureContext];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error;
                if ([device lockForConfiguration:&error]) {
                    device.exposureMode = AVCaptureExposureModeLocked;
                    [device unlockForConfiguration];
                } else {
                    NSLog(@"==%s====%@",__func__,error);
                }
            });
        }
        
    } else {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}
#pragma mark - 重置对焦、曝光模式
- (void)resetFocusAndExposureModes {
    
    AVCaptureDevice *device = [self activeCamera];
    AVCaptureExposureMode exposureMode =
    AVCaptureExposureModeContinuousAutoExposure;
    
    AVCaptureFocusMode focusMode = AVCaptureFocusModeContinuousAutoFocus;
    
    BOOL canResetFocus = [device isFocusPointOfInterestSupported] &&
    [device isFocusModeSupported:focusMode];
    BOOL canResetExposure = [device isExposurePointOfInterestSupported] &&
    [device isExposureModeSupported:exposureMode];
    
    CGPoint centerPoint = CGPointMake(0.5f, 0.5f);
    NSError *error;
    if ([device lockForConfiguration:&error]) {
        
        if (canResetFocus) {
            device.focusMode = focusMode;
            device.focusPointOfInterest = centerPoint;
        }
        
        if (canResetExposure) {
            device.exposureMode = exposureMode;
            device.exposurePointOfInterest = centerPoint;
        }
        
        [device unlockForConfiguration];
        
    } else {
       NSLog(@"==%s====%@",__func__,error);
    }
}
#pragma mark - 闪光灯
- (BOOL)cameraHasFlash {
    return [[self activeCamera] hasFlash];
}

- (AVCaptureFlashMode)flashMode {
    return [[self activeCamera] flashMode];
}

- (void)setFlashMode:(AVCaptureFlashMode)flashMode {
    
    AVCaptureDevice *device = [self activeCamera];
    
    if (device.flashMode != flashMode &&
        [device isFlashModeSupported:flashMode]) {
        
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            device.flashMode = flashMode;
            [device unlockForConfiguration];
        } else {
           
        }
    }
}

- (BOOL)cameraHasTorch {
    return [[self activeCamera] hasTorch];
}

- (AVCaptureTorchMode)torchMode {
    return [[self activeCamera] torchMode];
}

- (void)setTorchMode:(AVCaptureTorchMode)torchMode {
    
    AVCaptureDevice *device = [self activeCamera];
    
    if (device.torchMode != torchMode &&
        [device isTorchModeSupported:torchMode]) {
        
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            device.torchMode = torchMode;
            [device unlockForConfiguration];
        } else {
            
        }
    }
}


//判断视频的方向
- (int)degressFromVideoFileWithAsset:(AVAsset *)asset {
    int degress = 0;
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
            // Portrait
            degress = 90;
        } else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
            // PortraitUpsideDown
            degress = 270;
        } else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
            // LandscapeRight
            degress = 0;
        } else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
            // LandscapeLeft
            degress = 180;
        }
    }
    return degress;
}

@end
