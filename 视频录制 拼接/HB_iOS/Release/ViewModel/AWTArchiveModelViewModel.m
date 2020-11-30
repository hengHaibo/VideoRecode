//
//  CardHolderListModel.m
//  CoatingIndustryProgect
//
//  Created by apple on 2019/8/21.
//  Copyright © 2019年 zkyfios02. All rights reserved.
//

#import "AWTArchiveModelViewModel.h"
#import "HMHttpTool.h"
#import "MJExtension.h"

@implementation AWTArchiveModelViewModel

-(instancetype)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    [[RACObserve(self, page) filter:^BOOL(NSNumber* value) {
        return value.integerValue != 0;
    }]subscribeNext:^(id  _Nullable x) {
        [self getGoodsList:[x integerValue]];
    }];
}
- (void)getGoodsList:(NSInteger)page {
 
 
    
}



@end


@implementation AWTArchiveModel



@end
