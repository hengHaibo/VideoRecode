//
//  HMCacheTool.m
//  AWT_iOS
//
//  Created by wtoip_mac on 2019/10/28.
//  Copyright © 2019 wtoip_mac. All rights reserved.

/**
 *  沙盒Document路径
 */
#define kDocumentPath ([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject])

/**
 *  沙盒Cache路径
 */
#define kCachePath ([NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject])

#import "HMCacheTool.h"

@implementation HMCacheTool

//根据文件名fileName存储缓存数据
+ (void)cacheForData:(NSData *)data fileName:(NSString *)fileName
{
    NSString *path = [kCachePath stringByAppendingPathComponent:fileName];//将fileName添加到现有路径的末尾
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [data writeToFile:path atomically:YES];//数据异步写入文件中
    });
}
//根据文件名fileName取出缓存数据
+ (NSData *)getCacheFileName:(NSString *)fileName
{
    NSString *path = [kCachePath stringByAppendingPathComponent:fileName];//将fileName添加到现有路径的末尾
    NSData *data =  [[NSData alloc] initWithContentsOfFile:path];//根据文件fileName转为data数据
    return data;
}
////获取AFN的缓存文件大小
+ (NSUInteger)getAFNSize
{
    NSUInteger size = 0;
    NSFileManager *fm = [NSFileManager defaultManager];//文件管理者
    //// 获得文件夹的大小  == 获得文件夹中所有文件的总大小
    NSDirectoryEnumerator *fileEnumerator = [fm enumeratorAtPath:kCachePath];//根据kCachePath枚举目录
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [kCachePath stringByAppendingPathComponent:fileName];//将fileName添加到全路径的末尾
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];//获取文件的属性
        size += [attrs fileSize];
    }
    return size;
}
//获取所有缓存的大小
//+ (NSUInteger)getSize
//{
//    //获取SDWebImage的缓存大小
//    NSUInteger imageSize = [[SDImageCache sharedImageCache] getSize];
//    //获取AFN的缓存大小
//    NSUInteger afnSize = [self getAFNSize];
//    return imageSize+afnSize;//获取缓存图片和缓存文件的大小
//}
//清除AFN的缓存//
+ (void)clearAFNCache
{
    NSFileManager *fm = [NSFileManager defaultManager];////文件管理者
    
    NSDirectoryEnumerator *fileEnumerator = [fm enumeratorAtPath:kCachePath];//枚举目录
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [kCachePath stringByAppendingPathComponent:fileName];//将fileName添加到现有路径的末尾
        
        [fm removeItemAtPath:filePath error:nil];//移除缓存文件
        
    }
}
////清除所有的缓存
+ (void)clearCache
{
    //清除SDWebImage的缓存
    //    [[SDImageCache sharedImageCache] clearDisk];
//    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    //清除AFN的缓存
    [self clearAFNCache];
}
//判断缓存文件是否过期
+ (BOOL)isExpire:(NSString *)fileName
{
    NSString *path = [kCachePath stringByAppendingPathComponent:fileName];//将fileName添加到现有路径的末尾
    
    NSFileManager *fm = [NSFileManager defaultManager];//文件管理者
    NSDictionary *attributesDict = [fm attributesOfItemAtPath:path error:nil];//获取文件的属性
    NSDate *fileModificationDate = attributesDict[NSFileModificationDate];//获取文件的创建日期
    NSTimeInterval fileModificationTimestamp = [fileModificationDate timeIntervalSince1970];//文件创建的时间戳
    //现在的时间戳
    NSTimeInterval nowTimestamp = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
    //比较（现在的时间戳与文件创建的时间戳的差）与缓存的有效期的大小
    return ((nowTimestamp-fileModificationTimestamp)>kYBCache_Expire_Time);////缓存的有效期
}



@end
