//
//  ProcurementOrderDetailModel.h
//  XinRanB3App
//
//  Created by libj on 15/6/1.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "BaseModel.h"

@interface ProcurementOrderDetailModel : BaseModel

@property(nonatomic,strong) NSString *detailPaymentId;
@property(nonatomic,strong) NSString *detailAreaId;
@property(nonatomic,strong) NSMutableArray *detailGoodsModels;
@property(nonatomic,strong) NSString *detailPaymentName;
@property(nonatomic,strong) NSString *detailFinishTime;
@property(nonatomic,strong) NSString *detailAddTime;
@property(nonatomic,strong) NSString *detailPrice;
@property(nonatomic,strong) NSString *detailConsignee;
@property(nonatomic,strong) NSString *detailPaymentTime;
@property(nonatomic,strong) NSString *detailShippingCode;
@property(nonatomic,strong) NSString *detailPhone;
@property(nonatomic,assign) int detailState;
@property(nonatomic,strong) NSString *detailSN;
@property(nonatomic,strong) NSString *detailAddress;
@property(nonatomic,strong) NSString *detailShippingCompany;
@property(nonatomic,strong) NSString *detailId;
@property(nonatomic,strong) NSString *detailShippingTime;


//初始化数据
-(id)initWithDictionary:(NSDictionary*)dictionary;

@end
