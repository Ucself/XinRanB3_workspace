//
//  UserModel.m
//  XinRanB3App
//
//  Created by libj on 15/5/21.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

//对象序列化方法
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userName forKey:@"username"];
    [aCoder encodeObject:self.userPassword forKey:@"password"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        
        self.userName = [aDecoder decodeObjectForKey:@"username"];
        self.userPassword = [aDecoder decodeObjectForKey:@"password"];
    }
    return  self;
}

@end
