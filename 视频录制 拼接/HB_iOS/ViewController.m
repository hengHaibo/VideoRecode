//
//  ViewController.m
//  AWT_iOS
//
//  Created by wtoip_mac on 2019/10/25.
//  Copyright © 2019 wtoip_mac. All rights reserved.
//

#import "ViewController.h"
#import "AWTReleaseHomeViewController.h"



@interface ViewController ()




@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}

- (IBAction)release:(UIButton *)sender {
    
    AWTReleaseHomeViewController *releaseHome = [[AWTReleaseHomeViewController alloc]init];
    releaseHome.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    releaseHome.modalPresentationStyle = UIModalPresentationOverFullScreen;
    releaseHome.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
    [self presentViewController:releaseHome animated:NO completion:nil];
    
   
}




@end
