//
//  HomeViewController.m
//  IntelligentBra
//
//  Created by 寇凤伟 on 2019/3/8.
//  Copyright © 2019 rx. All rights reserved.
//

#import "HomeViewController.h"
#import <Masonry/Masonry.h>
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "HomeCell.h"
#import "ModeViewController.h"
#import "SwitchCollectionViewController.h"
#import "ZHPickerView.h"
#import "MusicListViewController.h"
#import "MemoryListViewController.h"
#import "IntroViewController.h"

@interface HomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *cycleView;
@property (nonatomic,retain) UICollectionView *collectionView;
@property(nonatomic,retain) NSMutableArray *funcDataAry;
@property(nonatomic,retain) NSMutableArray *funcImgDataAry;
@property(nonatomic,retain) NSMutableArray *scrollDataAry;
@end

@implementation HomeViewController
static NSString *const kBodyID = @"HomeCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"体验";
    [self.view addSubview:self.cycleView];
    [self.view addSubview:self.collectionView];
    [self.cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.right.left.equalTo(self.view);
        make.height.mas_equalTo(240);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.view);
        make.top.equalTo(self.cycleView.mas_bottom);
    }];
    
    
    self.funcDataAry = [[NSMutableArray alloc]initWithObjects:@"模式",@"定时",@"加热",@"力度",@"音乐按摩",@"光疗",@"关闭",@"说明",@"设置",nil];
    self.funcImgDataAry = [[NSMutableArray alloc]initWithObjects:@"moshi",@"dingshi",@"jiare",@"lidu",@"zidingyi",@"guangliao",@"close",@"sm_select",@"setting_select",nil];
    [self.collectionView reloadData];
    // Do any additional setup after loading the view.
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
    //组模型
    NSString *title = [self.funcDataAry objectAtIndex:indexPath.row];
    NSString *imageName = [self.funcImgDataAry objectAtIndex:indexPath.row];
    [cell.playBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [cell.playBtn setTitle:title forState:UIControlStateNormal];
    [cell layoutIfNeeded];
    
    return cell;
}


#pragma mark - UICollectionViewDelegate
//点击collectionView的item的时候调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:{
            ModeViewController *modeVC = [ModeViewController new];
            [self.navigationController pushViewController:modeVC animated:YES];
            break;
        }
        case 1:{
            NSMutableArray *secondArray = [NSMutableArray new];
            NSMutableArray *minuteArray = [NSMutableArray new];
            for (int i = 0; i<60; i++) {
                [secondArray addObject:[NSString stringWithFormat:@"%d",i]];
            }
            for (int i = 1; i<16; i++) {
                [minuteArray addObject:[NSString stringWithFormat:@"%d",i]];
            }
            [ZHStringPickerView showStringPickerWithTitle:@"请选择时间" dataSource:@[minuteArray,@[@"分钟"],secondArray,@[@"秒"]] defaultSelValue:@[@"1",@"分钟",@"0",@"秒"] isAutoSelect:NO resultBlock:^(id selectValue) {
                int second = [selectValue[0] intValue]*60+[selectValue[2] intValue];
//                Byte B=(Byte)0XFF&second;
//                Byte bytes[] = {B};
//                NSData *addData = [NSData dataWithBytes:bytes length:sizeof(bytes)];
                [[BluetoothManager shareBluetoothManager] sendTimeOrderWithOrder:0xA3 WithInt:second];
            }];

            break;
        }
        case 2:{
            SwitchCollectionViewController *switchVC = [SwitchCollectionViewController new];
            switchVC.flag = 1;
            [self.navigationController pushViewController:switchVC animated:YES];
            break;
        }
        case 3:{
            SwitchCollectionViewController *switchVC = [SwitchCollectionViewController new];
            switchVC.flag = 2;
            [self.navigationController pushViewController:switchVC animated:YES];
            break;
        }
        case 4:{
//            ModeViewController *modeVC = [ModeViewController new];
            MusicListViewController *musicVC = [MusicListViewController new];
            [self.navigationController pushViewController:musicVC animated:YES];
            break;
        }
        case 5:{
            SwitchCollectionViewController *switchVC = [SwitchCollectionViewController new];
            switchVC.flag = 3;
            [self.navigationController pushViewController:switchVC animated:YES];
            break;
        }
        case 6:{
            [[DataManager shareDataManager] deleteCurrentMode:@""];
            [[DataManager shareDataManager] stopPlaying];
            [BluetoothManager shareBluetoothManager].timeout = 0;
            [[BluetoothManager shareBluetoothManager].modeAry removeAllObjects];
            [[BluetoothManager shareBluetoothManager] sendOrderWithOrder:0xA1 WithDataStr:@"00"];
            break;
        }
        case 7:{
            IntroViewController *introVC = [IntroViewController new];
            [self.navigationController pushViewController:introVC animated:YES];
            break;
        }
        case 8:{
            
            MemoryListViewController *mvc = [MemoryListViewController new];
            [self.navigationController pushViewController:mvc animated:YES];
            break;
        }
        default:
            break;
    }
}


-(NSString *)HexStringWithData:(NSData *)data{
    Byte *bytes = (Byte *)[data bytes];
    NSString *hexStr=@"";
    for(int i=0;i<[data length];i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1){
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        }
        else{
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
        }
    }
    hexStr = [hexStr uppercaseString];
    return hexStr;
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    
//    [self.navigationController pushViewController:[NSClassFromString(@"DemoVCWithXib") new] animated:YES];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        //布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        CGFloat margin = 0;
        layout.itemSize = CGSizeMake(ScreenW/3, ScreenW/3);
        layout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        //设置头部视图的尺寸
        //        layout.headerReferenceSize = CGSizeMake(ScreenW, ScreenH * 0.085);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[HomeCell class] forCellWithReuseIdentifier:kBodyID];
    }
    return _collectionView;
}

- (SDCycleScrollView*)cycleView
{
    if (!_cycleView) {
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenW, 180) shouldInfiniteLoop:YES imageNamesGroup:@[[UIImage imageNamed:@"bk"]]];
        _cycleView.delegate = self;
        _cycleView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _cycleView.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _cycleView;
}
@end
