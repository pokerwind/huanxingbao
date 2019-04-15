//
//  DZProblemOrderHistoryVC.m（文件名称）
//  LNMobileProject（工程名称）
//
//  Created by  六牛科技 on 2017/9/27.（创建用户及时间）
//
//  山东六牛网络科技有限公司 https://liuniukeji.com
//

#import "DZProblemOrderHistoryVC.h"

#import "DZProblemHistoryInitialCell.h"
#import "DZProblemHistoryNormalCell.h"

#import "DZGetTalkRecordModel.h"

@interface DZProblemOrderHistoryVC ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation DZProblemOrderHistoryVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"退款协商记录";
    
    [self.view addSubview:self.tableView];
    
    // 写在 ViewDidLoad 的最后一行
    [self setSubViewsLayout];
    
    [self getData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - ---- 代理相关 ----
#pragma mark UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 0) {
//        return 156;
//    }else{
//        return 94;
//    }
//}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
        if (indexPath.row == 0) {
            return 156;
        }else{
            return 94;
        }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    DZTalkRecordModel *model = self.dataArray[indexPath.row];
    if ([model.type isEqualToString:@"1"]) {
        DZProblemHistoryInitialCell *cell = [DZProblemHistoryInitialCell viewFormNib];
        [cell fillData:model];
        return cell;
    }else{
        DZProblemHistoryNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [DZProblemHistoryNormalCell viewFormNib];
        }
        [cell fillData:model];
        return cell;
    }
}

#pragma mark - ---- 用户交互事件 ----

#pragma mark - ---- 私有方法 ----
- (void)getData{
    NSDictionary *params = @{@"order_sn":self.order_sn};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/getTalkRecord" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZGetTalkRecordModel *model = [DZGetTalkRecordModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            self.dataArray = model.data;
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

#pragma mark - ---- 公共方法 ----

#pragma mark - ---- 布局代码 ----
- (void) setSubViewsLayout{
    //    Maronsy
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark - --- getters 和 setters ----
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

@end
