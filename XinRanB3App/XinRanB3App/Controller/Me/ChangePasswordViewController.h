//
//  ChangePasswordViewController.h
//  XinRanB3App
//
//  Created by libj on 15/5/20.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "BaseUIViewController.h"

@interface ChangePasswordViewController : BaseUIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtOldPassword;

@property (weak, nonatomic) IBOutlet UITextField *txtNewPassword;

@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;


@end
