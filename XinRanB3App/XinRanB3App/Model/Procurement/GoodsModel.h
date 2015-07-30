//
//  GoodsModel.h
//  XinRanB3App
//
//  Created by libj on 15/5/29.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "BaseModel.h"

@interface GoodsModel : BaseModel

@property(nonatomic,assign) int goodsComd;
@property(nonatomic,strong) NSString *goodsDesc;
@property(nonatomic,strong) NSString *goodsGc;
@property(nonatomic,strong) NSString *goodsId;
@property(nonatomic,strong) NSString *goodsImage;
@property(nonatomic,strong) NSString *goodsName;
@property(nonatomic,strong) NSString *goodsOldPrice;
@property(nonatomic,strong) NSString *goodsPrice;
@property(nonatomic,assign) int goodsRemaind;
@property(nonatomic,assign) int goodsSaled;
@property(nonatomic,assign) int goodsNum;

//客户下单的属性
@property(nonatomic,strong) NSString *productNo;
@property(nonatomic,assign) int storageNum;

//客户订单列表属性
@property(nonatomic,strong) NSString *productId;
@property(nonatomic,assign) int quantity;
@property(nonatomic,strong) NSString *saleDetailId;
@property(nonatomic,assign) float total;
@property (nonatomic,assign) int back;
@property (nonatomic,assign) int returnedBack;


//初始化数据
-(id)initWithDictionary:(NSDictionary*)dictionary;

@end
