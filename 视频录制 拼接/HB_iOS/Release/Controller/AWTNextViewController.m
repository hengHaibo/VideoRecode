//
//  AWTNextViewController.m
//  AWT_iOS
//
//  Created by wtoip_mac on 2019/11/4.
//  Copyright © 2019 wtoip_mac. All rights reserved.
//

#import "AWTNextViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AWTSendPhotoViewController.h"
#import "AWTVideoEditorTool.h"
#import "AWTSendVideoViewController.h"

@interface AWTNextViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UIView *vodeoView;
@property (strong, nonatomic) AVPlayer *avPlayer;
//@property (nonatomic,)
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topH;

@end

@implementation AWTNextViewController

-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
   [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
  if (!@available(iOS 11.0, *)) {
    self.topH.constant = 20;
  }
    AWTVideoEditorTool *videoEditorTool = [[AWTVideoEditorTool alloc]init];
    int degrees = [videoEditorTool degressFromVideoFileWithUrl:self.firstVideoUrl];
  
    if (self.videoUrl == nil) {
        self.pic.image = [videoEditorTool fixOrientation:self.image];
      self.pic.contentMode = UIViewContentModeScaleToFill;
        self.vodeoView.hidden = true;
        self.pic.hidden = false;
    }else{
        [videoEditorTool startExportVideoWithVideoAssetForMX:self.videoUrl degrees:degrees completion:^(NSString * _Nonnull outputPath) {
      
            self.videoUrl = [NSURL fileURLWithPath:outputPath];
            [self setupView];
        }];
        self.pic.hidden = true;
        self.vodeoView.hidden = false;
    }
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.avPlayer play];
}

-(void)setupView{
    
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:self.videoUrl];
    self.avPlayer = [[AVPlayer alloc] initWithPlayerItem:item];
  
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];

    layer.frame = CGRectMake(0, 0, self.vodeoView.frame.size.width, [UIScreen mainScreen].bounds.size.height - 120);
    
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.backgroundColor = [UIColor blackColor].CGColor;
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //添加播放视图到self.view
    [self.vodeoView.layer addSublayer:layer];
    //视频播放
    [self.avPlayer play];
    
}
- (IBAction)next:(UIButton *)sender {
  
  if (self.videoUrl == nil) {
    AWTSendPhotoViewController *senvideoVC = [[AWTSendPhotoViewController alloc]init];

    NSMutableArray *array = [NSMutableArray array];
    [array addObject:self.image];
    senvideoVC.photos = array.copy;
    
//    senvideoVC.image = self.image;
    [self presentViewController:senvideoVC animated:true completion:nil];
  }else{
    AWTSendVideoViewController *senvideoVC = [[AWTSendVideoViewController alloc]init];
    senvideoVC.videoUrl = self.videoUrl;
//    senvideoVC.image = self.image;
    [self presentViewController:senvideoVC animated:true completion:nil];
  }
  
    
}

- (IBAction)close:(UIButton *)sender {
  if (self.remallobjectsBlock) {
    self.remallobjectsBlock();
  }
  
    [self dismissViewControllerAnimated:true completion:nil];
}


@end
