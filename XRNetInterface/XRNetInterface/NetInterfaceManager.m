//
//  NetInterfaceManager.m
//  XinRanApp
//
//  Created by tianbo on 14-12-8.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "NetInterfaceManager.h"
#import "NetInterface.h"
#import "JsonBuilder.h"
#import "ResultDataModel.h"
#import "EnvPreferences.h"
#import <XRCommon/ProtocolDefine.h>

@interface NetInterfaceManager ()
{
    NSString *recordUrl;
    NSString *recordBody;
    RequestType recordRequestType;
    int recordIsPost;
    NSString *controllerId;
}


@property(nonatomic, copy) void (^successBlock)(NSString* msg);
@property(nonatomic, copy) void (^failedBlock)(NSString* msg);
@end

@implementation NetInterfaceManager

+(NetInterfaceManager*)sharedInstance
{
    static NetInterfaceManager *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}



-(void)dealloc
{
    self.successBlock = nil;
    self.failedBlock = nil;
}

-(void)setSuccessBlock:(void (^)(NSString*))success failedBlock:(void (^)(NSString*))failed
{
    self.successBlock = success;
    self.failedBlock = failed;
}

#pragma mark---
-(void)postRequst:(NSString*)url body:(NSString*)body requestType:(int)type
{
    //记录一次请求数据
    recordUrl = url;
    recordBody = body;
    recordRequestType = type;
    recordIsPost = 1;
    
    [[NetInterface sharedInstance] httpPostRequest:url body:body suceeseBlock:^(NSString *msg){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //解析出token字符串
            if (type == KReqestType_Login) {
                NSString *token = [JsonBuilder tokenStringWithJosn:msg decode:NO key:nil];
                [[EnvPreferences sharedInstance] setToken:token];
            }
            //转化josn数据到ResultDataModel
            ResultDataModel *result = [[ResultDataModel alloc] initWithDictionary:[JsonBuilder dictionaryWithJson:msg decode:NO key:nil] reqType:type];
            //服务端验证失败token
            if (result.resultCode == 403 || result.resultCode == 401) {
                //鉴权失效重置token
                [[EnvPreferences sharedInstance] setToken:nil];
                //重新登录一次
                [self tokenExpireHandler];
                return ;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //通知页面
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_RequestFinished object:result];
            });
        });
        
    }failedBlock:^(NSError *error) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //转化错误信息到ResultDataModel
            ResultDataModel *result = [[ResultDataModel alloc] initWithErrorInfo:error reqType:type];
//            if (result.resultCode == 401) {
//                //鉴权失效重置token
//                [[EnvPreferences sharedInstance] setToken:nil];
//            }
            dispatch_async(dispatch_get_main_queue(), ^{
            //通知页面
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_RequestFailed object:result];
            });
            
        });
       
    }];
}

-(void)getRequst:(NSString*)url body:(NSString*)body requestType:(int)type
{
    //记录一次请求数据
    recordUrl = url;
    recordBody = body;
    recordRequestType = type;
    recordIsPost = 0;
    //携带token 请求
//    NSString *token = [[EnvPreferences sharedInstance] getToken];
//    [[NetInterface sharedInstance] setToken:token];
    [[NetInterface sharedInstance] httpGetRequest:url body:body suceeseBlock:^(NSString *msg){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            //解析出token字符串
            if (type == KReqestType_Login) {
                NSString *token = [JsonBuilder tokenStringWithJosn:msg decode:NO key:nil];
                [[EnvPreferences sharedInstance] setToken:token];
            }
            
            //转化josn数据到ResultDataModel
            ResultDataModel *result = [[ResultDataModel alloc] initWithDictionary:[JsonBuilder dictionaryWithJson:msg decode:NO key:nil] reqType:type];
            //服务端验证失败token
            if (result.resultCode == 403 || result.resultCode == 401) {
                //鉴权失效重置token
                [[EnvPreferences sharedInstance] setToken:nil];
                //重新登录一次
                [self tokenExpireHandler];
                return ;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //通知页面
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_RequestFinished object:result];
            });
            
        });
        
    }failedBlock:^(NSError *error) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //转化错误信息到ResultDataModel
            ResultDataModel *result = [[ResultDataModel alloc] initWithErrorInfo:error reqType:type];
//            if (result.resultCode == 403) {
//                //鉴权失效重置token
//                [[EnvPreferences sharedInstance] setToken:nil];
//            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //通知页面
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_RequestFailed object:result];
            });
            
        });
    }];
}

#pragma mark -----
//会话过期处理方法
-(void)tokenExpireHandler {
    
    //// stup 1. 登录
    NSDictionary  *userDic = [[EnvPreferences sharedInstance] getUser];
    //用户名
    NSString *userName = [userDic objectForKey:KJsonElement_UserName];
    NSString *userPassword = [userDic objectForKey:KJsonElement_Password];
    
    if (userName && userPassword) {
        
        NSString *body = [[JsonBuilder sharedInstance] jsonWithLogin:userName pwd:userPassword];
        NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, KUrl_Login];
//        [self postRequst:url body:body requestType:KReqestType_Login];
        [[NetInterface sharedInstance] httpPostRequest:url body:body suceeseBlock:^(NSString *msg){
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //解析出token字符串
                NSString *token = [JsonBuilder tokenStringWithJosn:msg decode:NO key:nil];
                //转化josn数据到ResultDataModel
                ResultDataModel *result = [[ResultDataModel alloc] initWithDictionary:[JsonBuilder dictionaryWithJson:msg decode:NO key:nil] reqType:KReqestType_Login];
                //登录成功重新加载
                if (result.resultCode == 0) {
                    [[EnvPreferences sharedInstance] setToken:token];
                    //// stup 2. 重新请求
                    [self reloadRecordData];
                }
                else if (result.resultCode == 1 || result.resultCode == 3){
                    //账号密码错误跳入登录
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //通知页面
                        [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_GotoLoginControl object:result];
                    });
                }
                else{
                    //重新登录失败提示数据加载失败 ，//自动登录失败了
                    result.desc = @"数据请求失败！";
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //通知页面
                        [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_RequestFailed object:result];
                    });
                }
                
            });
            
        }failedBlock:^(NSError *error) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //转化错误信息到ResultDataModel
                ResultDataModel *result = [[ResultDataModel alloc] initWithErrorInfo:error reqType:KReqestType_Login];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //通知页面
                    [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_RequestFailed object:result];
                });
                
            });
            
        }];
    }
    else{
        //这里应该跳入登录 账号密码都没有了 跳入登录界面
        dispatch_async(dispatch_get_main_queue(), ^{
            //通知页面
            [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_GotoLoginControl object:nil];
        });
    }
}
/**
 *  设置当前的ViewController
 *
 *  @param controller name
 */
-(void)setReqControllerId:(NSString*)cId
{
    //DBG_MSG(@"--controllerid=%@", cId)
    controllerId= cId;
}

-(NSString*)getReqControllerId
{
    return controllerId;
}

/**
 *  重新加载一次数据
 */
-(void) reloadRecordData {
    
    //重新加载的时候更换最新的token
    NSMutableDictionary *tempDicBody = [[NSMutableDictionary alloc] initWithDictionary:(NSMutableDictionary*)[JsonBuilder dictionaryWithJson:recordBody decode:NO key:nil]];
    NSString *tempToken = [[EnvPreferences sharedInstance] getToken];
    if ([tempDicBody objectForKey:@"token"] && tempToken) {
        [tempDicBody setObject:tempToken forKey:@"token"];
    }
    
    //更换recordBody
    recordBody = [JsonBuilder jsonWithDictionary:tempDicBody];
    
    if (recordUrl && recordBody) {
        switch (recordIsPost) {
            case 1:
                [self postRequst:recordUrl body:recordBody requestType:recordRequestType];
                break;
            case 0:
                [self getRequst:recordUrl body:recordBody requestType:recordRequestType];
                break;
            default:
                break;
        }
    }

}

#pragma mark -----

/**
 *  登录接口
 *
 *  @param name 用户名称
 *  @param pwd  用户密码密码
 */
-(void)login:(NSString*)name pwd:(NSString*)pwd
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithLogin:name pwd:pwd];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, KUrl_Login];
    [self postRequst:url body:body requestType:KReqestType_Login];
    
}
/**
 *  修改密码接口
 */
-(void)changPassword:(NSString *)oldpwd newpwd:(NSString *)newpwd
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithChangPassword:oldpwd newPwd:newpwd];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, KUrl_ChangPassword];
    [self postRequst:url body:body requestType:KReqestType_ChangPassword];
}
/**
 *  注销接口
 */
-(void)logout
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithLogout];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, KUrl_Logout];
    [self getRequst:url body:body requestType:KReqestType_Logout];
}

/**
 *
 * 获取地址列表
 *
 */
-(void)getConfignees
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithGetConfignees];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, KUrl_Getconfignees];
    [self postRequst:url body:body requestType:KReqestType_Getconfignees];
    
}
/**
 *
 * 获取默认地址列表
 *
 */
-(void)getDefaultConfignees
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithGetDefaultConfignees];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, KUrl_GetDefaultConfignees];
    [self postRequst:url body:body requestType:KReqestType_GetDefaultConfignees];
    
}
/**
 *
 * 删除收货地址
 *
 */
-(void)deleteConfignee:(NSString*)conId
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithDeleteConfignees:conId];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, KUrl_DeleteConfignee];
    [self postRequst:url body:body requestType:KReqestType_DeleteConfignees];
}
/**
 *
 * 添加或者更新收货地址
 *
 */
-(void)addOrUpdateConfignee:(NSString*)name areaId:(NSString *)areaId address:(NSString *)address phone:(NSString*)phone isDefault:(NSString*)isDefault conId:(NSString*)conId
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithAddOrDeleteConfignees:name areaId:areaId address:address phone:phone isDefault:isDefault conId:conId];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, KUrl_AddorUpdateConfignee];
    [self postRequst:url body:body requestType:KReqestType_AddorUpdateConfignee];
}
/**
 *
 * 获取商品列表
 *
 */
-(void)getGoodslist
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithGetGoodsList];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, KUrl_GoodsList];
    [self postRequst:url body:body requestType:KReqestType_GetGoodsList];
}
/**
 *
 * 生成订单
 *
 */
-(void)buyGoodsOrder:(NSString *)uid consignee_id:(NSString*)consignee_id pay_type:(int)pay_type goods:(NSArray*)goods
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithBuyGoodsOrder:uid consignee_id:consignee_id pay_type:pay_type goods:goods];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, KUrl_BuyGoodsOrder];
    [self postRequst:url body:body requestType:KReqestType_BuyGoodsOrder];
}
/**
 *
 * 获取订单列表
 *
 */
-(void)getGoodsOrderList:(int)type page:(int)page
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithGetGoodsOrderList:type page:page];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, KUrl_GetGoodsOrderList];
    [self postRequst:url body:body requestType:KReqestType_GetGoodsOrderList];
}
/**
 *
 * 取消订单
 *
 */
-(void)cancelGoodsOrder:(NSString *)oId
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithCancelGoodsOrder:oId];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, KUrl_CancelGoodsOrder];
    [self postRequst:url body:body requestType:KReqestType_CancelGoodsOrder];
}
/**
 *
 * 获取订单详细信息
 *
 */
-(void)getGoodsOrderDetail:(NSString*)orderId
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithGetGoodsOrderDetail:orderId];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, KUrl_GetGoodsOrderDetail];
    [self postRequst:url body:body requestType:KReqestType_GetGoodsOrderDetail];
}
/**
 *
 * 订单确认收货
 *
 */
-(void)setGoodsOrderFinish:(NSString*)orderId
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithsetGoodsOrderFinish:orderId];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, KUrl_SetGoodsOrderFinish];
    [self postRequst:url body:body requestType:KReqestType_SetGoodsOrderFinish];
}
/**
 *
 * 获取客户列表
 *
 */
-(void)getCustomerlist
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithGetCustomerlist];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, KUrl_GetCustomerlist];
    [self postRequst:url body:body requestType:KReqestType_GetCustomerlist];
}
/**
 *  微信支付接口
 *
 *  @param pdtName  商品名称
 *  @param price 总价
 *  @param orderId  订单id
 */
-(void)weixinPay:(NSString*)pdtName price:(NSString*)price orderId:(NSString*)orderId
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithweixinPay:pdtName price:price orderId:orderId];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, Kurl_WXPay];
    
    [self postRequst:url body:body requestType:KReqestType_weixinPay];
}

/**
 *  微信支付确认接口
 *
 *  @param orderId 订单id
 */
-(void)checkWXPay:(NSString*)orderId
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithCheckWxPay:orderId];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, Kurl_Checkwxpay];
    
    [self postRequst:url body:body requestType:KReqestType_CheckWXPay];
}
/**
 *  支付宝支付接口
 *
 *  @param pdtName  商品名称
 *  @param price 总价
 *  @param orderId  订单id
 */
-(void)aliPay:(NSString*)pdtName price:(NSString*)price orderId:(NSString*)orderId
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithweixinPay:pdtName price:price orderId:orderId];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, Kurl_AliPay];
    
    [self postRequst:url body:body requestType:KReqestType_AliPay];
}
/**
 *  支付宝支付接口
 *
 */
-(void)getProductStorage:(int)rangNum page:(int)page
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithGetProductStorage:rangNum page:page];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, Kurl_ProductStorage];
    
    [self postRequst:url body:body requestType:KReqestType_ProductStorage];
}
/**
 *  添加客户接口
 *
 */
-(void)addCustomer:(NSString *)name gender:(int)gender telephone:(NSString*)telephone
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithAddCustomer:name gender:gender telephone:telephone];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, Kurl_AddCustomer];
    
    [self postRequst:url body:body requestType:KReqestType_AddCustomer];
}
/**
 *  客户搜索
 *
 */
-(void)customerSearch:(NSString*)likeName
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithCustomerSearch:likeName];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, @"/customer_search"];
    
    [self postRequst:url body:body requestType:KReqestType_CustomerSearch];
}
//获取客户产品列表
-(void)getCustomerProductList:(int)page rangNum:(int)rangNum
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithGetCustomerProductList:page rangNum:rangNum];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, @"/customer/productlist"];
    
    [self postRequst:url body:body requestType:KReqestType_GetCustomerProductList];
}
//客户下单
-(void)customerProductBuy:(NSString*)customerId goods:(NSArray *)goods
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithCustomerProductBuy:customerId goods:goods];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, @"/customer/order"];
    [self postRequst:url body:body requestType:KReqestType_CustomerProductBuy];
}
//客户下单列表
-(void)customerOrderlist:(NSString*)customerId
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithCustomerOrderlist:customerId];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, @"/customer/orderlist"];
    [self postRequst:url body:body requestType:KReqestType_CustomerOrderList];
}
//商品退货
-(void)customerBackorder:(NSString*)gid customerId:(NSString *)customerId saleorderId:(NSString*)saleorderId saleDetailId:(NSString*)saleDetailId reason:(NSString*)reason remark:(NSString*)remark num:(int)num
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithCustomerBackorder:gid customerId:customerId saleorderId:saleorderId saleDetailId:saleDetailId reason:reason remark:remark num:num];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, @"/customer/backorder"];
    [self postRequst:url body:body requestType:KReqestType_CustomerBackorder];
}
//商品退货列表
-(void)getCustomerBackorderlist:(NSString*)productId saleDetailId:(NSString*)saleDetailId customerId:(NSString *)customerId
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithCustomerOrderlist:productId saleDetailId:saleDetailId customerId:customerId];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, @"/customer/backorderlist"];
    [self postRequst:url body:body requestType:KReqestType_CustomerBackorderlist];
}
@end













