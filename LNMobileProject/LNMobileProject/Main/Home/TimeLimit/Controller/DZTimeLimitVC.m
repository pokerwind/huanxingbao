//
//  DZTimeLimitVC.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/8/1.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZTimeLimitVC.h"
#import "HMSegmentedControl.h"
#import "DZTimeLimitView.h"
#import "DZTimeLimitDetailModel.h"
#import "DZTimeLimitCell.h"
#import "DZGoodsDetailVC.h"

#define kTimeLimitCell @"DZTimeLimitCell"

@interface DZTimeLimitVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIScrollView *scrollView;
//@property (strong, nonatomic) HMSegmentedControl *segmentedControl;
@property (strong, nonatomic) DZTimeLimitView *timeLimitView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat oldHeight;

@property (nonatomic, strong) DZTimeLimitDetailInfoModel *infoModel;
@property (nonatomic, strong) DZTimeLimitDetailModel *detailModel;

@property (nonatomic ,strong) RACSubject *buySubject;
@property (nonatomic ,assign) NSTimeInterval timeLeft;

@end

@implementation DZTimeLimitVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"限时特惠";
    [self initNavigationBar];
    
    [self.view addSubview:self.scrollView];
//    [self.scrollView addSubview:self.segmentedControl];
    [self.scrollView addSubview:self.timeLimitView];
    [self.scrollView addSubview:self.tableView];
    
    [RACObserve(self.tableView, contentSize) subscribeNext:^(NSValue *size) {
        CGFloat height = size.CGSizeValue.height;
        if(height == self.oldHeight) {
            return;
        }
        
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
        self.oldHeight = height;
    }];
    
    self.buySubject = [RACSubject subject];
    
    @weakify(self);
    [self.buySubject subscribeNext:^(NSString *goodsId) {
        @strongify(self);
        DZGoodsDetailVC *vc = [[DZGoodsDetailVC alloc] init];
        vc.act_type = self.detailModel.info.act_type;
        vc.act_id = self.detailModel.info.act_id;
        vc.goodsId = goodsId;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [self loadData];
    

    
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

    UIButton *rightButton = [[UIButton alloc] init];
    [rightButton setImage:[UIImage imageNamed:@"nav_icon_share"] forState:UIControlStateNormal];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = right;
    
    [[rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"share");
    }];
}

#pragma mark - ---- 代理相关 ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.detailModel) {
        return self.detailModel.list.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DZTimeLimitCell *cell = [tableView dequeueReusableCellWithIdentifier:kTimeLimitCell];
    DZTimeLimitDetailGoodsModel *model = self.detailModel.list[indexPath.row];
    [cell configView:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 129;
}
#pragma mark - ---- Action Events 和 response手势 ----
- (void)shareAction:(id)sender {
    
}

#pragma mark - ---- 私有方法 ----
- (void)loadData {
    //
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/GoodsApi/getActivitylist"];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZTimeLimitDetailNetModel *model = [DZTimeLimitDetailNetModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            model.data = [DZTimeLimitDetailModel objectWithKeyValues:model.data];
            model.data.info = [DZTimeLimitDetailInfoModel objectWithKeyValues:model.data.info];
            
            for (DZTimeLimitDetailGoodsModel *goods in model.data.list) {
                goods.buySubject = self.buySubject;
            }
            if (!model.data.list || model.data.list.count == 0) {
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(0);
                }];
            }
            
            self.detailModel = model.data;
            [self.tableView reloadData];
            [self setTimeLimit:model.data.info];
        } else {
            [SVProgressHUD showInfoWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:error.domain];
    }];
    
}

- (void)setTimeLimit:(DZTimeLimitDetailInfoModel *)model {
    
    //根据起始时间，现在时间，结束时间，判断剩余时间，并进行倒计时。
    if(model.start_time >0 && model.end_time >0) {
        if(model.start_time < model.now && model.now < model.end_time) {
            //进行中
            NSTimeInterval timeLeft = model.end_time - model.now;
            self.timeLeft = timeLeft;
            [self setupTimeLeft:timeLeft];
            @weakify(self);
            [[[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] takeUntil:self.rac_willDeallocSignal ] subscribeNext:^(id x) {
                @strongify(self);
                self.timeLeft--;
                [self setupTimeLeft:self.timeLeft];
            }];
        }
    }
    
}

- (void)setupTimeLeft:(NSTimeInterval)timeLeft {
    if(timeLeft <=0 ){
        return;
    }
    
    NSInteger hour = ((int)timeLeft/3600)%100;
    NSInteger min = ((int)timeLeft%3600)/60;
    NSInteger sec = ((int)timeLeft%60);
    
    self.timeLimitView.hourLabel.text = [NSString stringWithFormat:@"%02ld",(long)hour];
    self.timeLimitView.minLabel.text = [NSString stringWithFormat:@"%02ld",(long)min];
    self.timeLimitView.secLabel.text = [NSString stringWithFormat:@"%02ld",(long)sec];
}

#pragma mark - ---- 布局代码 ----
- (void) setSubViewsFrame{

}

- (void) setSubViewsLayout{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_offset(0);
    }];
    
//    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.mas_offset(0);
//        make.height.mas_equalTo(40);
//        
//
//    }];
    
    [self.timeLimitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(40);
        make.width.equalTo(self.scrollView.mas_width);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLimitView.mas_bottom);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(100);
        make.bottom.mas_offset(0);
    }];
    
}

#pragma mark - --- getters 和 setters ----

- (UIScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

//- (HMSegmentedControl *)segmentedControl{
//    if (!_segmentedControl) {
//        _segmentedControl=[[HMSegmentedControl alloc] initWithSectionTitles:@[@"今日抢批",@"明天预告"]];
//        
//        _segmentedControl.backgroundColor = [UIColor whiteColor];
//        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
//        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
//        _segmentedControl.selectionIndicatorColor=OrangeColor;
//        _segmentedControl.selectionIndicatorHeight=1;
//        _segmentedControl.borderWidth=1;
//        _segmentedControl.borderColor=[UIColor colorWithRed:0.965f green:0.965f blue:0.965f alpha:1.00f];
//        
//        NSDictionary *selectdefaults = @{
//                                         NSFontAttributeName : [UIFont systemFontOfSize:13.0f],
//                                         NSForegroundColorAttributeName : OrangeColor,
//                                         };
//        NSMutableDictionary *selectresultingAttrs = [NSMutableDictionary dictionaryWithDictionary:selectdefaults];
//        
//        NSDictionary *defaults = @{
//                                   NSFontAttributeName : [UIFont systemFontOfSize:13.0f],
//                                   NSForegroundColorAttributeName : TextBlackColor,
//                                   };
//        NSMutableDictionary *resultingAttrs = [NSMutableDictionary dictionaryWithDictionary:defaults];
//        _segmentedControl.selectedTitleTextAttributes=selectresultingAttrs;
//        _segmentedControl.titleTextAttributes=resultingAttrs;
//        //_segmentedControl.selectedSegmentIndex=0;
//        _segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
//        @weakify(self);
//        _segmentedControl.indexChangeBlock = ^(NSInteger index) {
//            @strongify(self);
//            //[self loadDiscovery:index];
//        };
//    }
//    return _segmentedControl;
//}

- (DZTimeLimitView *)timeLimitView {
    if(!_timeLimitView) {
        _timeLimitView = [DZTimeLimitView viewFormNib];
    }
    return _timeLimitView;
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        [_tableView registerNib:[UINib nibWithNibName:kTimeLimitCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kTimeLimitCell];
    }
    return _tableView;
}

@end
