//
//  CustomerModel.m
//  XinRanB3App
//
//  Created by libj on 15/6/3.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "CustomerModel.h"

@implementation CustomerModel

//初始化数据
-(id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        
        if ([dictionary objectForKey:@"gender"] && ![[dictionary objectForKey:@"gender"] isKindOfClass:[NSNull class]]) {
            self.gender = (int)[[dictionary objectForKey:@"gender"] integerValue];
        }
        else{
            self.gender = 1;
        }
        
        if ([dictionary objectForKey:@"id"]  && ![[dictionary objectForKey:@"id"] isKindOfClass:[NSNull class]]) {
            self.cId = [dictionary objectForKey:@"id"];
        }
        else{
            self.cId = @"";
        }
        
        if ([dictionary objectForKey:@"name"]  && ![[dictionary objectForKey:@"name"] isKindOfClass:[NSNull class]]) {
            self.name = [dictionary objectForKey:@"name"];
        }
        else {
            self.name = @"";
        }
        
        if ([dictionary objectForKey:@"telephone"]  && ![[dictionary objectForKey:@"telephone"] isKindOfClass:[NSNull class]]) {
            self.telephone = [dictionary objectForKey:@"telephone"];
        }
        else{
            self.telephone = @"";
        }
    }
    return self;
}
//对象序列化方法
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[NSNumber numberWithInt:self.gender] forKey:@"gender"];
    [aCoder encodeObject:self.cId forKey:@"cId"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.telephone forKey:@"telephone"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.gender = [[aDecoder decodeObjectForKey:@"gender"] intValue];
        self.cId = [aDecoder decodeObjectForKey:@"cId"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.telephone = [aDecoder decodeObjectForKey:@"telephone"];
    }
    return  self;
}

@end
