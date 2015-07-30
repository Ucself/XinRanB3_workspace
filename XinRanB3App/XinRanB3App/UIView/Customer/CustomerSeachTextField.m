//
//  CustomerSeachTextField.m
//  XinRanB3App
//
//  Created by libj on 15/6/8.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "CustomerSeachTextField.h"

@implementation CustomerSeachTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (CGRect)textRectForBounds:(CGRect)bounds {
    int margin = 27;
    CGRect inset = CGRectMake(bounds.origin.x + margin, bounds.origin.y, bounds.size.width - margin, bounds.size.height);
    return inset;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    int margin = 27;
    CGRect inset = CGRectMake(bounds.origin.x + margin, bounds.origin.y, bounds.size.width - margin, bounds.size.height);
    return inset;
}

-(CGRect)leftViewRectForBounds:(CGRect)bounds{
    int margin = 7;
    CGRect inset = CGRectMake(bounds.origin.x + margin, bounds.origin.y + 7, 17 , 17);
    return inset;
}
@end
