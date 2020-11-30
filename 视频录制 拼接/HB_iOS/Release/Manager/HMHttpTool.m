//
//  HMHttpTool.m
//  AWT_iOS
//
//  Created by wtoip_mac on 2019/10/28.
//  Copyright © 2019 wtoip_mac. All rights reserved.
//
#import "HMHttpTool.h"
#import "AFNetworking.h"
#import "HMCacheTool.h"
#import "HMDataModel.h"
#import "User.h"

#define kFileNameKey @"kFileNameKey"//文件名key
#define kResultKey @"kResultKey"//缓存结果key

static NSString *const kBaseURLString = @"https://test-apiAWT.wtoip.com/";
//图片压缩
#define k_compressionQuality 0.5


@interface AFHttpClient : AFHTTPSessionManager
+ (instancetype)sharedClient;
@end
@implementation AFHttpClient
+ (instancetype)sharedClient
{
    static AFHttpClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = 20.0f;
      User *user = [User getUser];
        _sharedClient = [[AFHttpClient alloc] initWithBaseURL:[NSURL URLWithString:user.url] sessionConfiguration:configuration];
_sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                             @"text/html",
                                                             @"image/jpeg",
                                                             @"image/png",
                                                             @"application/octet-stream",
                                                             @"text/json",@"text/plain", nil];
        

        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    return _sharedClient;
}
@end

@interface HMHttpTool ()

@end



@implementation HMHttpTool

/** get请求***/
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    [[AFNetworkReachabilityManager manager]startMonitoring];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",@"text/plain", nil];
  
  NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
      NSString *path = [doc stringByAppendingPathComponent:@"usr.archive"];
  User *user = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
  NSString *urlstr = [NSString stringWithFormat:@"%@%@",user.url,url];
  
  [manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"terminalType"];
  [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  [manager.requestSerializer setValue:user.token forHTTPHeaderField:@"token"];
  
    
    [manager GET:urlstr parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
            NSDictionary *dics = responseObject;
            NSString *code = dics[@"code"];
            
            
            if (code.intValue ==4003)
            {
//                ULoginViewController *loginVC = [[ULoginViewController alloc]init];
//                // 切换控制器
//                UIWindow *window = [UIApplication sharedApplication].keyWindow;
//                window.rootViewController = loginVC;
            }
            else
            {
                
                success(responseObject);
            }
            
        

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            // NSLog(@"%@", manager.requestSerializer.HTTPRequestHeaders);
            failure(error);
        }
    }];
    
}

/** post请求***/
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
 
  NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
  NSString *path = [doc stringByAppendingPathComponent:@"usr.archive"];
  User *user = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
  NSError *error = nil;
  NSDictionary *headers = @{ @"terminalType": @"iOS",
                             @"Content-Type": @"application/json",
                             @"token" : user.token
                             };
  
  NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:params error:&error];
  [request setAllHTTPHeaderFields:headers];
  
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
  
  NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];

  if (error) failure(error);
  
  
  
  [[[AFHttpClient sharedClient] dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
    
  } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
    //可获取下载进度
  } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
    
   
    
    if (error) {
      failure(error);
    }
    
    else {
      
      NSDictionary *dics = responseObject;
      NSString *code = dics[@"code"];
      
      
      if (code.intValue ==200){
        success(responseObject);
      }
      
    }
    
  }] resume];
}




//缓存数据的文件名：//根据文件名/参数拼接作为缓存数据的文件名
+ (NSString *)fileName:(NSString *)url params:(NSDictionary *)params
{
    NSMutableString *mStr = [NSMutableString stringWithString:url];
    if (params != nil) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];//参数转化为data数据类型
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];//data转str
        [mStr appendString:str];//url拼接参数字符串
    }
    //如果字符串中有中文，转换成URL就为nil,用stringByAddingPercentEncodingWithAllowedCharacters转换
    //[NSCharacterSet whitespaceAndNewlineCharacterSet] 去除NSString中的空格
    return [mStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet whitespaceAndNewlineCharacterSet]];//NSCharacterSet 去除NSString中的空格
    
    //    return mStr;
}

//取出缓存数据
+ (NSDictionary *)getCache:(YBCacheType)cacheType url:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success
{
    //拼接缓存数据的文件名
    NSString *fileName = [self fileName:url params:params];
    NSData *data = [HMCacheTool getCacheFileName:fileName];//根据文件名取出缓存数据
    
    BOOL result = NO;
    
    if (data) {//有缓存数据
        //NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];//把缓存数据转为字典
        //通过字典来创建一个模型
        //        HMDataModel *dataModel = dict;//用MJExtention字典转模型
        
        
        
        if (cacheType == YBCacheTypeReloadIgnoringLocalCacheData) {//忽略缓存，重新请求
            
        } else if (cacheType == YBCacheTypeReturnCacheDataDontLoad) {//有缓存就用缓存，没有缓存就不发请求，当做请求出错处理（用于离线模式）
            
        } else if (cacheType == YBCacheTypeReturnCacheDataElseLoad) {//有缓存就用缓存，没有缓存就重新请求(用于数据不变时)
            if (success) {
                // success(dataModel);
                
                
            }
            result = YES;////有缓存就用缓存
            
        } else if (cacheType == YBCacheTypeReturnCacheDataThenLoad) {///有缓存就先返回缓存，同步请求数据
            if (success) {
                // success(dataModel);
                
                
            }
        } else if (cacheType == YBCacheTypeReturnCacheDataExpireThenLoad) {//有缓存 判断是否过期了没有 没有就返回缓存
            //判断是否过期
            if (![HMCacheTool isExpire:fileName]) {
                if (success) {
                    // success(dataModel);
                }
                result = YES;////有缓存就用缓存
            }
        }
    }
    return @{kFileNameKey:fileName,
             kResultKey:@(result)};
}


/**
 上传图片
 
 @param path path description
 @param params params description
 @param imageDictionary {@"name": @[imgArray]}
 @param success success description
 @param failure failure description
 @param progress progress description
 */
+ (void)postImgPath:(NSString *)path params:(NSDictionary *)params isVideo:(BOOL)isVideo fileData:(NSData *)fileData success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure progress:(HttpUploadProgressBlock)progress {
    // 获取完整的URL
    
  User *user = [User getUser];
  NSError *error = nil;
  AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  //避免 Request failed: unacceptable content-type: text/html异常
  manager.responseSerializer = [AFHTTPResponseSerializer serializer];
  manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
  //添加请求头
  [requestSerializer setValue:user.token forHTTPHeaderField:@"token"];
  [requestSerializer setValue:@"iOS" forHTTPHeaderField:@"terminalType"];
  [requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
  
  manager.requestSerializer = requestSerializer;
  [manager POST:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    if (isVideo) {
      [formData appendPartWithFileData:fileData name:@"file" fileName:@"video.mp4" mimeType:@"key.mp4"];
    }else{
      [formData appendPartWithFileData:fileData name:@"file" fileName:@"image.jpeg" mimeType:@"key.jpeg"];
    }
  } progress:^(NSProgress * _Nonnull uploadProgress) {
    if (progress) {
      progress(uploadProgress);
    }
     
  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    success(dic);
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    failure(error);

  }];


  
  
  
}

//有缓存的get请求
+ (void)get:(NSString *)url params:(NSDictionary *)params cacheType:(YBCacheType)cacheType success:(void (^)(HMDataModel *))success failure:(void (^)(NSError *))failure
{
    //初始化AFN管理者
    [[AFNetworkReachabilityManager manager]startMonitoring];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    
    //缓存数据的文件名 data
    NSDictionary *dataDict = [self getCache:cacheType url:url params:params success:success];//取出缓存数据
    NSString *fileName = dataDict[kFileNameKey];//取出文件名
    //有缓存，不需要请求
    if ([dataDict[kResultKey] boolValue]) return;//存在就返回；不存在就执行下一步
    
    
    //缓存数据的文件名
    //NSString *fileName = [self fileName:url params:params];
    
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            
            //存储：缓存数据
            NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
            [HMCacheTool cacheForData:data fileName:fileName];
            
            //NSLog(@"responseObject:%@",responseObject);
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//初始化AFN
+ (AFHTTPSessionManager *)sessionManager
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    return sessionManager;
}

//有缓存的post请求
+ (void)post:(NSString *)url params:(NSDictionary *)params cacheType:(YBCacheType)cacheType success:(void (^)( HMDataModel*))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *sessionManager = [self sessionManager];
    //缓存数据的文件名 data
    NSDictionary *dataDict = [self getCache:cacheType url:url params:params success:success];
    //NSString *fileName = dataDict[kFileNameKey];//获取字典中的文件名
    //有缓存，不需要请求
    if ([dataDict[kResultKey] boolValue]) return;
    
    
    [sessionManager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //        HMDataModel *dataModel = [HMDataModel mj_objectWithKeyValues:responseObject];
        //
        //        if (dataModel.resultCode==200) {
        //            //缓存数据
        //            NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        //            [HMCacheTool cacheForData:data fileName:fileName];
        //        }
        //
        //        if (success) {
        //            success(dataModel);
        //        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //NSLog(@"%@",error);
        //[weakSelf errorHandle:task error:error failure:failure];
    }];
}
/*** 监控网络*/
+ (BOOL)networkStatus
{
    __block BOOL net ;
    /// 监控网络
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 当网络状态改变了，就会调用
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                
                net = NO;
                
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                net = YES;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                net = YES;
                break;
        }
    }];
    // 开始监控
    [mgr startMonitoring];
    //NSLog(@"net:%i",net);
    return net;
}



@end
