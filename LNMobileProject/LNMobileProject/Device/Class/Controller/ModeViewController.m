//
//  ModeViewController.m
//  IntelligentBra
//
//  Created by 寇凤伟 on 2019/3/10.
//  Copyright © 2019 rx. All rights reserved.
//

#import "ModeViewController.h"
#import <Masonry/Masonry.h>
#import "HomeCell.h"
#import "ModelTableViewCell.h"
#import "CustomLabel.h"

@interface ModeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain) UICollectionView *collectionView;
@property (nonatomic,retain) CustomLabel *desc;
@property (nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) NSArray *funcDataAry;
@property(nonatomic,retain) NSMutableArray *ModeDataAry;
@end

@implementation ModeViewController
static NSString *const kBodyID = @"HomeCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.title = @"模式";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F5"]];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.desc];
    [self.view addSubview:self.tableView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).with.offset(IsiPhoneX?88:64);
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(ScreenW/5);
    }];
    [self.desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(30);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.desc.mas_bottom).with.offset(1);
        make.left.right.bottom.equalTo(self.view);
        
    }];
    
    [self requestDataWithIndex:0];
    
}

- (void)requestDataWithIndex:(NSUInteger)index {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    self.funcDataAry = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSDictionary *dic = [self.funcDataAry objectAtIndex:index];
    
    [self.desc setText:[NSString stringWithFormat:@"%@",dic[@"desc"]]];
    CGSize textSize = [self.desc.text boundingRectWithSize:self.desc.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.desc.font} context:nil].size;
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    [self.desc mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(frameSize.height+16);
    }];
    self.ModeDataAry = dic[@"datas"];
    
    [self.collectionView reloadData];
    [self.tableView reloadData];
}

#pragma mark - UICollectionViewDataSource
/** 返回有多少组  */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

/** 返回每组有多少个item  */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.funcDataAry.count;
    
}
/** 返回每个item的具体内容  */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBodyID forIndexPath:indexPath];
    cell.tag = indexPath.row;
    cell.needBorder = NO;
    //组模型
    NSDictionary *infoDic = [self.funcDataAry objectAtIndex:indexPath.row];
    [cell.playBtn setImage:[UIImage imageNamed:infoDic[@"image"]] forState:UIControlStateNormal];
    [cell.playBtn setTitle:infoDic[@"title"] forState:UIControlStateNormal];
    [cell.playBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [cell layoutIfNeeded];
    
    return cell;
}


#pragma mark - UICollectionViewDelegate
//点击collectionView的item的时候调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self requestDataWithIndex:indexPath.row];
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.ModeDataAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *aCellIdentifier = @"ModelTableViewCell";
    ModelTableViewCell *cell = (ModelTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:aCellIdentifier];
    if (cell==nil) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"ModelTableViewCell" owner:self options:nil];
        cell = [arr objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *infoDic = [self.ModeDataAry objectAtIndex:indexPath.row];
    [cell.titleBtn setImage:[UIImage imageNamed:infoDic[@"image"]] forState:UIControlStateNormal];
    if ([[[DataManager shareDataManager] getCurrentMode] isEqualToString:infoDic[@"id"]]) {
        [cell.switchControl setOn:YES];
    }
    else
    {
        [cell.switchControl setOn:NO];
    }
    [cell.titleBtn setTitle:infoDic[@"title"] forState:UIControlStateNormal];
    [cell setButtonImageAndTitleWithSpace:5 WithButton:cell.titleBtn];
    cell.switchBlock = ^(UISwitch * _Nonnull sender) {
        if (sender.on) {
            switch ([infoDic[@"id"] integerValue]) {
                case 00:{
                    [BluetoothManager shareBluetoothManager].timeout = 300;
                    [BluetoothManager shareBluetoothManager].modeAry= [NSMutableArray arrayWithArray:@[@"A1-07",@"A1-06",@"A1-04"]];
                    [[BluetoothManager shareBluetoothManager] countDown];
                    [[DataManager shareDataManager] saveCurrentMode:infoDic[@"id"]];
                    break;
                }
                case 10:{
                    [BluetoothManager shareBluetoothManager].timeout = 300;
                    [BluetoothManager shareBluetoothManager].modeAry= [NSMutableArray arrayWithArray:@[@"A1-02",@"A1-03",@"A1-07",@"A2-02"]];
                    [[BluetoothManager shareBluetoothManager] countDown];
                    [[DataManager shareDataManager] saveCurrentMode:infoDic[@"id"]];
                    break;
                }
                case 20:{
                    [BluetoothManager shareBluetoothManager].timeout = 300;
                    [BluetoothManager shareBluetoothManager].modeAry= [NSMutableArray arrayWithArray:@[@"A1-02",@"A1-03",@"A1-07",@"A5-01"]];
                    [[BluetoothManager shareBluetoothManager] countDown];
                    [[DataManager shareDataManager] saveCurrentMode:infoDic[@"id"]];
                    break;
                }
                case 30:{
                    [BluetoothManager shareBluetoothManager].timeout = 300;
                    [BluetoothManager shareBluetoothManager].modeAry= [NSMutableArray arrayWithArray:@[@"A1-01",@"A1-02",@"A1-05",@"A1-08"]];
                    [[BluetoothManager shareBluetoothManager] countDown];
                    [[DataManager shareDataManager] saveCurrentMode:infoDic[@"id"]];
                    break;
                }
                case 40:{
                    [BluetoothManager shareBluetoothManager].timeout = 300;
                    [BluetoothManager shareBluetoothManager].modeAry= [NSMutableArray arrayWithArray:@[@"A1-05",@"A2-02",@"A1-08"]];
                    [[BluetoothManager shareBluetoothManager] countDown];
                    [[DataManager shareDataManager] saveCurrentMode:infoDic[@"id"]];
                    break;
                }
                default:{
                    [BluetoothManager shareBluetoothManager].timeout = 0;
                    [[BluetoothManager shareBluetoothManager].modeAry removeAllObjects];
                    [[DataManager shareDataManager] stopPlaying];
                    [[BluetoothManager shareBluetoothManager] sendOrderWithOrder:0xA1 WithDataStr:infoDic[@"cmd"]];
                    [[DataManager shareDataManager] saveCurrentMode:infoDic[@"id"]];
                    break;
                }
            }
        }
        else
        {
            
            [BluetoothManager shareBluetoothManager].timeout = 0;
            [[BluetoothManager shareBluetoothManager].modeAry removeAllObjects];
            [[BluetoothManager shareBluetoothManager] sendOrderWithOrder:0xA1 WithDataStr:@"00"];
            [[DataManager shareDataManager] deleteCurrentMode:infoDic[@"id"]];
        }
        
        [self.tableView reloadData];
        
    };
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        //布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        CGFloat margin = 0;
        layout.itemSize = CGSizeMake(ScreenW/5, ScreenW/5);
        layout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        //设置头部视图的尺寸
        //        layout.headerReferenceSize = CGSizeMake(ScreenW, ScreenH * 0.085);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView setAllowsMultipleSelection:NO];
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[HomeCell class] forCellWithReuseIdentifier:kBodyID];
    }
    return _collectionView;
}

-(CustomLabel*)desc
{
    if (!_desc) {
        _desc = [CustomLabel new];
        [_desc setFont:[UIFont systemFontOfSize:13]];
        [_desc setBackgroundColor:[UIColor whiteColor]];
        [_desc setTextColor:[UIColor lightGrayColor]];
        [_desc setNumberOfLines:0];
        [_desc setLineBreakMode:NSLineBreakByWordWrapping];
        [_desc setTextInsets:UIEdgeInsetsMake(0, 14, 0, 14)];
    }
    return _desc;
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
