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
#import "UIView+AWTView.h"

@interface AWTSendPhotoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray *_selectedPhotos;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet AWTSendVideoTextView *textView;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionContentH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewContentH;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@property(nonatomic, strong)NSMutableArray *selectPhptos;

@end

@implementation AWTSendPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
//    self.textView.delegate = self;
    _selectedPhotos = [self.photos mutableCopy];
    [self configCollectionView];
    self.textView.placeholder = @"分享你的心情和故事吧～";
    self.sendBtn.layer.cornerRadius = 20;
    self.sendBtn.layer.masksToBounds = true;
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    self.collectionContentH.constant = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
    
    
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
    if (_photos.count >= 9) {
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
    
    if (_selectedPhotos.count >= 9) {
        return;
    }else{
        if (indexPath.item == (_selectedPhotos.count - 1)) {
            
        }
    }
}
-(void)deleteBtnClik:(UIButton *)button{
    
    if ([self collectionView:self.collectionView numberOfItemsInSection:0] <= _selectedPhotos.count) {
        [_selectedPhotos removeObjectAtIndex:button.tag];
        [self.collectionView reloadData];
        return;
    }
    [_selectedPhotos removeObjectAtIndex:button.tag];
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:button.tag inSection:0];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self.collectionView reloadData];
    }];
    
}
- (IBAction)close:(UIButton *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
