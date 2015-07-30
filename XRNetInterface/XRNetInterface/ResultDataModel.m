//
//  ResultDataModel.m
//  XinRanApp
//
//  Created by tianbo on 14-12-9.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "ResultDataModel.h"

@implementation ResultDataModel

-(void)dealloc
{
    self.desc = nil;
    self.data = nil;
}

-(id)initWithDictionary:(NSDictionary *)dict reqType:(int)reqestType
{
    self = [super init];
    if ([dict isKindOfClass:[NSNull class]] || dict == nil) {
        return self;
    }
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return self;
    }

    if (self) {
        self.data = nil;
        self.requestType = reqestType;
        
        int resultCode = [[dict objectForKey:@"result"] intValue];
        self.resultCode = resultCode;
        
        if (resultCode == 0) {
            self.desc = @"请求成功";
            [self parseData:dict];
        }
        else {
            NSString *msg = [dict objectForKey:@"msg"];
            self.desc = msg ? msg : @"未知错误";
        }
    }
    
    return self;
}

-(id)initWithErrorInfo:(NSError*)error reqType:(int)reqestType
{
    self = [super init];
    if (self) {
        self.requestType = reqestType;
        self.resultCode = (int)error.code;
        DBG_MSG(@"http request error code: (%d)", self.resultCode);
        switch (self.resultCode) {
            case NSURLErrorNotConnectedToInternet:
                self.desc = @"亲，你的网络不给力，请检查网络!";
                break;
            default:
                self.desc = @"亲，数据获取失败，请重试!";
                break;
        }
        self.data = nil;
    }
    
    return self;
}

-(NSString*)parseErrorCode:(NSInteger)code
{
    NSString *ret = @"";
    switch (code) {

        case 401:
            ret = @"请求失败";
            break;
            
        default:
            break;
    }
    return  ret;
}

#pragma mark- 解析数据
//将返回的字典数据转化为相应的类
-(id)parseData:(NSDictionary*)dict
{
    NSDictionary *ret = nil;
    switch (self.requestType) {
        case KReqestType_Login:
            [self parseLoginData:dict];
            break;
        case KReqestType_Getconfignees:
            [self parseGetconfigneesData:dict];
            break;
        case KReqestType_GetGoodsList:
            [self parseGetGoodsListData:dict];
            break;
        case KReqestType_GetDefaultConfignees:
            [self parseDicData:dict];
            break;
        case KReqestType_GetGoodsOrderList:
            [self parseArrayData:dict];
            break;
        case KReqestType_GetGoodsOrderDetail:
            [self parseDicData:dict];
            break;
        case KReqestType_GetCustomerlist:
            [self parseArrayData:dict];
            break;
        case KReqestType_BuyGoodsOrder:
            [self parseBuyGoodsOrder:dict];
            break;
        case KReqestType_AddorUpdateConfignee:
            [self parseAddorUpdateConfignee:dict];
            break;
        case KReqestType_ProductStorage:
            [self parseArrayData:dict];
            break;
        case KReqestType_weixinPay:
            [self parseDicData:dict];
            break;
        case KReqestType_AliPay:
            [self parseDicData:dict];
            break;
        case KReqestType_CustomerSearch:
            [self parseArrayData:dict];
            break;
        case KReqestType_GetCustomerProductList:
            [self parseArrayData:dict];
            break;
        case KReqestType_CustomerOrderList:
            [self parseArrayData:dict];
            break;
        case KReqestType_CustomerBackorderlist:
            [self parseArrayData:dict];
        default:
            break;
    }

    return ret;
}
//解析数组
-(void)parseDicData:(NSDictionary *)dict
{
    NSDictionary *data = [dict objectForKey:KJsonElement_Data];
    self.data = data;
}
//解析字典
-(void)parseArrayData:(NSDictionary *)dict
{
    NSArray *array = [dict objectForKey:KJsonElement_Data];
    self.data = array;
}
//登录数据解析
-(void)parseLoginData:(NSDictionary *)dict
{
    NSDictionary *data = [dict objectForKey:KJsonElement_Token];
    self.data = data;
}
//获取收货地址数据解析
-(void)parseGetconfigneesData:(NSDictionary *)dict
{
    NSArray *array = [dict objectForKey:KJsonElement_Data];
    self.data = array;
}
//获取收货地址数据解析
-(void)parseGetGoodsListData:(NSDictionary *)dict
{
    NSArray *array = [dict objectForKey:KJsonElement_Data];
    self.data = array;
}
//生成订单获取支付秘钥，价格，订单号等信息解析
-(void)parseBuyGoodsOrder:(NSDictionary *)dict
{
    NSMutableDictionary *tempData = [[NSMutableDictionary alloc] init];
    [tempData setObject:[dict objectForKey:KJsonElement_Data] forKey:KJsonElement_Data];
    if ([dict objectForKey:KJsonElement_OrderId]) {
        [tempData setObject:[dict objectForKey:KJsonElement_OrderId] forKey:KJsonElement_OrderId];
    }
    if ([dict objectForKey:KJsonElement_Price]) {
        [tempData setObject:[dict objectForKey:KJsonElement_Price] forKey:KJsonElement_Price];
    }
    self.data = tempData;
}
//生成订单获取支付秘钥，价格，订单号等信息解析
-(void)parseAddorUpdateConfignee:(NSDictionary *)dict
{
    NSMutableDictionary *tempData = [[NSMutableDictionary alloc] init];
    [tempData setObject:[dict objectForKey:KJsonElement_ConsigneeId] forKey:KJsonElement_ConsigneeId];
    self.data = tempData;
}
@end
