//
//  JsonBuilder.h
//  XinRanApp
//
//  Created by tianbo on 14-12-8.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonBuilder : NSObject
{
    
}

+(JsonBuilder*)sharedInstance;

/**
 *  设置加解密密钥
 *
 *  @param key 密钥
 */
-(void)setCryptKey:(NSString*)key;


//解析json
///////////////////////////////////////////////////////////////

/**
*  解析json数据
*
*  @param json     json字符串
*  @param isDecode 是否需要解密
*  @param key      密钥
*
*  @return dictionary
*/
+(NSDictionary*)dictionaryWithJson:(NSString*)json decode:(BOOL)isDecode key:(NSString*)key;

/**
 *  initAndPlay
 *
 *  @param json     json字符串
 *  @param isDecode 是否需要解密
 *  @param key      密钥
 *
 *  @return string
 */
+(NSString*)stringWithJson:(NSString*)json decode:(BOOL)isDecode key:(NSString*)key;

/**
 *  解析token字符串
 *
 *  @param json     josn字符串
 *  @param isDecode 是否需要解密
 *  @param key      密钥
 *
 *  @return return value description
 */
+(NSString*)tokenStringWithJosn:(NSString*)json decode:(BOOL)isDecode key:(NSString*)key;


//生成
///////////////////////////////////////////////////////////////

/**
 *  生成json字符串
 *
 *  @param dict 字典
 *
 *  @return json字符串
 */
+(NSString*)jsonWithDictionary:(NSDictionary*)dict;



#pragma mark --- 生成请求json数据
//生成请求json数据
///////////////////////////////////////////////////////////////
/*****************************************************
 Version 1.1
 *****************************************************/

-(NSString*)jsonWithLogin:(NSString*)name pwd:(NSString*)pwd;
//登出
-(NSString*)jsonWithLogout;
//修改密码
-(NSString*)jsonWithChangPassword:(NSString*)oldPwd newPwd:(NSString*)newPwd;
//获取地址列表
-(NSString*)jsonWithGetConfignees;
//获取地址列表
-(NSString*)jsonWithGetDefaultConfignees;
//删除收货地址
-(NSString*)jsonWithDeleteConfignees:(NSString*)conId;
//更新或者添加收货地址地址
-(NSString*)jsonWithAddOrDeleteConfignees:(NSString*)name areaId:(NSString *)areaId address:(NSString *)address phone:(NSString*)phone isDefault:(NSString*)isDefault conId:(NSString*)conId;
//登出登录
-(NSString*)jsonWithGetGoodsList;
//下订单的功能
-(NSString*)jsonWithBuyGoodsOrder:(NSString *)uid consignee_id:(NSString*)consignee_id pay_type:(int)pay_type goods:(NSArray*)goods;
//获取订单列表
-(NSString*)jsonWithGetGoodsOrderList:(int)type page:(int)page;
//取消订单
-(NSString *)jsonWithCancelGoodsOrder:(NSString *)oId;
//获取订单详情
-(NSString *)jsonWithGetGoodsOrderDetail:(NSString *)orderId;
//确认收货
-(NSString *)jsonWithsetGoodsOrderFinish:(NSString *)oId;
//获取客户列表
-(NSString *)jsonWithGetCustomerlist;
//微信和支付宝序列化支付接口
-(NSString*)jsonWithweixinPay:(NSString*)pdtName price:(NSString*)price orderId:(NSString*)orderId;
//确认微信支付接口
-(NSString*)jsonWithCheckWxPay:(NSString*)orderId;
//获取库存列表
-(NSString*)jsonWithGetProductStorage:(int)rangNum page:(int)page;
//添加客户
-(NSString*)jsonWithAddCustomer:(NSString *)name gender:(int)gender telephone:(NSString*)telephone;
//搜索客户
-(NSString*)jsonWithCustomerSearch:(NSString *)likeName;//getCustomerProductList
//获取客户商品列表
-(NSString*)jsonWithGetCustomerProductList:(int)page rangNum:(int)rangNum;
//为客户下订单
-(NSString*)jsonWithCustomerProductBuy:(NSString*)customerId goods:(NSArray *)goods;
//客户的下单列表
-(NSString*)jsonWithCustomerOrderlist:(NSString*)customerId;
//商品退货
-(NSString*)jsonWithCustomerBackorder:(NSString*)gid customerId:(NSString *)customerId saleorderId:(NSString*)saleorderId saleDetailId:(NSString*)saleDetailId reason:(NSString*)reason remark:(NSString*)remark num:(int)num;
//商品退货列表
-(NSString*)jsonWithCustomerOrderlist:(NSString*)productId saleDetailId:(NSString*)saleDetailId customerId:(NSString *)customerId;
@end
