//
//  TableViewController.m
//  LNFrameWork
//
//  Created by LiuYanQi on 2017/7/9.
//  Copyright © 2017年 LiuYanQi. All rights reserved.
//

#import "TableViewController.h"
#import "NewListDataController.h"
//
@interface TableViewController ()
@property (strong, nonatomic) NewListDataController *listViewModel;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self lnSetupData];
    [self lnSetupUI];
    [self lnLoadData];
}

- (void)lnSetupData{
    self.listViewModel = [[NewListDataController alloc] init];
    self.listViewModel.viewController = self;
    self.dataController = self.listViewModel;
    
}

- (void)lnSetupUI{
    
//    self.isNeedPullUpToRefreshAction = NO;
    self.isNeedTableBlankView = YES;    // 是否拥有空视图 这地方
    // layout 给父类的控件 重新布局 记得用 remake
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-240);
    }];
}

- (void)lnLoadData{
    // API
    [self.dataController loadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.userInteractionEnabled = NO;
    [self.listViewModel click:tableView didSelected:indexPath callback:^(id obj, NSError *error) {
        tableView.userInteractionEnabled = YES;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Title" message:@"message" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataController.tableArray[indexPath.row];
    return cell;
}

@end
