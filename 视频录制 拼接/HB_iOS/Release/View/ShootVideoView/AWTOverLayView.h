//
//  AWTOverLayView.h
//  AWT_iOS
//
//  Created by apple on 2019/10/27.
//  Copyright © 2019年 wtoip_mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    Video,
    Picture,
    Photos
}CameraModel;

@protocol AWTOverLayViewDelegate <NSObject>

-(void)clickButtonWithModel:(CameraModel)type;

@end


@interface AWTOverLayView : UIView

@property (nonatomic, weak)id<AWTOverLayViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIView *statusView;

@end

NS_ASSUME_NONNULL_END
