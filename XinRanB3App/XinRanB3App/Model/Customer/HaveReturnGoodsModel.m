//
//  HaveReturnGoodsModel.m
//  XinRanB3App
//
//  Created by libj on 15/6/10.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "HaveReturnGoodsModel.h"

@implementation HaveReturnGoodsModel

//初始化数据
-(id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        
        if ([dictionary objectForKey:@"back_order_detail_id"]) {
            self.backOrderDetailId = [dictionary objectForKey:@"back_order_detail_id"];
        }
        
        if ([dictionary objectForKey:@"backsaledate"]) {
            self.backSaleDate = [dictionary objectForKey:@"backsaledate"];
        }
        
        if ([dictionary objectForKey:@"images"]) {
            self.images = [dictionary objectForKey:@"images"];
        }
        
        if ([dictionary objectForKey:@"name"]) {
            self.name = [dictionary objectForKey:@"name"];
        }
        
        if ([[dictionary objectForKey:@"price" ] floatValue]) {
            self.price = [[dictionary objectForKey:@"price" ] floatValue];
        }
        
        if ([dictionary objectForKey:@"prodcut_id"]) {
            self.prodcutId = [dictionary objectForKey:@"prodcut_id"];
        }
        
        if ([[dictionary objectForKey:@"quantity" ] integerValue]) {
            self.quantity = [[dictionary objectForKey:@"quantity" ] integerValue];
        }
        
        if ([dictionary objectForKey:@"reason"]) {
            self.reason = [dictionary objectForKey:@"reason"];
        }
        
        if ([dictionary objectForKey:@"remark"]) {
            self.remark = [dictionary objectForKey:@"remark"];
        }
        
        if ([[dictionary objectForKey:@"total" ] floatValue]) {
            self.total = [[dictionary objectForKey:@"total" ] floatValue];
        }
        
    }
    return self;
}


@end
