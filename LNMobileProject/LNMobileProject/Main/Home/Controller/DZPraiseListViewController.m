//
//  DZPraiseListViewController.m
//  LNMobileProject
//
//  Created by 高盛通 on 2019/1/28.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import "DZPraiseListViewController.h"
#import "DZPraiseTableViewCell.h"
#import "DZCGSize.h"
#import "GXQKeyBoardView.h"
#import "JSSendCommentModel.h"
#import "JSCommentListModel.h"
@interface DZPraiseListViewController ()<UITableViewDelegate,UITableViewDataSource,GXQKeyBoardDelegate>
{
    GXQKeyBoardView *_keyBoardViews;
}
/*
 * items
 */
@property (nonatomic,strong)NSMutableArray *items;

/*
 * tableView
 */
@property (nonatomic,strong)UITableView *tableView;

@end

@implementation DZPraiseListViewController

- (NSMutableArray *)items
{
    if (_items == nil) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评价";
    [self loadData];
    // Do any additional setup after loading the view.
   [self setupTableView];
    
    [self setupToolBar];
}


- (void)setupTableView
{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.backgroundColor=[UIColor whiteColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];
    self.tableView.showsVerticalScrollIndicator=NO;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - KNavigationBarH - 50);
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DZPraiseTableViewCell *cell = [DZPraiseTableViewCell cellWithTableView:tableView];
    cell.list = [self.items objectAtIndex:indexPath.section];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JSCommentListData *list = [self.items objectAtIndex:indexPath.section];
   return [DZCGSize sizeWithText:list.content andFont:[UIFont systemFontOfSize:14] andMaxW:KScreenWidth - 105].height + 80.5;
}


//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{

//    JSHospitalInfomationNewslist *list = [self.arr objectAtIndex:section];
//
//    UIView *headView = [[UIView alloc]init];
//    headView.backgroundColor = [UIColor whiteColor];
//
//    UILabel *timeL = [[UILabel alloc]init];
//    timeL.text = list.createDate;
//    timeL.textAlignment = NSTextAlignmentCenter;
//    timeL.textColor = [UIColor whiteColor];
//    timeL.backgroundColor = KRGBA(210, 210, 210, 1);
//    timeL.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 10];
//    [headView addSubview:timeL];
//    [timeL sizeToFit];
//    [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(headView);
//        make.centerY.mas_equalTo(headView);
//        make.width.mas_equalTo(timeL.width + 10);
//        make.height.mas_equalTo(timeL.height + 4);
//    }];
//    timeL.layer.cornerRadius = 0.5*timeL.height + 2;
//    timeL.layer.masksToBounds = YES;
//    return headView;
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

- (void)netRequest
{
    
}


#pragma mark - ---- 私有方法 ----
- (void)loadData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.artid forKey:@"article_id"];
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ArticleApi/articleComment" parameters:params method:LCRequestMethodPost];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        JSCommentListModel *model = [JSCommentListModel objectWithKeyValues:request.responseJSONObject];
        if (model.status == 1) {
            self.items = [model.data mutableCopy];
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)setupToolBar
{
    GXQKeyBoardView *keyBoardView = [[GXQKeyBoardView alloc]initWithFrame:CGRectMake(0,KScreenHeight - 50 - KNavigationBarH , KScreenWidth, 50) andType:0];
    _keyBoardViews = keyBoardView;
    keyBoardView.delegate = self;
    [self.view addSubview:keyBoardView];
}

-(void)GXQKeyBoardToReplyTag:(int)tag andText:(NSString *)text
{
    [self.view endEditing:YES];
    [self commentRequest:text];
}


#pragma mark - ---- 私有方法 ----
- (void)commentRequest:(NSString *)content{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.artid forKey:@"article_id"];
    [params setObject:content forKey:@"content"];
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ArticleUserApi/articleComment" parameters:params method:LCRequestMethodPost];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
         JSSendCommentModel *model = [JSSendCommentModel objectWithKeyValues:request.responseJSONObject];
        if(model.status == 1) {
            _keyBoardViews.txtView.text = @"";
            [self loadData];
        }else{
             [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}


@end
