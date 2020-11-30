//
//  DeviceDirection.m
//  AWT_iOS
//
//  Created by apple on 2019/11/2.
//  Copyright © 2019年 wtoip_mac. All rights reserved.
//

#import "DeviceDirection.h"
#import <UIKit/UIKit.h>

@interface DeviceDirection ()<UIAccelerometerDelegate>
@property (nonatomic, assign) DeviceDirectionType directionType;
@end

@implementation DeviceDirection

+(DeviceDirection *)share{
    
    static DeviceDirection *shareDirectionObjective = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        shareDirectionObjective = [[self alloc]init];
        
        
    });
    return shareDirectionObjective;

}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.directionType = DeviceDirectionTypePortrait;
        [self makeAccelerometer];
    }
    return self;
}

- (void)makeAccelerometer{

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    
    [[UIAccelerometer sharedAccelerometer]setDelegate:self];
    
#pragma clang diagnostic pop


}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
#pragma clang diagnostic pop
    
    UIAccelerationValue X =acceleration.x;
    UIAccelerationValue Y =acceleration.y;
    
    DeviceDirectionType directionType = DeviceDirectionTypePortrait;
    
    if ((Y<0)&&(fabs(Y)-fabs(X)>0.1)) {
        //home键在下方
        directionType = DeviceDirectionTypePortrait;
//        NSLog(@"down");
        
    } else if ((X>0)&&(fabs(X)-fabs(Y))>0.1) {
       // home键在左方
        directionType = DeviceDirectionTypeLandscapeLeft;
//        NSLog(@"left");
    } else if ((Y>0)&&(fabs(Y)-fabs(X)>0.1)) {
       // home键在上方
        directionType = DeviceDirectionTypeLandscapeRight;
//        NSLog(@"up");

    } else if ((X<0)&&(fabs(X)-fabs(Y)>0.1)) {
       //home键在右方
        directionType = DeviceDirectionTypeUpsideDown;
//        NSLog(@"right");
    }
    
    if (self.directionType != directionType) {
        self.directionType = directionType;
        if (self.deviceDirectionChangeBlock) {
            self.deviceDirectionChangeBlock(directionType);
        }
    }
    
    
}

@end
