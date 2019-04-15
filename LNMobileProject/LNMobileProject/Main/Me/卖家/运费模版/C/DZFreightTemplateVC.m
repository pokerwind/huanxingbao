//
//  DZFreightTemplateVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/26.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZFreightTemplateVC.h"
#import "DZFreightAddressVC.h"

#import "DZFreightTemplateHeader.h"
#import "DZFreightTemplateCell.h"

#import "DZGetExpressTemplateModel.h"
#import "DZGetRegionListModel.h"

@interface DZFreightTemplateVC ()<UITableViewDelegate, UITableViewDataSource, DZFreightAddressVCDelegate>

@property (strong, nonatomic) UIBarButtonItem *rightItem;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) DZFreightTemplateHeader *header;

@property (strong, nonatomic) NSMutableArray *templateArray;

@end

@implementation DZFreightTemplateVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑运费模板";
    self.navigationItem.rightBarButtonItem = self.rightItem;
    
    [self.view addSubview:self.tableView];
    
    [self setSubviewsLayout];
    
    [self getData];
}

- (void)viewDidLayoutSubviews{
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 167);
}

#pragma mark - ---- 布局代码 ----
- (void)setSubviewsLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark - ---- Action Events 和 response手势 ----
- (void)rightItemAction{
    [self save:YES];
}

- (void)addButtonAction{
    DZExpressTemplateModel *model = [DZExpressTemplateModel new];
    [self.templateArray insertObject:model atIndex:0];
    [self.tableView reloadData];
}

- (void)deleteButtonAction:(UIButton *)btn{
    [self.templateArray removeObjectAtIndex:btn.tag];
    [self.tableView reloadData];
    
    [self save:NO];
}

- (void)areaButtonAction:(UIButton *)btn{
    DZFreightAddressVC *vc = [DZFreightAddressVC new];
    vc.index = btn.tag;
    vc.delegate = self;
    
    NSMutableArray *regionNameArray = [NSMutableArray array];
    for (DZExpressTemplateModel *model in self.templateArray) {
        if (model.region_name.length) {
            [regionNameArray addObjectsFromArray:[model.region_name componentsSeparatedByString:@","]];
        }
    }
    vc.selectedArray = regionNameArray;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ---- 代理相关 ----
- (void)textFieldTextChanged:(UITextField *)tf{
    if (tf.tag >= 0) {//首重
        DZExpressTemplateModel *model = self.templateArray[tf.tag];
        model.first_money = tf.text;
        NSLog(@"model.first_money: %@", model.first_money);
    }else{//续重
        DZExpressTemplateModel *model = self.templateArray[- tf.tag - 1];
        model.add_money = tf.text;
    }
}

#pragma mark - ---- DZFreightAddressVCDelegate ----
- (void)didSelectedArea:(NSArray *)area atIndex:(NSInteger)index{
    if (!area.count) {
        return;
    }
    NSMutableArray *array = [NSMutableArray array];
    for (DZRegionModel *model in area) {
        [array addObject:model.region_name];
    }
    NSString *resultStr = [array componentsJoinedByString:@","];
    DZExpressTemplateModel *model = self.templateArray[index];
    model.express_template_name = resultStr;
    model.regionArray = area;
    
    [self.tableView reloadData];
}

#pragma mark - ---- UITableViewDataSource ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.templateArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 131;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DZFreightTemplateCell *cell = [tableView dequeueReusableCellWithIdentifier:[DZFreightTemplateCell cellIdentifier]];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DZFreightTemplateCell" owner:self options:nil] firstObject];
    }
    cell.deleteButton.tag = indexPath.row;
    [cell.deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.areaButton.tag = indexPath.row;
    [cell.areaButton addTarget:self action:@selector(areaButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    DZExpressTemplateModel *model = self.templateArray[indexPath.row];
    if (model.express_template_name) {
        [cell.areaButton setTitle:model.express_template_name forState:UIControlStateNormal];
    }else{
        [cell.areaButton setTitle:@"选择地区" forState:UIControlStateNormal];
    }
    cell.firstPriceTextField.text = model.first_money;
    cell.addPriceTextField.text = model.add_money;
    cell.firstPriceTextField.tag = indexPath.row;
    cell.addPriceTextField.tag = -(indexPath.row + 1);
    [cell.firstPriceTextField addTarget:self action:@selector(textFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
    [cell.addPriceTextField addTarget:self action:@selector(textFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
    
    return cell;
}

#pragma mark - ---- 私有方法 ----
- (void)getData{
    NSDictionary *params = nil;
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/getExpressTemplateByPage" parameters:params];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZGetExpressTemplateModel *model = [DZGetExpressTemplateModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            self.templateArray = [NSMutableArray arrayWithArray:model.data];
            for (DZExpressTemplateModel *model in self.templateArray) {
                if ([model.is_default integerValue] == 1) {
                    [self.templateArray removeObject:model];
                    break;
                }
            }
            for (DZExpressTemplateModel *models in model.data) {
                if ([models.is_default integerValue] == 1) {
                    self.header.initialPriceTextField.text = models.first_money;
                    self.header.additionPriceTextField.text = models.add_money;
                }
            }
            
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)save:(BOOL)needBack{
    if (!self.header.initialPriceTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入默认首重金额"];
        return;
    }
    if (!self.header.additionPriceTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入默认续重金额"];
        return;
    }
    
    if (needBack) {
        for (DZExpressTemplateModel *model in self.templateArray) {
            if (!model.first_money.length || !model.add_money.length || ((!model.regionArray || !model.regionArray.count) && (!model.region_id || !model.region_name))) {
                [SVProgressHUD showErrorWithStatus:@"请继续完善运费模板信息"];
                return;
            }
        }
        
        NSMutableArray *firstArray = [NSMutableArray array];
        for (DZExpressTemplateModel *model in self.templateArray) {
            [firstArray addObject:model.first_money];
        }
        NSString *firstMoney = [firstArray componentsJoinedByString:@"|"];
        
        NSMutableArray *addArray = [NSMutableArray array];
        for (DZExpressTemplateModel *model in self.templateArray) {
            [addArray addObject:model.add_money];
        }
        NSString *addMoney = [addArray componentsJoinedByString:@"|"];
        
        NSMutableArray *nameArray = [NSMutableArray array];
        for (DZExpressTemplateModel *model in self.templateArray) {
            [nameArray addObject:model.express_template_name];
        }
        NSString *nameString = [nameArray componentsJoinedByString:@"|"];
        
        NSMutableArray *regionIdArray = [NSMutableArray array];
        for (DZExpressTemplateModel *model in self.templateArray) {
            [regionIdArray addObject:model.region_id];
        }
        NSString *regionIdString = [regionIdArray componentsJoinedByString:@"|"];
        
        NSMutableArray *regionNameArray = [NSMutableArray array];
        for (DZExpressTemplateModel *model in self.templateArray) {
            [regionNameArray addObject:model.region_name];
        }
        NSString *regionNameString = [regionNameArray componentsJoinedByString:@"|"];
        
        NSDictionary *params = @{@"default_first_money":self.header.initialPriceTextField.text, @"default_add_money":self.header.additionPriceTextField.text, @"first_money":firstMoney?firstMoney:@"", @"add_money":addMoney?addMoney:@"", @"express_template_name":nameString, @"region_id":regionIdString, @"area_name":regionNameString};
        LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/setExpressTemplate" parameters:params];
        [SVProgressHUD show];
        [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            [SVProgressHUD dismiss];
            LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
            if (model.isSuccess) {
                [[NSNotificationCenter defaultCenter] postNotificationName:SELLERMEVCREFRESHNOTIFICATION object:nil];
                [SVProgressHUD showSuccessWithStatus:@"保存成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:model.info];
            }
        } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }];
    }else{
        NSMutableArray *firstArray = [NSMutableArray array];
        NSMutableArray *addArray = [NSMutableArray array];
        NSMutableArray *nameArray = [NSMutableArray array];
        NSMutableArray *regionIdArray = [NSMutableArray array];
        NSMutableArray *regionNameArray = [NSMutableArray array];
        for (DZExpressTemplateModel *model in self.templateArray) {
            if (model.first_money.length && model.add_money.length && model.regionArray && model.regionArray.count && model.region_id && model.region_name) {
                [firstArray addObject:model.first_money];
                [addArray addObject:model.add_money];
                [nameArray addObject:model.express_template_name];
                [regionIdArray addObject:model.region_id];
                [regionNameArray addObject:model.region_name];
            }
        }
        
        NSString *firstMoney = [firstArray componentsJoinedByString:@"|"];
        NSString *addMoney = [addArray componentsJoinedByString:@"|"];
        NSString *nameString = [nameArray componentsJoinedByString:@"|"];
        NSString *regionIdString = [regionIdArray componentsJoinedByString:@"|"];
        NSString *regionNameString = [regionNameArray componentsJoinedByString:@"|"];
        
        NSDictionary *params = @{@"default_first_money":self.header.initialPriceTextField.text, @"default_add_money":self.header.additionPriceTextField.text, @"first_money":firstMoney?firstMoney:@"", @"add_money":addMoney?addMoney:@"", @"express_template_name":nameString, @"region_id":regionIdString, @"area_name":regionNameString};
        LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/setExpressTemplate" parameters:params];
        [SVProgressHUD show];
        [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            [SVProgressHUD dismiss];
            LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
            if (model.isSuccess) {
                [[NSNotificationCenter defaultCenter] postNotificationName:SELLERMEVCREFRESHNOTIFICATION object:nil];
            }else{
                [SVProgressHUD showErrorWithStatus:model.info];
            }
        } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }];
    }
}

#pragma mark - --- getters 和 setters ----
- (UIBarButtonItem *)rightItem{
    if (!_rightItem) {
        _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
        _rightItem.tintColor = HEXCOLOR(0xff7722);
        [_rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
        [_rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateSelected];
    }
    return _rightItem;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.allowsSelection = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.header;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
    }
    return _tableView;
}

- (DZFreightTemplateHeader *)header{
    if (!_header) {
        _header = [DZFreightTemplateHeader viewFormNib];
        [_header.addButton addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _header;
}

- (NSMutableArray *)templateArray{
    if (!_templateArray) {
        _templateArray = [NSMutableArray array];
    }
    return _templateArray;
}

@end
