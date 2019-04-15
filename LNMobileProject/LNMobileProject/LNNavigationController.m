//
//  LNNavigationController.m
//  LNMobileProject
//
//  Created by LiuYanQiMini on 2017/7/25.
//  Copyright © 2017年 LiuYanQi. All rights reserved.
//

#import "LNNavigationController.h"

@interface LNNavigationController () <UINavigationControllerDelegate>

@end

@implementation LNNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated{
    NSString *vcStr = [NSString stringWithUTF8String:object_getClassName(viewController)];
    NSLog(@"willShowVC %@",viewController);
    if([vcStr isEqualToString:@"DZMeVC"] || [vcStr isEqualToString:@"DZSellerMeVC"] || [vcStr isEqualToString:@"DZGoodsDetailVC"] || [vcStr isEqualToString:@"DZShopDetailVC"] || [vcStr isEqualToString:@"DZSearchVC"]  || [vcStr isEqualToString:@"DZSearchResultVC"]  || [vcStr isEqualToString:@"DZSearchShopResultVC"] || [vcStr isEqualToString:@"DZGoodPreviewVC"] || [vcStr isEqualToString:@"DZHomeVC"] || [vcStr isEqualToString:@"DZCircleVC"] || [vcStr isEqualToString:@"DZFindVC"] || [vcStr isEqualToString:@"DZOrderSearchVC"]){
        [navigationController setNavigationBarHidden:YES animated:animated];
    } else {
        [navigationController setNavigationBarHidden:NO animated:animated];
    }
    
}
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated{
    NSLog(@"didShowVC %@",viewController);
}

@end
