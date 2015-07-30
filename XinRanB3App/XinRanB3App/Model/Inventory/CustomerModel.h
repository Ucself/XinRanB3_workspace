//
//  CustomerModel.h
//  XinRanB3App
//
//  Created by libj on 15/6/3.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "BaseModel.h"

@interface CustomerModel : BaseModel

@property (nonatomic,assign) int gender;
@property (nonatomic,strong) NSString *cId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *telephone;

//初始化数据
-(id)initWithDictionary:(NSDictionary*)dictionary;

@end
