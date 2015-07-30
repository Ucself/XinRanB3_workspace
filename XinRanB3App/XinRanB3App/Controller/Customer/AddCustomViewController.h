//
//  AddCustomViewController.h
//  XinRanB3App
//
//  Created by libj on 15/6/5.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "BaseUIViewController.h"

@interface AddCustomViewController : BaseUIViewController

//添加客户
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userPhone;


@property (weak, nonatomic) IBOutlet UIView *maleView;
@property (weak, nonatomic) IBOutlet UIView *femaleView;
@property (weak, nonatomic) IBOutlet UIImageView *maleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *femaleImageView;

@end
