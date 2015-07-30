//
//  JsonBuilder.m
//  XinRanApp
//
//  Created by tianbo on 14-12-8.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "JsonBuilder.h"
#import "EnvPreferences.h"

@interface JsonBuilder ()

@property(nonatomic, strong) NSString *strKey;
@end

@implementation JsonBuilder

+(JsonBuilder*)sharedInstance
{
    static JsonBuilder *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

-(void)setCryptKey:(NSString*)key
{
    self.strKey = key;
}

//转换byte
+(NSData*) hexToBytes:(NSString*)str {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= str.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [str substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

+(NSString*)decrypt:(NSString*)json key:(NSString*)key
{
    NSData *cipher = [self hexToBytes:json];
    NSData *plain = [cipher AESDecryptWithKey:key];
    
    NSString *dest = [[NSString alloc] initWithData:plain encoding:NSUTF8StringEncoding];
    return dest;
}

#pragma mark- 解析json
+(NSDictionary*)dictionaryWithJson:(NSString*)json decode:(BOOL)isDecode key:(NSString*)key
{
    if (isDecode) {
        json = [self decrypt:json key:key];
    }

    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    if (!data) {
        return nil;
    }
    
    return [JsonUtils jsonDataToDcit:data];
}

+(NSString*)stringWithJson:(NSString*)json decode:(BOOL)isDecode key:(NSString*)key
{
    NSString *strRet = nil;
    if (isDecode) {
        strRet = [self decrypt:json key:key];
    }
    return strRet;
}

+(NSString*)tokenStringWithJosn:(NSString*)json decode:(BOOL)isDecode key:(NSString*)key
{
    NSString *token;
    NSDictionary *dict = [self dictionaryWithJson:json decode:isDecode key:key];
    if (dict) {
        token = [dict objectForKey:@"token"];
    }
    
    return token;
}

//生成json
+(NSString*)jsonWithDictionary:(NSDictionary*)dict
{
    JsonBuilder *parse = [[JsonBuilder alloc] init];
    NSString *json = [parse generateJsonWithDictionary:dict];
    return json;
}

#pragma mark- 生成json
-(NSString*)generateJsonWithDictionary:(NSDictionary*)dict;
{
    if (!dict) {
        return nil;
    }
    
    return [JsonUtils dictToJson:dict];
}

#pragma  mark- 生成请求数据
-(NSString*)getVersion
{
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    NSRange range = [version rangeOfString:@"."];
    NSString *mainVersion = [version substringToIndex:range.location];
    
    NSString *temp = [version substringFromIndex:range.location+1];
    NSString *subVersion = [[temp componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];;
    
    return [NSString stringWithFormat:@"%@.%@", mainVersion, subVersion];
}
//为请求数据添加Token

-(NSMutableDictionary *)addBodyToken:(NSMutableDictionary*)oldDic
{
    NSString *token = [[EnvPreferences sharedInstance] getToken];
    if (token && token.length>0) {
        [oldDic setObject:token forKey:KJsonElement_Token];
    }
    
    return oldDic;
}

#pragma mark --- 生成请求json数据
//生成请求json数据
///////////////////////////////////////////////////////////////
/*****************************************************
 Version 0.1
 *****************************************************/

-(NSString*)jsonWithLogin:(NSString*)name pwd:(NSString*)pwd
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:[self getVersion] forKey:KJsonElement_Version];
    [dict setObject:KTerminalCode forKey:KJsonElement_Terminal];
    [dict setObject:name forKey:KJsonElement_Name];
    [dict setObject:pwd forKey:KJsonElement_Password];
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}
//登出登录
-(NSString*)jsonWithLogout
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    dict = [self addBodyToken:dict];
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}
//修改密码
-(NSString*)jsonWithChangPassword:(NSString*)oldPwd newPwd:(NSString*)newPwd
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    dict = [self addBodyToken:dict];
    [dict setObject:[self getVersion] forKey:KJsonElement_Version];
    [dict setObject:KTerminalCode forKey:KJsonElement_Terminal];
    [dict setObject:oldPwd forKey:KJsonElement_OldPwd];
    [dict setObject:newPwd forKey:KJsonElement_NewPwd];
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}
//获取地址列表
-(NSString*)jsonWithGetConfignees
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    dict = [self addBodyToken:dict];
    [dict setObject:[self getVersion] forKey:KJsonElement_Version];
    [dict setObject:KTerminalCode forKey:KJsonElement_Terminal];
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}
//获取地址列表
-(NSString*)jsonWithGetDefaultConfignees
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    dict = [self addBodyToken:dict];
    [dict setObject:[self getVersion] forKey:KJsonElement_Version];
    [dict setObject:KTerminalCode forKey:KJsonElement_Terminal];
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}

//删除收货地址
-(NSString*)jsonWithDeleteConfignees:(NSString*)conId
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    dict = [self addBodyToken:dict];
    [dict setObject:[self getVersion] forKey:KJsonElement_Version];
    [dict setObject:KTerminalCode forKey:KJsonElement_Terminal];
    [dict setObject:conId forKey:KJsonElement_ConId];
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}
//更新或者添加收货地址地址
-(NSString*)jsonWithAddOrDeleteConfignees:(NSString*)name areaId:(NSString *)areaId address:(NSString *)address phone:(NSString*)phone isDefault:(NSString*)isDefault conId:(NSString*)conId
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    dict = [self addBodyToken:dict];
    [dict setObject:[self getVersion] forKey:KJsonElement_Version];
    [dict setObject:KTerminalCode forKey:KJsonElement_Terminal];
    [dict setObject:name forKey:KJsonElement_name];
    [dict setObject:areaId forKey:KJsonElement_AreaId];
    [dict setObject:address forKey:KJsonElement_Address];
    [dict setObject:phone forKey:KJsonElement_phone];
    [dict setObject:isDefault forKey:KJsonElement_IsDefault];
    [dict setObject:conId forKey:KJsonElement_ID];
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}

//登出登录
-(NSString*)jsonWithGetGoodsList
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    dict = [self addBodyToken:dict];
    [dict setObject:[self getVersion] forKey:KJsonElement_Version];
    [dict setObject:KTerminalCode forKey:KJsonElement_Terminal];
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}
//下订单的功能
-(NSString*)jsonWithBuyGoodsOrder:(NSString *)uid consignee_id:(NSString*)consignee_id pay_type:(int)pay_type goods:(NSArray*)goods
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    dict = [self addBodyToken:dict];
    [dict setObject:[self getVersion] forKey:KJsonElement_Version];
    [dict setObject:KTerminalCode forKey:KJsonElement_Terminal];
    [dict setObject:uid forKey:KJsonElement_UId];
    [dict setObject:consignee_id forKey:KJsonElement_ConsigneeId];
    [dict setObject:[NSNumber numberWithInt:pay_type] forKey:KJsonElement_PayType];
    //添加goods节点 传字符串
    NSString *tempStr =@"[";
    //传对象
    NSMutableArray *tempGoodsArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < goods.count; i++) {
        NSDictionary *tempGoodsDic = goods[i];
        [tempGoodsArray addObject:tempGoodsDic];
        if (i==0) {
            tempStr = [tempStr stringByAppendingFormat:@"%@",[self generateJsonWithDictionary:tempGoodsDic]];
        }
        else {
            tempStr = [tempStr stringByAppendingFormat:@",%@",[self generateJsonWithDictionary:tempGoodsDic]];
        }
    }
    
    
    tempStr = [tempStr stringByAppendingFormat:@"%@",@"]"];
    //去掉换行符 和 空格符号
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [dict setObject:tempStr forKey:KJsonElement_Goods];
    
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}
//获取订单列表
-(NSString *)jsonWithGetGoodsOrderList:(int)type page:(int)page{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    dict = [self addBodyToken:dict];
    [dict setObject:[self getVersion] forKey:KJsonElement_Version];
    [dict setObject:KTerminalCode forKey:KJsonElement_Terminal];
    [dict setObject:[NSNumber numberWithInt:type] forKey:KJsonElement_Type];
    [dict setObject:[NSNumber numberWithInt:page] forKey:KJsonElement_Page];
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}
//取消订单
-(NSString *)jsonWithCancelGoodsOrder:(NSString *)oId
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    dict = [self addBodyToken:dict];
    [dict setObject:[self getVersion] forKey:KJsonElement_Version];
    [dict setObject:KTerminalCode forKey:KJsonElement_Terminal];
    [dict setObject:oId forKey:KJsonElement_OID];
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}
//获取订单详情
-(NSString *)jsonWithGetGoodsOrderDetail:(NSString *)orderId{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    dict = [self addBodyToken:dict];
    [dict setObject:[self getVersion] forKey:KJsonElement_Version];
    [dict setObject:KTerminalCode forKey:KJsonElement_Terminal];
    [dict setObject:orderId forKey:KJsonElement_OID];
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}
//确认收货
-(NSString *)jsonWithsetGoodsOrderFinish:(NSString *)oId
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    dict = [self addBodyToken:dict];
    [dict setObject:[self getVersion] forKey:KJsonElement_Version];
    [dict setObject:KTerminalCode forKey:KJsonElement_Terminal];
    [dict setObject:oId forKey:KJsonElement_OID];
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}
//获取客户列表
-(NSString *)jsonWithGetCustomerlist
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    dict = [self addBodyToken:dict];
    [dict setObject:[self getVersion] forKey:KJsonElement_Version];
    [dict setObject:KTerminalCode forKey:KJsonElement_Terminal];
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}

//微信和支付宝序列化支付接口
-(NSString*)jsonWithweixinPay:(NSString*)pdtName price:(NSString*)price orderId:(NSString*)orderId
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    dict = [self addBodyToken:dict];
    [dict setObject:[self getVersion] forKey:KJsonElement_Version];
    [dict setObject:KTerminalCode forKey:KJsonElement_Terminal];
//    [dict setObject:pdtName forKey:KJsonElement_Body];
    [dict setObject:price forKey:KJsonElement_TotalFee];
    [dict setObject:orderId forKey:KJsonElement_Trade_no];
    
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}

//确认微信支付接口
-(NSString*)jsonWithCheckWxPay:(NSString*)orderId
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    dict = [self addBodyToken:dict];
    [dict setObject:[self getVersion] forKey:KJsonElement_Version];
    [dict setObject:KTerminalCode forKey:KJsonElement_Terminal];
    if (orderId && orderId.length > 0) {
        [dict setObject:orderId forKey:KJsonElement_Trade_no];
    }
    
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}
//获取库存列表
-(NSString*)jsonWithGetProductStorage:(int)rangNum page:(int)page
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    dict = [self addBodyToken:dict];
    [dict setObject:[self getVersion] forKey:KJsonElement_Version];
    [dict setObject:KTerminalCode forKey:KJsonElement_Terminal];
    [dict setObject:[NSNumber numberWithInt:rangNum] forKey:KJsonElement_RangNum];
    [dict setObject:[NSNumber numberWithInt:page] forKey:KJsonElement_Page];
    
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}
//添加客户customerSearch
-(NSString*)jsonWithAddCustomer:(NSString *)name gender:(int)gender telephone:(NSString*)telephone{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    dict = [self addBodyToken:dict];
    [dict setObject:[self getVersion] forKey:KJsonElement_Version];
    [dict setObject:KTerminalCode forKey:KJsonElement_Terminal];
    [dict setObject:name forKey:KJsonElement_Name];
//    [dict setObject:[NSNumber numberWithInt:gender] forKey:KJsonElement_Gender];
    [dict setObject:[[NSString alloc] initWithFormat:@"%d",gender] forKey:KJsonElement_Gender];
    [dict setObject:telephone forKey:@"telephone"];
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}
//搜索客户customerSearch
-(NSString*)jsonWithCustomerSearch:(NSString *)likeName{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    dict = [self addBodyToken:dict];
    [dict setObject:[self getVersion] forKey:KJsonElement_Version];
    [dict setObject:KTerminalCode forKey:KJsonElement_Terminal];
    [dict setObject:likeName forKey:@"likename"];
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}
//获取客户商品列表
-(NSString*)jsonWithGetCustomerProductList:(int)page rangNum:(int)rangNum
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    dict = [self addBodyToken:dict];
    [dict setObject:[self getVersion] forKey:KJsonElement_Version];
    [dict setObject:KTerminalCode forKey:KJsonElement_Terminal];
    [dict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [dict setObject:[NSNumber numberWithInt:rangNum] forKey:@"rang_num"];
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}
//为客户下订单
-(NSString*)jsonWithCustomerProductBuy:(NSString*)customerId goods:(NSArray *)goods
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    dict = [self addBodyToken:dict];
    [dict setObject:[self getVersion] forKey:KJsonElement_Version];
    [dict setObject:KTerminalCode forKey:KJsonElement_Terminal];
    [dict setObject:customerId forKey:KJsonElement_CustomerId];
    //添加goods节点 传字符串
    NSString *tempStr =@"[";
    //传对象
    NSMutableArray *tempGoodsArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < goods.count; i++) {
        NSDictionary *tempGoodsDic = goods[i];
        [tempGoodsArray addObject:tempGoodsDic];
        if (i==0) {
            tempStr = [tempStr stringByAppendingFormat:@"%@",[self generateJsonWithDictionary:tempGoodsDic]];
        }
        else {
            tempStr = [tempStr stringByAppendingFormat:@",%@",[self generateJsonWithDictionary:tempGoodsDic]];
        }
    }
    tempStr = [tempStr stringByAppendingFormat:@"%@",@"]"];
    //去掉换行符 和 空格符号
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [dict setObject:tempStr forKey:KJsonElement_Goods];
    
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}
//客户的下单列表
-(NSString*)jsonWithCustomerOrderlist:(NSString*)customerId
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    dict = [self addBodyToken:dict];
    [dict setObject:[self getVersion] forKey:KJsonElement_Version];
    [dict setObject:KTerminalCode forKey:KJsonElement_Terminal];
    [dict setObject:customerId forKey:KJsonElement_CustomerId];
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}
//商品退货
-(NSString*)jsonWithCustomerBackorder:(NSString*)gid customerId:(NSString *)customerId saleorderId:(NSString*)saleorderId saleDetailId:(NSString*)saleDetailId reason:(NSString*)reason remark:(NSString*)remark num:(int)num
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    dict = [self addBodyToken:dict];
    [dict setObject:[self getVersion] forKey:KJsonElement_Version];
    [dict setObject:KTerminalCode forKey:KJsonElement_Terminal];
    [dict setObject:gid forKey:@"gid"];
    [dict setObject:customerId forKey:@"customer_id"];
    [dict setObject:saleorderId forKey:@"saleorder_id"];
    [dict setObject:saleDetailId forKey:@"sale_detail_id"];
    [dict setObject:reason forKey:@"reason"];
    [dict setObject:remark forKey:@"remark"];
    [dict setObject:[NSNumber numberWithInt:num] forKey:@"num"];
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;

}
//商品退货列表
-(NSString*)jsonWithCustomerOrderlist:(NSString*)productId saleDetailId:(NSString*)saleDetailId customerId:(NSString *)customerId
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    dict = [self addBodyToken:dict];
    [dict setObject:[self getVersion] forKey:KJsonElement_Version];
    [dict setObject:KTerminalCode forKey:KJsonElement_Terminal];
    [dict setObject:productId forKey:@"product_id"];
    [dict setObject:saleDetailId forKey:@"sale_detail_id"];
    [dict setObject:customerId forKey:@"customer_id"];
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}

@end






