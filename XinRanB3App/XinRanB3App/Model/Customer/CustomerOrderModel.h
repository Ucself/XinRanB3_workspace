//
//  CustomerOrderModel.h
//  XinRanB3App
//
//  Created by libj on 15/6/9.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "BaseModel.h"

@interface CustomerOrderModel : BaseModel

@property (nonatomic,strong) NSString *customerId;
@property (nonatomic,strong) NSMutableArray *goods;
@property (nonatomic,strong) NSString *orderId;
@property (nonatomic,assign) float orderTotal;
@property (nonatomic,strong) NSString *saleDate;




-(id)initWithDictionary:(NSDictionary*)dictionary;
@end
