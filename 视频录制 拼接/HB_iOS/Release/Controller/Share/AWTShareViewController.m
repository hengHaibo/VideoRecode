//
//  AWTShareViewController.m
//  AWT_iOS
//
//  Created by wtoip_mac on 2019/11/5.
//  Copyright © 2019 wtoip_mac. All rights reserved.
//

#import "AWTShareViewController.h"
#import "AWTReleaseHomeViewController.h"
#import "AWTShareBtn.h"

#import "AWTVideoViewController.h"
#import "TZImagePickerController.h"


#import "User.h"


@interface AWTShareViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topH;
@property (weak, nonatomic) IBOutlet UIButton *lookDetail;


@end

@implementation AWTShareViewController

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
  [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//  [self setStatusBarBackgroundColor:[UIColor blackColor]];
}
-(void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
  [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
  
}
- (void)setStatusBarBackgroundColor:(UIColor*)color {
  UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
  if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
     statusBar.backgroundColor= color;
  }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
    if (!@available(iOS 11.0, *)) {
      self.topH.constant = 20;
    }
  self.lookDetail.layer.cornerRadius = 20.0;//2.0是圆角的弧度，根据需求自己更改
  self.lookDetail.layer.borderColor = [UIColor colorWithRed:255/255.0 green:78/255 blue:104/255 alpha:1.0f].CGColor;//设置边框颜色
  self.lookDetail.layer.borderWidth = 1.0f;//设置边框颜色
}

- (IBAction)jixu:(UIButton *)sender {
  
  AWTReleaseHomeViewController *releaseHome = [[AWTReleaseHomeViewController alloc]init];
  releaseHome.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
  releaseHome.modalPresentationStyle = UIModalPresentationOverFullScreen;
  releaseHome.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
  [self presentViewController:releaseHome animated:NO completion:nil];
}


- (IBAction)close:(UIButton *)sender {

  [self dismissViewControllerClass];

}
- (IBAction)cancle:(UIButton *)sender {
  
  [self dismissViewControllerClass];
}

- (void)dismissViewControllerClass{
  UIViewController *vc = self;
  while(vc.presentingViewController){
    vc = vc.presentingViewController;
  }
  [vc dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)wx:(AWTShareBtn *)sender {
  
//  [self shareType:UMSocialPlatformType_WechatSession];
}
- (IBAction)pengyouquan:(AWTShareBtn *)sender {
//  [self shareType:UMSocialPlatformType_WechatTimeLine];

}
- (IBAction)sina:(AWTShareBtn *)sender {
//   [self shareType:UMSocialPlatformType_Sina];
 
}
- (IBAction)qq:(AWTShareBtn *)sender {
  
//  [self shareType:UMSocialPlatformType_QQ];
}

- (IBAction)workDetai:(UIButton *)sender {
  
  NSDictionary *diuc= @{@"pageName":@"ProductDetail",
                        @"param":@{@"worksId":self.workid}};
  [[NSNotificationCenter defaultCenter]postNotificationName:@"pushDetail" object:self userInfo:diuc];
  [self dismissViewControllerClass];
  
}


- (IBAction)lijicunzheng:(UIButton *)sender {
  
  [[NSNotificationCenter defaultCenter]postNotificationName:@"pushCunzheng" object:self userInfo:nil];
  
  [self dismissViewControllerClass];
}

@end
