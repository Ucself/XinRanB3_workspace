//
//  HaveReturnGoodsModel.h
//  XinRanB3App
//
//  Created by libj on 15/6/10.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "BaseModel.h"

@interface HaveReturnGoodsModel : BaseModel


@property (nonatomic,strong) NSString *backOrderDetailId;
@property (nonatomic,strong) NSString *backSaleDate;
@property (nonatomic,strong) NSString *images;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) float price;
@property (nonatomic,strong) NSString *prodcutId;
@property (nonatomic,assign) int quantity;
@property (nonatomic,strong) NSString *reason;
@property (nonatomic,strong) NSString *remark;
@property (nonatomic,assign) float total;

//初始化数据
-(id)initWithDictionary:(NSDictionary*)dictionary;
@end
