//
//  IWTConstants.h
//  iwutong
//
//  Created by 司晓鑫 on 2019/11/16.
//  Copyright © 2019 Facebook. All rights reserved.
//

#ifndef IWTConstants_h
#define IWTConstants_h

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)




//字体宏
#define UIFONT_FONTNAME_SIZE(name, fontSize) [UIFont fontWithName:(name) size:(fontSize)]
#define IWTFONTPFSCSemibold(fontSize) UIFONT_FONTNAME_SIZE(@"PingFangSC-Semibold",(fontSize))
#define IWTFONTPFSCMedium(fontSize) UIFONT_FONTNAME_SIZE(@"PingFangSC-Medium",(fontSize))
#define IWTFONTPFSCRegular(fontSize) UIFONT_FONTNAME_SIZE(@"PingFangSC-Regular",(fontSize))



#endif /* IWTConstants_h */
