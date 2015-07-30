//
//  NetInterfaceManager.h
//  XinRanApp
//
//  Created by tianbo on 14-12-8.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NetInterfaceManager : NSObject


+(NetInterfaceManager*)sharedInstance;

/**
 *  设置网络请求标识
 *
 *  @param controller name
 */
-(void)setReqControllerId:(NSString*)cId;
-(NSString*)getReqControllerId;

/**
 *  重新加载一次数据
 */
-(void) reloadRecordData;

/**
 *  登录接口
 *
 *  @param name 用户手机号或邮箱
 *  @param pwd  密码
 *  @param type 1：手机号码；2：邮箱
 */
-(void)login:(NSString*)name pwd:(NSString*)pwd;

/**
 *
 * 退出登录
 *
 */
-(void)logout;

/**
 *  修改密码接口
 */
-(void)changPassword:(NSString *)oldpwd newpwd:(NSString *)newpwd;
/**
 *
 * 获取收货列表
 *
 */
-(void)getConfignees;
/**
 *
 * 获取默认地址列表
 *
 */
-(void)getDefaultConfignees;
/**
 *
 * 删除收货地址
 *
 */
-(void)deleteConfignee:(NSString*)conId;
/**
 *
 * 更新或者添加收货地址
 *
 */
-(void)addOrUpdateConfignee:(NSString*)name areaId:(NSString *)areaId address:(NSString *)address phone:(NSString*)phone isDefault:(NSString*)isDefault conId:(NSString*)conId;
/**
 *
 * 获取商品列表
 *
 */
-(void)getGoodslist;
/**
 *
 * 生成订单
 *
 */
-(void)buyGoodsOrder:(NSString *)uid consignee_id:(NSString*)consignee_id pay_type:(int)pay_type goods:(NSArray*)goods;
/**
 *
 * 获取订单列表
 *
 */
-(void)getGoodsOrderList:(int)type page:(int)page;
/**
 *
 * 取消订单
 *
 */
-(void)cancelGoodsOrder:(NSString *)oId;
/**
 *
 * 获取订单详细信息
 *
 */
-(void)getGoodsOrderDetail:(NSString*)orderId;
/**
 *
 * 订单确认收货
 *
 */
-(void)setGoodsOrderFinish:(NSString*)orderId;
/**
 *
 * 获取客户列表
 *
 */
-(void)getCustomerlist;
/**
 *  微信支付接口
 *
 *  @param pdtName  商品名称
 *  @param price 总价
 *  @param orderId  订单id
 */
-(void)weixinPay:(NSString*)pdtName price:(NSString*)price orderId:(NSString*)orderId;
/**
 *  微信支付确认接口
 *
 *  @param orderId 订单id
 */
-(void)checkWXPay:(NSString*)orderId;
/**
 *  支付宝支付接口
 *
 *  @param pdtName  商品名称
 *  @param price 总价
 *  @param orderId  订单id
 */
-(void)aliPay:(NSString*)pdtName price:(NSString*)price orderId:(NSString*)orderId;
/**
 *  支付宝支付接口
 *
 */
-(void)getProductStorage:(int)rangNum page:(int)page;
/**
 *  添加客户接口
 *
 */
-(void)addCustomer:(NSString *)name gender:(int)gender telephone:(NSString*)telephone;
/**
 *  客户搜索
 *
 */
-(void)customerSearch:(NSString*)likeName;
/**
 *  获取客户产品列表
 *
 */
-(void)getCustomerProductList:(int)page rangNum:(int)rangNum;
/**
 *  给客户下单
 *
 */
-(void)customerProductBuy:(NSString*)customerId goods:(NSArray *)goods;
/**
 *  客户下单列表
 *
 */
-(void)customerOrderlist:(NSString*)customerId;
/**
 *  商品退货
 *
 */
-(void)customerBackorder:(NSString*)gid customerId:(NSString *)customerId saleorderId:(NSString*)saleorderId saleDetailId:(NSString*)saleDetailId reason:(NSString*)reason remark:(NSString*)remark num:(int)num;
/**
 *  商品退货列表
 *
 */
-(void)getCustomerBackorderlist:(NSString*)productId saleDetailId:(NSString*)saleDetailId customerId:(NSString *)customerId;
@end
