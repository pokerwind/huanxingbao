//
//  DZShopCommentCell.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/7.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZShopCommentCell.h"
#import "DZShopCommentModel.h"
#import "DZShopCommentImageCell.h"
#import "DZShopCommentModel.h"

#define kImageCell @"DZShopCommentImageCell"

@interface DZShopCommentCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewBottom;


@property (nonatomic, strong) NSArray *imgArray;
@end

@implementation DZShopCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 17;
    self.layer.masksToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 8, 0, 8);
    CGFloat width = (SCREEN_WIDTH - 24)/3;
    CGFloat height = width;
    layout.itemSize = CGSizeMake(width, height);
    layout.minimumLineSpacing = 4;
    layout.minimumInteritemSpacing = 4;
    
    [self.collectionView  setCollectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:kImageCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kImageCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configView:(DZShopCommentModel *)model {
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:FULL_URL(model.head_pic)] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
    self.nickLabel.text = model.nickname;
    self.timeLabel.text = model.add_time;
//    self.starImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@star",model.rank]];
    self.starImageView.hidden = YES;
    self.commentLabel.text = model.content;
    
    self.imgArray = model.img_comment_array;
    [self.collectionView reloadData];
    
    if(!self.imgArray || self.imgArray.count == 0) {
        self.collectionViewHeight.constant = 12;
        self.collectionViewTop.constant = 0;
        self.collectionViewBottom.constant = 0;
        self.collectionView.hidden = YES;
    } else {
        NSInteger line = (self.imgArray.count + 2)/3;
        CGFloat height = (SCREEN_WIDTH - 24)/3;
        CGFloat total = height * line + (line - 1) * 4;
        self.collectionViewHeight.constant = total;
        self.collectionViewTop.constant = 8;
        self.collectionViewBottom.constant = 8;
        self.collectionView.hidden = NO;
    }
    
    if (![model.reply_content notBlank]) {
        model.reply_content = @" ";
    }
    self.replyLabel.text = model.reply_content;
}

- (void)setFrame:(CGRect)frame {
    frame.size.height -= 18;
    [super setFrame:frame];
}

#pragma mark UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imgArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DZShopCommentImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kImageCell forIndexPath:indexPath];
    NSString *model = self.imgArray[indexPath.row];
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:FULL_URL(model)] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.imageSubject) {
        [self.imageSubject sendNext:RACTuplePack(@(self.row),@(indexPath.row))];
    }
}



@end
