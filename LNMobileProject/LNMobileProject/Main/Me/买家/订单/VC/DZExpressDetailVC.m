//
//  DZExpressDetailVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/21.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZExpressDetailVC.h"

#import "DZExpressDetailCell.h"

#import "DZGetExpressTracesModel.h"

@interface DZExpressDetailVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *infoArray;

@end

@implementation DZExpressDetailVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"物流详情";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    if (self.imgUrl) {
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DEFAULT_HTTP_IMG, self.imgUrl]]];
    }
    
    [self getData];
}

#pragma mark - ---- 布局代码 ----

#pragma mark - ---- Action Events 和 response手势 ----

#pragma mark - ---- 代理相关 ----
#pragma mark - ---- UITableViewDataSource ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.infoArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 61;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"DZExpressDetailCell";
    DZExpressDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [DZExpressDetailCell viewFormNib];
    }
    DZTracesModel *model = self.infoArray[indexPath.row];
    if (indexPath.row == 0) {
        [cell fillData:model type:1];
    }else if (indexPath.row == self.infoArray.count - 1){
        [cell fillData:model type:-1];
    }else{
        [cell fillData:model type:0];
    }
    
    return cell;
}

#pragma mark - ---- 私有方法 ----
- (void)getData{
    NSDictionary *params = @{@"order_sn":self.order_sn};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/getExpressTraces" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZGetExpressTracesModel *model = [DZGetExpressTracesModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            switch ([model.data.State integerValue]) {
                case 1:
                    self.stateLabel.text = @"物流状态  待揽件";
                    break;
                case 2:
                    self.stateLabel.text = @"物流状态  正在配送";
                    break;
                case 3:
                    self.stateLabel.text = @"物流状态  已签收";
                    break;
                case 4:
                    self.stateLabel.text = @"物流状态  问题件";
                    break;
                default:
                    break;
            }
            self.countLabel.text = [NSString stringWithFormat:@"共%@件商品", model.data.goods_counts];
            self.companyLabel.text = [NSString stringWithFormat:@"承运公司：%@", model.data.express_name];
            self.numberLabel.text = [NSString stringWithFormat:@"运单编号：%@", model.data.express_code];
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESHMYORDERNOTIFICATION object:nil];
            NSMutableArray *array = [NSMutableArray arrayWithArray:model.data.Traces];
            self.infoArray = [[array reverseObjectEnumerator] allObjects];
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无物流信息";
    
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

#pragma mark - --- getters 和 setters ----
- (NSArray *)infoArray{
    if (!_infoArray) {
        _infoArray = [NSArray array];
    }
    return _infoArray;
}

@end
