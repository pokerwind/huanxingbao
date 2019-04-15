//
//  DZSearchResultFilterVC.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/9.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZSearchResultFilterVC.h"
#import "DZSearchResultFilterView.h"
#import "DZSearchResultSizeCell.h"
#import "DZGoodsSizeModel.h"

#define duration 0.2
#define kSizeCell @"DZSearchResultSizeCell"

@interface DZSearchResultFilterVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    CGPoint startTouchPoint; // 手指按下时的坐标
    CGFloat startContentOriginX; // 移动前的窗口位置
    BOOL _isMoving;
    UIColor *_bgColor;
}

@property (nonatomic, strong) DZSearchResultFilterView* filterView;
@property (nonatomic, strong) UIView* shadowView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger sizeIndex;
@end

@implementation DZSearchResultFilterVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.filterSubject = [RACSubject subject];
    }
    return self;
}

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.shadowView];
    
    UITapGestureRecognizer *tapShadow = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideSlideBar)];
    [self.shadowView addGestureRecognizer:tapShadow];
    
    
    
    //CGRect rect = CGRectMake(kSBWidth, 0, kSidebarWidth, self.view.bounds.size.height);
    [self.view addSubview:self.filterView];
    
    [self.filterView.collectionViewContainer addSubview:self.collectionView];

    self.view.hidden = YES;
    self.sizeIndex = -1;
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
#pragma mark UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sizeArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DZSearchResultSizeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSizeCell forIndexPath:indexPath];
    DZGoodsSizeModel *model = self.sizeArray[indexPath.row];
    cell.sizeLabel.text = model.item;
    
    if (indexPath.row == self.sizeIndex) {
        //选中的，
        cell.backgroundColor = OrangeColor;
        cell.sizeLabel.textColor = TextWhiteColor;
    } else {
        cell.backgroundColor = BgColor;
        cell.sizeLabel.textColor = [UIColor blackColor];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.sizeIndex == indexPath.row) {
        self.sizeIndex = -1;
        self.filterView.goods_size = nil;
    } else {
        self.sizeIndex = indexPath.row;
        DZGoodsSizeModel *model = self.sizeArray[indexPath.row];
        self.filterView.goods_size = model.item;
    }

    [self.collectionView reloadData];
}
#pragma mark - ---- Action Events 和 response手势 ----

#pragma mark - ---- 私有方法 ----
- (void)hideSlideBar{
    [self showHideSidebar];
}
#pragma mark - ---- 公有方法 ----
- (void)setSizeArray:(NSArray *)sizeArray {
    _sizeArray = sizeArray;
    [self.collectionView reloadData];
}

#pragma mark - 显示/隐藏

- (BOOL)isSidebarShown{
    return self.filterView.frame.origin.x < kSidebarWidth ? YES :NO;
}

- (void)showHideSidebar{
    if (self.filterView.frame.origin.x == SCREEN_WIDTH) {
        startContentOriginX = self.filterView.frame.origin.x;
    }
    [self autoShowHideSidebar];
}
- (void)autoShowHideSidebar
{
    if (!self.isSidebarShown){
        //        NSLog(@"自动弹出");
        self.view.hidden = NO;
        [UIView animateWithDuration:duration animations:^{
            [self setSidebarOriginX:SCREEN_WIDTH - kSidebarWidth];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            [self sidebarDidShown];
        }];
    }else{
        //        NSLog(@"自动缩回");
        [UIView animateWithDuration:duration animations:^{
            [self setSidebarOriginX:SCREEN_WIDTH];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            self.view.hidden = YES;
            [self slideToRight];
        }];
    }
}

- (void)setSidebarOriginX:(CGFloat)x
{
    CGRect rect = self.filterView.frame;
    rect.origin.x = x;
    [self.filterView
     setFrame:rect];
    
    [self setShadowViewAlpha];
}

- (void)setShadowViewAlpha
{
    self.shadowView.alpha = 0.4;
    //self.filterView.backgroundColor = _bgColor;
}

- (void)setBgColor:(UIColor *)color{
    _bgColor = color;
}

- (void)slideToRight
{
    //    NSLog(@"触发了右滑事件，需要时可以在子类中用");
}

- (void)sidebarDidShown
{
    //    NSLog(@"已经完成显示，需要时可以在子类中用");
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
- (UIView *)shadowView {
    if(!_shadowView) {
        _shadowView = [[UIView alloc] initWithFrame:self.view.bounds];
        _shadowView.userInteractionEnabled = YES;
        _shadowView.backgroundColor = [UIColor blackColor];
        _shadowView.alpha = 0;
    }
    return _shadowView;
}

- (DZSearchResultFilterView *)filterView {
    if(!_filterView) {
        _filterView = [DZSearchResultFilterView viewFormNib];
        _filterView.frame = CGRectMake(SCREEN_WIDTH, 0, kSidebarWidth, self.view.bounds.size.height);
        @weakify(self);
        [[_filterView.confirmButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self showHideSidebar];
            //将筛选条件发送出去
            NSInteger shop_type = _filterView.shop_type;
            NSString *size = _filterView.goods_size;
            NSString *start = _filterView.startPriceTextFileld.text;
            NSString *end = _filterView.endPriceTextField.text;
            NSString *num = _filterView.batchNumTextField.text;
            
            [self.filterSubject sendNext:RACTuplePack(@(shop_type),size,start,end,num)];
            
        }];
        [_filterView.clearSubject subscribeNext:^(id x) {
            @strongify(self);
            self.sizeIndex = -1;
            self.filterView.goods_size = nil;
            [self.collectionView reloadData];
        }];
    }
    return _filterView;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat width = (kSidebarWidth - 12*2 - 4*2)/3;
        CGFloat height = 30;
        layout.sectionInset = UIEdgeInsetsMake(0, 12, 0, 12);
        layout.itemSize = CGSizeMake(width, height);
        layout.minimumLineSpacing = 4;
        layout.minimumInteritemSpacing = 4;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.pagingEnabled = NO;
        //collectionView.directionalLockEnabled = YES;
        
        //注册cell
        
        [collectionView registerNib:[UINib nibWithNibName:kSizeCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kSizeCell];
        //collectionView.scrollEnabled = NO;
        _collectionView = collectionView;
        //        @weakify(self);
        //        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //            @strongify(self);
        //            //[self getFirstPage];
        //        }];
        //
        //        _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //            @strongify(self);
        //            [self getNextPage];
        //        }];
    }
    return _collectionView;
    
}
@end
