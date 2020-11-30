//
//  User.h
//  iwutong
//
//  Created by wtoip_mac on 2019/11/7.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject<NSCoding>

@property (nonatomic , copy) NSString  *token;
@property (nonatomic , copy) NSString  *url;
@property (nonatomic , copy) NSString  *userName;
@property (nonatomic , copy) NSString  *nickName;

+(User *)getUser;

@end

NS_ASSUME_NONNULL_END
