//
//  UserAddressModel.m
//  XinRanB3App
//
//  Created by libj on 15/5/26.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "UserAddressModel.h"

@implementation UserAddressModel

//初始化数据
-(id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        //详细地址地址
        if ([dictionary objectForKey:@"address"]) {
            self.address = [dictionary objectForKey:@"address"];
        }
        //area_id
        if ([dictionary objectForKey:@"area_id"]) {
            self.area_id = [dictionary objectForKey:@"area_id"];
        }
        //id
        if ([dictionary objectForKey:@"id"]) {
            self.addId = [dictionary objectForKey:@"id"];
        }
        //name
        if ([dictionary objectForKey:@"name"]) {
            self.name = [dictionary objectForKey:@"name"];
        }
        //phone
        if ([dictionary objectForKey:@"phone"]) {
            self.phone = [dictionary objectForKey:@"phone"];
        }
        //is_default
        if ([[dictionary objectForKey:@"is_default" ] integerValue]) {
            self.isDefault = YES;
        }
    }
    return self;
}

//对象序列化方法
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.area_id forKey:@"area_id"];
    [aCoder encodeObject:self.addId forKey:@"addId"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.isDefault?@"1":@"0" forKey:@"isDefault"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.area_id = [aDecoder decodeObjectForKey:@"area_id"];
        self.addId = [aDecoder decodeObjectForKey:@"addId"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.isDefault = [[aDecoder decodeObjectForKey:@"isDefault"] isEqualToString:@"1"] ? YES : NO;
    }
    return  self;
}
@end
