//
//  DZSpecChooseCell.h
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/5.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZGoodsSpecModel.h"

@protocol DZSpecChooseCellDelegate <NSObject>

- (void)refreshCartData;

@end

@interface DZSpecChooseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockLabel;
@property (weak, nonatomic) IBOutlet UIView *numView;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;

@property (strong, nonatomic) DZGoodsSpecModel *model;//更新数据用
@property (nonatomic) id <DZSpecChooseCellDelegate>delegate;

@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) RACSubject *changeSubject;
@end
