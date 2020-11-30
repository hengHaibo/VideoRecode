//
//  AWTSendVideoViewController.m
//  AWT_iOS
//
//  Created by wtoip_mac on 2019/10/28.
//  Copyright © 2019 wtoip_mac. All rights reserved.
//

#import "AWTSendVideoViewController.h"
#import "AWTShareViewController.h"
#import "AWTVideoEditorTool.h"
#import <AVFoundation/AVFoundation.h>
#import "AWTSendVideoTextView.h"
//#import "IQKeyboardManager.h"
#import "UIView+Layout.h"
#import "User.h"
#import "HMHttpTool.h"
#import "AWTShareViewController.h"
#import "AWTArchiveModelViewModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "IWTAlertView.h"

@interface AWTSendVideoViewController ()<UITextViewDelegate>
{
  AVPlayerItem *item;
}

@property (nonatomic, strong)AWTVideoEditorTool *videoEditorTool;
@property (weak, nonatomic) IBOutlet UIView *sendVideoVackView;
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet AWTSendVideoTextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topH;

@property (strong, nonatomic) AVPlayer *avPlayer;
@property (weak, nonatomic) IBOutlet UIImageView *pic;

@property (nonatomic, copy) NSDictionary *params;
@property (nonatomic, copy)NSString *fileUrl;
@property (nonatomic, copy)NSString *mediaPreview;
@property (nonatomic, copy)NSString *imagefileUrl;
@property (nonatomic, copy)NSString *outputPath;
@end

@implementation AWTSendVideoViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
  
  [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
//    [IQKeyboardManager sharedManager].enable = NO;
//    [IQKeyboardManager sharedManager].enableAutoToolbar = false;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
  [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];

}

-(void)awakeFromNib{
  [super awakeFromNib];
  self.sendBtn.layer.cornerRadius = 20;
  self.sendBtn.layer.masksToBounds = true;
//  self.sendBtn.enabled = false;
}
- (void)viewDidLoad {
    [super viewDidLoad];

  if (!@available(iOS 11.0, *)) {
    self.topH.constant = 20;
  }

  self.textView.delegate = self;
  self.textView.placeholder = @"分享你的心情和故事吧～";
  
    self.sendBtn.layer.cornerRadius = 20;
    self.sendBtn.layer.masksToBounds = true;
    self.videoEditorTool = [[AWTVideoEditorTool alloc]init];
//  user.url = @"https://test-apiAWT.wtoip.com/";
  if (self.isNetwork == false) {
    
      self.videoView.hidden = false;
      self.playBtn.hidden = false;
      self.pic.hidden = true;
      int degrees = [self.videoEditorTool degressFromVideoFileWithUrl:self.firstVideoUrl];
    
    NSLog(@"====视频方向==:%d",degrees);

        [self setupView];
  }else{
    if ([self.archiveModel.worksUrl hasSuffix:@"jpg"] || [self.archiveModel.worksUrl hasSuffix:@"png"] ||
        [self.archiveModel.worksUrl hasSuffix:@"jpeg"] ||
        [self.archiveModel.worksUrl hasSuffix:@"JPEG"] ||
        [self.archiveModel.worksUrl hasSuffix:@"PNG"] ||
        [self.archiveModel.worksUrl hasSuffix:@"JPG"]) {
      self.videoView.hidden = true;
      self.playBtn.hidden = true;
      self.pic.hidden = false;
      [self.pic sd_setImageWithURL:[NSURL URLWithString:self.archiveModel.worksUrl] placeholderImage:nil];
    }else{
      
      self.videoView.hidden = false;
      self.playBtn.hidden = false;
      self.pic.hidden = true;
    }
    [self setupView];
  }
  
//   [self setupView];
  
}
-(void)videoPlayEnd{
  
  self.playBtn.hidden = false;
  [item seekToTime:kCMTimeZero];
  
}
- (IBAction)playVideo:(UIButton *)sender {
//    sender.hidden = true;
  
//  CGFloat progress;
  
    sender.hidden = true;
    sender.selected = true;
    [self.avPlayer play];
    
    
    CGFloat progress = CMTimeGetSeconds(self.avPlayer.currentItem.currentTime) / CMTimeGetSeconds(self.avPlayer.currentItem.duration);
    NSLog(@"======;%.2f",progress);

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [IWTAlertView hideLoadingView];
    [self.avPlayer pause];
  
}

- (void)setupView{
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: self.sendVideoVackView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10,10)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.sendVideoVackView.bounds;
    //赋值
    maskLayer.path = maskPath.CGPath;
    self.sendVideoVackView.layer.mask = maskLayer;
    
  
  if (self.isNetwork) {
    if ([self.archiveModel.worksUrl hasSuffix:@"jpg"] || [self.archiveModel.worksUrl hasSuffix:@"png"] ||
        [self.archiveModel.worksUrl hasSuffix:@"jpeg"]) {
    }else{
      item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.archiveModel.worksUrl]];
    }
  }else{
    item = [[AVPlayerItem alloc] initWithURL:self.videoUrl];
  }
  
  
    self.avPlayer = [[AVPlayer alloc] initWithPlayerItem:item];
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
  
 
    NSLog(@"====frame===:%@", NSStringFromCGRect(self.videoView.frame));
    layer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 340);
    NSLog(@"==layer==frame===:%@", NSStringFromCGRect(layer.frame));
    layer.backgroundColor = [UIColor blackColor].CGColor;
    layer.videoGravity = AVLayerVideoGravityResizeAspect;
//  showVodioLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //添加播放视图到self.view
    [self.videoView.layer addSublayer:layer];
    //视频播放
  
    [[NSNotificationCenter defaultCenter]
   
   addObserver:self
   
   selector:@selector(videoPlayEnd)
   
   name:AVPlayerItemDidPlayToEndTimeNotification
   
   object:nil];
  
}

- (IBAction)backView:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:true completion:nil];
  if (self.remallobjectsBlock) {
    self.remallobjectsBlock();
  }
  
  
}

//发布
- (IBAction)send:(UIButton *)sender {
  
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
  NSString *path = [doc stringByAppendingPathComponent:@"usr.archive"];
  User *user = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
//  user.url = @"https://test-apiAWT.wtoip.com/";
  NSString *sendUrl = [NSString stringWithFormat:@"%@works/publish",user.url];

  AWTShareViewController *vc = [[AWTShareViewController alloc]init];
  
//  [IWTAlertView showLoadingWithText:@"正在发布..."];
  
  vc.isVideo = true;
  if(self.isNetwork){
    
    if ([self.archiveModel.worksUrl hasSuffix:@"jpg"] || [self.archiveModel.worksUrl hasSuffix:@"png"] ||
        [self.archiveModel.worksUrl hasSuffix:@"jpeg"] ||
        [self.archiveModel.worksUrl hasSuffix:@"JPEG"] ||
        [self.archiveModel.worksUrl hasSuffix:@"PNG"] ||
        [self.archiveModel.worksUrl hasSuffix:@"JPG"]) {
      vc.imageStr = self.archiveModel.worksUrl;
    }else{
      vc.imageStr = self.archiveModel.mediaPreview;
    }
    NSString *videoHost = [NSString stringWithFormat:@"%@certificate/publish",user.url];
    NSDictionary *dic = @{@"certificateId":self.archiveModel.certificateId,
                          @"memberId":self.archiveModel.memberId,
                          @"worksDetails":self.textView.text.length > 0 ? self.textView.text : self.archiveModel.worksDetails
                          };
    [HMHttpTool post:videoHost params:dic success:^(NSDictionary *JSONDic) {
      [IWTAlertView hideLoadingView];
      NSInteger code = [JSONDic[@"code"] integerValue];
      NSLog(@"====----:%@",JSONDic);
      if (code == 200) {
          vc.isNetwork = true;
          NSDictionary *dic =  JSONDic[@"data"];
          vc.workid = dic[@"worksId"];
          [self presentViewController:vc animated:true completion:nil];
        
      }else{
        [IWTAlertView showWithText:JSONDic[@"message"] afterDely:1];

      }

    } failure:^(NSError *error) {

      [IWTAlertView hideLoadingView];
      [IWTAlertView showWithText:@"网络出小差，请稍后重试" afterDely:1];
    }];
  
  }else{
   
    NSString *videoHost = [NSString stringWithFormat:@"%@oss/uploadVideo",user.url];
    
    NSData *vedioData = [NSData dataWithContentsOfURL:self.videoUrl];
    
    
    [HMHttpTool postImgPath:videoHost params:nil isVideo:true fileData:vedioData success:^(NSDictionary *JSONDic) {
      NSInteger code = [JSONDic[@"code"] integerValue];
      if (code == 200) {
        NSDictionary *param = JSONDic[@"data"];
        self.fileUrl = param[@"fileUrl"];
        self.mediaPreview = param[@"fileImageUrl"];
        [self sendVideoWithVideourl:self.fileUrl imageStr:self.mediaPreview host:sendUrl controller:vc];
        
      }else{
        [IWTAlertView showWithText:JSONDic[@"message"] afterDely:1];
        [IWTAlertView hideLoadingView];
      }
      
    } failure:^(NSError *error) {
      [IWTAlertView showWithText:@"网络错误,请检查网络" afterDely:1];
      [IWTAlertView hideLoadingView];
    } progress:^(NSProgress *progress) {
      dispatch_async(dispatch_get_main_queue(), ^{
        
        [IWTAlertView showLoadingWithText:[NSString stringWithFormat:@"上传视频%@",progress.localizedDescription] view:self.view];
        
        NSLog(@"==prohress===:%@",progress.localizedDescription);
        if ([progress.localizedDescription isEqualToString:@"已完成 100%"]) {
           [IWTAlertView showLoadingWithText:@"开始发布视频" view:self.view];
        }
      });
    }];
    
  }
}
#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(AWTSendVideoTextView *)textView
{
    if (textView.hasText) { // textView.text.length
        textView.placeholder = @"";
        
    } else {
        textView.placeholder = @"分享你的心情和故事吧～";
        
    }
}

//发布视频
-(void)sendVideoWithVideourl:(NSString *)videourl imageStr:(NSString *)imageStr host:(NSString *)host controller:(AWTShareViewController *)vc{
  
  if (videourl.length > 0 && imageStr.length > 0) {
    NSDictionary *dic = @{@"fileList":@[@{@"fileUrl":videourl.length > 0 ? videourl : @"",
                                          @"isTop":@(0),
                                          @"remarks":@"",
                                          @"sort":@"0"
                                          }],
                          @"mediaPreview":imageStr.length > 0 ? imageStr : @"",
                          @"remarks":@"123",
                          @"worksDetails":self.textView.text.length > 0 ? self.textView.text : @"",
                          @"worksType":@(2)
                          };
    [HMHttpTool post:host params:dic success:^(NSDictionary *JSONDic) {
      NSInteger code = [JSONDic[@"code"] integerValue];
      [IWTAlertView hideLoadingView];
      if (code == 200) {
        [IWTAlertView hideLoadingView];
        [IWTAlertView showLoadingWithText:@"发布成功" view:self.view];

        
        vc.imageStr = [NSString stringWithFormat:@"https:%@",self.mediaPreview];
        NSDictionary *dic = JSONDic[@"data"];
        vc.workid = dic[@"worksId"] ;
        [self presentViewController:vc animated:true completion:^{
          [IWTAlertView hideLoadingView];
          
        }];
        
      }else{
        [IWTAlertView hideLoadingView];
        [IWTAlertView showWithText:JSONDic[@"用户尚未登录！"] afterDely:1];
      }
      
    } failure:^(NSError *error) {
      [IWTAlertView hideLoadingView];
      [IWTAlertView showWithText:@"网络出小差，请稍后重试" afterDely:1];
    }];
  }else{
    
    [IWTAlertView hideLoadingView];
    [IWTAlertView showWithText:@"网络出小差，请稍后重试" afterDely:1];
  }
}








@end
