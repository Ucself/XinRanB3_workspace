//
//  ProcurementOrderDetailModel.m
//  XinRanB3App
//
//  Created by libj on 15/6/1.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "ProcurementOrderDetailModel.h"
#import "GoodsModel.h"

@implementation ProcurementOrderDetailModel


//初始化数据
-(id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        
        if ([dictionary objectForKey:@"payment_id"]) {
            self.detailPaymentId = [dictionary objectForKey:@"payment_id"];
        }
        
        if ([dictionary objectForKey:@"area_id"]) {
            self.detailAreaId = [dictionary objectForKey:@"area_id"];
        }
        
        if ([dictionary objectForKey:@"goods"]) {
            NSArray *tempArray =(NSArray *)[dictionary objectForKey:@"goods"];
            self.detailGoodsModels = [[NSMutableArray alloc] init];
            
            for (NSDictionary *tempDic in tempArray) {
                GoodsModel *tempGoodsModel = [[GoodsModel alloc] initWithDictionary:tempDic];
                [self.detailGoodsModels addObject:tempGoodsModel];
            }
        }
        
        if ([dictionary objectForKey:@"payment_name"]) {
            self.detailPaymentName = [dictionary objectForKey:@"payment_name"];
        }
        
        if ([dictionary objectForKey:@"finnshed_time"]) {
            self.detailFinishTime = [dictionary objectForKey:@"finnshed_time"];
        }
        if ([dictionary objectForKey:@"addtime"]) {
            self.detailAddTime = [dictionary objectForKey:@"addtime"];
        }
        if ([dictionary objectForKey:@"price"]) {
            self.detailPrice = [dictionary objectForKey:@"price"];
        }
        if ([dictionary objectForKey:@"consignee"]) {
            self.detailConsignee = [dictionary objectForKey:@"consignee"];
        }
        if ([dictionary objectForKey:@"payment_time"]) {
            self.detailPaymentTime = [dictionary objectForKey:@"payment_time"];
        }
        if ([dictionary objectForKey:@"shipping_code"]) {
            self.detailShippingCode = [dictionary objectForKey:@"shipping_code"];
        }
        if ([dictionary objectForKey:@"phone"]) {
            self.detailPhone = [dictionary objectForKey:@"phone"];
        }
        if ([[dictionary objectForKey:@"state" ] integerValue]) {
            self.detailState = (int)[[dictionary objectForKey:@"state" ] integerValue];
        }
        if ([dictionary objectForKey:@"sn"]) {
            self.detailSN = [dictionary objectForKey:@"sn"];
        }
        if ([dictionary objectForKey:@"address"]) {
            self.detailAddress = [dictionary objectForKey:@"address"];
        }
        if ([dictionary objectForKey:@"shipping_company"]) {
            self.detailShippingCompany = [dictionary objectForKey:@"shipping_company"];
        }
        if ([dictionary objectForKey:@"id"]) {
            self.detailId = [dictionary objectForKey:@"id"];
        }
        if ([dictionary objectForKey:@"shipping_time"]) {
            self.detailShippingTime = [dictionary objectForKey:@"shipping_time"];
        }
        
    }
    return self;
}


@end
