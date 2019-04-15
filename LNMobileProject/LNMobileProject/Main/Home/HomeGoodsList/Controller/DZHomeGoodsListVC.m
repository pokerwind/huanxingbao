//
//  DZHomeGoodsListVC.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/8/1.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZHomeGoodsListVC.h"
#import "DZGoodsModel.h"
#import "DZHomeGoodsListCell.h"
#import "DZBannerModel.h"
#import "DZHomeAdReusableView.h"

#define kHomeGoodsListCell @"DZHomeGoodsListCell"
#define kHomeAdReusableView @"DZHomeAdReusableView"
#define kGoodsPerAd 8

@interface DZHomeGoodsListVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) CGFloat oldHeight;
@end

@implementation DZHomeGoodsListVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.refreshSubject = [RACSubject subject];
        self.clickSubject = [RACSubject subject];
    }
    return self;
}

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    
    [RACObserve(self.collectionView, contentSize) subscribeNext:^(NSValue *size) {
        if(size.CGSizeValue.height == self.oldHeight) {
            return; //与上次相同不用再回调
        }
        [self.refreshSubject sendNext:@(size.CGSizeValue.height)];
        self.oldHeight = size.CGSizeValue.height;        
    }];
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;

    // 写在 ViewDidLoad 的最后一行
    [self setSubViewsLayout];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setSubViewsFrame];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}

#pragma mark - ---- 代理相关 ----
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"me_null"];
}

//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
//    NSString *title = @"狮子王";
//    NSDictionary *attributes = @{
//                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
//                                 NSForegroundColorAttributeName:[UIColor darkGrayColor]
//                                 };
//    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
//}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"没有数据";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName:paragraph
                                 };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return [self getSectionNum];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger secNum = [self getSectionNum];
    if (section < secNum - 1) {
        return kGoodsPerAd; //除了最后一个，前面都是满的
    } else {
        return self.dataArray.count - (secNum -1) * kGoodsPerAd; // 最后一个应该是剩下的
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DZHomeGoodsListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeGoodsListCell forIndexPath:indexPath];
    NSInteger sec = indexPath.section;
    //NSInteger secNum = [self getSectionNum];
    NSInteger index = kGoodsPerAd *sec + indexPath.row;

    DZGoodsModel *model = self.dataArray[index];
//    if(model.pack_price) {
//        [cell fillPic:model.goods_img title:model.goods_name pack_price:model.pack_price shop_price:model.shop_price];
//    } else if (model.user_price) {
        [cell configView:model];
//    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.source == 2) {
//        return;
//    }
    NSInteger index = kGoodsPerAd *indexPath.section + indexPath.row;
    DZGoodsModel *model = self.dataArray[index];
    [self.clickSubject sendNext:model];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section > self.adArray.count || indexPath.section == 0) {
        return nil;
    }
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        DZHomeAdReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHomeAdReusableView forIndexPath:indexPath];
        DZBannerModel *ad = self.adArray[indexPath.section - 1];
        [headerView.adImageView sd_setImageWithURL:[NSURL URLWithString:FULL_URL(ad.content)] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
        headerView.clickSubject = self.clickSubject;
        headerView.model = ad;
        return headerView;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(0, 0);
    }
    
    return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*148/375);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.collectionView.scrollEnabled = NO;
}
#pragma mark - ---- Action Events 和 response手势 ----

#pragma mark - ---- 私有方法 ----
- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self.collectionView reloadData];
}

- (void)setAdArray:(NSArray *)adArray {
    _adArray = adArray;
    [self.collectionView reloadData];
}

- (void)loadAds {
    //获取活动广告
    LNetWorkAPI *api4 = [[LNetWorkAPI alloc] initWithUrl:@"/Api/IndexApi/adActivityBanner"];
    [api4 startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        DZBannerNetModel *model = [DZBannerNetModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            //self.reasonArray = request.responseJSONObject[@"data"];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        
    }];
}

- (NSInteger)getSectionNum {
    //根据广告数和商品数来判断。 每8个商品展示一个广告。广告用section header来做。
    //广告数   商品允许的广告数 商品数/8
    // min(广告数，商品数/8)
    
    if(self.adArray.count > 0 && self.dataArray.count/kGoodsPerAd > 0) {
        if (self.adArray.count > (self.dataArray.count/kGoodsPerAd)) {
            return (self.dataArray.count/kGoodsPerAd) + 1;
        } else {
            return self.adArray.count + 1;
        }
    }
    return 1;
}
#pragma mark - ---- 布局代码 ----
- (void) setSubViewsFrame{

}

- (void) setSubViewsLayout{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_offset(0);
    }];
}

#pragma mark - --- getters 和 setters ----
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat width = (SCREEN_WIDTH - 15)/2;
        CGFloat picHeight = width*400/350;
        CGFloat height = picHeight + 71;
        layout.itemSize = CGSizeMake(width, height);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 9;
        layout.sectionInset = UIEdgeInsetsMake(5, 3, 5, 3);
        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*148/375);
        //layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        //collectionView.backgroundColor = TextWhiteColor;
        collectionView.pagingEnabled = NO;
        collectionView.directionalLockEnabled = YES;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.scrollEnabled = NO;
        //注册cell
        [collectionView registerNib:[UINib nibWithNibName:kHomeGoodsListCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kHomeGoodsListCell];
        [collectionView registerNib:[UINib nibWithNibName:kHomeAdReusableView bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHomeAdReusableView];
        collectionView.backgroundColor = BgColor;
        _collectionView = collectionView;
    }
    return _collectionView;
    
}
@end
