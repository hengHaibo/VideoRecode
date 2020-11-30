//
//  CardHolderListModel.h
//  CoatingIndustryProgect
//
//  Created by apple on 2019/8/21.
//  Copyright © 2019年 zkyfios02. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@class CardListModel;
@interface AWTArchiveModelViewModel : BaseModel

@property (nonatomic) NSInteger page;

@property (strong, nonatomic) NSArray *listModelArray;

@property(strong, nonatomic)NSString *searchText;
@property(strong, nonatomic) NSArray *searchListArray;
//@property(nonatomic, strong)

@property(strong, nonatomic) NSString *ids;
@property(strong, nonatomic) NSArray *detailCardArray;
@property(strong, nonatomic) CardListModel *model;

@end

@interface AWTArchiveModel : NSObject

@property (copy, nonatomic) NSString *createName;
@property (copy, nonatomic) NSString *certificateType;
@property (copy, nonatomic) NSString *certificateTime;
@property (copy, nonatomic) NSString *mediaPreview;
@property (copy, nonatomic) NSString *worksUrl;
@property (copy, nonatomic) NSString *worksName;
@property (copy, nonatomic) NSString *certificateId;
@property (copy, nonatomic) NSString *memberId;
@property (copy, nonatomic) NSString *worksDetails;

@end









