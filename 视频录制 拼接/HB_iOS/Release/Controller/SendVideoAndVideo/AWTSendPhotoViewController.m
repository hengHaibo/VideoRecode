//
//  AWTSendPhotoViewController.m
//  AWT_iOS
//
//  Created by apple on 2019/11/3.
//  Copyright © 2019年 wtoip_mac. All rights reserved.
//

#import "AWTSendPhotoViewController.h"
#import "AWTSendVideoTextView.h"
#import "TZTestCell.h"
#import "UIView+Layout.h"
#import "AWTVideoViewController.h"
#import "MBProgressHUD.h"
#import "IWTAlertView.h"

#import "HMHttpTool.h"
#import "User.h"
#import "AWTShareViewController.h"
#import "TZImagePickerController.h"


@interface AWTSendPhotoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray *_selectedPhotos;
  NSMutableArray *_selectedAssets;
    CGFloat _itemWH;
    CGFloat _margin;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet AWTSendVideoTextView *textView;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionContentH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewContentH;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@property(nonatomic, assign) BOOL isComplate;

@property(nonatomic, strong)NSMutableArray *imageurlArray;

@end

@implementation AWTSendPhotoViewController

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  
  [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
  [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
-(void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
  if (!@available(iOS 11.0, *)) {
    self.topH.constant = 20;
  }
//    self.textView.delegate = self;
    self.imageurlArray = [NSMutableArray array];
    _selectedAssets = [self.assets mutableCopy];
    _selectedPhotos = [self.photos mutableCopy];
    [self configCollectionView];
    self.textView.placeholder = @"分享你的心情和故事吧～";
    self.sendBtn.layer.cornerRadius = 20;
    self.sendBtn.layer.masksToBounds = true;
  
  [[NSNotificationCenter defaultCenter] addObserverForName:@"cancle" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
    [self dismissViewControllerAnimated:true completion:nil];
  }];
}
-(void)viewDidDisappear:(BOOL)animated{
  [super viewDidDisappear:animated];
  [IWTAlertView hideLoadingView];
}
- (void)configCollectionView {

    _layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemWH = ([UIScreen mainScreen].bounds.size.width - 30 - 2 * 4 - 4) / 3 - 4;
     _layout.itemSize = CGSizeMake(itemWH, itemWH);
    _layout.minimumInteritemSpacing = 4;
    _layout.minimumLineSpacing = 4;
    _collectionView.collectionViewLayout = _layout;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_selectedPhotos.count >= 9) {
        return _selectedPhotos.count;
    }
    return _selectedPhotos.count + 1;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    cell.gifLable.hidden = YES;
    if (indexPath.item == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"sendPic"];
        cell.deleteBtn.hidden = true;
    }else{
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.item;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

        if (indexPath.item == _selectedPhotos.count) {

          TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 - _selectedPhotos.count delegate:self];
          imagePickerVc.showSelectedIndex = true;
          imagePickerVc.photoPickerPageUIConfigBlock = ^(UICollectionView *collectionView, UIView *bottomToolBar, UIButton *previewButton, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel, UIView *divideLine) {
            bottomToolBar.hidden = true;
          };
          imagePickerVc.allowPickingVideo = false;
          imagePickerVc.allowPickingImage = true;
          imagePickerVc.sortAscendingByModificationDate = false;
          
          [self presentViewController:imagePickerVc animated:YES completion:nil];
       
    }
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos
{
  
  for (PHAsset *phAsset in assets) {
    NSLog(@"==location:%@",phAsset.location);
  }
  NSMutableIndexSet  *indexes = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, photos.count)];
  [self->_selectedPhotos insertObjects:photos atIndexes:indexes];
  
//  [self->_selectedPhotos addObject:image];
  [self.collectionView reloadData];

  self.collectionContentH.constant = self.collectionView.collectionViewLayout.collectionViewContentSize.height + 10;
  
}

-(void)deleteBtnClik:(UIButton *)button{
    
    if ([self collectionView:self.collectionView numberOfItemsInSection:0] <= _selectedPhotos.count) {
        [_selectedPhotos removeObjectAtIndex:button.tag];
        [self.collectionView reloadData];
       self.collectionContentH.constant = self.collectionView.collectionViewLayout.collectionViewContentSize.height + 10;
        return;
    }
    [_selectedPhotos removeObjectAtIndex:button.tag];
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:button.tag inSection:0];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self.collectionView reloadData];
      self.collectionContentH.constant = self.collectionView.collectionViewLayout.collectionViewContentSize.height + 10;
    }];
    
}
- (IBAction)close:(UIButton *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)send:(UIButton *)sender {
  
  [self.imageurlArray removeAllObjects];
  
  if (_selectedPhotos.count <= 0) {
    
    [IWTAlertView showWithText:@"请选择图片" afterDely:1];
    return;
  }
  NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
  NSString *path = [doc stringByAppendingPathComponent:@"usr.archive"];
  User *user = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
  //  user.url = @"https://test-apiAWT.wtoip.com/";
  NSString *sendUrl = [NSString stringWithFormat:@"%@oss/upload",user.url];
  
  MBProgressHUD *mbHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
  mbHUD.mode = MBProgressHUDModeIndeterminate;
  mbHUD.label.text = @"正在发布...";
//  [IWTAlertView showLoadingWithText:@"正在发布..." view:self.view];
  dispatch_group_t group = dispatch_group_create();
  for (int i=0; i< _selectedPhotos.count; i++){
    UIImage *tempImg = _selectedPhotos[i];
    NSData *imageData = UIImageJPEGRepresentation(tempImg, 0.5);
    dispatch_group_enter(group);
    
    [HMHttpTool postImgPath:sendUrl params:nil isVideo:false fileData:imageData success:^(NSDictionary *JSONDic) {
        NSInteger code = [JSONDic[@"code"] integerValue];
        if (code == 200) {
          [self.imageurlArray addObject:JSONDic[@"data"][@"fileUrl"]];
        }
      
        dispatch_group_leave(group);
    } failure:^(NSError *error) {
//      [mbHUD hideAnimated:true afterDelay:1.0f];
      
      dispatch_group_leave(group);
    } progress:nil];
  }
  dispatch_group_notify(group, dispatch_get_main_queue(), ^{
    
    self.isComplate = true;
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [doc stringByAppendingPathComponent:@"usr.archive"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    //  user.url = @"https://test-apiAWT.wtoip.com/";
    NSString *sendUrl = [NSString stringWithFormat:@"%@works/publish",user.url];
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < self.imageurlArray.count; i++) {
      NSDictionary *dic = @{@"fileUrl":self.imageurlArray[i],
                            @"isTop":@(0),
                            @"remarks":@"",
                            @"sort":@"0"
                            };
      [array addObject:dic];
    }
    if (self.textView.text.length > 0) {
    }else{
      self.textView.text = @"";
    }
    if (self.isComplate == true) {
      NSDictionary *dic = @{@"fileList":array,
                            @"mediaPreview":@"",
                            @"remarks":@"123",
                            @"worksDetails":self.textView.text,
                            @"worksType":@(1)
                            };
      [HMHttpTool post:sendUrl params:dic success:^(NSDictionary *JSONDic) {
        NSInteger code = [JSONDic[@"code"] integerValue];
        [IWTAlertView hideLoadingView];
        if (code == 200) {
//          [IWTAlertView hideLoadingView];
          [mbHUD hideAnimated:true afterDelay:1.0f];
          AWTShareViewController *vc = [[AWTShareViewController alloc]init];
          vc.isVideo = false;
          vc.imageStr = self.imageurlArray[0];
          vc.workid = JSONDic[@"data"][@"worksId"];
          [self presentViewController:vc animated:true completion:nil];
        } else {
//          [IWTAlertView hideLoadingView];
          [mbHUD hideAnimated:true afterDelay:1.0f];
          [IWTAlertView showWithText:JSONDic[@"message"] afterDely:1];
        }
        
      } failure:^(NSError *error) {
//        [IWTAlertView hideLoadingView];
        [mbHUD hideAnimated:true afterDelay:0.4f];
        [IWTAlertView showWithText:@"网络出小差，请稍后重试" afterDely:1];
      }];
    }
    
  });
  
  
}

@end
