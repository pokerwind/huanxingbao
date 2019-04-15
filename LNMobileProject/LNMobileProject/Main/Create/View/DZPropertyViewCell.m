//
//  DZPropertyViewCell.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/30.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZPropertyViewCell.h"

#import "DZPropertyViewInnerCell.h"

@interface DZPropertyViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) DZAttrListModel *model;
@property (strong, nonatomic) NSArray *tagArray;
@property (strong, nonatomic) NSMutableArray *selectedTagArray;

@end

@implementation DZPropertyViewCell
static NSString *identifier = @"DZPropertyViewInnerCell";

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(100, 100);
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"DZPropertyViewInnerCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillData:(DZAttrListModel *)model{
    self.nameLabel.text = model.attr_name;
    self.model = model;
    self.tagArray = model.values;
    
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.tagArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DZPropertyViewInnerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSString *str = self.tagArray[indexPath.item];
    cell.nameLabel.text = str;
    if ([self.model.selectedValue isEqualToString:str]) {
        cell.backgroundColor = HEXCOLOR(0xff7722);
        cell.nameLabel.textColor = [UIColor whiteColor];
    }else{
        cell.backgroundColor = HEXCOLOR(0xf1f1f1);
        cell.nameLabel.textColor = HEXCOLOR(0x666666);
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *tag = self.tagArray[indexPath.item];
    if ([self.model.selectedValue isEqualToString:tag]) {
        self.model.selectedValue = nil;
    }else{
        self.model.selectedValue = tag;
    }
    
    [self.collectionView reloadData];
}

- (NSArray *)tagArray{
    if (!_tagArray) {
        _tagArray = [NSArray array];
    }
    return _tagArray;
}

@end
