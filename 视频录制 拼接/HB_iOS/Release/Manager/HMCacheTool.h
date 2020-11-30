//
//  HMCacheTool.h
//  AWT_iOS
//
//  Created by wtoip_mac on 2019/10/28.
//  Copyright © 2019 wtoip_mac. All rights reserved.
#import <Foundation/Foundation.h>

#define kYBCache_Expire_Time (3600*24) //缓存的有效期  单位是s

typedef NS_ENUM(NSUInteger, YBCacheType){
    
    YBCacheTypeReturnCacheDataThenLoad = 0,///< 有缓存就先返回缓存，同步请求数据
    YBCacheTypeReloadIgnoringLocalCacheData, ///< 忽略缓存，重新请求
    YBCacheTypeReturnCacheDataElseLoad,///< 有缓存就用缓存，没有缓存就重新请求(用于数据不变时)
    YBCacheTypeReturnCacheDataDontLoad,///< 有缓存就用缓存，没有缓存就不发请求，当做请求出错处理（用于离线模式）
    YBCacheTypeReturnCacheDataExpireThenLoad///< 有缓存就用缓存，如果过期了就重新请求 没过期就不请求
};


@interface HMCacheTool : NSObject
/**
 *  缓存数据
 *
 *  @param fileName 缓存数据的文件名
 *
 *  @param data 需要缓存的二进制
 */
+ (void)cacheForData:(NSData *)data fileName:(NSString *)fileName;

/**
 *  取出缓存数据
 *
 *  @param fileName 缓存数据的文件名
 *
 *  @return 缓存的二进制数据
 */
+ (NSData *)getCacheFileName:(NSString *)fileName;

/**
 *  判断缓存文件是否过期
 */
+ (BOOL)isExpire:(NSString *)fileName;

/**
 *  获取缓存的大小
 *
 *  @return 缓存的大小  单位是B
 */
+ (NSUInteger)getSize;

/**
 *  清除缓存
 */
+ (void)clearCache;



@end
