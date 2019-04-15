//
//  DZLxzTableViewCell.m
//  LNMobileProject
//
//  Created by 高盛通 on 2019/1/24.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import "DZLxzTableViewCell.h"

@implementation DZLxzTableViewCell

+ (DZLxzTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *identy = @"DZLxzTableViewCell";
    DZLxzTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:identy owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//source 1.为乐享赚  2.积分兑换  3.会员权益 4.免费试用 5.限时活动
- (IBAction)btnClick:(UIButton *)sender {
    if (self.source == 3) {
        if (self.vipList.btn == 1) {
            //可以购买
            if (self.btnBlock) {
                self.btnBlock(self.source, self.tag);
            }else{
                
            }
        }else{
            //不可以兑换
        }
    }else{
        if (self.btnBlock) {
            self.btnBlock(self.source, self.tag);
        }
    }
}

- (void)setSource:(NSInteger)source
{
    _source = source;
    if (source == 1) {
        self.vipBtn.hidden = YES;
    }else if (source == 2){
        self.vipBtn.hidden = YES;
        self.yongjinBtn.hidden = YES;
    }else if (source == 3){
       self.yongjinBtn.hidden = YES;
    }else if (source == 4){
       self.vipBtn.hidden = YES;
//        self.yongjinBtn.hidden = YES;
        [self.btn setBackgroundImage:[UIImage imageNamed:@"JSApply"] forState:UIControlStateNormal];
    }else{
        self.vipBtn.hidden = YES;
        self.yongjinBtn.hidden = YES;
    }
}

- (void)setModel:(DZTimeLimitModel *)model
{
    _model = model;
     [self.imageV sd_setImageWithURL:[NSURL URLWithString:FULL_URL(model.goods_img)] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
    self.nameL.text = model.goods_name;
    
    self.priceL.text = [NSString stringWithFormat:@"¥%@",model.now_price];
    
    self.orginalPriceL.text = [NSString stringWithFormat:@"原价：¥%@",model.shop_price];
}

- (void)setFreeList:(JSFreeList *)freeList
{
    _freeList = freeList;
    
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:FULL_URL(freeList.goods_img)] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
    self.nameL.text = freeList.goods_name;
    
    self.priceL.text = [NSString stringWithFormat:@"¥%@",freeList.cash_pledge];
    
//    self.orginalPriceL.text = [NSString stringWithFormat:@"原价：¥%@",freeList.cash_pledge];
    self.orginalPriceL.hidden = YES;
    [self.yongjinBtn setTitle:[NSString stringWithFormat:@"试用：%@天",freeList.free_test_day] forState:UIControlStateNormal];
}
- (void)setLexiangzhuanModel:(THLexiangzhuangModel *)lexiangzhuanModel {
    _lexiangzhuanModel = lexiangzhuanModel;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:lexiangzhuanModel.goods_imgUrl] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
    self.nameL.text = lexiangzhuanModel.goods_name;
    
    self.priceL.text = [NSString stringWithFormat:@"¥%@",lexiangzhuanModel.goods_price];
    
    //    self.orginalPriceL.text = [NSString stringWithFormat:@"原价：¥%@",freeList.cash_pledge];
    [self.btn setBackgroundImage:[UIImage imageNamed:@"ljfx"] forState:UIControlStateNormal];
    self.orginalPriceL.hidden = YES;
    [self.yongjinBtn setTitle:[NSString stringWithFormat:@"佣金￥%@",lexiangzhuanModel.bonus] forState:UIControlStateNormal];
}

- (void)setGiftList:(JSGiftList *)giftList
{
    _giftList = giftList;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:FULL_URL(giftList.pic)] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
    self.nameL.text = giftList.name;
    
    self.priceL.text = [NSString stringWithFormat:@"¥%@",giftList.price];
    
    self.orginalPriceL.text = @"";
}

- (void)setVipList:(JSVipList *)vipList
{
    _vipList = vipList;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:FULL_URL(vipList.goods_img)] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
    self.nameL.text = vipList.goods_name;
    
    self.priceL.text = [NSString stringWithFormat:@"¥%@",vipList.goods_price];
    
    self.orginalPriceL.text = [NSString stringWithFormat:@"原价：¥%@",vipList.shop_price];
    [self.vipBtn setTitle:[NSString stringWithFormat:@"VIP%@",vipList.allow_vip] forState:UIControlStateNormal];
    if (vipList.btn == 1) {
        //符合
        [self.btn setBackgroundImage:[UIImage imageNamed:@"ljgm"] forState:UIControlStateNormal];
    }else{
        [self.btn setBackgroundImage:[UIImage imageNamed:@"JSDjbz"] forState:UIControlStateNormal];
    }
}

@end
