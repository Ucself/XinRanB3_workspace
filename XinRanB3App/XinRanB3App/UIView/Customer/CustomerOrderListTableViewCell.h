//
//  CustomerOrderListTableViewCell.h
//  XinRanB3App
//
//  Created by libj on 15/6/5.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomerOrderListTableViewCell;


@protocol CustomerOrderListTableViewCellDelegate <NSObject>

-(void) rightButtonClick:(CustomerOrderListTableViewCell*)cell indexPath:(NSIndexPath*)indexPath;
-(void) leftButtonClick:(CustomerOrderListTableViewCell*)cell indexPath:(NSIndexPath*)indexPath;

@end

@interface CustomerOrderListTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UITextView *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) IBOutlet UILabel *goodsCount;



@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;

@property (nonatomic,copy) NSIndexPath *indexPath;

@property (nonatomic,assign) id delegate;

@end
