//
//  DZLxzTableViewCell.h
//  LNMobileProject
//
//  Created by 高盛通 on 2019/1/24.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZTimeLimitModel.h"
#import "JSFreeModel.h"
#import "JSGiftModel.h"
#import "JSVipModel.h"
#import "THLexiangzhuangModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^JSBtnClickBlock)(NSInteger source,NSInteger tag);

@interface DZLxzTableViewCell : UITableViewCell

+ (DZLxzTableViewCell *)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *orginalPriceL;
@property (weak, nonatomic) IBOutlet UIButton *vipBtn;
@property (weak, nonatomic) IBOutlet UIButton *yongjinBtn;
@property (weak, nonatomic) IBOutlet UIButton *btn;

/*
 * JSBtnClickBlock
 */
@property (nonatomic,copy)JSBtnClickBlock btnBlock;

/*
 * source 1.为乐享赚  2.积分兑换  3.会员权益 4.免费试用 5.限时活动
 */
@property (nonatomic,assign)NSInteger source;

/*
 * 限时活动
 */
@property (nonatomic,strong)DZTimeLimitModel *model;

/*
 * 免费试用
 */
@property (nonatomic,strong)JSFreeList *freeList;

/*
 * 礼包兑换
 */
@property (nonatomic,strong)JSGiftList *giftList;

/*
 *会员权益
 */
@property (nonatomic,strong)JSVipList *vipList;

@property(nonatomic,strong) THLexiangzhuangModel *lexiangzhuanModel;

@end

NS_ASSUME_NONNULL_END
