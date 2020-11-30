//
//  HMDataModel.h
//  AWT_iOS
//
//  Created by wtoip_mac on 2019/10/28.
//  Copyright © 2019 wtoip_mac. All rights reserved.

#import <Foundation/Foundation.h>

@interface HMDataModel : NSObject
/* 状态码  */
@property (nonatomic,assign) NSNumber * code;
/* 描述  */
@property (nonatomic,copy) NSString *message;
/* 是否成功  */
@property (nonatomic,copy) NSString *success;

@end
