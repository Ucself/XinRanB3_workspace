//
//  MeProcurementTableViewCell.m
//  XinRanB3App
//
//  Created by libj on 15/5/28.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "GoodsListTableViewCell.h"

@implementation GoodsListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self initInterface];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mrak ---
-(void)initInterface{
    
    UITapGestureRecognizer *selectedGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedClick)];
    [self.selectedImage addGestureRecognizer:selectedGesture];
    
    UITapGestureRecognizer *addGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addClick)];
    [self.addImageView addGestureRecognizer:addGesture];
    
    UITapGestureRecognizer *deleteGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteClick)];
    [self.deleteImageView addGestureRecognizer:deleteGesture];
    
    UITapGestureRecognizer *countGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(countViewClick)];
    [self.numView addGestureRecognizer:countGesture];
    
}
//点击NumView事件
-(void)countViewClick{
    return;
}
//图片选中点击
-(void)selectedClick{
    
    if ([self.delegate respondsToSelector:@selector(selectedImageClick:goodsListTableViewCell:)]) {
        [self.delegate selectedImageClick:_cellIndex goodsListTableViewCell:self];
    }
    
}
//加号点击
-(void)addClick{
    if ([self.delegate respondsToSelector:@selector(addImageClick:goodsListTableViewCell:)]) {
        [self.delegate addImageClick:_cellIndex goodsListTableViewCell:self];
    }
}
//减号点击
-(void)deleteClick{
    if ([self.delegate respondsToSelector:@selector(deleteImageClick:goodsListTableViewCell:)]) {
        [self.delegate deleteImageClick:_cellIndex goodsListTableViewCell:self];
    }
}

//设置勾选
-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    self.selectedImage.image = _isSelected ? [UIImage imageNamed:@"icon_selected"] : [UIImage imageNamed:@"icon_not_selected"];
}



@end
