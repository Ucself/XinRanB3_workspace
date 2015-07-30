//
//  ProtocolDefine.h
//  XinRanApp
//
//  Created by tianbo on 14-12-5.
//  Copyright (c) 2014年 deshan.com All rights reserved.
//
//
//  通信协议基础定义

#ifndef XinRanApp_ProtocolDefine_h
#define XinRanApp_ProtocolDefine_h

#pragma mark- url 定义

//#define KTestServer
//#define KFinalServer
#define KQAServer
//#define KTuBinTestServer
//#define HPKServer
//#define YFServer
//#define ZJServer

//测试地址
#ifdef KTuBinTestServer
#define KServerAddr                @"http://192.168.0.38:9099/api"
#define KImageDonwloadAddr         @"http://192.168.0.38:9099"
#endif

//测试地址
#ifdef KTestServer
#define KServerAddr                @"http://192.168.1.10:8086/api"
#define KImageDonwloadAddr         @"http://192.168.1.10:8086"
#endif

//正式地址
#ifdef KFinalServer
#define KServerAddr                @"http://www.xinran.com/api"
#define KImageDonwloadAddr         @"http://www.xinran.com"
#endif

//QAserver
#ifdef KQAServer
#define KServerAddr                @"http://192.168.1.33:80/api"
#define KImageDonwloadAddr         @"http://192.168.1.33:80"
#endif

//HPKServer
#ifdef HPKServer
#define KServerAddr                @"http://192.168.1.52:9013/api"
#define KImageDonwloadAddr         @"http://192.168.1.52"
#endif

//YFServer
#ifdef YFServer
#define KServerAddr                @"http://192.168.0.16:80/api"
#define KImageDonwloadAddr         @"http://192.168.0.16"
#endif

//ZJServer
#ifdef ZJServer
#define KServerAddr                @"http://192.168.0.32:80/api"
#define KImageDonwloadAddr         @"http://192.168.0.32"
#endif


/******************************************************
 *  v0.1 接口
 ******************************************************/

//用户接口  POST
#define KUrl_Login                 @"/login"
#define KUrl_Logout                @"/logout"
#define KUrl_Getconfignees         @"/user/getconfignees"
#define KUrl_GetDefaultConfignees  @"/user/get_default_confignees"
#define KUrl_DeleteConfignee       @"/user/delete_confignee"
#define KUrl_AddorUpdateConfignee  @"/user/add_or_update_confignees"
#define KUrl_ChangPassword         @"/changepwd"
#define KUrl_GoodsList             @"/goodslist"
#define KUrl_BuyGoodsOrder         @"/shop/buy"
#define KUrl_GetGoodsOrderList     @"/shop/order/get_orders"
#define KUrl_CancelGoodsOrder      @"/shop/order/cancel"
#define KUrl_GetGoodsOrderDetail   @"/shop/order/get_orderdetail"
#define KUrl_SetGoodsOrderFinish   @"/shop/order/finish"
#define KUrl_GetCustomerlist       @"/customerlist"
// 微信支付接口
#define Kurl_WXPay                  @"/shop/order/wx_pay"
// 支付宝支付接口
#define Kurl_AliPay                 @"/shop/order/ali_pay"
//微信支付确认接口
#define Kurl_Checkwxpay             @"/shop/order/check_wx_order"
#define Kurl_ProductStorage         @"/shop/product_storage"
//客户管理
#define Kurl_AddCustomer            @"/customer_add_or_up"


//****************************************************************
#define KResultCode                @"resultcode"
#define KResultInfo                @"errorinfo"

//请求类型
typedef enum {
    KReqestType_Login = 0,
    KReqestType_Logout,
    KReqestType_Getconfignees,
    KReqestType_GetDefaultConfignees,
    KReqestType_DeleteConfignees,
    KReqestType_AddorUpdateConfignee,
    KReqestType_ChangPassword,
    KReqestType_GetGoodsList,
    KReqestType_BuyGoodsOrder,
    KReqestType_GetGoodsOrderList,
    KReqestType_CancelGoodsOrder,
    KReqestType_GetGoodsOrderDetail,
    KReqestType_SetGoodsOrderFinish,
    KReqestType_GetCustomerlist,
    KReqestType_weixinPay,
    KReqestType_CheckWXPay,
    KReqestType_AliPay,
    KReqestType_ProductStorage,
    KReqestType_AddCustomer,
    KReqestType_CustomerSearch,
    KReqestType_GetCustomerProductList,
    KReqestType_CustomerProductBuy,
    KReqestType_CustomerOrderList,
    KReqestType_CustomerBackorder,
    KReqestType_CustomerBackorderlist,
} RequestType;

//登示类型
typedef enum{
    LoginType_Phone = 0,
    LoginType_Email,
}LoginType;



#pragma mark- 回调消息通知
//请求回调消息通知
#define KNotification_RequestFinished            @"HttpRequestFinishedNoitfication"
#define KNotification_RequestFailed              @"HttpRequestFailedNoitfication"
#define KNotification_UserLoginDone              @"HttpRequestUserLoginDoneNoitfication"
#define KNotification_GotoLoginControl           @"GotoLoginControlNoitfication"
#define KNotification_GotoMainListControl        @"GotoMainListControlNoitfication"
#define KNotification_GotoCustomerListControl    @"GotoCustomerListControlNoitfication"
#define KNotification_GotoProcurementListControl @"GotoProcurementListControlNoitfication"

//公用级别信息
#pragma mark- JSON基础字符串定义
#define KTerminalCode                      @"2"                        //终端类型：1安卓，2：ios，3：安卓平板，4：ios平板
#define KJsonElement_Result                @"result"                   //返回结果
#define KJsonElement_Token                 @"token"
#define KJsonElement_Version               @"version"
#define KJsonElement_User                  @"user"
#define KJsonElement_Type                  @"type"
#define KJsonElement_Name                  @"name"
#define KJsonElement_ID	                   @"id"
#define KJsonElement_Data                  @"data"
#define KJsonElement_Status                @"state"
#define KJsonElement_Pid                   @"pid"
#define KJsonElement_Order                 @"order"
#define KJsonElement_name                  @"name"
#define KJsonElement_phone                 @"phone"
#define KJsonElement_RangNum               @"rang_num"

//用户相关
#define KJsonElement_Terminal            @"terminal"                   //终端类型：1安卓，2：ios，3：安卓平板，4：ios平板
#define KJsonElement_Password            @"password"
#define KJsonElement_Pwd                 @"pwd"
#define KJsonElement_UserName            @"userName"
//用户中心
#define KJsonElement_ConId                 @"con_id"
#define KJsonElement_AreaId                @"area_id"
#define KJsonElement_Address               @"address"
#define KJsonElement_IsDefault             @"is_default"
#define KJsonElement_OldPwd                @"oldpwd"
#define KJsonElement_NewPwd                @"newpwd"
//订单相关
#define KJsonElement_UId                 @"uid"
#define KJsonElement_ConsigneeId         @"consignee_id"
#define KJsonElement_PayType             @"pay_type"
#define KJsonElement_GId                 @"gid"
#define KJsonElement_Goods               @"goods"
#define KJsonElement_Num                 @"num"
#define KJsonElement_OID                 @"oid"
#define KJsonElement_Page                @"page"
#define KJsonElement_OrderId             @"order_id"
#define KJsonElement_Price               @"price"
//支付相关
#define KJsonElement_TotalFee            @"total_fee"
#define KJsonElement_Trade_no            @"out_trade_no"
#define KJsonElement_Body                @"body"
//客户相关
#define KJsonElement_Gender                @"gender"
#define KJsonElement_CustomerId              @"customer_id"


/******************************************************
 *  UM SDK Key
 ******************************************************/
#define UMENG_APPKEY @"54f5502afd98c58983000854"

#endif

