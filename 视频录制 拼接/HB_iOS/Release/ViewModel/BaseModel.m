//
//  BaseModel.m
//  CoatingIndustryProgect
//
//  Created by apple on 2019/8/21.
//  Copyright © 2019年 zkyfios02. All rights reserved.
//

#import "BaseModel.h"
@implementation BaseModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.successObject = [RACSubject subject];
        self.failureObject = [RACSubject subject];
        self.errorObject = [RACSubject subject];
        self.requestBeforeObject = [RACSubject subject];
       
    }
    return self;
}



@end
