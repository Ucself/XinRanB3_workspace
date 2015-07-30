//
//  CustomerListTableViewCell.h
//  XinRanB3App
//
//  Created by libj on 15/6/1.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomerModel;
@class CustomerListTableViewCell;

@protocol CustomerListTableViewCellDelegate <NSObject>

//下单协议
-(void) placeOrderClick:(CustomerListTableViewCell*)cell index:(int)index;

@end

@interface CustomerListTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblGender;
@property (weak, nonatomic) IBOutlet UILabel *lblTelephone;
@property (nonatomic,assign) int index;
@property (nonatomic,assign) id delegate;

@end
