//
//  JSSucceedTipViewController.m
//  iOSMedical
//
//  Created by 高盛通 on 2018/11/8.
//  Copyright © 2018年 ZJXxiaoqiang. All rights reserved.
//

#import "JSSucceedTipViewController.h"
#import "LYEmptyViewHeader.h"
@interface JSSucceedTipViewController ()
/*
 * LYEmptyView
 */
@property (nonatomic,strong)LYEmptyView *emptyView;
@end

@implementation JSSucceedTipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationItem.title = @"申请成功";
    LYEmptyView *emptyView = [self setUpBlankTip];
    emptyView.contentViewY = 30;
    [self.view addSubview:emptyView];

}


- (LYEmptyView *)setUpBlankTip
{
    //JSBlankTip  申请成功  并为您通知护士更换
    //JSJingqingqidai
    if (self.emptyView == nil) {
        LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:self.image titleStr:self.tipStr detailStr:self.contentStr];
        self.emptyView = emptyView;
        emptyView.subViewMargin = 14.f;
        emptyView.titleLabFont = [UIFont fontWithName:@"PingFangSC-Regular" size:16];;
        emptyView.titleLabTextColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        emptyView.detailLabTextColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        return emptyView;
    }
    return self.emptyView;
}

@end
