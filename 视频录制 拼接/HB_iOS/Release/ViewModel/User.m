//
//  User.m
//  iwutong
//
//  Created by wtoip_mac on 2019/11/7.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "User.h"

@implementation User

- (void)encodeWithCoder:(NSCoder *)encoder{
  
      [encoder encodeObject:self.token forKey:@"token"];
      [encoder encodeObject:self.url forKey:@"url"];
      [encoder encodeObject:self.userName forKey:@"userName"];
      [encoder encodeObject:self.nickName forKey:@"nickName"];
  
}

- (id)initWithCoder:(NSCoder *)decoder{
  if (self = [super init]) {
    
    self.token = [decoder decodeObjectForKey:@"token"];
    self.url = [decoder decodeObjectForKey:@"url"];
    self.userName = [decoder decodeObjectForKey:@"userName"];
    self.nickName = [decoder decodeObjectForKey:@"nickName"];
   }
     return self;
}
+(User *)getUser{
  NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
  NSString *path = [doc stringByAppendingPathComponent:@"usr.archive"];
  User *user = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
  return user;
}


@end
