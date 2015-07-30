//
//  ConfigInfo.h
//  XinRanApp
//
//  Created by tianbo on 14-12-5.
//  Copyright (c) 2014年 deshan.com All rights reserved.
//
//  系统环境参数类

#import <Foundation/Foundation.h>

@interface EnvPreferences : NSObject
{
    
}

+(EnvPreferences*)sharedInstance;

//本地保存的app版本
-(NSString*)getAppVersion;
-(void)setAppVersion:(NSString*)version;

//用户登录信息
-(void)setToken:(NSString *)token;
-(NSString*)getToken;
//用户登录的账号密码
-(void)setUser:(NSDictionary*)dic;
-(NSDictionary*)getUser;

//检查更新日期
-(void)setCheckData:(NSString*)data;
-(NSString*)getCheckData;

-(void)setAVersion:(NSString*)ver;
-(NSString*)getAVersion;
-(void)setBVersion:(NSString*)ver;
-(NSString*)getBVersion;
-(void)setCVersion:(NSString*)ver;
-(NSString*)getCVersion;
-(void)setWVersion:(NSString*)ver;
-(NSString*)getWVersion;
//缓存选择的收货地址
-(void)setSelectedShipAddress:(NSDictionary*)dic;
-(NSDictionary *)getSelectedShipAddress;

@end
