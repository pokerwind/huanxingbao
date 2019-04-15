//
//  DZAddCartVC.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/5.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZAddCartVC.h"
#import "DZSpecChooseCell.h"
#import "DZAddAlertView.h"
#import "DZGoodsSpecModel.h"

#define kSpecChooseCell @"DZSpecChooseCell"

@interface DZAddCartVC ()<UITableViewDelegate,UITableViewDataSource, DZSpecChooseCellDelegate>
@property (weak, nonatomic) IBOutlet UILabel *getGoodsLabel;
@property (weak, nonatomic) IBOutlet UILabel *packLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;

@property (weak, nonatomic) IBOutlet UILabel *getNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *packNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *getPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *packPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic,strong) RACSubject *changeSubject;

@end

@implementation DZAddCartVC


#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择规格和数量";
    
    self.goodsImageView.layer.masksToBounds = YES;
    
    self.getGoodsLabel.layer.masksToBounds = YES;
    self.getGoodsLabel.layer.cornerRadius = 2;
    self.getGoodsLabel.layer.borderColor = OrangeColor.CGColor;
    self.getGoodsLabel.layer.borderWidth = 1;
    
    self.packLabel.layer.masksToBounds = YES;
    self.packLabel.layer.cornerRadius = 2;
    self.packLabel.layer.borderColor = OrangeColor.CGColor;
    self.packLabel.layer.borderWidth = 1;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsSelection = NO;
    [self.tableView registerNib:[UINib nibWithNibName:kSpecChooseCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kSpecChooseCell];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self configView];
    
    [self loadData];
    
    @weakify(self);
    [self.changeSubject subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
       //cell点击+ -事件
        RACTupleUnpack(NSString *act,NSNumber *row) = tuple;
        NSInteger index = row.integerValue;
        DZGoodsSpecModel *spec = self.dataArray[index];
        if ([act isEqualToString:@"minus"]) {
            if (spec.buyCount <=0) {
                //[SVProgressHUD showInfoWithStatus:@""];
                return;
            }
            spec.buyCount --;
        } else if ([act isEqualToString:@"plus"]) {
            if (spec.buyCount >= spec.store_count.integerValue) {
                [SVProgressHUD showInfoWithStatus:@"库存不足"];
                return;
            }
            spec.buyCount ++;
        }
        
        [self refreshCartData];
        
        //更新表中本行
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
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

#pragma mark - ---- 代理相关 ----
- (void)refreshCartData{
    NSInteger totalCount = 0;
    float totalPrice = 0.0;
    for (DZGoodsSpecModel *model in self.dataArray) {
        totalCount += model.buyCount;
    }
//    if (totalCount >= [self.model.goods_info.basic_amount integerValue]) {
//        if (self.isActivity) {
//            totalPrice = totalCount * [self.activityPrice floatValue];
//        } else {
//            totalPrice = totalCount * [self.model.goods_info.pack_price floatValue];
//        }
//
//    }else{
//        if (self.isActivity) {
//            totalPrice = totalCount * [self.activityPrice floatValue];
//        } else {
//            totalPrice = totalCount * [self.model.goods_info.shop_price floatValue];
//        }
//    }
//    self.countLabel.text = [NSString stringWithFormat:@"%ld", totalCount];
//    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", totalPrice];
}

#pragma mark UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DZSpecChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:kSpecChooseCell];
    DZGoodsSpecModel *spec = self.dataArray[indexPath.row];
    
    cell.nameLabel.text = spec.spec_name;
    cell.stockLabel.text = spec.store_count;
    cell.numberTextField.text = Str(spec.buyCount);
    cell.row = indexPath.row;
    cell.changeSubject = self.changeSubject;
    cell.model = spec;
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

#pragma mark - ---- Action Events 和 response手势 ----
- (IBAction)addCart:(id)sender {
    //加入进货车
    
    NSMutableArray *specArray = [NSMutableArray array];
    NSMutableArray *numArray = [NSMutableArray array];
    NSInteger totalBuyCount = 0;
    
    for (DZGoodsSpecModel *model in self.dataArray) {
        if (model.buyCount > 0) {
            [specArray addObject:model.spec_key];
            [numArray addObject:Str(model.buyCount)];
            totalBuyCount += model.buyCount;
        }
    }
    NSString *specs = [specArray componentsJoinedByString:@","];
    NSString *nums = [numArray componentsJoinedByString:@","];
    
    if (specArray.count == 0 || numArray.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择数量"];
        return;
    }
    
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/CartApi/addCart" parameters:@{@"goods_id":self.goodsId,@"goods_spec_key":specs,@"buy_number":nums}];
    
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        LNNetBaseModel *model = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
        [SVProgressHUD showInfoWithStatus:model.info];
        if (model.isSuccess) {
            //加入成功，显示按钮
            [[NSNotificationCenter defaultCenter] postNotificationName:CARTUPDATENOTIFICATION object:nil];
            [self showAddSuccess];
        }else{
            [SVProgressHUD showInfoWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

#pragma mark - ---- 私有方法 ----
- (void)configView {
    if (self.model) {
        DZGoodsInfoModel *info = self.model.goods_info;
        
        self.goodsNameLabel.text = info.goods_name;
        [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:FULL_URL(info.goods_img)] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
//        self.getNumLabel.text = [NSString stringWithFormat:@"%@-%d件",info.retail_amount,[info.basic_amount intValue] - 1];
//        self.packNumLabel.text = [NSString stringWithFormat:@"%@件以上",info.basic_amount];
//        
//        if (self.isActivity) {
//            self.getPriceLabel.text = [NSString stringWithFormat:@"￥%@",self.activityPrice];
//            self.packPriceLabel.text = [NSString stringWithFormat:@"￥%@",self.activityPrice];
//        } else {
//            self.getPriceLabel.text = [NSString stringWithFormat:@"￥%@",info.shop_price];
//            self.packPriceLabel.text = [NSString stringWithFormat:@"￥%@",info.pack_price];
//        }
        

        
    }
}

- (void)loadData {
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/GoodsApi/goodsSpec" parameters:@{@"goods_id":self.goodsId}];
    
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZGoodsSpecNetModel *model = [DZGoodsSpecNetModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:model.data];
            [self.tableView reloadData];
            [self refreshCartData];
        } else {
            [SVProgressHUD showInfoWithStatus:model.info];
            
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)showAddSuccess {
    DZAddAlertView *alert = [DZAddAlertView viewFormNib];
    
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];

    
    [maskView addSubview:alert];
    [alert mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(maskView);
        make.width.mas_equalTo(275);
        make.height.mas_equalTo(156);
    }];
    
//    LGAlertView *alertView = [LGAlertView alertViewWithViewAndTitle:nil message:nil style:LGAlertViewStyleAlert view:alert buttonTitles:nil cancelButtonTitle:nil destructiveButtonTitle:nil actionHandler:nil cancelHandler:nil destructiveHandler:nil];
//
//    alertView.layerCornerRadius = 4;
//    alertView.backgroundColor = [UIColor clearColor];
//
//    __weak LGAlertView *weakAlertView = alertView;
    
    __weak UIView *weakAlert = maskView;
    
    @weakify(self);
    [[alert.continueButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        //继续购物，即返回上一页
        //[weakAlertView dismissAnimated];
        
        [self.navigationController popViewControllerAnimated:YES];
        [weakAlert removeFromSuperview];
        
    }];
    
    [[alert.checkoutButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        //[weakAlertView dismissAnimated];
         [weakAlert removeFromSuperview];
        if ([DPMobileApplication sharedInstance].isSellerMode) {
            [self showTabWithIndex:3 needSwitch:YES showLogin:NO];
        }else{
            [self showTabWithIndex:3 needSwitch:NO showLogin:NO];
        }
    }];
    
    
    [self.view.window addSubview:maskView];
    //[self.view addSubview:maskView];

    
    //[alertView showAnimated];
}

#pragma mark - ---- 布局代码 ----
- (void) setSubViewsFrame{

}

- (void) setSubViewsLayout{

}

#pragma mark - --- getters 和 setters ----
- (NSMutableArray *)dataArray {
    if(!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (RACSubject *)changeSubject {
    if(!_changeSubject) {
        _changeSubject = [RACSubject subject];
        
    }
    return _changeSubject;
}

@end
