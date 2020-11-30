//
//  NSFileManager+Additions.h
//  AWT_iOS
//
//  Created by apple on 2019/10/27.
//  Copyright © 2019年 wtoip_mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (Additions)
- (NSString *)temporaryDirectoryWithTemplateString:(NSString *)templateString;
@end

NS_ASSUME_NONNULL_END
