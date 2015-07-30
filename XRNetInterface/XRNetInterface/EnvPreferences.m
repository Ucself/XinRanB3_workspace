//
//  ConfigInfo.m
//  XinRanApp
//
//  Created by tianbo on 14-12-5.
//  Copyright (c) 2014年 deshan.com All rights reserved.
//

#import "EnvPreferences.h"
#import <XRCommon/FileManager.h>
#import <XRCommon/XRCommon.h>

@interface EnvPreferences ()
{
    NSMutableDictionary  *preDict;
}

@end


@implementation EnvPreferences

+(EnvPreferences*)sharedInstance
{
    static EnvPreferences *instance = nil;
    static dispatch_once_t once;
    _dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}


-(void)save
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *fullPath = [FileManager fileFullPathAtDocumentsDirectory:@"Preferences.plist"];
        if (![NSKeyedArchiver archiveRootObject:preDict toFile:fullPath]) {
            DBG_MSG(@"wirte file 'Preferences.plist' failed!");
        }
    });
    //[FileManager writeToFile:preDict fileName:@"Preferences.plist"];
}

-(id)init
{
    self = [super init];
    if ( !self ){
        return nil;
    }
    NSString *fullPath = [FileManager fileFullPathAtDocumentsDirectory:@"Preferences.plist"];
    preDict = [NSKeyedUnarchiver unarchiveObjectWithFile:fullPath];
    if (preDict == nil)
    {
        preDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}


-(void)dealloc
{
    [self save];
}


#pragma mark-

-(NSString*)getAppVersion
{
    NSString *version = [preDict valueForKey:@"Version"];
    DBG_MSG(@"The local version is %@", version);
    return version;
}

-(void)setAppVersion:(NSString*)version
{
    [preDict  setValue:version forKey:@"Version"];
    [self save];
}


-(void)setToken:(NSString *)token
{
    [preDict  setValue:token forKey:@"userToken"];
    [self save];
//    if (![_token isEqualToString:token]) {
//        _token = token;
//    }
}

-(NSString*)getToken
{
    return [preDict objectForKey:@"userToken"];
//    return self.token;
}

-(void)setUser:(NSDictionary*)dic
{
    [preDict setValue:dic forKey:@"UserInfor"];
    [self save];
}
-(NSDictionary*)getUser
{
    return [preDict objectForKey:@"UserInfor"];
}

//检查更新日期
-(void)setCheckData:(NSString*)data
{
    [preDict setValue:data forKey:@"CheckData"];
    [self save];
}

-(NSString*)getCheckData
{
    return [preDict objectForKey:@"CheckData"];
}


-(void)setAVersion:(NSString*)ver
{
    [preDict setValue:ver forKey:@"AVersion"];
    [self save];
}
-(NSString*)getAVersion
{
    return [preDict objectForKey:@"AVersion"];
}
-(void)setBVersion:(NSString*)ver
{
    [preDict setValue:ver forKey:@"BVersion"];
    [self save];
}
-(NSString*)getBVersion
{
    return [preDict objectForKey:@"BVersion"];
}
-(void)setCVersion:(NSString*)ver
{
    [preDict setValue:ver forKey:@"CVersion"];
    [self save];
}
-(NSString*)getCVersion
{
    return [preDict objectForKey:@"CVersion"];
}
-(void)setWVersion:(NSString*)ver
{
    [preDict setValue:ver forKey:@"WVersion"];
    [self save];
}
-(NSString*)getWVersion
{
    return [preDict objectForKey:@"WVersion"];
}
//缓存选择的收货地址
-(void)setSelectedShipAddress:(NSDictionary*)dic
{
    [preDict setValue:dic forKey:@"selectedShipAddress"];
    [self save];
}
-(NSDictionary *)getSelectedShipAddress
{
    return [preDict objectForKey:@"selectedShipAddress"];
}


@end




