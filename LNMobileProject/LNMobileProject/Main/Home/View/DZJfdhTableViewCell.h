//
//  DZJfdhTableViewCell.h
//  LNMobileProject
//
//  Created by 高盛通 on 2019/1/24.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSScoreModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void (^JSBtnClickBlock)(NSInteger source,NSInteger tag);

@interface DZJfdhTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *jifenL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *orignalPriceL;
@property (weak, nonatomic) IBOutlet UIButton *btn;

+ (DZJfdhTableViewCell *)cellWithTableView:(UITableView *)tableView;

/*
 * JSBtnClickBlock
 */
@property (nonatomic,copy)JSBtnClickBlock btnBlock;

/*
 * JSScoreList
 */
@property (nonatomic,strong)JSScoreList *list;

@end

NS_ASSUME_NONNULL_END
