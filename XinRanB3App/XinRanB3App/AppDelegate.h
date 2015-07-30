//
//  AppDelegate.h
//  XinRanB3App
//
//  Created by libj on 15/5/18.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XRCommon/Common.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic, assign) XNetworkStatus netStatus;

@end

