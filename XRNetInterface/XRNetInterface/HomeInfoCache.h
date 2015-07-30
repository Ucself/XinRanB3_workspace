//
//  HomeInfoCache.h
//  XinRanApp
//
//  Created by tianbo on 14-12-18.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//
// 首页数据缓存

#import <Foundation/Foundation.h>

@interface HomeInfoCache : NSObject

+(HomeInfoCache*)sharedInstance;

-(void)setHomeInfo:(NSDictionary*)dict;
-(NSDictionary*)getHomeInfo;

//缓存客户管理信息
-(void)setCustomerInfor:(NSArray*)customerInfor;
//缓存客户管理信息
-(NSArray *)getCustomerInfor;
@end
