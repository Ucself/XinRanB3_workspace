//
//  ProcurementOrderModel.h
//  XinRanB3App
//
//  Created by libj on 15/6/1.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "BaseModel.h"

@interface ProcurementOrderModel : BaseModel

@property(nonatomic,strong) NSString *orderAddTime;
@property(nonatomic,strong) NSMutableArray *ordergoodsModels;
@property(nonatomic,strong) NSString *orderId;
@property(nonatomic,strong) NSString *orderPaymentId;
@property(nonatomic,strong) NSString *orderSN;
@property(nonatomic,assign) int orderState;

//初始化数据
-(id)initWithDictionary:(NSDictionary*)dictionary;

@end
