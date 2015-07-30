//
//  ShipAddressViewController.h
//  XinRanApp
//
//  Created by libj on 15/4/24.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "BaseUIViewController.h"
#import "UserAddressModel.h"


@interface EditorAddressViewController : BaseUIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *adressTextField;
@property (weak, nonatomic) IBOutlet UITextView *detailAdressTextView;
@property (weak, nonatomic) IBOutlet UITextField *tellphoneTextField;

@property (weak, nonatomic) IBOutlet UILabel *textViewTips;


@property (weak, nonatomic) IBOutlet UIView *defaultAdressView;
@property (weak, nonatomic) IBOutlet UIImageView *defaultAdressImage;
@property (weak, nonatomic) IBOutlet UIView *deleteView;


//收货地址数据
@property (nonatomic,strong) UserAddressModel *userAddressModel;

//控制器类型 1 为管理收货地址进入 2为选择收货地址进入
@property (nonatomic,assign) int controlType;

@end
