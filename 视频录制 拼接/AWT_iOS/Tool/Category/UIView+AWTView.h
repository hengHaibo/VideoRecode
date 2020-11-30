//
//  UIView+AWTView.h
//  AWT_iOS
//
//  Created by wtoip_mac on 2019/10/25.
//  Copyright © 2019 wtoip_mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GradientChangeDirection) {
    
    GradientChangeDirectionLevel,                               //水平方向渐变
    GradientChangeDirectionVertical,                           //垂直方向渐变
    GradientChangeDirectionUpwardDiagonalLine,    //主对角线方向渐变
    GradientChangeDirectionDownDiagonalLine,       //副对角线方向渐变
};
@interface UIView (AWTView)


@property (nonatomic, assign)CGFloat x;
@property (nonatomic, assign)CGFloat y;
@property (nonatomic, assign)CGFloat width;
@property (nonatomic, assign)CGFloat height;
@property (nonatomic, assign)CGFloat centerX;
@property (nonatomic, assign)CGFloat centerY;
@property (nonatomic, assign)CGSize size;
@property(nonatomic, assign) IBInspectable CGFloat borderWidth;
@property(nonatomic, assign) IBInspectable UIColor *borderColor;
@property(nonatomic, assign) IBInspectable CGFloat cornerRadius;

//view旋转360度
-(void)transformVertical360;
//view旋转90度
-(void)transformVertical;
//view恢复
-(void)transformIdentity;

-(void)colorGradientChange;

@end

NS_ASSUME_NONNULL_END
