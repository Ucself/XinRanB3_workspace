//
//  AddressTableViewCell.h
//  XinRanB3App
//
//  Created by libj on 15/5/26.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblConsignee;
@property (weak, nonatomic) IBOutlet UILabel *lblPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblDefaultMark;
@property (weak, nonatomic) IBOutlet UITextView *txtAddress;

@property (weak, nonatomic) IBOutlet UIImageView *rightImage;


@end
