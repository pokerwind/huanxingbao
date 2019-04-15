//
//  DZGoodsDetailIntroView.h
//  LNMobileProject
//
//  Created by LNMac007 on 2017/10/30.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZGoodsDetailIntroView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;
@end
