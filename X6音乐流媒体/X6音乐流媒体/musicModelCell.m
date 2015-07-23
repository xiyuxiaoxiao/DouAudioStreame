//
//  musicModelCell.m
//  X6音乐流媒体
//
//  Created by lanou3g on 15/7/10.
//  Copyright (c) 2015年 wyj. All rights reserved.
//

#import "musicModelCell.h"
#import "Colours.h"
@implementation musicModelCell

- (void)awakeFromNib {
    // Initialization code
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = self.headerImageView.frame.size.width / 2;
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.headerImageView.layer.borderWidth = 4;
    self.headerImageView.layer.borderColor = [UIColor skyBlueColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
