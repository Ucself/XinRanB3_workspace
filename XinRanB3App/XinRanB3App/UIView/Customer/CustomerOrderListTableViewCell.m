//
//  CustomerOrderListTableViewCell.m
//  XinRanB3App
//
//  Created by libj on 15/6/5.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "CustomerOrderListTableViewCell.h"

@implementation CustomerOrderListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)rightBtnClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(rightButtonClick:indexPath:)]) {
        [self.delegate rightButtonClick:self indexPath:self.indexPath];
    }
    
}

- (IBAction)leftBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(leftButtonClick:indexPath:)]) {
        [self.delegate leftButtonClick:self indexPath:self.indexPath];
    }
}

@end
