//
//  DZNewsCell.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/15.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZNewsCell.h"
#import "DZNewsModel.h"
#import "DZNewsGoodsCell.h"
#import "DZGoodsModel.h"

#define kNewsGoodsCell @"DZNewsGoodsCell"


@interface DZNewsCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIImageView *followImageView;
@property (weak, nonatomic) IBOutlet UILabel *followLabel;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) DZNewsModel *model;

@property (weak, nonatomic) IBOutlet UIView *showAllView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewTopConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *showAllImageView;
@end

@implementation DZNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = floor((SCREEN_WIDTH - 16 - 6)/3);
    layout.itemSize = CGSizeMake(width, width);
    layout.minimumLineSpacing = 3;
    layout.minimumInteritemSpacing = 3;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self.collectionView setCollectionViewLayout:layout];
    [self.collectionView registerNib:[UINib nibWithNibName:kNewsGoodsCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kNewsGoodsCell];
    self.collectionView.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 18;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configView:(DZNewsModel *)model {
    _model = model;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:FULL_URL(model.shop_info.shop_logo)] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
    self.nameLabel.text = model.shop_info.shop_name;
    self.timeLabel.text = model.add_time;
    
    self.dataArray = model.goods_list;
    
    if ([model.favorite_shop isEqualToString:@"0"]) {
        self.followLabel.text = @"关注";
        self.followImageView.hidden = NO;
    } else {
        self.followLabel.text = @"已关注";
        self.followImageView.hidden = YES;
    }
    
    //如果文字小于某个值，如100，则无需隐藏，无需显示 全文按钮。
    //如果文字大于此值，则默认隐藏多出的部分，后面加…
    //点击全文后，切换是否隐藏。
    NSString *content = model.content;
    if (content.length < kNeedHideNum) {
        self.showAllView.hidden = YES;
        self.collectionViewTopConstraint.constant = 8;
        self.contentLabel.text = model.content;
    } else {
        self.showAllView.hidden = NO;
        self.collectionViewTopConstraint.constant = 30;
        if (model.isShowAll) {
            self.contentLabel.text = model.content;
            self.showAllImageView.image = [UIImage imageNamed:@"group_icon_close"];
        } else {
            self.contentLabel.text = [model.content substringToIndex:kNeedHideNum].a(@"…");
            self.showAllImageView.image = [UIImage imageNamed:@"group_icon_open"];
        }
    }
    
    
    [self.collectionView reloadData];
}

#pragma mark UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DZNewsGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kNewsGoodsCell forIndexPath:indexPath];
    DZGoodsModel *model = self.dataArray[indexPath.row];
    [cell.goodsImageView sd_setImageWithURL:[NSURL URLWithString:FULL_URL(model.goods_img)] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%@ - ￥%@",model.pack_price,model.shop_price];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DZGoodsModel *model = self.dataArray[indexPath.row];
    [self.clickSubject sendNext:RACTuplePack(@"goods", model.goods_id)];
}

- (IBAction)chatAction:(id)sender {
    [self.clickSubject sendNext:RACTuplePack(@"chat", self.model.shop_id)];
}

- (IBAction)shareAction:(id)sender {
    [self.clickSubject sendNext:RACTuplePack(@"share", @(self.row))];
}
- (IBAction)followAction:(id)sender {
    [self.clickSubject sendNext:RACTuplePack(@"follow", self.model.shop_id)];
}

- (IBAction)shopAction:(id)sender {
    [self.clickSubject sendNext:RACTuplePack(@"shop", self.model.shop_id)];
}
- (IBAction)showAllAction:(id)sender {
    self.model.isShowAll = !self.model.isShowAll;
    [self.clickSubject sendNext:RACTuplePack(@"show", @"")];
}

- (void)setFrame:(CGRect)frame {
    frame.origin.y +=2;
    frame.size.height -=2;
    [super setFrame:frame];
}

@end
