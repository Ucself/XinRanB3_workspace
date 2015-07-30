//
//  CustomerListTableViewCell.m
//  XinRanB3App
//
//  Created by libj on 15/6/1.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "CustomerListTableViewCell.h"

@implementation CustomerListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    //添加打电话事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneCall)];
    [self.lblTelephone addGestureRecognizer:tapGesture];
    [self.lblTelephone setUserInteractionEnabled:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//下单
- (IBAction)btnPlaceOrderClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(placeOrderClick:index:)]) {
        [self.delegate placeOrderClick:self index:self.index];
    }
}

//打电话
-(void)phoneCall{
    
    NSString *phoneUrl = [[NSString alloc] initWithFormat:@"telprompt://%@",self.lblTelephone.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneUrl]];
}

@end
