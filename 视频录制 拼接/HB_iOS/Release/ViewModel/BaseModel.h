//
//  BaseModel.h
//  CoatingIndustryProgect
//
//  Created by apple on 2019/8/21.
//  Copyright © 2019年 zkyfios02. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseModel : NSObject


@property (nonatomic, strong) RACSubject *requestBeforeObject;
@property (nonatomic, strong) RACSubject *successObject;
@property (nonatomic, strong) RACSubject *failureObject;
@property (nonatomic, strong) RACSubject *errorObject;

@end

NS_ASSUME_NONNULL_END
