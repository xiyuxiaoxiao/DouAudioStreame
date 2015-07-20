//
//  RootViewController.m
//  X6音乐流媒体
//
//  Created by lanou3g on 15/7/10.
//  Copyright (c) 2015年 wyj. All rights reserved.
//

#import "RootViewController.h"
#import "MusicStreamerController.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)streamerMusic:(id)sender {
    
    [self.navigationController pushViewController:[[MusicStreamerController alloc] init] animated:YES];
}

- (IBAction)locationMusic:(id)sender {
}


@end
