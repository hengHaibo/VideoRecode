//
//  HMHttpTool.h
//  AWT_iOS
//
//  Created by wtoip_mac on 2019/10/28.
//  Copyright © 2019 wtoip_mac. All rights reserved.

#import "HMCacheTool.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^HttpSuccessBlock) (NSDictionary * JSONDic);
typedef void (^HttpFailureBlock) (NSError *error);
typedef void (^HttpUploadProgressBlock) (NSProgress * progress);
@class HMDataModel;
@interface HMHttpTool : NSObject
/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *error))failure;
/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)postImgPath:(NSString *)path params:(NSDictionary *)params isVideo:(BOOL)isVideo fileData:(NSData *)fileData success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure progress:(HttpUploadProgressBlock)progress;

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;



/**
 发送一个POST请求
 
 @param url 请求路径
 @param params 请求参数
 @param show 是否需要显示加载框
 @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)post:(NSString *)url params:(NSDictionary *)params showProgressHUD:(BOOL)show success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;


/**
 上传图片
 
 @param path path description
 @param params params description
 @param imageDictionary {@"name": @[imgArray]}
 @param success success description
 @param failure failure description
 @param progress progress description
 */
+ (void)postWithImgPath:(NSString *)path params:(NSDictionary *)params imageDictionary:(NSDictionary *)imageDictionary success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure progress:(HttpUploadProgressBlock)progress;


//有缓存的get请求
+ (void)get:(NSString *)url params:(NSDictionary *)params cacheType:(YBCacheType)cacheType success:(void (^)(HMDataModel *))success failure:(void (^)(NSError *))failure;


//有缓存的post请求
+ (void)post:(NSString *)url params:(NSDictionary *)params cacheType:(YBCacheType)cacheType success:(void (^)( HMDataModel*))success failure:(void (^)(NSError *))failure;


//判断网络状况
+ (BOOL)networkStatus;





@end
