//
//  HaveBuyGoodsTableViewCell.h
//  XinRanB3App
//
//  Created by libj on 15/5/28.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HaveBuyGoodsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;

@property (weak, nonatomic) IBOutlet UITextView *goodsDesc;

@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;

@property (weak, nonatomic) IBOutlet UILabel *selectedCount;


@end
