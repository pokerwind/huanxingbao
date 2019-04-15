//
//  DZFindVC.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/8/1.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZFindVC.h"
#import "DZSearchVC.h"
#import "DZSearchResultVC.h"
#import "DZLoginVC.h"
#import "DZMessageVC.h"
#import "LNNavigationController.h"
#import "JSMessageListViewController.h"
#import "DZHomeNavTitleView.h"
#import "DZFindTitleCell.h"
#import "DZFindItemCell.h"
#import "DZHistoryGroupHeader.h"

#import "DZGetCategoryListModel.h"

#define HeaderIdentifier @"HeaderIdentifier"

@interface DZFindVC ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) DZHomeNavTitleView *navView;
@property (strong, nonatomic) NSArray *arrayTitle;
@property (strong, nonatomic) NSMutableArray *arrayCell;

@property (nonatomic) NSInteger currentIndex;//当前选中的分类

@end

@implementation DZFindVC
static NSString *identifier = @"DZFindItemCell";

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    //[self setupNavigationBar];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.collectionView];
    
    [self setSubViewsLayout];
    
    [self getData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setSubViewsFrame];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}

#pragma mark - ---- 代理相关 ----
#pragma mark - ---- UICollectionViewDelegate ----
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DZCategoryListModel *model = self.arrayTitle[indexPath.section];
    DZCategoryListModel *models = model.child[indexPath.row];
    DZSearchResultVC *vc = [DZSearchResultVC new];
    vc.catId = models.cat_id;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ---- UICollectionViewDataSource ----
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.arrayTitle.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    DZCategoryListModel *model = self.arrayTitle[section];
    return model.child.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DZFindItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    DZCategoryListModel *model = self.arrayTitle[indexPath.section];
    DZCategoryListModel *models = model.child[indexPath.row];
    [cell fillData:models];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        DZHistoryGroupHeader *headerView = (DZHistoryGroupHeader *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
        
        DZCategoryListModel *model = self.arrayTitle[indexPath.section];
        headerView.dateLabel.text = model.cat_name_mobile;
        
        reusableView = headerView;
    }
    return reusableView;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = {SCREEN_WIDTH,30};
    return size;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.collectionView) {
//        [self currentIndex];
    }
}

#pragma mark - ---- UITableViewDelegate ----
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (DZCategoryListModel *model in self.arrayTitle) {
        model.isSelected = NO;
    }
    DZCategoryListModel *model = self.arrayTitle[indexPath.row];
    model.isSelected = YES;
    [self.tableView reloadData];
    
    [self.collectionView setContentOffset:CGPointMake(0, [self originYForSection:indexPath.row]) animated:YES];
}

#pragma mark - ---- UITableViewDataSource ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayTitle.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DZFindTitleCell *cell;
    if (indexPath.row < self.arrayCell.count) {
        cell = self.arrayCell[indexPath.row];
    }else{
        cell = [DZFindTitleCell viewFormNib];
    }
    
    DZCategoryListModel *model = self.arrayTitle[indexPath.row];
    [cell fillData:model];
    
    return cell;
}

#pragma mark - ---- Action Events 和 response手势 ----

#pragma mark - ---- 布局代码 ----
- (void) setSubViewsFrame{

}

- (void) setSubViewsLayout{
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_equalTo(KNavigationBarH);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navView.mas_bottom);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(self.tableView.mas_right).with.offset(15);
        make.right.mas_equalTo(-15);
    }];
}

#pragma mark - ---- 私有方法 ----
- (void)getData{
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/GoodsCategoryApi/getCategoryList" parameters:nil];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZGetCategoryListModel *model = [DZGetCategoryListModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            self.arrayTitle = model.data;
            if (self.arrayTitle.count > 0) {
                DZCategoryListModel *model = self.arrayTitle[0];
                model.isSelected = YES;
            }
            [self.tableView reloadData];
            [self.collectionView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)setupNavigationBar {
    DZHomeNavTitleView *titleView = [DZHomeNavTitleView viewFormNib];
    self.navigationItem.titleView = titleView;
    
    //self.navigationItem.hidesBackButton = YES;
    
    @weakify(self);
    [[titleView.searchButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        NSLog(@"go search");
        DZSearchVC *vc = [[DZSearchVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (CGFloat)originYForSection:(NSInteger)i{
    float y = 0;
    for (int j = 0; j < i; j++) {
        DZCategoryListModel *model = self.arrayTitle[j];
        NSInteger line = model.child.count / 3;
        if (model.child.count % 3 != 0) {
            line++;
        }
        y += line * ((SCREEN_WIDTH * 0.77 - 35 - 71) / 3 + 4.5 + 12);
        y += (line - 1) * 15;
    }
    y += i * 30;
    if (y > self.collectionView.contentSize.height - self.collectionView.height) {
        y = self.collectionView.contentSize.height - self.collectionView.height;
    }
    return y;
}

- (NSInteger)currentIndex{
    NSInteger i;
    if (self.collectionView.contentOffset.y <= 0) {
        i = 0;
    }else{
        for (i = 0; i < self.arrayTitle.count; i++) {
            if (i + 1 == self.arrayTitle.count) {
                break;
            }else{
                if (self.collectionView.contentOffset.y > [self originYForSection:i] && self.collectionView.contentOffset.y < [self originYForSection:i + 1]) {
                    break;
                }
            }
        }
    }
    
    if (_currentIndex != i) {
        for (DZCategoryListModel *model in self.arrayTitle) {
            model.isSelected = NO;
        }
        
        DZCategoryListModel *model = self.arrayTitle[i];
        model.isSelected = YES;
        _currentIndex = i;
        [self.tableView reloadData];
    }
    
    return _currentIndex;
}

#pragma mark - --- getters 和 setters ----
- (NSArray *)arrayTitle{
    if (!_arrayTitle) {
        _arrayTitle = [NSArray array];
    }
    return _arrayTitle;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((SCREEN_WIDTH * 0.77 - 30 - 2) / 3, (SCREEN_WIDTH * 0.77 - 35 - 71) / 3 + 4.5 + 12);
        layout.minimumLineSpacing = 15;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"DZFindItemCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
        [_collectionView registerClass:[DZHistoryGroupHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier];
        
    }
    return _collectionView;
}

- (NSMutableArray *)arrayCell{
    if (!_arrayCell) {
        _arrayCell = [NSMutableArray array];
    }
    return _arrayCell;
}

- (DZHomeNavTitleView *)navView {
    if(!_navView) {
        _navView = [DZHomeNavTitleView viewFormNib];
        @weakify(self);
        [[_navView.searchButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            DZSearchVC *vc = [[DZSearchVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        [[_navView.messageButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if ([DPMobileApplication sharedInstance].isLogined) {
                JSMessageListViewController *vc = [JSMessageListViewController new];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                DZLoginVC *vc = [DZLoginVC new];
                LNNavigationController *nvc = [[LNNavigationController alloc] initWithRootViewController:vc];
                [self.navigationController presentViewController:nvc animated:YES completion:nil];
            }
        }];
    }
    return _navView;
}

@end
