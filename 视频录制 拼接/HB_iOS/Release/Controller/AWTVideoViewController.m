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
#import "UIView+Layout.h"
#import "TZImagePickerController.h"
#import "AWTSendPhotoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AWTSendVideoViewController.h"
#import "MBProgressHUD.h"
#import "IWTAlertView.h"
#define Tem NSTemporaryDirectory()

@interface AWTVideoViewController ()<AWTOverLayViewDelegate, TZImagePickerControllerDelegate>
{
  CMTime courseTime;
  CMTime totalTime;
}

@property (nonatomic, strong) AWTCaptureVideoTool *captureVideoTool;
@property (weak, nonatomic) IBOutlet AWTPrevieView *previewView;
@property (weak, nonatomic) IBOutlet AWTOverLayView *overlayView;
@property (nonatomic, strong) AWTPhotoView *photoView; //拍摄按钮
//拍摄的类型
@property (nonatomic, assign) CameraModel cameraModel;
//@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) AWTVideoEditorTool *videoEditorTool;

@property (weak, nonatomic) IBOutlet UIButton *deleteVideoBtn;
@property (weak, nonatomic) IBOutlet UIButton *completeVideoBtn;
@property (weak, nonatomic) IBOutlet UILabel *continueL;
@property (weak, nonatomic) IBOutlet UIImageView *continueImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topH;
@property (weak, nonatomic) IBOutlet UIView *timeBackView;
@property(nonatomic,strong)dispatch_source_t timer;

@property (weak, nonatomic) IBOutlet UILabel *tilmeL;
@property (nonatomic, strong)NSMutableArray *urlArray;
@property (nonatomic, copy)NSURL *videoPath;

@property (weak, nonatomic) IBOutlet UIButton *flasAWTtn;

@property(nonatomic, assign)BOOL isFirstOpenApp;

@end

@implementation AWTVideoViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
  
    [self.captureVideoTool startSession];
    [self removeFile];
}
- (void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  
  [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
  
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
  
  totalTime = kCMTimeZero;
  [[UIApplication sharedApplication] setStatusBarHidden:true withAnimation:UIStatusBarAnimationNone];
  [self.captureVideoTool startSession];
  self.deleteVideoBtn.hidden = true;
  self.completeVideoBtn.hidden = true;
  self.continueL.hidden = true;
  self.continueImageView.hidden = true;
  self.photoView.progress = 0.0f;
  [self.photoView setNeedsDisplay];
  self.tilmeL.text = @"00:00";
  
  if (self.cameraModel == Picture) {
    [self.photoView.photoBTn setImage:[UIImage imageNamed:@"发布_摄像_摄影"] forState:UIControlStateNormal];
  } else {
    [self.urlArray removeAllObjects];
    totalTime = kCMTimeZero;
    [self.photoView.photoBTn setImage:[UIImage imageNamed:@"发布_摄像_长安摄像"] forState:UIControlStateNormal];
  }
  if (self.cameraModel == Photos){
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Addpicnofi" object:self userInfo:@{@"addpicnofi":@"photos"}];
  }
  
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

    [self.captureVideoTool stopSession];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
    totalTime = kCMTimeZero;
    self.urlArray = [NSMutableArray array];
    self.videoEditorTool = [[AWTVideoEditorTool alloc]init];
    self.captureVideoTool = [[AWTCaptureVideoTool alloc] init];
    self.overlayView.delegate = self;
    self.deleteVideoBtn.hidden = true;
    self.completeVideoBtn.hidden = true;
    self.continueL.hidden = true;
    self.continueImageView.hidden = true;
  
    NSError *error;
    if ([self.captureVideoTool setupSession:&error] ) {
        [self.previewView setSession:self.captureVideoTool.captureSession];
        [self.captureVideoTool startSession];
    }else{
        NSLog(@"Error: %@", [error localizedDescription]);
    }
  
  //程序进入后台
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)name:UIApplicationWillResignActiveNotification object:nil];
    
    [self bindPhotoBtn];


}
-(void)applicationWillResignActive:(NSNotification *)notification
{
  NSLog(@"程序进入j后台");
  
  [self pauseRecored:self.photoView.photoBTn];

}
#pragma mark - 拍摄按钮

-(void)bindPhotoBtn{
    //按钮点击
  [self.photoView.photoBTn addTarget:self action:@selector(shootingAction:) forControlEvents:UIControlEventTouchUpInside];
  
    @weakify(self);
    self.captureVideoTool.videoCompleteBlock = ^(NSURL * _Nonnull url) {
        @strongify(self);
        [self.urlArray addObject:url];

        AVAsset *asset = [AVAsset assetWithURL:url];
        CMTime singleTime = asset.duration;
        self->totalTime = CMTimeAdd(self->totalTime, singleTime);
      NSLog(@"===总的时间==:%@====单个时间:%f",[NSValue valueWithCMTime:self->totalTime], ceil((NSUInteger)CMTimeGetSeconds(singleTime)));
      
    };
    //完成按钮
    [[self.completeVideoBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
       @strongify(self);

      MBProgressHUD *mbHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
      mbHUD.mode = MBProgressHUDModeIndeterminate;
      NSUInteger time = (NSUInteger)CMTimeGetSeconds(self->totalTime);
      if (time < 3) {

        [mbHUD hideAnimated:true afterDelay:0.1f];
        [IWTAlertView showWithText:@"录制时间不能小于3秒" afterDely:1];
        return;
      }
      mbHUD.label.text = @"正在合成视频...";
      
      
      if (self.urlArray.count > 1) {
        
        //多个视频拼接
        [self.videoEditorTool mergeAndExportVideosAtFileURLs:self.urlArray completion:^(NSURL * _Nonnull outputPath) {
          
          if (outputPath) {
            int degrees = [self.videoEditorTool degressFromVideoFileWithUrl:self.urlArray[0]];
            [self.videoEditorTool startExportVideoWithVideoAssetForMX:outputPath degrees:degrees completion:^(NSString * _Nonnull outputPath) {
              
              [IWTAlertView hideLoadingView];
              self.videoPath = [NSURL fileURLWithPath:outputPath];
              if (self.videoPath != nil && self.urlArray.count > 0) {
                ALAssetsLibrary *library=[[ALAssetsLibrary alloc]init];
                if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:self.videoPath]) {
                  ALAssetsLibraryWriteVideoCompletionBlock completionBlock;
                  completionBlock = ^(NSURL *assetURL, NSError *error){
                    if (error) {
                      NSLog(@"==%s====%@",__func__,error);
                    } else {
                    }
                  };
                  [library writeVideoAtPathToSavedPhotosAlbum:self.videoPath completionBlock:completionBlock];
                }
                AWTSendVideoViewController *senvideoVC = [[AWTSendVideoViewController alloc]init];
                senvideoVC.videoUrl = self.videoPath;
                senvideoVC.firstVideoUrl = self.urlArray[0];
                [mbHUD hideAnimated:true afterDelay:1.0f];
                senvideoVC.remallobjectsBlock = ^{
                  [self.urlArray removeAllObjects];
                };
                [self presentViewController:senvideoVC animated:true completion:^{
                  
                }];
              }
            }];
            
          } else {
            [mbHUD hideAnimated:true afterDelay:1.0f];
            [IWTAlertView showWithText:@"视频合成错误，请重新拍摄" afterDely:1];
          }
        }];
      } else {

        //一个视频只旋转
        int degrees = [self.videoEditorTool degressFromVideoFileWithUrl:self.urlArray[0]];
        [self.videoEditorTool startExportVideoWithVideoAssetForMX:self.urlArray[0] degrees:degrees completion:^(NSString * _Nonnull outputPath) {
          
          [IWTAlertView hideLoadingView];
          self.videoPath = [NSURL fileURLWithPath:outputPath];
          if (self.videoPath != nil && self.urlArray.count > 0) {
            ALAssetsLibrary *library=[[ALAssetsLibrary alloc]init];
            if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:self.urlArray[0]]) {
              ALAssetsLibraryWriteVideoCompletionBlock completionBlock;
              completionBlock = ^(NSURL *assetURL, NSError *error){
                if (error) {
                  NSLog(@"==%s====%@",__func__,error);
                } else {
                }
              };
              [library writeVideoAtPathToSavedPhotosAlbum:self.urlArray[0] completionBlock:completionBlock];
            }
            AWTSendVideoViewController *sendVideoUrl = [[AWTSendVideoViewController alloc]init];
            sendVideoUrl.firstVideoUrl = self.videoPath;
            sendVideoUrl.videoUrl = self.videoPath;
            [mbHUD hideAnimated:true afterDelay:1.0f];
            sendVideoUrl.remallobjectsBlock = ^{
              [self.urlArray removeAllObjects];
            };
            [self presentViewController:sendVideoUrl animated:true completion:^{
              [mbHUD hideAnimated:true afterDelay:1.0f];
            }];
          }
        }];
      }
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
          [self stopTimer];
          [self.captureVideoTool stopRecording];
          self.photoView.photoBTn.selected = false;
          [self.photoView.photoBTn setImage:[UIImage imageNamed:@"发布_摄像_长安摄像"] forState:UIControlStateNormal];
          totalTime = kCMTimeZero;
        }
        [self removeFile];
    }];
}
//拍摄按钮的点击
-(void)shootingAction:(UIButton *)x{
  
  self.deleteVideoBtn.hidden = true;
  self.completeVideoBtn.hidden = true;
  self.continueL.hidden = true;
  self.continueImageView.hidden = true;

  if (self.cameraModel == Video){
    
    if (self.photoView.progress >= 1.0f) {
      self.deleteVideoBtn.hidden = false;
      self.completeVideoBtn.hidden = false;
      [x setImage:[UIImage imageNamed:@"发布_完成"] forState: UIControlStateNormal];
      return ;
    }
    if (x.isSelected) {
      [self pauseRecored:x];
    }else{
      
      [x setImage:[UIImage imageNamed:@"发布_摄像_暂停"] forState: UIControlStateNormal];
      self.deleteVideoBtn.hidden = true;
      self.completeVideoBtn.hidden = true;
      self.continueL.hidden = true;
      self.continueImageView.hidden = true;
      int progress = (int)floor(self.photoView.progress * 100);
      if (progress >= 100) {
        return ;
      }
      if (!self.captureVideoTool.isRecording) {
       
        __weak typeof(self) weakSelf = self;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
         [self.captureVideoTool startRecording];
        });
      
        
        self.captureVideoTool.startRecord = ^{
          dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
          dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [weakSelf startTimer];
          });
        };
      }
      x.selected = true;
    }
  }else if(self.cameraModel == Picture) {
    [self.captureVideoTool captureStillImage];
    self.captureVideoTool.picCompleteBlock = ^(UIImage * _Nonnull image) {
      if (self.isPhotovc == true) {
        self.chooseImageBlock(image);
        [self dismissViewControllerAnimated:true completion:nil];
        return;
      }
      AWTSendPhotoViewController *senvideoVC = [[AWTSendPhotoViewController alloc]init];
      
      NSMutableArray *array = [NSMutableArray array];
      [array addObject:image];
      senvideoVC.photos = array.copy;
 
      [self presentViewController:senvideoVC animated:true completion:nil];
    };
  }else{
    self.captureVideoTool.picCompleteBlock = ^(UIImage * _Nonnull image) {
      if (self.isPhotovc == true) {
        self.chooseImageBlock(image);
        [self dismissViewControllerAnimated:true completion:nil];
        return;
      }
      AWTSendPhotoViewController *senvideoVC = [[AWTSendPhotoViewController alloc]init];
      
      NSMutableArray *array = [NSMutableArray array];
      [array addObject:image];
      senvideoVC.photos = array.copy;
      
      [self presentViewController:senvideoVC animated:true completion:nil];
    };
  }
}
//暂停录制
-(void)pauseRecored:(UIButton *)x{
  self.deleteVideoBtn.hidden = false;
  self.completeVideoBtn.hidden = false;
  self.continueL.hidden = false;
  self.continueImageView.hidden = false;
  int progress = (int)floor(self.photoView.progress * 100);
  if (progress >= 100) {
    
    [x setImage:[UIImage imageNamed:@"发布_完成"] forState: UIControlStateNormal];
  }else{
    [x setImage:[UIImage imageNamed:@"发布_摄像_暂停"] forState: UIControlStateNormal];
  }
  
  if (self.captureVideoTool.isRecording) {
    [self.captureVideoTool stopRecording];
    [self stopTimer];
  }
  
  x.selected = false;
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos
{
    
    for (PHAsset *phAsset in assets) {
        NSLog(@"==location:%@",phAsset.location);
    }
    
    AWTSendPhotoViewController *photoVC = [[AWTSendPhotoViewController alloc]init];
    photoVC.photos = photos;
    photoVC.assets = assets;
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
  
    switch (type) {
        case Video://选中视频
        {
          self.cameraModel = type;
           [self.photoView.photoBTn setImage:[UIImage imageNamed:@"发布_摄像_长安摄像"] forState:UIControlStateNormal];
            self.photoView.progerssBackgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
            self.photoView.progerssColor = [UIColor whiteColor];
          self.timeBackView.hidden = false;
            if (self.photoView.progress > 0.0f) {
              
              //说明是暂停中
              [self.photoView.photoBTn setImage:[UIImage imageNamed:@"发布_摄像_暂停"] forState:UIControlStateNormal];
              
                self.deleteVideoBtn.hidden = false;
                self.completeVideoBtn.hidden = false;
                self.continueL.hidden = false;
                self.continueImageView.hidden = false;
              
            }else{
                self.deleteVideoBtn.hidden = true;
                self.completeVideoBtn.hidden = true;
            }
            
            [self.photoView setNeedsDisplay];
        }
            break;
        case Picture://选中照片
        {
          self.cameraModel = type;
          if (self.captureVideoTool.isRecording) {
            [self.captureVideoTool stopRecording];
            [self stopTimer];
            self.photoView.photoBTn.selected = false;
          }
          
            self.deleteVideoBtn.hidden = true;
            self.completeVideoBtn.hidden = true;
            self.continueL.hidden = true;
            self.continueImageView.hidden = true;
            self.timeBackView.hidden = true;
            self.photoView.progerssColor = [UIColor clearColor];
            self.photoView.progerssBackgroundColor = [UIColor clearColor];
            [self.photoView.photoBTn setImage:[UIImage imageNamed:@"发布_摄像_摄影"] forState:UIControlStateNormal];
            [self.photoView setNeedsDisplay];
        }
            break;
        case Photos://选中相册
        {
          if (self.captureVideoTool.isRecording) {
            [self.captureVideoTool stopRecording];
            [self stopTimer];
            self.photoView.photoBTn.selected = false;
          }

            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self ];
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
  
//      [self.captureVideoTool startSession];
//      [self startTimer];
//        if (self.cameraModel == Picture) {
//            self.captureVideoTool.cameraHasFlash = false;
//        } else {
//            self.captureVideoTool.cameraHasTorch = false;
//        }
    }else{
//        if (self.cameraModel == Picture) {
//            self.captureVideoTool.cameraHasFlash = true;
//        } else {
//            self.captureVideoTool.cameraHasTorch = true;
//        }
    }
}
- (IBAction)closeVC:(UIButton *)sender {
  [self.captureVideoTool stopSession];
  [self.captureVideoTool stopRecording];
  [self stopTimer];
  [self.previewView removeFromSuperview];
  
  dispatch_async(dispatch_get_main_queue(), ^{

    [self dismissViewControllerAnimated:YES completion:nil];
  });
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
  dispatch_queue_t queue = dispatch_get_main_queue();
  dispatch_source_t timer = dispatch_source_create(&_dispatch_source_type_timer, 0, 0, queue);
  dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
  dispatch_source_set_event_handler(timer, ^{
//    NSLog(@"当前的线程为==:%@",[NSThread currentThread]);
    [self updateTimeDisplay];
  });
  
  dispatch_resume(timer);
  
  _timer = timer;
}
- (void)stopTimer {
  if (_timer) {
    dispatch_source_cancel(_timer);
    _timer = nil;
  }
}

- (void)updateTimeDisplay {

  CMTime duration = CMTimeAdd(totalTime, self.captureVideoTool.recordedDuration);
    NSUInteger time = ceil((NSUInteger)CMTimeGetSeconds(duration));
  if (time >= 30) {
    time = 30;
  }
//    NSInteger hours = (time / 3600);
    NSInteger minutes = (time / 60) % 60;

    NSInteger seconds = ceil(time % 60);
    NSString *format = @"%02i:%02i";
  
    NSString *timeString = [NSString stringWithFormat:format, minutes, seconds];
    self.tilmeL.text = timeString;
//  if (seconds >= 1) {
    self.photoView.progress += 0.01;
//  }

    if (self.photoView.progress >= 1.00f) {
      [self.photoView.photoBTn setImage:[UIImage imageNamed:@"发布_完成"] forState: UIControlStateNormal];
      [self.captureVideoTool stopRecording];
      [self stopTimer];
      self.completeVideoBtn.hidden = false;
      self.deleteVideoBtn.hidden = false;
      self.flasAWTtn.hidden = false;
    }else if(self.photoView.progress > 0 && self.photoView.progress < 1) {
        self.flasAWTtn.hidden = true;
    }else{
      self.flasAWTtn.hidden = false;
    }
}



@end
