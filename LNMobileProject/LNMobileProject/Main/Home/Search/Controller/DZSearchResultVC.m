//
//  DZSearchResultVC.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/9.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZSearchResultVC.h"
#import "DZSearchResultNavView.h"
#import "YZPullDownMenu.h"
#import "PullListTableVC.h"
#import "PullDoubleTableVC.h"
#import "DZGoodsDetailVC.h"
#import "DZSearchResultFilterVC.h"
#import "DZGoodsModel.h"
#import "DZHomeGoodsListCell.h"
#import "DZGoodsCateModel.h"
#import "DZFilterModel.h"
#import "DZGoodsAttrModel.h"
#import "DZGoodsSizeModel.h"

#define kHomeGoodsListCell @"DZHomeGoodsListCell"

@interface DZSearchResultVC ()<YZPullDownMenuDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) DZSearchResultNavView *navView;
//@property (nonatomic ,strong) YZPullDownMenu * menu;
@property (strong, nonatomic) NSArray *menuTitle;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) DZSearchResultFilterVC *filterVC;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *cateArray;
@property (nonatomic, strong) NSMutableArray *attrArray;
@property (nonatomic, strong) NSArray *sortArray;
@property (nonatomic, strong) NSArray *sizeArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) PullListTableVC *pull1VC;
@property (nonatomic, strong) PullDoubleTableVC *pull2VC;
@property (nonatomic, strong) DZFilterModel *filter;
@end

@implementation DZSearchResultVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.navView];
//    [self.view addSubview:self.menu];
    [self.view addSubview:self.collectionView];
    
    [self.view addSubview:self.filterVC.view];
    
    self.page = 1;
    self.filter.keywords = self.keyword;
    if (self.catId) {
        self.filter.cat_id = self.catId.integerValue;
    }
    
    [self loadData];
//    [self loadCate];
//    [self loadSize];
//    self.menuTitle = @[@"分类",@"属性",@"综合排序"];
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self loadData];
    }];
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page ++;
        [self loadData];
    }];
    
    [self processNotification];
    
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


#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //点击了搜索，改变关键字，在搜索一下。
    self.page = 1;
    self.filter.keywords = textField.text;
    [self loadData];
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - 下拉菜单代理
- (NSInteger)numberOfColsInMenu:(YZPullDownMenu *)pullDownMenu
{
    return self.menuTitle.count;
}
// 返回下拉菜单每列按钮
- (UIButton *)pullDownMenu:(YZPullDownMenu *)pullDownMenu buttonForColAtIndex:(NSInteger)index
{
    NSString *buttonTitle = self.menuTitle[index];
    UIButton *button = [[UIButton alloc] init];
    //button.backgroundColor = AfterColor;
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setTitleColor:TextLightColor forState:UIControlStateNormal];
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    return button;
}

// 返回下拉菜单每列对应的控制器
- (UIViewController *)pullDownMenu:(YZPullDownMenu *)pullDownMenu viewControllerForColAtIndex:(NSInteger)index
{
    return self.childViewControllers[index];
}

// 返回下拉菜单每列对应的高度
- (CGFloat)pullDownMenu:(YZPullDownMenu *)pullDownMenu heightForColAtIndex:(NSInteger)index
{
    // 第1列 高度
    if(index == 0) {
        if (self.cateArray.count > 8) {
            return 8 * 44;
        }
        return self.cateArray.count * 44;
    } else if (index == 1) {
        if (self.attrArray.count > 0) {
            NSInteger indexNum = self.attrArray.count;
            
            for (DZGoodsAttrModel *attr in self.attrArray) {
                if (indexNum < attr.value_list.count) {
                    indexNum = attr.value_list.count;
                }
            }
            if (indexNum > 8) {
                return 8 *44;
            }
            
            return indexNum * 44;
        }
        return 4 * 44;
    }
    int i = 5;
    return 44 * i;
}

#pragma mark UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DZHomeGoodsListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeGoodsListCell forIndexPath:indexPath];
    DZGoodsModel *model = self.dataArray[indexPath.row];
    
    [cell fillPic:model.goods_img title:model.goods_name pack_price:model.sale_num shop_price:model.shop_price];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //[self.clickSubject sendNext:nil];
    DZGoodsDetailVC *vc = [[DZGoodsDetailVC alloc] init];
    DZGoodsModel *model = self.dataArray[indexPath.row];
    vc.goodsId = model.goods_id;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ---- Action Events 和 response手势 ----

#pragma mark - ---- 私有方法 ----
- (void)processNotification {
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:YZUpdateMenuTitleNote object:nil] subscribeNext:^(NSNotification *noti) {
        NSLog(@"clicked:");
        NSDictionary *userInfo = noti.userInfo;
        NSString *type = userInfo[@"type"];
        if ([type isEqualToString:@"cate"]) {
            NSNumber *index = userInfo[@"index"];
            DZGoodsCateModel *cate = self.cateArray[index.integerValue];
            self.filter.cat_id = cate.cat_id;
            self.filter.attr = nil;
            [self loadData];
            //此时需要加载此分类的属性
            [self loadAttr];
        } else if ([type isEqualToString:@"attr"]) {
            NSString *title = userInfo[@"title"];
            self.filter.attr = title;
            [self loadData];
        } else if ([type isEqualToString:@"sort"]) {
            NSNumber *index = userInfo[@"index"];
            NSDictionary *dict = self.sortArray[index.integerValue];
            NSString *key = dict[@"key"];
            if ([key isEqualToString:@""]) {
                self.filter.sort = nil;
            } else {
                self.filter.sort = key;
            }
            [self loadData];
        }
    }];
}

- (void)loadData {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    self.filter.keywords = self.navView.searchField.text;
    [dict setObject:self.filter.keywords forKey:@"keywords"];
//
//    if (self.filter.cat_id) {
//        [dict setObject:@(self.filter.cat_id) forKey:@"cat_id"];
//    }
//
//    if (self.filter.attr) {
//        [dict setObject:self.filter.attr forKey:@"attr"];
//    }
//
//    if (self.filter.sort) {
//        [dict setObject:self.filter.sort forKey:@"sort"];
//    }
//
//    if (self.filter.shop_type) {
//        [dict setObject:@(self.filter.shop_type) forKey:@"shop_type"];
//    }
//
//    if (self.filter.goods_size) {
//        [dict setObject:self.filter.goods_size forKey:@"goods_size"];
//    }
//    if (self.filter.min_price) {
//        [dict setObject:self.filter.min_price forKey:@"min_price"];
//    }
//    if (self.filter.max_price) {
//        [dict setObject:self.filter.max_price forKey:@"max_price"];
//    }
//    if (self.filter.pack_num) {
//        [dict setObject:self.filter.pack_num forKey:@"pack_num"];
//    }
    
    [dict setObject:@(self.page) forKey:@"p"];
    
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"Api/GoodsApi/goodsList" parameters:dict method:LCRequestMethodPost];
    
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZGoodsNetModel *model = [DZGoodsNetModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
                [self.collectionView.mj_header endRefreshing];
            } else {
                [self.collectionView.mj_footer endRefreshing];
            }
            [self.dataArray addObjectsFromArray:model.data];
            [self.collectionView reloadData];
        } else {
            [SVProgressHUD showInfoWithStatus:model.info];

        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];

}

- (void)loadCate {
    //加载分类
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/GoodsCategoryApi/all_category"];
    
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZGoodsCateNetModel *model = [DZGoodsCateNetModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            [self.cateArray removeAllObjects];
            [self.cateArray addObjectsFromArray:model.data];
            NSMutableArray *dataSource = [NSMutableArray array];
            for (DZGoodsCateModel *cate in model.data) {
                [dataSource addObject:@{@"name":cate.cat_name,@"short":cate.cat_name,@"type":@"cate"}];
            }
            self.pull1VC.dataSoure = dataSource;
//            [self.menu reload];
            //分类加载完毕，如果是从某个分类点击进来的
            [self chooseCate];
        } else {
            [SVProgressHUD showInfoWithStatus:model.info];
            
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)chooseCate {
    if (self.catId) {
        //找到这个id对应的分类名称及下标
        DZGoodsCateModel *cate = [self findCate:self.catId.integerValue];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"YZUpdateMenuTitleNote" object:self.pull1VC userInfo:@{@"title":cate.cat_name,@"type":@"cate",@"index":@(cate.index)}];
        self.pull1VC.selectedCol = cate.index;
    }

}

- (DZGoodsCateModel *)findCate:(NSInteger)catId {
    DZGoodsCateModel *result = nil;
    for (int i = 0; i < self.cateArray.count; i++) {
        DZGoodsCateModel *cate = self.cateArray[i];
        if (cate.cat_id == catId) {
            result = cate;
            result.index = i;
            break;
        }
    }
    return result;
}

- (void)loadSize {
    //加载分类
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/GoodsEditApi/getSizeList"];
    
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZGoodsSizeNetModel *model = [DZGoodsSizeNetModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            self.sizeArray = model.data;
            self.filterVC.sizeArray = self.sizeArray;
        } else {
            [SVProgressHUD showInfoWithStatus:model.info];
            
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)loadAttr {
    //加载属性
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/GoodsApi/getFilterAttr" parameters:@{@"cat_id":@(self.filter.cat_id)}];
    
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZGoodsAttrNetModel *model = [DZGoodsAttrNetModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            [self.attrArray removeAllObjects];
            [self.attrArray addObjectsFromArray:model.data];
            NSMutableArray *indexArray = [NSMutableArray array];
            NSMutableArray *listArrays = [NSMutableArray array];
            for (DZGoodsAttrModel *cate in model.data) {
                [indexArray addObject:cate.attr_name];
                NSMutableArray *values = [NSMutableArray array];
                for (DZGoodsAttrValueModel *value in cate.value_list) {
                    [values addObject:value.attr_value];
                }
                [listArrays addObject:values];
            }
            
            self.pull2VC.indexArray = indexArray;
            self.pull2VC.listArrays = listArrays;
//            self.menu.isAttriLoaded = YES;
//            [self.menu reloadColumn:1];//应该使用局部刷新，避免其他列重置。
        } else {
            [SVProgressHUD showInfoWithStatus:model.info];
            
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)showFilter {
//    [self.menu dismissNow];
    [self.filterVC showHideSidebar];
}

#pragma mark - 添加子控制器
- (void)setupPullDownMenuChildVC
{
    for(UIViewController *vc in self.childViewControllers) {
        [vc removeFromParentViewController];
    }
    
    PullListTableVC *allCourse2 = [[PullListTableVC alloc] init];
    allCourse2.dataSoure = @[@{@"name":@"女装",@"short":@"新品",@"type":@"store_count"},
                             @{@"name":@"T恤",@"short":@"新品",@"type":@"store_count"},
                             @{@"name":@"男装",@"short":@"新品",@"type":@"store_count"},
                             @{@"name":@"饰品",@"short":@"新品",@"type":@"store_count"},
                             @{@"name":@"衬衫",@"short":@"新品",@"type":@"store_count"},
                             @{@"name":@"短裙",@"short":@"新品",@"type":@"store_count"},
                             @{@"name":@"针织衫",@"short":@"新品",@"type":@"store_count"},
                             @{@"name":@"马甲",@"short":@"新品",@"type":@"store_count"},
                             @{@"name":@"风衣",@"short":@"新品",@"type":@"store_count"},
                             @{@"name":@"吊带",@"short":@"新品",@"type":@"store_count"}];
    self.pull1VC = allCourse2;
    [self addChildViewController:allCourse2];
    
    //排序
    PullDoubleTableVC *propVC = [[PullDoubleTableVC alloc] init];
    
    
    propVC.indexArray = @[@"风格",@"季节",@"面料",@"厚度"];
    propVC.listArrays = @[@[@"日韩",@"欧美",@"大众",@"运动"],
                          @[@"冬秋",@"春夏"],
                          @[@"针织",@"棉麻",@"涤纶",@"皮草"],
                          @[@"透",@"偏薄",@"中等",@"偏厚"],
                          ];
    self.pull2VC = propVC;
    [self addChildViewController:propVC];
    
    PullListTableVC *allCourse3 = [[PullListTableVC alloc] init];
    allCourse3.dataSoure = @[
                            @{@"name":@"综合排序",@"short":@"综合排序",@"type":@"sort",@"key":@""},
                            @{@"name":@"发布时间",@"short":@"发布时间",@"type":@"sort",@"key":@"add_time"},
                            @{@"name":@"价格",@"short":@"价格",@"type":@"sort",@"key":@"shop_price"},
                            @{@"name":@"收藏量",@"short":@"收藏量",@"type":@"sort",@"key":@"collect_num"},
                            @{@"name":@"销量",@"short":@"销量",@"type":@"sort",@"key":@"sale_num"},
                            ];
    self.sortArray = allCourse3.dataSoure;
    [self addChildViewController:allCourse3];
    
}

#pragma mark - ---- 布局代码 ----
- (void) setSubViewsFrame{

}

- (void) setSubViewsLayout{
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(KNavigationBarH + 0.5);
    }];
//    [self.menu mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.navView.mas_bottom);
//        make.left.right.mas_offset(0);
//        make.height.mas_equalTo(30);
//    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navView.mas_bottom);
        make.left.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
}

#pragma mark - --- getters 和 setters ----
- (DZSearchResultNavView *)navView {
    if(!_navView) {
        _navView = [DZSearchResultNavView viewFormNib];
        @weakify(self);
        [[_navView.backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        [[_navView.filterButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self loadData];
            [self.view endEditing:YES];
//            [self showFilter];
        }];
        _navView.searchField.text = self.keyword;
        _navView.searchField.delegate = self;
    }
    return _navView;
}

//-(YZPullDownMenu *)menu
//{
//    if (!_menu) {
//        _menu = [[YZPullDownMenu alloc] init];
//        _menu.backgroundColor = BgColor;
//        _menu.coverColor = [UIColor colorWithWhite:0 alpha:0.4];
//        // 设置下拉菜单代理
//        _menu.dataSource = self;
//        @weakify(self);
//        _menu.clickBlock = ^(UIButton *button, BOOL selected) {
//            @strongify(self);
//            //[self clickMenuTitle:button selected:selected];
//        };
//        // 添加子控制器
//        [self setupPullDownMenuChildVC];
//    }
//    return _menu;
//}

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
        //layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        //collectionView.backgroundColor = TextWhiteColor;
        collectionView.pagingEnabled = NO;
        collectionView.directionalLockEnabled = YES;
        collectionView.showsHorizontalScrollIndicator = NO;
        //注册cell
        [collectionView registerNib:[UINib nibWithNibName:kHomeGoodsListCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kHomeGoodsListCell];
        collectionView.backgroundColor = BgColor;
        _collectionView = collectionView;
        collectionView.emptyDataSetSource = self;
        collectionView.emptyDataSetDelegate = self;
    }
    return _collectionView;
}

- (DZSearchResultFilterVC *)filterVC  {
    if(!_filterVC) {
        _filterVC = [[DZSearchResultFilterVC alloc] init];
        _filterVC.view.frame = [UIScreen mainScreen].bounds;
        @weakify(self);
        [_filterVC.filterSubject subscribeNext:^(RACTuple * tuple) {
            @strongify(self);
            RACTupleUnpack(NSNumber *shop_type,NSString *size,NSString *start,NSString *end, NSString *num) = tuple;
            self.filter.shop_type = shop_type.integerValue;
            if (size && ![size isEqualToString:@"全部"]) {
                self.filter.goods_size = size;
            } else {
                self.filter.goods_size = nil;
            }
            if ([start notBlank]) {
                self.filter.min_price = start;
            } else {
                self.filter.min_price = nil;
            }
            
            if ([end notBlank]) {
                self.filter.max_price = end;
            } else {
                self.filter.max_price = nil;
            }
            
            if ([num notBlank]) {
                self.filter.pack_num = num;
            } else {
                self.filter.pack_num = nil;
            }
            [self loadData];
        }];
    }
    return _filterVC;
}

- (NSMutableArray *)dataArray {
    if(!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)cateArray {
    if(!_cateArray) {
        _cateArray = [NSMutableArray array];
    }
    return _cateArray;
}

- (NSMutableArray *)attrArray {
    if(!_attrArray) {
        _attrArray = [NSMutableArray array];
    }
    return _attrArray;
}

- (DZFilterModel *)filter {
    if(!_filter) {
        _filter = [[DZFilterModel alloc] init];
    }
    return _filter;
}
@end
