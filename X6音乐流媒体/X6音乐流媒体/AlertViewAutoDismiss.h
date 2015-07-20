//
//  AlertViewAutoDismiss.h
//  Douban
//
//  Created by lanou3g on 15/6/9.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertViewAutoDismiss : NSObject
-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message;
-(void)show;
@end
