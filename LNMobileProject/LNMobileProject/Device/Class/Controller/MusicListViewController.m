//
//  MusicListViewController.m
//  IntelligentBra
//
//  Created by 寇凤伟 on 2019/3/12.
//  Copyright © 2019 rx. All rights reserved.
//

#import "MusicListViewController.h"
//#import <DFPlayer/DFPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "GetAudioFileInfo.h"
#import "HttpUtils.h"
#import <MJRefresh/MJRefresh.h>

@interface MusicListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) NSArray *musicArray;

@end

@implementation MusicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.title = @"音乐按摩";
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
        
        //        make.top.equalTo(self.view).with.offset(IsiPhoneX?88:64);
    }];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"music" ofType:@"json"];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    self.musicArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataWithFilters];
    }];
    [self.tableView.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}

-(void)loadDataWithFilters
{
    [SVProgressHUD show];
    [HttpUtils getWithURL:[NSString stringWithFormat:@"%@HardWare/Bar/getMusicList",DEFAULT_HTTP_HOST] params:nil success:^(id json) {
        [SVProgressHUD dismiss];
        if ([json[@"status"] isEqualToNumber:[NSNumber numberWithInteger:1]]) {
            self.musicArray = json[@"data"];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.musicArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"mycell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    NSDictionary *dic = [self.musicArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:dic[@"name"]];
    
    if (indexPath == [DataManager shareDataManager].selectPath) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [BluetoothManager shareBluetoothManager].timeout = 0;
    [[BluetoothManager shareBluetoothManager].modeAry removeAllObjects];
    if (indexPath == [DataManager shareDataManager].selectPath) {
        [[DataManager shareDataManager] stopPlaying];
        UITableViewCell *cells = [tableView cellForRowAtIndexPath:[DataManager shareDataManager].selectPath];
        cells.accessoryType = UITableViewCellAccessoryNone;
        [DataManager shareDataManager].selectPath = nil;
    }
    else
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[DataManager shareDataManager].selectPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        [DataManager shareDataManager].selectPath = indexPath;
        UITableViewCell *cells = [tableView cellForRowAtIndexPath:[DataManager shareDataManager].selectPath];
        cells.accessoryType = UITableViewCellAccessoryCheckmark;
        [[BluetoothManager shareBluetoothManager] sendOrderWithOrder:0xA1 WithDataStr:@"0B"];
        NSDictionary *dic = [self.musicArray objectAtIndex:indexPath.row];
        [[DataManager shareDataManager] playTheMusicWithUrl:dic[@"link"]];
    }
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

//-(AVPlayer*)player
//{
//    if (_player) {
//        player = [[AVPlayer alloc]initWithPlayerItem:item];
//    }
//}

@end
