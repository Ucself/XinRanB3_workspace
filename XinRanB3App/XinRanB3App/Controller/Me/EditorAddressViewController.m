//
//  ShipAddressViewController.m
//  XinRanApp
//
//  Created by libj on 15/4/24.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "EditorAddressViewController.h"
#import "AreaPickerView.h"
#import <XRCommon/BCBaseObject.h>
#import "UserAddressModel.h"
#import "Areas.h"
#import <XRNetInterface/EnvPreferences.h>


@interface EditorAddressViewController ()<UITextFieldDelegate,UITextViewDelegate>{
    //地域选择
    AreaPickerView *pickerView;
    //是否为默认地址
    BOOL isDefaultAddress;
}

@property (strong, nonatomic) NSMutableArray *arProvince;
@property (strong, nonatomic) NSMutableArray *arCity;
@property (strong, nonatomic) NSMutableArray *arDistrict;
//当前选中区域
@property (strong, nonatomic) Areas *selDistrict;
@property (strong, nonatomic) Areas *selCity;
@property (strong, nonatomic) Areas *selProvince;

@end

@implementation EditorAddressViewController

- (void)viewDidLoad {
    isShowRequestPrompt = NO;
    
    [super viewDidLoad];
    [self initInterface];
    //获取本地的数据地址
    [self loadLocalDataUserInfor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initInterface{
    //对键盘操作的协议
    self.nameTextField.delegate = self;
    self.adressTextField.delegate = self;
    self.detailAdressTextView.delegate = self;
    self.tellphoneTextField.delegate = self;
    //设置默认地址添加手势
    UITapGestureRecognizer *addressGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setDefaultAdress)];
    [self.defaultAdressView addGestureRecognizer:addressGesture];
    //删除添加手势
    UITapGestureRecognizer *deleteGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteDefaultAdress)];
    [self.deleteView addGestureRecognizer:deleteGesture];
    //判断是否有数据传入过来
    if (self.userAddressModel) {
        //设置删除按钮显示
        [self.deleteView setHidden:NO];
        isDefaultAddress = self.userAddressModel.isDefault;
        //设置收货人姓名绑定
        self.nameTextField.text = self.userAddressModel.name;
        //设置收货人地址绑定
        if (self.userAddressModel.area_id) {
            //数据库取数据
            NSString *stringDistrict=@"";NSString *stringCity=@"";NSString *stringProvince=@"";
            //取县区
            Areas *arDistrict = [Areas getArearWithId:self.userAddressModel.area_id];
            if (arDistrict) {
                //定位使用当前的区域
                stringDistrict = arDistrict.name;
                self.selDistrict = arDistrict; //设置选中的区县
                //取市
                Areas *arCity = [Areas getArearWithId:arDistrict.pId];
                if (arCity) {
                    stringCity = arCity.name;
                    self.selCity = arCity; //设置选中的城市
                    //取省
                    Areas *arProvince = [Areas getArearWithId:arCity.pId];
                    if (arProvince) {
                        stringProvince = arProvince.name;
                        self.selProvince = arProvince;
                    }
                    else{
                        //只有两级的值，说只有省份和市区
                        self.selProvince = arCity;
                        self.selCity = arDistrict;
                        self.selDistrict = nil;
                    }
                    
                }
                else {
                    //只有一个值说明只是第一级的值
                    self.selProvince = arDistrict;
                    self.selCity = nil;
                    self.selDistrict = nil;
                }
            }
            self.adressTextField.text = [[NSString alloc] initWithFormat:@"%@ %@ %@",stringProvince,stringCity,stringDistrict];
        }
        //详细地址绑定
        self.detailAdressTextView.text = self.userAddressModel.address;
        if (![self.userAddressModel.address isEqualToString:@""]) {
            self.textViewTips.hidden = YES;
        }
        //电话号码绑定
        self.tellphoneTextField.text = self.userAddressModel.phone;
    }
    else{
        [self.deleteView setHidden:YES];
        isDefaultAddress = NO;
    }
    //设置默认地址图标
    self.defaultAdressImage.image = isDefaultAddress ? [UIImage imageNamed:@"icon_selected"] : [UIImage imageNamed:@"icon_not_selected"];
    //如果是新增收货地址
    if (!self.userAddressModel) {
        self.navigationItem.title = @"新增收货地址";
    }
    else {
        self.navigationItem.title = @"编辑收货地址";
    }
}

- (void) setDefaultAdress{
    isDefaultAddress = !isDefaultAddress;
    self.defaultAdressImage.image = isDefaultAddress ? [UIImage imageNamed:@"icon_selected"] : [UIImage imageNamed:@"icon_not_selected"];
}

- (void) deleteDefaultAdress{
    //弹出确认删除提示
    UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"删除地址后将无法恢复，你确认删除？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    [tempAlertView show];
}


- (IBAction)doneEdite:(id)sender {
    //隐藏键盘
    [self.nameTextField resignFirstResponder];
    [self.adressTextField resignFirstResponder];
    [self.detailAdressTextView resignFirstResponder];
    [self.tellphoneTextField resignFirstResponder];
    //取消区域选择框
    [pickerView cancelPicker:self.view];
    
    //收货人验证
    if ([_nameTextField.text isEqualToString:@""]) {
        [self showTipsView:@"请输入收货人姓名!"];
        return;
    }
    if (_nameTextField.text.length < 2 || _nameTextField.text.length > 10 || ![BCBaseObject isChineseStr:_nameTextField.text]) {
        [self showTipsView:@"收货人姓名为2-10个汉字!"];
        return;
    }
    //省市区验证
    if ([_adressTextField.text isEqualToString:@""]) {
        [self showTipsView:@"请选择省市区!"];
        return;
    }
    //详细地址验证
    if ([_detailAdressTextView.text isEqualToString:@""]) {
        [self showTipsView:@"详细地址不能为空!"];
        return;
    }
    if (_detailAdressTextView.text.length < 5 || _detailAdressTextView.text.length > 60) {
        [self showTipsView:@"详细地址为5-60个字符!"];
        return;
    }
    if (![BCBaseObject isHasChineseCharacter:_detailAdressTextView.text]) {
        [self showTipsView:@"详细地址不能为纯数字或字母!"];
        return;
    }
    
    //手机号码验证
    if (![BCBaseObject isAllMobileNumber:self.tellphoneTextField.text]) {
        [self showTipsView:@"请输入正确的座机号或手机号或小灵通!"];
        return;
    }
    NSString *nowAreaId ;
    //设置区域id
    if(self.selDistrict){
        nowAreaId = self.selDistrict.Id;
    }
    else if (self.selCity){
        nowAreaId = self.selCity.Id;
    }
    else if (self.selProvince){
        nowAreaId = self.selProvince.Id;
    }
    NSString *conId = self.userAddressModel.addId == nil? @"" :self.userAddressModel.addId;
    //验证通过设置model的值
    //为数据对象分配内存
    if (!self.userAddressModel) {
        self.userAddressModel = [[UserAddressModel alloc] init];
    }
    self.userAddressModel.address = self.detailAdressTextView.text;
    self.userAddressModel.area_id = nowAreaId;
    self.userAddressModel.name = self.nameTextField.text;
    self.userAddressModel.phone = self.tellphoneTextField.text;
    self.userAddressModel.isDefault = isDefaultAddress;
    //取出数据修改并且发送数据到服务器
    [[NetInterfaceManager sharedInstance] addOrUpdateConfignee:self.nameTextField.text areaId:nowAreaId address:self.detailAdressTextView.text phone:self.tellphoneTextField.text isDefault:isDefaultAddress?@"1":@"0" conId:conId];
    
    [self startWait];
    
}
- (IBAction)selectAdress:(id)sender {
    //隐藏键盘
    [self.nameTextField resignFirstResponder];
    [self.adressTextField resignFirstResponder];
    [self.detailAdressTextView resignFirstResponder];
    [self.tellphoneTextField resignFirstResponder];
    //展示选择
    [self showPickerView];
}

-(NSMutableArray*)getProvinceArray
{
    static NSMutableArray *array = nil;
    static dispatch_once_t once;
    _dispatch_once(&once, ^{
        array = [NSMutableArray arrayWithArray:[Areas provinceList]];
    });
    
    return array;
}

-(NSMutableArray*)getCityArray
{
    static NSMutableArray *array = nil;
    static dispatch_once_t once;
    _dispatch_once(&once, ^{
        array = [NSMutableArray new];
        for (Areas *province in self.arProvince) {
            if (province) {
                [array addObjectsFromArray:[Areas cityList:province.Id]];
            }
        }
    });
    
    return array;
}

-(NSMutableArray*)getDistrictArray
{
    static NSMutableArray *array = nil;
    static dispatch_once_t once;
    _dispatch_once(&once, ^{
        array = [NSMutableArray new];
        for (Areas *city in self.arCity) {
            if (city) {
                [array addObjectsFromArray:[Areas districtList:city.Id]];
            }
        }
    });
    
    return array;
}


//获取本地的用户地址数据
-(void)loadLocalDataUserInfor{
    [self startWait];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        DBG_MSG(@"begin");
        //省级数组
        self.arProvince = [self getProvinceArray];//[NSMutableArray arrayWithArray:[Areas provinceList]];
        if (!self.arProvince || self.arProvince.count == 0) {
            //没有省级就认为失败
            DBG_MSG(@"load local areas data failed!");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stopWait];
            });
            return;
        }
        //城市数组
        self.arCity = [self getCityArray];
        //区域数组
        self.arDistrict = [self getDistrictArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopWait];
            NSString *nsAddress = [[NSString alloc] initWithFormat:@"%@ %@ %@" ,self.selProvince ? self.selProvince.name : @"" , self.selCity ? self.selCity.name : @"", self.selDistrict ? self.selDistrict.name : @""];
            
            DBG_MSG(@"%@",nsAddress);
        });
        
    });
    
    
}
#pragma mark - 点击return回收键盘  UITextFieldDelegate
//点击编辑的时候关闭地域选择控件
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [pickerView cancelPicker:self.view];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.nameTextField && range.location >= 10) {
        
        return NO;
    }
    else if (textField == self.tellphoneTextField && range.location >= 11 ){
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //回收选择控件
    [pickerView cancelPicker:self.view];
    //回收键盘
    [textField resignFirstResponder];
    return YES;
}
//#pragma mark - 点击背景回收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[[event allTouches] anyObject];
    if (touch.tapCount >=1) {
        [self.nameTextField resignFirstResponder];
        [self.adressTextField resignFirstResponder];
        [self.detailAdressTextView resignFirstResponder];
        [self.tellphoneTextField resignFirstResponder];
        //取消区域选择框
        [pickerView cancelPicker:self.view];
        
    }
}
#pragma mark ----
//展示省份市信息
-(void)showPickerView
{
    if (!pickerView) {
        //pickerView = [[AreaPickerView alloc] initWithDelegate:self areas:self.arProvince];
        pickerView = [[AreaPickerView alloc] initWithDelegate:self arProvince:self.arProvince arCity:self.arCity arDistrict:self.arDistrict];
    }
    
    [pickerView setAreas:self.selProvince city:self.selCity district:self.selDistrict];
    [pickerView showInView:self.view];
}
#pragma mark- AreaPickerView delegate
- (void)pickerViewDidChange:(AreaPickerView *)picker
{
    
}
- (void)pickerViewCancel
{
    [pickerView cancelPicker:self.view];
}
- (void)pickerViewOK:(Areas*)province city:(Areas*)city district:(Areas*)district
{
    self.selDistrict = district;
    self.selCity= city;
    self.selProvince = province;
    [pickerView cancelPicker:self.view];
    
    NSMutableString *string = [NSMutableString stringWithCapacity:0];
    if (self.selProvince) {
        [string appendFormat:@"%@", self.selProvince.name];
    }
    if (self.selCity) {
        [string appendFormat:@" %@", self.selCity.name];
    }
    if (self.selDistrict) {
        [string appendFormat:@" %@", self.selDistrict.name];
    }
    
    self.adressTextField.text = string;
}

#pragma mark textview delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.textViewTips.hidden = YES;
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location > 100)
        return NO;
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.textViewTips.hidden = NO;
    }
    return YES;
}

#pragma mark ---UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        [[NetInterfaceManager sharedInstance] deleteConfignee:self.userAddressModel.addId];
        [self startWait];
    }
}

#pragma mark ---
//数据请求成功
-(void)httpRequestFinished:(NSNotification *)notification{
    [super httpRequestFinished:notification];
    ResultDataModel *result =notification.object;
    if (!result) {
        DBG_MSG(@"http result is nil");
        return;
    }
    switch (result.requestType) {
        case KReqestType_DeleteConfignees:
            if (result.resultCode == 0) {
                //返回弹回列表
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                [self showTipsView:@"删除失败，请重试！"];
            }
            break;
        case KReqestType_AddorUpdateConfignee:
            
            if (result.resultCode == 0) {
                //返回成功弹回列表
                [self.navigationController popViewControllerAnimated:YES];
                //以管理收货地址进入
                if (self.controlType == 2) {
                    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
                    self.userAddressModel.addId = [((NSDictionary*)result.data) objectForKey:KJsonElement_ConsigneeId];
                    [tempDic setValue:self.userAddressModel forKey:@"selectedShipAddress"];
                    [[EnvPreferences sharedInstance] setSelectedShipAddress:tempDic];
                }
            }
            else {
                [self showTipsView:@"服务器连接失败！"];
            }
            break;
        default:
            break;
    }
}
//数据请求失败
-(void)httpRequestFailed:(NSNotification *)notification{
    [super httpRequestFailed:notification];
}




@end
