//
//  AWTVideoEditorTool.h
//  AWT_iOS
//
//  Created by apple on 2019/10/30.
//  Copyright © 2019年 wtoip_mac. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWTVideoEditorTool : NSObject

//拼接视频
- (void)mergeAndExportVideosAtFileURLs:(NSArray *)fileURLArray completion:(void (^)(NSURL *outputPath))completion;
//旋转视频
-(void)startExportVideoWithVideoAssetForMX:(NSURL *)videolUrl degrees:(int)degrees completion:(void (^)(NSString *outputPath))completion;
//获取视频的方向
- (int)degressFromVideoFileWithUrl:(NSURL *)videolUrl;
//获取视频第一帧的截图
- (UIImage*) getVideoPreViewImage:(NSURL *)path;
//旋转图片
- (UIImage *)fixOrientation:(UIImage *)aImage;

@end

NS_ASSUME_NONNULL_END
