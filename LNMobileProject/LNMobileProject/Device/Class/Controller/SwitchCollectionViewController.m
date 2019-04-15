//
//  SwitchCollectionViewController.m
//  IntelligentBra
//
//  Created by 寇凤伟 on 2019/3/10.
//  Copyright © 2019 rx. All rights reserved.
//

#import "SwitchCollectionViewController.h"
#import <Masonry/Masonry.h>
#import "HomeCell.h"

@interface SwitchCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,retain) UICollectionView *collectionView;
@property(nonatomic,retain) NSArray *funcDataAry;
@property(nonatomic,retain) NSMutableArray *funcImgDataAry;
@property(nonatomic,assign) Byte type;
@end
static NSString *const kBodyID = @"HomeCell";
@implementation SwitchCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
        
        //        make.top.equalTo(self.view).with.offset(IsiPhoneX?88:64);
    }];
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    switch (self.flag) {
        case 1://加热
            self.funcDataAry = @[@{@"title":@"关",@"image":@"guan",@"cmd":@"00"},
                                 @{@"title":@"低",@"image":@"di_img",@"cmd":@"01"},
                                 @{@"title":@"中",@"image":@"zhong_img",@"cmd":@"02"},
                                 @{@"title":@"高",@"image":@"gao_img",@"cmd":@"03"}];
            self.type = 0xA2;
            self.title = @"加热档位";
            break;
        case 2://震动档位
            self.funcDataAry = @[@{@"title":@"一档",@"image":@"dwone_img",@"cmd":@"01"},
                                 @{@"title":@"二档",@"image":@"dwtwo_img",@"cmd":@"02"},
                                 @{@"title":@"三档",@"image":@"dwthree_img",@"cmd":@"03"}];
            self.type = 0xA4;
            self.title = @"速度档位";
            break;
        case 3://光疗
            self.funcDataAry = @[@{@"title":@"开",@"image":@"glkai_img",@"cmd":@"01"},
                                 @{@"title":@"关",@"image":@"glguan_img",@"cmd":@"00"}];
            self.type = 0xA5;
            self.title = @"光疗";
            break;
        default:
            break;
    }
    [self.collectionView reloadData];
    // Do any additional setup after loading the view.
}

#pragma mark - UICollectionViewDataSource
/** 返回有多少组  */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

/** 返回每组有多少个item  */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.funcDataAry.count;
    
}
/** 返回每个item的具体内容  */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBodyID forIndexPath:indexPath];
    cell.tag = indexPath.row;
    //组模型
    NSDictionary *infoDic = [self.funcDataAry objectAtIndex:indexPath.row];
    [cell.playBtn setImage:[UIImage imageNamed:infoDic[@"image"]] forState:UIControlStateNormal];
    [cell.playBtn setTitle:infoDic[@"title"] forState:UIControlStateNormal];
    [cell layoutIfNeeded];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *infoDic = [self.funcDataAry objectAtIndex:indexPath.row];
    [[BluetoothManager shareBluetoothManager] sendOrderWithOrder:self.type WithDataStr:infoDic[@"cmd"]];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        //布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        CGFloat margin = 0;
        layout.itemSize = CGSizeMake(ScreenW/3, ScreenW/3);
        layout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        //设置头部视图的尺寸
        //        layout.headerReferenceSize = CGSizeMake(ScreenW, ScreenH * 0.085);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[HomeCell class] forCellWithReuseIdentifier:kBodyID];
    }
    return _collectionView;
}

@end
