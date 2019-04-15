//
// DZChooseGoodsVC.m(文件名称)
// LNMobileProject(工程名称) //
// Created by 六牛科技 on 2017/9/18. (创建用户及时间)
//
// 山东六牛网络科技有限公司 https:// liuniukeji.com
//

#import "DZChooseGoodsVC.h"
#import "DZGoodsModel.h"
#import "DZHomeGoodsListCell.h"
#import "DZShopGoodsModel.h"

#define kHomeGoodsListCell @"DZHomeGoodsListCell"

@interface DZChooseGoodsVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@end

@implementation DZChooseGoodsVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.goodsSubject = [RACSubject subject];
    }
    return self;
}

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"添加商品";
    [self initNavigationBar];
    
    [self.view addSubview:self.collectionView];
    self.page = 1;

    [self loadData];
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

- (void)initNavigationBar {
    UIButton *right = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 27, 16)];
    [right setTitle:@"确定" forState:UIControlStateNormal];
    [right setTitleColor:OrangeColor forState:UIControlStateNormal];
    right.titleLabel.font = [UIFont systemFontOfSize:13];
    
    @weakify(self);
    [[right rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        //点击确定之后，将选定的商品传回原来的页面
        NSMutableArray *selectedArray = [NSMutableArray array];
        for (DZGoodsModel *goods in self.dataArray) {
            if (goods.isSelected) {
                [selectedArray addObject:goods];
            }
            [self.goodsSubject sendNext:selectedArray];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - ---- 代理相关 ----
#pragma mark UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DZHomeGoodsListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeGoodsListCell forIndexPath:indexPath];
    DZGoodsModel *model = self.dataArray[indexPath.row];
    
    [cell fillPic:model.goods_img title:model.goods_name pack_price:model.pack_price shop_price:model.shop_price];
    if (model.isSelected) {
        [cell setEditingState:1];
    } else {
        [cell setEditingState:-1];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //[self.clickSubject sendNext:nil];
//    DZGoodsDetailVC *vc = [[DZGoodsDetailVC alloc] init];
//    DZGoodsModel *model = self.dataArray[indexPath.row];
//    vc.goodsId = model.goods_id;
//    [self.navigationController pushViewController:vc animated:YES];
    DZGoodsModel *model = self.dataArray[indexPath.row];
    
    if (!model.isSelected) {
        //点击了一个未选中的，如果数目已经达到上限，则进行提示，不能选择
        NSInteger num = 0;
        for (DZGoodsModel *goods in self.dataArray) {
            if (goods.isSelected) {
                num ++;
            }
        }
        if (num >= self.maxGoodsNum) {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"商品最多只能选择%ld件",self.maxGoodsNum]];
            return;
        }
        
    }
    model.isSelected = !model.isSelected;
    
    [self.collectionView reloadData];
}

#pragma mark - ---- Action Events 和 response手势 ----

#pragma mark - ---- 私有方法 ----

- (void)loadData {
    
    NSString *shopId = [DPMobileApplication sharedInstance].loginUser.shop_id;
    
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopApi/shop_goods" parameters:@{@"shop_id":shopId,@"p":@(self.page)}];
    
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZShopGoodsNetModel *model = [DZShopGoodsNetModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            if(self.page == 1) {
                [self.dataArray removeAllObjects];
                [self.collectionView.mj_header endRefreshing];
            } else {
                [self.collectionView.mj_footer endRefreshing];
            }
            
            [self addGoods:model.data.goodsList];
            [self.collectionView reloadData];

        } else {
            [SVProgressHUD showInfoWithStatus:model.info];
            
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}
- (void)addGoods:(NSArray *)list {
    //检查商品是否已经被选中
    for(DZGoodsModel *goods in list) {
        for(DZGoodsModel *selected in self.selectedArray) {
            if (selected.goods_id == goods.goods_id) {
                goods.isSelected = YES;
                continue;
            }
        }
    }
    
    [self.dataArray addObjectsFromArray:list];
    
    
}
#pragma mark - ---- 布局代码 ----
- (void) setSubViewsFrame{

}

- (void) setSubViewsLayout{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_offset(0);
        make.bottom.mas_offset(0);
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
        @weakify(self);
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.page = 1;
            [self loadData];
        }];
        
        _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            self.page ++;
            [self loadData];
        }];
    }
    return _collectionView;
}

- (NSMutableArray *)dataArray  {
    if(!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
