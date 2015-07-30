//
//  CustomerOrderModel.m
//  XinRanB3App
//
//  Created by libj on 15/6/9.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "CustomerOrderModel.h"
#import "GoodsModel.h"

@implementation CustomerOrderModel

//初始化数据
-(id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        
        if ([dictionary objectForKey:@"customer_id"]) {
            self.customerId = [dictionary objectForKey:@"customer_id"];
        }
        
        if ([dictionary objectForKey:@"goods"]) {
            NSArray *tempArray =(NSArray *)[dictionary objectForKey:@"goods"];
            self.goods = [[NSMutableArray alloc] init];
            
            for (NSDictionary *tempDic in tempArray) {
                GoodsModel *tempGoodsModel = [[GoodsModel alloc] initWithDictionary:tempDic];
                [self.goods addObject:tempGoodsModel];
            }
        }
        
        if ([dictionary objectForKey:@"ord_id"]) {
            self.orderId = [dictionary objectForKey:@"ord_id"];
        }
        
        if ([[dictionary objectForKey:@"order_total" ] floatValue]) {
            self.orderTotal = (float)[[dictionary objectForKey:@"order_total" ] floatValue];
        }
        
        if ([dictionary objectForKey:@"saledate"]) {
            self.saleDate = [dictionary objectForKey:@"saledate"];
        }
        

    }
    return self;
}


@end
