//
//  AWTVideoEditorTool.m
//  AWT_iOS
//
//  Created by apple on 2019/10/30.
//  Copyright © 2019年 wtoip_mac. All rights reserved.
//

#import "AWTVideoEditorTool.h"
@interface AWTVideoEditorTool()

@end

@implementation AWTVideoEditorTool



- (void)mergeAndExportVideosAtFileURLs:(NSArray *)fileURLArray completion:(void (^)(NSURL *outputPath))completion{
    
    NSError *error = nil;
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    //视频容器
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    //音频容器
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *assetTrack;
    
    CMTime totalDuration = kCMTimeZero;
    for (int i = 0; i< fileURLArray.count; i++) {
        AVAsset *asset = [AVAsset assetWithURL:fileURLArray[i]];
        CMTime singleTime = asset.duration;
        CMTimeRange videoTimeRang = CMTimeRangeMake(kCMTimeZero, singleTime);
        assetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
        
        NSLog(@"单个视频 timeRange>>>>%@",[NSValue valueWithCMTimeRange:videoTimeRang]);
        [videoTrack insertTimeRange:videoTimeRang ofTrack:assetTrack
                             atTime:totalDuration
                              error:&error];
        assetTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
        
        [audioTrack insertTimeRange:videoTimeRang ofTrack:assetTrack
                             atTime:totalDuration
                              error:&error];
        
        totalDuration = CMTimeAdd(totalDuration, singleTime);
        
        NSLog(@"===合成视频 timeRange====:%@", [NSValue valueWithCMTime:totalDuration]);
    }
    NSURL *mergeFileURL = [self joinStorePaht:@"video"];
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPreset960x540];
    exporter.outputURL = mergeFileURL;
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    
    
//    NSArray *tracks = [videoAsset tracksWithMediaType:AVMediaTypeVideo];
//    AVAssetTrack *videoTrack1 = tracks[0];
//    CGSize videoSize = CGSizeApplyAffineTransform(videoTrack1.naturalSize, videoTrack1.preferredTransform);
//    videoSize = CGSizeMake(fabs(videoSize.width), fabs(videoSize.height));
//    NSLog(@"===视频宽==:%f====高==:%f",videoSize.width, videoSize.height);
    //获取第一个视频的方向
    int degrees = [self degressFromVideoFileWithUrl:fileURLArray[0]];
    AVAsset *videoAsset = [AVAsset assetWithURL:fileURLArray[0]]; 
    NSLog(@"======合成成功的方向==:%d",degrees);
    if (degrees != 0) {
        CGAffineTransform translateToCenter;
        CGAffineTransform mixedTransform;
        AVMutableVideoComposition *waterMarkVideoComposition = [AVMutableVideoComposition videoComposition];
        waterMarkVideoComposition.frameDuration = CMTimeMake(1, 30);

        NSArray *tracks = [videoAsset tracksWithMediaType:AVMediaTypeVideo];
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];

        if (degrees == 90) {
            // 顺时针旋转90°
            translateToCenter = CGAffineTransformMakeTranslation(videoTrack.naturalSize.height, 0.0);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI_2);
            waterMarkVideoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height,videoTrack.naturalSize.width);
        } else if(degrees == 180){
            // 顺时针旋转180°
            translateToCenter = CGAffineTransformMakeTranslation(videoTrack.naturalSize.width, videoTrack.naturalSize.height);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI);
            waterMarkVideoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.width,videoTrack.naturalSize.height);
        } else if(degrees == 270){
            // 顺时针旋转270°
            translateToCenter = CGAffineTransformMakeTranslation(0.0, videoTrack.naturalSize.width);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI_2*3.0);
            waterMarkVideoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height,videoTrack.naturalSize.width);
        }

        AVMutableVideoCompositionInstruction *roateInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        roateInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, [videoAsset duration]);
        AVMutableVideoCompositionLayerInstruction *roateLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];

        [roateLayerInstruction setTransform:mixedTransform atTime:kCMTimeZero];

        roateInstruction.layerInstructions = @[roateLayerInstruction];
        //将视频方向旋转加入到视频处理中
        waterMarkVideoComposition.instructions = @[roateInstruction];

        exporter.videoComposition = waterMarkVideoComposition;
    }
    
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (exporter.status == AVAssetExportSessionStatusCompleted) {
            
                if (completion) {
                    completion(mergeFileURL);
                }
            }else if (exporter.status == AVAssetExportSessionStatusFailed){
                NSLog(@"======合成失败==:%@",exporter.error);
            }else if (exporter.status == AVAssetExportSessionStatusCancelled){
                NSLog(@"===cancle===");
            }
        });
    }];
}

-(NSURL *)joinStorePaht:(NSString *)fileName
{
    NSString *documentPath = NSTemporaryDirectory();
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *nowTimeStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    NSString *storePath = [documentPath stringByAppendingPathComponent:nowTimeStr];
    
    BOOL isExist = [fileManager fileExistsAtPath:storePath];
    if(!isExist){
        [fileManager createDirectoryAtPath:storePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *realName = [NSString stringWithFormat:@"%@.mp4", fileName];
    storePath = [storePath stringByAppendingPathComponent:realName];
    NSURL *outputFileUrl = [NSURL fileURLWithPath:storePath];
    return outputFileUrl;
}

//获取视频的方向
- (int)degressFromVideoFileWithUrl:(NSURL *)videolUrl {
    AVAsset *asset = [AVAsset assetWithURL:videolUrl];
    int degress = 0;
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
            // Portrait
            degress = 90;
        } else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
            // PortraitUpsideDown
            degress = 270;
        } else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
            // LandscapeRight
            degress = 0;
        } else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
            // LandscapeLeft
            degress = 180;
        }
    }
    return degress;
}
//旋转视频
-(void)startExportVideoWithVideoAssetForMX:(NSURL *)videolUrl degrees:(int)degrees completion:(void (^)(NSString *outputPath))completion {
    AVAsset *videoAsset = [AVAsset assetWithURL:videolUrl];
    NSArray *presets = [AVAssetExportSession exportPresetsCompatibleWithAsset:videoAsset];
    if ([presets containsObject:AVAssetExportPreset960x540]) {
        AVAssetExportSession *session = [[AVAssetExportSession alloc]initWithAsset:videoAsset presetName:AVAssetExportPreset640x480];
        
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        NSString *outputPath = [NSHomeDirectory() stringByAppendingFormat:@"/tmp/output-%@.mp4", [formater stringFromDate:[NSDate date]]];
        NSLog(@"video outputPath = %@",outputPath);
        session.outputURL = [NSURL fileURLWithPath:outputPath];
        session.shouldOptimizeForNetworkUse = true;
        
        NSArray *supportedTypeArray = session.supportedFileTypes;
        if ([supportedTypeArray containsObject:AVFileTypeMPEG4]) {
            session.outputFileType = AVFileTypeMPEG4;
        } else if (supportedTypeArray.count == 0) {
            NSLog(@"No supported file types 视频类型暂不支持导出");
            return;
        } else {
            session.outputFileType = [supportedTypeArray objectAtIndex:0];
        }
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/tmp"]]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/tmp"] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
        CGSize naturalSize = videoAssetTrack.naturalSize;
        int d = [self degressFromVideoFileWithUrl:videolUrl];
        NSLog(@"===视频的宽高==:%f===%f==方向==:%d", naturalSize.width, naturalSize.height, d);
        
        if (degrees != 0) {
            CGAffineTransform translateToCenter;
            CGAffineTransform mixedTransform;
            AVMutableVideoComposition *waterMarkVideoComposition = [AVMutableVideoComposition videoComposition];
            waterMarkVideoComposition.frameDuration = CMTimeMake(1, 30);
            
            NSArray *tracks = [videoAsset tracksWithMediaType:AVMediaTypeVideo];
            AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
            
            if (degrees == 90) {
                // 顺时针旋转90°
                translateToCenter = CGAffineTransformMakeTranslation(videoTrack.naturalSize.height, 0.0);
                mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI_2);
                waterMarkVideoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height,videoTrack.naturalSize.width);
            } else if(degrees == 180){
                // 顺时针旋转180°
                translateToCenter = CGAffineTransformMakeTranslation(videoTrack.naturalSize.width, videoTrack.naturalSize.height);
                mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI);
                waterMarkVideoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.width,videoTrack.naturalSize.height);
            } else if(degrees == 270){
                // 顺时针旋转270°
                translateToCenter = CGAffineTransformMakeTranslation(0.0, videoTrack.naturalSize.width);
                mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI_2*3.0);
                waterMarkVideoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height,videoTrack.naturalSize.width);
            }
            
            AVMutableVideoCompositionInstruction *roateInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
            roateInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, [videoAsset duration]);
            AVMutableVideoCompositionLayerInstruction *roateLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
            
            [roateLayerInstruction setTransform:mixedTransform atTime:kCMTimeZero];
            
            roateInstruction.layerInstructions = @[roateLayerInstruction];
            //将视频方向旋转加入到视频处理中
            waterMarkVideoComposition.instructions = @[roateInstruction];
            
            session.videoComposition = waterMarkVideoComposition;
        }
        
        // Begin to export video to the output path asynchronously.
        [session exportAsynchronouslyWithCompletionHandler:^(void) {
            switch (session.status) {
                case AVAssetExportSessionStatusUnknown:
                    NSLog(@"AVAssetExportSessionStatusUnknown"); break;
                case AVAssetExportSessionStatusWaiting:
                    NSLog(@"AVAssetExportSessionStatusWaiting"); break;
                case AVAssetExportSessionStatusExporting:
                    NSLog(@"AVAssetExportSessionStatusExporting"); break;
                case AVAssetExportSessionStatusCompleted: {
                    NSLog(@"AVAssetExportSessionStatusCompleted");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion) {
                            completion(outputPath);
                        }
                    });
                }  break;
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"AVAssetExportSessionStatusFailed==:%@",session.error); break;
                default: break;
            }
        }];
    }
}

//获取视频第一帧的截图
- (UIImage*) getVideoPreViewImage:(NSURL *)path
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}
//旋转图片

- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}




@end
