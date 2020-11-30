//
//  AWTPermissionsViewController.m
//  AWT_iOS
//
//  Created by wtoip_mac on 2019/11/4.
//  Copyright © 2019 wtoip_mac. All rights reserved.
//

#import "AWTPermissionsViewController.h"
#import "UIColor+Hex.h"

@interface AWTPermissionsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *microBtn;
@property (weak, nonatomic) IBOutlet UIButton *album;
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;

@end

@implementation AWTPermissionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.microBtn.layer addSublayer:[self setupButtonColorWithFrame:self.microBtn.bounds]];
    
    [self.microBtn.layer addSublayer:[self setupButtonColorWithFrame:self.microBtn.bounds]];
    
    [self.microBtn.layer addSublayer:[self setupButtonColorWithFrame:self.microBtn.bounds]];
    

}

- (IBAction)startPhoto:(UIButton *)sender {
    
}

- (IBAction)startMicro:(UIButton *)sender {
    
}

- (IBAction)startAlum:(UIButton *)sender {
    
}


- (IBAction)close:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:true completion:nil];
}


-(CALayer *)setupButtonColorWithFrame:(CGRect)frame{
    
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = frame;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.locations = @[@(0.0),@(1.0)];//渐变点
    [gradientLayer setColors:@[(id)[UIColor colorWithHexString:@"FFBF4E"].CGColor,(id)[UIColor colorWithHexString:@"FF2E6F"].CGColor]];//渐变数组
    return gradientLayer;
}

@end
