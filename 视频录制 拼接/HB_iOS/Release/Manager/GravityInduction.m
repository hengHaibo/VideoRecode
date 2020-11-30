//
//  GravityInduction.m
//  AWT_iOS
//
//  Created by wtoip_mac on 2019/10/28.
//  Copyright © 2019 wtoip_mac. All rights reserved.

#import "GravityInduction.h"
#import <CoreMotion/CoreMotion.h>

@interface GravityInduction ()

@property (nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation GravityInduction

-(CMMotionManager *)motionManager {
  if (_motionManager == nil) {
    _motionManager = [[CMMotionManager alloc] init];
  }
  return _motionManager;
}


- (void)startUpdateAccelerometerResult{
  if ([self.motionManager isAccelerometerAvailable] == YES) {
    [self.motionManager setAccelerometerUpdateInterval:0.06];
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error)
     {
       double x = accelerometerData.acceleration.x;
       double y = accelerometerData.acceleration.y;
       if (fabs(y) >= fabs(x))
       {
         if (y >= 1){
           //Down
           NSLog(@"Down");
         }
         if(y<= -1){
           //Portrait
           NSLog(@"Portrait");
         }
       }
       else
       {
         if (x >= 1){
           //Right
           NSLog(@"Right");
           
         }
         if(x<= -1){
           //Left
           NSLog(@"Left");
//           self.btnClick.backgroundColor =[UIColor yellowColor];
         }
       }
     }];
  }
}
- (void)dealloc
{
  _motionManager = nil;
}

@end
