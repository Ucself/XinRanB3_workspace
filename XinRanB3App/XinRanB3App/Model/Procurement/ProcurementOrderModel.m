//
//  ProcurementOrderModel.m
//  XinRanB3App
//
//  Created by libj on 15/6/1.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "ProcurementOrderModel.h"
#import "GoodsModel.h"


@implementation ProcurementOrderModel


//初始化数据
-(id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        
        if ([dictionary objectForKey:@"addtime"]) {
            self.orderAddTime = [dictionary objectForKey:@"addtime"];
        }
        
        if ([dictionary objectForKey:@"goods"]) {
            NSArray *tempArray =(NSArray *)[dictionary objectForKey:@"goods"];
            self.ordergoodsModels = [[NSMutableArray alloc] init];
            
            for (NSDictionary *tempDic in tempArray) {
                GoodsModel *tempGoodsModel = [[GoodsModel alloc] initWithDictionary:tempDic];
                [self.ordergoodsModels addObject:tempGoodsModel];
            }
        }
        
        if ([dictionary objectForKey:@"id"]) {
            self.orderId = [dictionary objectForKey:@"id"];
        }
        
        if ([dictionary objectForKey:@"payment_id"]) {
            self.orderPaymentId = [dictionary objectForKey:@"payment_id"];
        }
        if ([dictionary objectForKey:@"sn"]) {
            self.orderSN = [dictionary objectForKey:@"sn"];
        }
        
        if ([[dictionary objectForKey:@"state" ] integerValue]) {
            self.orderState = (int)[[dictionary objectForKey:@"state" ] integerValue];
        }
        
    }
    return self;
}


@end
