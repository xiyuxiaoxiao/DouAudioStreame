//
//  AlertViewAutoDismiss.m
//  Douban
//
//  Created by lanou3g on 15/6/9.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "AlertViewAutoDismiss.h"

@interface AlertViewAutoDismiss ()
@property(strong,nonatomic)UIAlertView *alertView;
@end

@implementation AlertViewAutoDismiss
-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message;
{
    self = [super init];
    if (self) {
        self.alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    }
    return self;
}

-(void)show
{
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(dismissAlert:) userInfo:nil repeats:NO];
    [self.alertView show];
    
}
#pragma mark alertView自动消失
-(void)dismissAlert:(NSTimer *)timer
{
    [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
}
@end
