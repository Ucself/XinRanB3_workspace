//
//  GoodsModel.m
//  XinRanB3App
//
//  Created by libj on 15/5/29.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "GoodsModel.h"

@implementation GoodsModel

//初始化数据
-(id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        
        if ([dictionary objectForKey:@"comd"]) {
            self.goodsComd = (int)[[dictionary objectForKey:@"comd"] integerValue];
        }
        
        if ([dictionary objectForKey:@"desc"]) {
            self.goodsDesc = [dictionary objectForKey:@"desc"];
        }
        
        if ([dictionary objectForKey:@"gc"]) {
            self.goodsGc = [dictionary objectForKey:@"gc"];
        }
        
        if ([dictionary objectForKey:@"id"]) {
            self.goodsId = [dictionary objectForKey:@"id"];
        }
        
        if ([dictionary objectForKey:@"image"]) {
            self.goodsImage = [dictionary objectForKey:@"image"];
        }
        if ([dictionary objectForKey:@"name"]) {
            self.goodsName = [dictionary objectForKey:@"name"];
        }
        
        if ([dictionary objectForKey:@"old_price"]) {
            self.goodsOldPrice = [dictionary objectForKey:@"old_price"];
        }
        
        if ([dictionary objectForKey:@"price"]) {
            self.goodsPrice = [dictionary objectForKey:@"price"];
        }
        
        if ([[dictionary objectForKey:@"remaind" ] integerValue]) {
            self.goodsRemaind = (int)[[dictionary objectForKey:@"remaind" ] integerValue];
        }
        if ([[dictionary objectForKey:@"saled" ] integerValue]) {
            self.goodsRemaind = (int)[[dictionary objectForKey:@"saled" ] integerValue];
        }
        if ([[dictionary objectForKey:@"num" ] integerValue]) {
            self.goodsNum = (int)[[dictionary objectForKey:@"num" ] integerValue];
        }
        
        ////////////////////
        if ([[dictionary objectForKey:@"storage_num" ] integerValue]) {
            self.storageNum = (int)[[dictionary objectForKey:@"storage_num" ] integerValue];
        }
        if ([dictionary objectForKey:@"product_no"]) {
            self.productNo = [dictionary objectForKey:@"product_no"];
        }
        
        ///////////
        if ([dictionary objectForKey:@"product_id"]) {
            self.productId = [dictionary objectForKey:@"product_id"];
        }
        if ([[dictionary objectForKey:@"quantity"] integerValue]) {
            self.quantity = [[dictionary objectForKey:@"quantity"] integerValue];
        }
        if ([dictionary objectForKey:@"sale_detail_id"]) {
            self.saleDetailId = [dictionary objectForKey:@"sale_detail_id"];
        }
        if ([[dictionary objectForKey:@"total"] floatValue]) {
            self.total = [[dictionary objectForKey:@"total"] floatValue];
        }
        if ([dictionary objectForKey:@"back"]) {
            self.back = [[dictionary objectForKey:@"back"] integerValue];
        }
        if ([dictionary objectForKey:@"returnedback"]) {
            self.returnedBack = [[dictionary objectForKey:@"returnedback"] integerValue];
        }
        
    }
    return self;
}


@end
