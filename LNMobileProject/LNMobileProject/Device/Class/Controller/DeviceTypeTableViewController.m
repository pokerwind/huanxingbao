//
//  DeviceTypeTableViewController.m
//  LNMobileProject
//
//  Created by 寇凤伟 on 2019/3/20.
//  Copyright © 2019 Liuniu. All rights reserved.
//

#import "DeviceTypeTableViewController.h"
#import "DeviceListViewController.h"

@interface DeviceTypeTableViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *deviceTypeAry;
}
@property (nonatomic,retain) UITableView *tableView;
@end

@implementation DeviceTypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设备";
    deviceTypeAry = @[@"欢星咪宝"];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return deviceTypeAry.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"mycell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell.textLabel setText:deviceTypeAry[indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeviceListViewController *dvc = [DeviceListViewController new];
    [self.navigationController pushViewController:dvc animated:YES];
}


-(UITableView*)tableView
{
    if (!_tableView) {
        //布局
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

@end
