//
//  LoginViewController.h
//  XinRanB3App
//
//  Created by libj on 15/5/19.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "BaseUIViewController.h"

@interface LoginViewController : BaseUIViewController


@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextField;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;


@property (weak, nonatomic) IBOutlet UIView *headView;
@end
