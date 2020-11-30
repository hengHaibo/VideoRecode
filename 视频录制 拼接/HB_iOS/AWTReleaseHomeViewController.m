//
//  AWTReleaseHomeViewController.m
//  AWT_iOS
//
//  Created by wtoip_mac on 2019/10/25.
//  Copyright © 2019 wtoip_mac. All rights reserved.
//

#import "AWTReleaseHomeViewController.h"
#import "AWTRleaseBtn.h"
#import "AWTVideoViewController.h"
#import "TZImagePickerController.H"

#import "AWTSendPhotoViewController.h"
#import "DeviceDirection.h"

#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "GravityInduction.h"
#import "AWTVideoViewController.h"

@interface AWTReleaseHomeViewController ()<TZImagePickerControllerDelegate>

@property(nonatomic, assign)BOOL isMicro;
@property(nonatomic, assign)BOOL isAlbum;
@property(nonatomic, assign)BOOL isPhoto;
@end

@implementation AWTReleaseHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
 
//  GravityInduction *induction = [[GravityInduction alloc]init];;
//  [induction startUpdateAccelerometerResult];
  
    [DeviceDirection share].deviceDirectionChangeBlock = ^(DeviceDirectionType direction) {
        switch (direction) {
            case DeviceDirectionTypePortrait:
                //home键在下方
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"DeviceDegress" object:self userInfo:@{@"degress":@"down"}];

                NSLog(@"down");
                break;
            case DeviceDirectionTypeLandscapeLeft:
                // home键在左方
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"DeviceDegress" object:self userInfo:@{@"degress":@"left"}];
                NSLog(@"left");
                break;
            case DeviceDirectionTypeLandscapeRight:
                // home键在上方
//               [[NSNotificationCenter defaultCenter]postNotificationName:@"DeviceDegress" object:self userInfo:@{@"degress":@"up"}];
                NSLog(@"up");
                break;
            case DeviceDirectionTypeUpsideDown:
                //home键在右方
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"DeviceDegress" object:self userInfo:@{@"degress":@"right"}];
                NSLog(@"right");
                break;

            default:

                break;
        }
    };

}

/**
 视频

 @param sender <#sender description#>
 */
- (IBAction)video:(AWTRleaseBtn *)sender {
    
    
  
    
    AWTVideoViewController *videoVC = [[AWTVideoViewController alloc]init];
    [self presentViewController:videoVC animated:true completion:nil];
}

/**
 拍照

 @param sender <#sender description#>
 */
- (IBAction)pic:(AWTRleaseBtn *)sender {
    
    PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
//    switch (photoAuthorStatus) {
//        case PHAuthorizationStatusAuthorized:
//            //用户允许当前应用访问相册
//            self.isAlbum = false;
//            break;
//
//        case PHAuthorizationStatusDenied:
//            self.isAlbum = true;
//            break;
//
//        case PHAuthorizationStatusNotDetermined:
//            //用户还没有做出选择
//            self.isAlbum = true;
//            break;
//
//        case PHAuthorizationStatusRestricted:
//            //不允许访问
//            self.isAlbum = true;
//            break;
//
//        default:
//            break;
//    }

  
  AWTVideoViewController *vc = [[AWTVideoViewController alloc]init];
  [self presentViewController:vc animated:true completion:^{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"clicj" object:self userInfo:nil];
  }];
  
  
    
//    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
//    imagePickerVc.showSelectedIndex = true;
//    imagePickerVc.photoPickerPageUIConfigBlock = ^(UICollectionView *collectionView, UIView *bottomToolBar, UIButton *previewButton, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel, UIView *divideLine) {
//        bottomToolBar.hidden = true;
//    };
//    imagePickerVc.allowPickingVideo = false;
//    imagePickerVc.allowPickingImage = true;
//    imagePickerVc.sortAscendingByModificationDate = false;
  
//    [self presentViewController:imagePickerVc animated:YES completion:nil];
  
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos
{

    for (PHAsset *phAsset in assets) {
        NSLog(@"==location:%@",phAsset.location);
    }
  
    AWTSendPhotoViewController *photoVC = [[AWTSendPhotoViewController alloc]init];
    photoVC.photos = photos;
    [self presentViewController:photoVC animated:true completion:nil];
}
/**
 已存档

 @param sender <#sender description#>
 */
- (IBAction)save:(AWTRleaseBtn *)sender {
    
    
}
- (IBAction)closeVC:(UIButton *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
