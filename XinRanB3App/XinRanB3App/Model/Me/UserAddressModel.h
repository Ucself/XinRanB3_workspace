//
//  UserAddressModel.h
//  XinRanB3App
//
//  Created by libj on 15/5/26.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "BaseModel.h"

@interface UserAddressModel : BaseModel

@property(nonatomic,strong) NSString* address;
@property(nonatomic,strong) NSString* area_id;
@property(nonatomic,strong) NSString* addId;
@property(nonatomic,strong) NSString* name;
@property(nonatomic,strong) NSString* phone;
@property(nonatomic,assign) BOOL isDefault;


//初始化数据
-(id)initWithDictionary:(NSDictionary*)dictionary;

@end
