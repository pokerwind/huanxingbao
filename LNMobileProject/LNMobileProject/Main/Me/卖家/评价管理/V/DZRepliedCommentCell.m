//
//  DZRepliedCommentCell.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/26.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZRepliedCommentCell.h"
#import "DZCommentImageCell.h"

@interface DZRepliedCommentCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) DZClientEvaluateModel *model;

@end

@implementation DZRepliedCommentCell

static NSString *identifier = @"DZCommentImageCell";

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 34) / 3, (SCREEN_WIDTH - 34) / 3);
    layout.minimumInteritemSpacing = 5;
    self.collectionView.collectionViewLayout = layout;
    [self.collectionView registerNib:[UINib nibWithNibName:@"DZCommentImageCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)cellIdentifier{
    return NSStringFromClass([self class]);
}

- (void)fillData:(DZClientEvaluateModel *)model{
    self.model = model;
    [self.collectionView reloadData];
    if (model.head_pic.length) {
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DEFAULT_HTTP_IMG, model.head_pic]]];
    }
    self.nickLabel.text = model.nickname;
    self.dateLabel.text = model.add_time;
    self.contentLabel.text = model.content;
    self.replyLabel.text = model.reply_content;
    switch ([model.rank integerValue]) {
        case 1:{
            self.star1.image = [UIImage imageNamed:@"icon_1star_s"];
            self.star2.image = [UIImage imageNamed:@"icon_1star_n"];
            self.star3.image = [UIImage imageNamed:@"icon_1star_n"];
            self.star4.image = [UIImage imageNamed:@"icon_1star_n"];
            self.star5.image = [UIImage imageNamed:@"icon_1star_n"];
            break;
        }
        case 2:{
            self.star1.image = [UIImage imageNamed:@"icon_1star_s"];
            self.star2.image = [UIImage imageNamed:@"icon_1star_s"];
            self.star3.image = [UIImage imageNamed:@"icon_1star_n"];
            self.star4.image = [UIImage imageNamed:@"icon_1star_n"];
            self.star5.image = [UIImage imageNamed:@"icon_1star_n"];
            break;
        }
        case 3:{
            self.star1.image = [UIImage imageNamed:@"icon_1star_s"];
            self.star2.image = [UIImage imageNamed:@"icon_1star_s"];
            self.star3.image = [UIImage imageNamed:@"icon_1star_s"];
            self.star4.image = [UIImage imageNamed:@"icon_1star_n"];
            self.star5.image = [UIImage imageNamed:@"icon_1star_n"];
            break;
        }
        case 4:{
            self.star1.image = [UIImage imageNamed:@"icon_1star_s"];
            self.star2.image = [UIImage imageNamed:@"icon_1star_s"];
            self.star3.image = [UIImage imageNamed:@"icon_1star_s"];
            self.star4.image = [UIImage imageNamed:@"icon_1star_s"];
            self.star5.image = [UIImage imageNamed:@"icon_1star_n"];
            break;
        }
        case 5:{
            self.star1.image = [UIImage imageNamed:@"icon_1star_s"];
            self.star2.image = [UIImage imageNamed:@"icon_1star_s"];
            self.star3.image = [UIImage imageNamed:@"icon_1star_s"];
            self.star4.image = [UIImage imageNamed:@"icon_1star_s"];
            self.star5.image = [UIImage imageNamed:@"icon_1star_s"];
            break;
        }
        default:
            break;
    }
    
    if (!model.img_comment_array.count) {
        self.collectionView.hidden = YES;
    }else{
        self.collectionView.hidden = NO;
    }
}

//UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.model) {
        return self.model.img_comment_array.count;
    }else{
        return 0;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DZCommentImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell fillImg:self.model.img_comment_array[indexPath.item]];
    
    return cell;
}

@end
