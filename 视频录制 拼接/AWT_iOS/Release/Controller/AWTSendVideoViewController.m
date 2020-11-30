//
//  AWTSendVideoViewController.m
//  AWT_iOS
//
//  Created by wtoip_mac on 2019/10/28.
//  Copyright © 2019 wtoip_mac. All rights reserved.
//

#import "AWTSendVideoViewController.h"
#import "AWTVideoEditorTool.h"
#import <AVFoundation/AVFoundation.h>
#import "AWTSendVideoTextView.h"
#import "IQKeyboardManager.h"
#import "UIView+AWTView.h"

@interface AWTSendVideoViewController ()<UITextViewDelegate>

@property (nonatomic, strong)AWTVideoEditorTool *videoEditorTool;
@property (weak, nonatomic) IBOutlet UIView *sendVideoVackView;
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet AWTSendVideoTextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property (strong, nonatomic) AVPlayer *avPlayer;
@property (weak, nonatomic) IBOutlet UIImageView *pic;

@end

@implementation AWTSendVideoViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [IQKeyboardManager sharedManager].enable = NO;
//    [IQKeyboardManager sharedManager].enableAutoToolbar = false;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [IQKeyboardManager sharedManager].enable = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.sendBtn.layer.cornerRadius = 20;
    self.sendBtn.layer.masksToBounds = true;
    self.videoEditorTool = [[AWTVideoEditorTool alloc]init];
    if (self.videoUrl == nil) {
        self.pic.image = [self.videoEditorTool fixOrientation:self.image];
        self.videoView.hidden = true;
        self.playBtn.hidden = true;
        self.pic.hidden = false;
    }else{
        self.videoView.hidden = false;
        self.playBtn.hidden = false;
        self.pic.hidden = true;
        int degrees = [self.videoEditorTool degressFromVideoFileWithUrl:self.videoUrl];
        
        [self.videoEditorTool startExportVideoWithVideoAssetForMX:self.videoUrl degrees:degrees completion:^(NSString * _Nonnull outputPath) {
            
            self.videoUrl = [NSURL fileURLWithPath:outputPath];
            [self setupView];
        }];
    }
    
    
}
- (IBAction)playVideo:(UIButton *)sender {
    sender.hidden = true;
     [self.avPlayer play];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.avPlayer pause];
}
-(void)setupView{
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: self.sendVideoVackView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10,10)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.sendVideoVackView.bounds;
    //赋值
    maskLayer.path = maskPath.CGPath;
    self.sendVideoVackView.layer.mask = maskLayer;
    
    self.sendBtn.layer.cornerRadius = 20;
    self.sendBtn.layer.masksToBounds = true;
    
    self.textView.delegate = self;
    self.textView.placeholder = @"分享你的心情和故事吧～";
    
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:self.videoUrl];
    self.avPlayer = [[AVPlayer alloc] initWithPlayerItem:item];
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    NSLog(@"====frame===:%@", NSStringFromCGRect(self.videoView.frame));
    layer.frame = CGRectMake(0, 0, self.videoView.width, self.videoView.height);
    NSLog(@"==layer==frame===:%@", NSStringFromCGRect(layer.frame));
    layer.backgroundColor = [UIColor blackColor].CGColor;
    layer.videoGravity = AVLayerVideoGravityResizeAspect;
    //添加播放视图到self.view
    [self.videoView.layer addSublayer:layer];
    //视频播放
   
}

- (IBAction)backView:(UIButton *)sender {
    
    
    [self dismissViewControllerAnimated:true completion:nil];
}

//发布
- (IBAction)send:(UIButton *)sender {
    
    
    
    
}
#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(AWTSendVideoTextView *)textView
{
    if (textView.hasText) { // textView.text.length
        textView.placeholder = @"";
        
    } else {
        textView.placeholder = @"ws";
        
    }
}


@end
