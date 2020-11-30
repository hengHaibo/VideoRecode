//
//  DeviceDirection.m
//  AWT_iOS
//
//  Created by apple on 2019/11/2.
//  Copyright © 2019年 wtoip_mac. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,DeviceDirectionType){
    
    DeviceDirectionTypePortrait,
    DeviceDirectionTypeUpsideDown,
    DeviceDirectionTypeLandscapeLeft,
    DeviceDirectionTypeLandscapeRight
    
};

@interface DeviceDirection : NSObject

+(DeviceDirection *)share;

@property (nonatomic, copy) void (^deviceDirectionChangeBlock)(DeviceDirectionType direction);

@end
