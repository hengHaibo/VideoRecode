//
//  AWTVideoViewController.m
//  AWT_iOS
//
//  Created by wtoip_mac on 2019/10/25.
//  Copyright © 2019 wtoip_mac. All rights reserved.
//

#import "AWTVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AWTCaptureVideoTool.h"
#import "AWTPrevieView.h"
#import "AWTOverLayView.h"
#import "AWTPhotoView.h"
#import "ReactiveObjC.h"
#import "AWTVideoEditorTool.h"
#import "AWTNextViewController.h"
#import "UIView+AWTView.h"
#import "TZImagePickerController.h"
#import "AWTSendPhotoViewController.h"

#define Tem NSTemporaryDirectory()

@interface AWTVideoViewController ()<AWTOverLayViewDelegate, TZImagePickerControllerDelegate>
{
    NSInteger minutes;
    NSInteger seconds;
    CMTime cursorTime;
    CMTime totalTime;
}

@property (nonatomic, strong) AWTCaptureVideoTool *captureVideoTool;
@property (weak, nonatomic) IBOutlet AWTPrevieView *previewView;
@property (weak, nonatomic) IBOutlet AWTOverLayView *overlayView;
@property (nonatomic, strong) AWTPhotoView *photoView; //拍摄按钮
//拍摄的类型
@property (nonatomic, assign) CameraModel cameraModel;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) AWTVideoEditorTool *videoEditorTool;

@property (weak, nonatomic) IBOutlet UIButton *deleteVideoBtn;
@property (weak, nonatomic) IBOutlet UIButton *completeVideoBtn;

@property (weak, nonatomic) IBOutlet UILabel *tilmeL;
@property (nonatomic, strong)NSMutableArray *urlArray;
@property (nonatomic, copy)NSURL *videoPath;

@property (weak, nonatomic) IBOutlet UIButton *flashBtn;

@end

@implementation AWTVideoViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self removeFile];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.captureVideoTool startSession];
    self.deleteVideoBtn.hidden = true;
    self.completeVideoBtn.hidden = true;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

    [self.captureVideoTool stopSession];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    totalTime = kCMTimeZero;
    self.urlArray = [NSMutableArray arrayWithCapacity:5];
    self.videoEditorTool = [[AWTVideoEditorTool alloc]init];
    self.captureVideoTool = [[AWTCaptureVideoTool alloc] init];
    self.overlayView.delegate = self;
    self.deleteVideoBtn.hidden = true;
    self.completeVideoBtn.hidden = true;
    NSError *error;
    if ([self.captureVideoTool setupSession:&error] ) {
        [self.previewView setSession:self.captureVideoTool.captureSession];
        [self.captureVideoTool startSession];
    }else{
        NSLog(@"Error: %@", [error localizedDescription]);
    }
    
    [self bindPhotoBtn];
    
    [[NSNotificationCenter defaultCenter]addObserverForName:@"DeviceDegress" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSString *degress = note.userInfo[@"degress"];
        if ([degress isEqualToString:@"right"] || [degress isEqualToString:@"left"]) {

            [self.flashBtn transformVertical];
        }else{
            [self.flashBtn transformIdentity];
        }
    }];
    
}

-(void)bindPhotoBtn{
    //按钮按下
    @weakify(self);
    [[self.photoView.photoBTn rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [x setImage:[UIImage imageNamed:@"发布_摄像_长安摄像"] forState:UIControlStateNormal];
        self.deleteVideoBtn.hidden = true;
        self.completeVideoBtn.hidden = true;
        [self.captureVideoTool stopRecording];
        [self stopTimer];

        if (self.cameraModel == Video) {
            int progress = (int)floor(self.photoView.progress * 100);
            if (progress >= 100) {
                return ;
            }
            if (!self.captureVideoTool.isRecording) {
                dispatch_async(dispatch_queue_create("com.tapharmonic.kamera", NULL), ^{
                    [self.captureVideoTool startRecording];
                    [self startTimer];
                
                
                });
            }
        }
    }];
    //按钮点击
    [[self.photoView.photoBTn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
        @strongify(self);
        
        self.deleteVideoBtn.hidden = true;
        self.completeVideoBtn.hidden = true;
        [self stopTimer];
        [self.captureVideoTool stopRecording];
        if (self.cameraModel == Picture) {
            [self.captureVideoTool captureStillImage];
        }
    }];
    //按钮松开
    [[self.photoView.photoBTn rac_signalForControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside] subscribeNext:^(__kindof UIButton * _Nullable x) {
        @strongify(self);

        self.deleteVideoBtn.hidden = false;
        self.completeVideoBtn.hidden = false;
        if (self.cameraModel == Video) {
            int progress = (int)floor(self.photoView.progress * 100);
            //        NSLog(@"====pro==:%d",progress);
            if (progress >= 100) {
                
                [x setImage:[UIImage imageNamed:@"发布_完成"] forState: UIControlStateNormal];
            }else{
                [x setImage:[UIImage imageNamed:@"发布_摄像_暂停"] forState: UIControlStateNormal];
            }
            if (self.captureVideoTool.isRecording) {
                [self.captureVideoTool stopRecording];
                [self stopTimer];
                self->totalTime = self->cursorTime;
            }
        }else{
            self.captureVideoTool.picCompleteBlock = ^(UIImage * _Nonnull image) {
                AWTNextViewController *sendVideoUrl = [[AWTNextViewController alloc]init];
                sendVideoUrl.image = image;
                [self presentViewController:sendVideoUrl animated:true completion:nil];
            };
        }
       
        
    }];
    self.captureVideoTool.videoCompleteBlock = ^(NSURL * _Nonnull url) {
        @strongify(self);
        [self.urlArray addObject:url];
        
        [self.videoEditorTool mergeAndExportVideosAtFileURLs:self.urlArray completion:^(NSURL * _Nonnull outputPath) {
            
//            self.videoPath = [NSString stringWithFormat:@"%@", outputPath];
            self.videoPath = outputPath;
        }];
        
    };
    //完成按钮
    [[self.completeVideoBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
       @strongify(self);
        AWTNextViewController *sendVideoUrl = [[AWTNextViewController alloc]init];
        sendVideoUrl.videoUrl = self.videoPath;
        [self presentViewController:sendVideoUrl animated:true completion:nil];
    }];
    //删除按钮
    [[self.deleteVideoBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        int progress = (int)floor(self.photoView.progress * 100);
        if (progress >= 0) {
            self.photoView.progress = 0.0f;
            [self.photoView setNeedsDisplay];
            self.tilmeL.text = @"00:00";
            self.deleteVideoBtn.hidden = true;
            self.completeVideoBtn.hidden = true;
        }
        [self removeFile];
    }];
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos
{
    
    for (PHAsset *phAsset in assets) {
        NSLog(@"==location:%@",phAsset.location);
    }
    
    AWTSendPhotoViewController *photoVC = [[AWTSendPhotoViewController alloc]init];
    photoVC.photos = photos;
    [self presentViewController:photoVC animated:true completion:nil];
}

//删除文件
-(void)removeFile{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *dirPath = NSTemporaryDirectory();
    NSError *error;
    NSArray *contentArr = [fileManager contentsOfDirectoryAtPath:dirPath error:nil];
    for (NSString *path in contentArr) {
        BOOL success = [fileManager removeItemAtPath:[dirPath stringByAppendingString:path] error:&error];
        if (success) {
            NSLog(@"删除成功");
        }else{
            NSLog(@"=====删除失败===：%@",[error localizedDescription]);
        }
    }
}
/// AWTOverLayViewDelegate
-(void)clickButtonWithModel:(CameraModel)type{
    self.cameraModel = type;
    switch (type) {
        case Video://选中视频
        {
            self.photoView.progerssBackgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
            self.photoView.progerssColor = [UIColor whiteColor];
            
            if (self.photoView.progress > 0.0f) {
                self.deleteVideoBtn.hidden = false;
                self.completeVideoBtn.hidden = false;
            }else{
                self.deleteVideoBtn.hidden = true;
                self.completeVideoBtn.hidden = true;
            }
            
            [self.photoView setNeedsDisplay];
            [self.photoView.photoBTn setImage:[UIImage imageNamed:@"发布_摄像_摄影"] forState:UIControlStateNormal];
            
        }
            break;
        case Picture://选中照片
        {
            self.deleteVideoBtn.hidden = true;
            self.completeVideoBtn.hidden = true;
            self.photoView.progerssColor = [UIColor clearColor];
            self.photoView.progerssBackgroundColor = [UIColor clearColor];
            [self.photoView.photoBTn setImage:[UIImage imageNamed:@"发布_摄像_摄影"] forState:UIControlStateNormal];
            [self.photoView setNeedsDisplay];
        }
            break;
        case Photos://选中相册
        {
            self.deleteVideoBtn.hidden = true;
            self.completeVideoBtn.hidden = true;
            self.photoView.progerssColor = [UIColor clearColor];
            self.photoView.progerssBackgroundColor = [UIColor clearColor];
            [self.photoView.photoBTn setImage:[UIImage imageNamed:@"发布_摄像_摄影"] forState:UIControlStateNormal];
            [self.photoView setNeedsDisplay];
            
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
            imagePickerVc.showSelectedIndex = true;
            imagePickerVc.photoPickerPageUIConfigBlock = ^(UICollectionView *collectionView, UIView *bottomToolBar, UIButton *previewButton, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel, UIView *divideLine) {
                bottomToolBar.hidden = true;
            };
            imagePickerVc.allowPickingVideo = false;
            imagePickerVc.allowPickingImage = true;
            imagePickerVc.sortAscendingByModificationDate = false;
            
            [self presentViewController:imagePickerVc animated:YES completion:nil];
            
        }
            break;
        default:
            break;
    }
}

//翻转摄像头
- (IBAction)swapCameras:(id)sender {

    if (self.cameraModel == Photos) {
        return;
    }
    if([self.captureVideoTool switchCameras]){
        if (self.cameraModel == Picture) {
            self.captureVideoTool.cameraHasFlash = false;
        } else {
            self.captureVideoTool.cameraHasTorch = false;
        }
    }else{
        if (self.cameraModel == Picture) {
            self.captureVideoTool.cameraHasFlash = true;
        } else {
            self.captureVideoTool.cameraHasTorch = true;
        }
    }
}
- (IBAction)closeVC:(UIButton *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
//闪光灯
- (IBAction)flash:(UIButton *)sender {
    [sender sendActionsForControlEvents:UIControlEventValueChanged];
    if (self.cameraModel == Photos) {
        return;
    }
    sender.selected = !sender.selected;
    if (self.cameraModel == Picture) {
        self.captureVideoTool.flashMode = sender.selected;
    }else if (self.cameraModel == Video){
        self.captureVideoTool.torchMode = sender.selected;
    }
}

- (void)startTimer {
    [self.timer invalidate];
    self.timer = [NSTimer timerWithTimeInterval:1
                                         target:self
                                       selector:@selector(updateTimeDisplay)
                                       userInfo:nil
                                        repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)updateTimeDisplay {
    cursorTime = self.captureVideoTool.recordedDuration;
    CMTime totaltime = CMTimeAdd(totalTime, cursorTime);
    NSUInteger time = (NSUInteger)CMTimeGetSeconds(totaltime);
    minutes = (time / 60) % 60 + minutes;
    seconds = time % 60 ;
    self.photoView.progress += 0.01/6;
    NSString *format = @"%02i:%02i";
    NSString *timeString = [NSString stringWithFormat:format, minutes, seconds];
    self.tilmeL.text = timeString;

}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


@end
