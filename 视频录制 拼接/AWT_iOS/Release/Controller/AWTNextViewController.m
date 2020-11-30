//
//  AWTNextViewController.m
//  AWT_iOS
//
//  Created by wtoip_mac on 2019/11/4.
//  Copyright © 2019 wtoip_mac. All rights reserved.
//

#import "AWTNextViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+AWTView.h"
#import "AWTVideoEditorTool.h"
#import "AWTSendVideoViewController.h"

@interface AWTNextViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UIView *vodeoView;
@property (strong, nonatomic) AVPlayer *avPlayer;
//@property (nonatomic,)

@end

@implementation AWTNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AWTVideoEditorTool *videoEditorTool = [[AWTVideoEditorTool alloc]init];
    int degrees = [videoEditorTool degressFromVideoFileWithUrl:self.videoUrl];
    
    if (self.videoUrl == nil) {
        self.pic.image = [videoEditorTool fixOrientation:self.image];
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
    NSLog(@"====frame===:%@", NSStringFromCGRect(self.vodeoView.frame));
    layer.frame = CGRectMake(0, 0, self.vodeoView.width, self.vodeoView.height);
    NSLog(@"==layer==frame===:%@", NSStringFromCGRect(layer.frame));
    layer.backgroundColor = [UIColor blackColor].CGColor;
    layer.videoGravity = AVLayerVideoGravityResizeAspect;
    //添加播放视图到self.view
    [self.vodeoView.layer addSublayer:layer];
    //视频播放
    [self.avPlayer play];
    
}
- (IBAction)next:(UIButton *)sender {
    
    AWTSendVideoViewController *senvideoVC = [[AWTSendVideoViewController alloc]init];
    senvideoVC.videoUrl = self.videoUrl;
    senvideoVC.image = self.image;
    [self presentViewController:senvideoVC animated:true completion:nil];
    
}

- (IBAction)close:(UIButton *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}


@end
