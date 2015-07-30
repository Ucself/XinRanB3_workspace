//
//  Areas.m
//  XinRanApp
//
//  Created by tianbo on 14-12-22.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "Areas.h"
#import <XRNetInterface/FMDBUtils.h>
#import <XRNetInterface/FMResultSet.h>

@interface Areas (){
    
}

@end
@implementation Areas

-(id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        if ([dictionary isKindOfClass:[NSNull class]] || !dictionary) {
            return self;
        }
        
        self.Id = [dictionary objectForKey:KJsonElement_ID];
        self.name = [dictionary objectForKey:KJsonElement_Name];
        self.state = [[dictionary objectForKey:KJsonElement_Status] intValue];
        self.pId = [dictionary objectForKey:KJsonElement_Pid];
        self.order = [[dictionary objectForKey:KJsonElement_Order] intValue];
    }
    
    return self;
    
}
//对象序列化方法
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.Id forKey:KJsonElement_ID];
    [aCoder encodeObject:self.name forKey:KJsonElement_Name];
    [aCoder encodeObject:[NSNumber numberWithInt:self.state] forKey:KJsonElement_Status];
    [aCoder encodeObject:self.pId forKey:KJsonElement_Pid];
    [aCoder encodeObject:[NSNumber numberWithInt:self.order] forKey:KJsonElement_Order];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.Id = [aDecoder decodeObjectForKey:KJsonElement_ID];
        self.name = [aDecoder decodeObjectForKey:KJsonElement_Name];
        self.state = [[aDecoder decodeObjectForKey:KJsonElement_Status] intValue];
        self.pId = [aDecoder decodeObjectForKey:KJsonElement_Pid];
        self.order = [[aDecoder decodeObjectForKey:KJsonElement_Order] intValue];
    }
    return  self;
}
#pragma mark- 数据库操作
//数据库路径
+(NSString *) dbFilePath{
    return [[NSBundle mainBundle] pathForResource:@"AraeDB" ofType:@"sqlite"];
}

//表名
+ (NSString * ) tableName{
    return @"T_Areas";
}
//表名
+ (NSString * ) selectAllHeard{
    return [@"SELECT * from " stringByAppendingString:[self tableName]];
}

#pragma mark --数据操作
+(NSArray*)modelList
{
    //拼接sql语句
    NSString *sql= [[self selectAllHeard] stringByAppendingString:@" order by id "];
    //解析查出来的数据
    __block NSMutableArray *returnList  = [[NSMutableArray alloc] init];
    [FMDBUtils query:sql dbFile:[self dbFilePath] result:^(FMResultSet *resultSet) {
        Areas *tempAreas = [self createBean:resultSet];
        if (tempAreas) {
            [returnList addObject:tempAreas];
        }
    }];
    return returnList;
}

+(NSArray*)provinceList
{
    NSString *sql= [[self selectAllHeard] stringByAppendingString:@" where parent_id = '0' "];
    //解析查出来的数据
    __block NSMutableArray *returnList  = [[NSMutableArray alloc] init];
    [FMDBUtils query:sql dbFile:[self dbFilePath] result:^(FMResultSet *resultSet) {
        Areas *tempAreas = [self createBean:resultSet];
        if (tempAreas) {
            [returnList addObject:tempAreas];
        }
    }];
    return returnList;
}
+(NSArray*)cityList:(NSString*)provinceId
{
    NSString *sql= [[self selectAllHeard] stringByAppendingString:[NSString stringWithFormat:@" where parent_id = '%@' ", provinceId]];
    //解析查出来的数据
    __block NSMutableArray *returnList  = [[NSMutableArray alloc] init];
    [FMDBUtils query:sql dbFile:[self dbFilePath] result:^(FMResultSet *resultSet) {
        Areas *tempAreas = [self createBean:resultSet];
        if (tempAreas) {
            [returnList addObject:tempAreas];
        }
    }];
    return returnList;
}

+(NSArray*)districtList:(NSString*)cityId
{
    NSString *sql =  [[self selectAllHeard] stringByAppendingString:[NSString stringWithFormat:@" where parent_id = '%@' ", cityId]];
    //解析查出来的数据
    __block NSMutableArray *returnList  = [[NSMutableArray alloc] init];
    [FMDBUtils query:sql dbFile:[self dbFilePath] result:^(FMResultSet *resultSet) {
        Areas *tempAreas = [self createBean:resultSet];
        if (tempAreas) {
            [returnList addObject:tempAreas];
        }
    }];
    return returnList;
}
+(Areas*)getArearWithId:(NSString*)Id
{
    NSString *sql = [[self selectAllHeard] stringByAppendingString:[NSString stringWithFormat:@" where id = '%@' ", Id]];
    
    __block Areas *areas = nil;
    [FMDBUtils query:sql dbFile:[self dbFilePath] result:^(FMResultSet *resultSet) {
        areas = [self createBean:resultSet];
    }];
    return areas;
}

//生成对象
+ (Areas *)createBean:(FMResultSet *) stmt{

    NSString *Id =  [stmt stringForColumnIndex:0];
    NSString *name = [stmt stringForColumnIndex:1];
    int state = [stmt intForColumnIndex:2];
    NSString *pId = [stmt stringForColumnIndex:3];
    int order = [stmt intForColumnIndex:4];
    if(Id==nil || [Id length]==0){
        return nil;
    }
    Areas * bean = [Areas new];
    bean.Id = Id;
    bean.name =name;
    bean.state = state;
    bean.pId = pId;
    bean.order = order;
    return bean;
}
@end
