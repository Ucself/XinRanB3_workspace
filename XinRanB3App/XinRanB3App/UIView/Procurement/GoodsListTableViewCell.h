//
//  MeProcurementTableViewCell.h
//  XinRanB3App
//
//  Created by libj on 15/5/28.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsListTableViewCell;

@protocol GoodsListTableViewCellDelegate <NSObject>

//勾选图片点击
- (void) selectedImageClick:(int)cellIndex goodsListTableViewCell:(GoodsListTableViewCell*)cell;
//加号点击
- (void) addImageClick:(int)cellIndex goodsListTableViewCell:(GoodsListTableViewCell*)cell;
//减号点击
- (void) deleteImageClick:(int)cellIndex goodsListTableViewCell:(GoodsListTableViewCell*)cell;

@end


@interface GoodsListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *selectedImage;
@property (assign, nonatomic) BOOL isSelected;//是否选中图片

@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;

@property (weak, nonatomic) IBOutlet UITextView *goodsDesc;

@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;

@property (weak, nonatomic) IBOutlet UILabel *selectedCount;

@property (weak, nonatomic) IBOutlet UIView *numView;

//设置第几个cell的属性
@property (assign, nonatomic) int cellIndex;
//公布的协议
@property (assign, nonatomic) id delegate;

@property (weak, nonatomic) IBOutlet UIImageView *addImageView;
@property (weak, nonatomic) IBOutlet UIImageView *deleteImageView;

@end
