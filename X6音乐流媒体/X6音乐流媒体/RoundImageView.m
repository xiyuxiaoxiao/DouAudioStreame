//
//  RoundImageView.m
//  X6音乐流媒体
//
//  Created by lanou3g on 15/7/10.
//  Copyright (c) 2015年 wyj. All rights reserved.
//

#import "RoundImageView.h"
#import "Colours.h"
@implementation RoundImageView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = rect.size.width / 2;
    self.contentMode = UIViewContentModeScaleAspectFit;
    
    self.layer.borderWidth = 10;
    self.layer.borderColor = [UIColor skyBlueColor].CGColor;
}


@end
