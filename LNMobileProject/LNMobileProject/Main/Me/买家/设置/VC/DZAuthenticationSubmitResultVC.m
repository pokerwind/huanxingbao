//
//  DZAuthenticationSubmitResultVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/11.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZAuthenticationSubmitResultVC.h"

@interface DZAuthenticationSubmitResultVC ()

@end

@implementation DZAuthenticationSubmitResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"身份验证";
}

- (IBAction)closeButtonAction:(UIButton *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


@end
