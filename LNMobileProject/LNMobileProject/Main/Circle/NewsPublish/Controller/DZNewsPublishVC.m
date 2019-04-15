//
// DZNewsPublishVC.m(文件名称)
// LNMobileProject(工程名称) //
// Created by 六牛科技 on 2017/9/18. (创建用户及时间)
//
// 山东六牛网络科技有限公司 https:// liuniukeji.com
//

#import "DZNewsPublishVC.h"
#import "DZNewsPublishCell.h"
#import "DZGoodsModel.h"
#import "DZChooseGoodsVC.h"

#define Placeholder_Text  @"说点啥…"

#define MaxContentLength 1000
#define MaxGoodsNum 9

#define kNewsPublishCell @"DZNewsPublishCell"
@interface DZNewsPublishVC ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) CGFloat oldHeight;
@property (nonatomic, strong) RACSubject *deleteSubject;

@property (nonatomic, assign) BOOL isPublishing;
@end

@implementation DZNewsPublishVC

- (instancetype)init {
    self = [super init];
    if(self) {
        self.refreshSubject = [RACSubject subject];
    }
    return self;
}

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];

    [self initNavigationBar];
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
    [right setTitle:@"发表" forState:UIControlStateNormal];
    [right setTitleColor:OrangeColor forState:UIControlStateNormal];
    right.titleLabel.font = [UIFont systemFontOfSize:13];
    
    @weakify(self);
    [[right rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        //发布动态
        
        if (self.isPublishing) {
            return;
        }
        
        NSString *content = self.textView.text;
        if (![content notBlank] || [content isEqualToString:Placeholder_Text]) {
            [SVProgressHUD showInfoWithStatus:@"请输入内容"];
            return;
        }
        
        if (self.dataArray.count == 0) {
            [SVProgressHUD showInfoWithStatus:@"请选择商品"];
            return;
        }
        
        NSMutableArray *idsArray = [NSMutableArray array];
        
        for (DZGoodsModel *goods in self.dataArray) {
            [idsArray addObject:Str(goods.goods_id)];
        }
        NSString *ids = [idsArray componentsJoinedByString:@","];
        
        LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/setShopCircle" parameters:@{@"content":content,@"ids":ids}];
        
        self.isPublishing = YES;
        
        [SVProgressHUD show];
        [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            [SVProgressHUD dismiss];
            LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
            [SVProgressHUD showInfoWithStatus:model.info];
            if (model.isSuccess) {
                [self.navigationController popViewControllerAnimated:YES];
                [self.refreshSubject sendNext:nil];
            }
            self.isPublishing = NO;
        } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:error.domain];
            self.isPublishing = NO;
        }];
        

    }];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - ---- 代理相关 ----
#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:Placeholder_Text]) {
        textView.text = @"";
        textView.textColor = TextDarkColor;
    }
    
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = Placeholder_Text;
        textView.textColor = PlaceholderColor;
    }
    
}

- (void)textViewDidChange:(UITextView *)textView {
    NSString *text = textView.text;
    if (text.length > MaxContentLength) {
        textView.text = [text substringToIndex:MaxContentLength];
        [SVProgressHUD showInfoWithStatus:@"最多输入".a(MaxContentLength).a(@"字")];
        //[self showHint:@"最多输入".a(MaxContentLength).a(@"字") yOffset:-300];
    }
}

#pragma mark UICollectionViewDelegate 

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger num = self.dataArray.count;
    if (num == MaxGoodsNum) {
        return num;
    } else {
        return num + 1;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DZNewsPublishCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kNewsPublishCell forIndexPath:indexPath];
    
    NSInteger row = indexPath.row;
    cell.row = row;
    cell.deleteSubject = self.deleteSubject;
    
    if (row == self.dataArray.count) {
        cell.goodsImageView.image = [UIImage imageNamed:@"btn_addgood"];
        cell.deleteButton.hidden = YES;
    } else {
        DZGoodsModel *goods = self.dataArray[row];
        [cell.goodsImageView sd_setImageWithURL:[NSURL URLWithString:FULL_URL(goods.goods_img)] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
        cell.deleteButton.hidden = NO;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //打开商品选择界面
    DZChooseGoodsVC *vc = [[DZChooseGoodsVC alloc] init];
    //把已经选择的传过去，选中的过去之后还是选中状态。
    vc.selectedArray = self.dataArray;
    vc.maxGoodsNum = MaxGoodsNum;
    [vc.goodsSubject subscribeNext:^(NSArray *selectedArray) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:selectedArray];
        [self.collectionView reloadData];
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - ---- Action Events 和 response手势 ----

#pragma mark - ---- 私有方法 ----
- (void)setupViews {
    self.textView.text = Placeholder_Text;
    self.textView.textColor = PlaceholderColor;
    self.textView.delegate = self;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = (SCREEN_WIDTH - 5*12)/4;
    CGFloat height = width;
    layout.itemSize = CGSizeMake(width, height);
    layout.minimumLineSpacing = 12;
    layout.minimumInteritemSpacing = 12;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.collectionView setCollectionViewLayout:layout];
    [self.collectionView registerNib:[UINib nibWithNibName:kNewsPublishCell bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:kNewsPublishCell];
    
    //集合视图高度要与内容适配
    [RACObserve(self.collectionView, contentSize) subscribeNext:^(NSValue *value) {
        CGFloat height = value.CGSizeValue.height;
        if (height == self.oldHeight) {
            return;
        }        
        self.collectionViewHeightConstraint.constant = height;
        self.oldHeight = height;
    }];
    
    self.deleteSubject = [RACSubject subject];
    
    [self.deleteSubject subscribeNext:^(NSNumber *row) {
        //删除对应的商品
        [self.dataArray removeObjectAtIndex:row.integerValue];
        [self.collectionView reloadData];
    }];
}

#pragma mark - ---- 布局代码 ----
- (void) setSubViewsFrame{

}

- (void) setSubViewsLayout{

}

#pragma mark - --- getters 和 setters ----
- (NSMutableArray *)dataArray {
    if(!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
