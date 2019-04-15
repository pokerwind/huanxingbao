//
//  DZShopFileVC.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/7.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZShopFileVC.h"
#import "DZShopFileTopView.h"
#import "DZShopFileReviewView.h"
#import "DZShopFileNumView.h"
#import "DZShopFileContactView.h"
#import "DZShopFileModel.h"
#import "DZShopCollectModel.h"
#import "DZShopCommentVC.h"

@interface DZShopFileVC ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) DZShopFileTopView *topView;
@property (nonatomic, strong) DZShopFileReviewView *reviewView;
@property (nonatomic, strong) DZShopFileNumView *numView;
@property (nonatomic, strong) DZShopFileContactView *contactView;
@property (nonatomic, strong) DZShopFileModel *model;
@end

@implementation DZShopFileVC
- (instancetype) init {
    self = [super init];
    if (self) {
        self.refreshSubject = [RACSubject subject];
    }
    return self;
}

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"店铺档案";
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.topView];
    [self.scrollView addSubview:self.reviewView];
    [self.scrollView addSubview:self.numView];
    [self.scrollView addSubview:self.contactView];
    
    
    NSArray *images = @[self.topView.image1,self.topView.image2,self.topView.image3,self.topView.image4,self.topView.image5];
    for (UIImageView *iv in images) {
        iv.hidden = YES;
    }
    
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

#pragma mark - ---- 代理相关 ----

#pragma mark - ---- Action Events 和 response手势 ----

#pragma mark - ---- 私有方法 ----
- (void)loadData {
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopApi/shopFiles" parameters:@{@"shop_id":self.shopId}];
    
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZShopFileNetModel *model = [DZShopFileNetModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            self.model = model.data;
            [self setupViews];
        } else {
            [SVProgressHUD showInfoWithStatus:model.info];
            
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)setupViews {
    [self.topView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:FULL_URL(self.model.shop_logo)] placeholderImage:[UIImage imageNamed:@"avatar_grey"]];
    self.topView.nameLabel.text = self.model.shop_name;
    self.topView.timeLabel.text = self.model.add_time;
    self.topView.addrLabel.text = self.model.address;
    NSInteger bond = self.model.shop_bond.integerValue;
    if (self.model.shop_bond) {
        if ( bond == 0) {
            self.topView.bondNoLabel.hidden = NO;
            self.topView.bondLabel.hidden = YES;
            self.topView.bondImageView.hidden = YES;
            self.topView.bondMoneyLabel.hidden = YES;
        } else if (bond < 2000) {
            self.topView.bondNoLabel.hidden = NO;
            self.topView.bondNoLabel.text = @"已缴纳保证金";
            self.topView.bondLabel.hidden = YES;
            self.topView.bondImageView.hidden = YES;
            self.topView.bondMoneyLabel.hidden = YES;
        } else {
            self.topView.bondLabel.text = [NSString stringWithFormat:@"%@元",self.model.shop_bond];
            if (bond < 3000) {
                self.topView.bondMoneyLabel.text = @"两千";
            } else if (bond < 5000) {
                self.topView.bondMoneyLabel.text = @"三千";
            } else if (bond < 10000) {
                self.topView.bondMoneyLabel.text = @"五千";
            } else if (bond < 20000) {
                self.topView.bondMoneyLabel.text = @"一万";
            } else if (bond < 50000) {
                self.topView.bondMoneyLabel.text = @"两万";
            } else {
                self.topView.bondMoneyLabel.text = @"五万";
            }
        }
     }

    
    self.topView.isFavoriteStr = self.model.is_favorite;
    self.reviewView.goodRateLabel.text = [NSString stringWithFormat:@"%@%%",self.model.comment.favorableRate];
    self.reviewView.commentNumLabel.text = [NSString stringWithFormat:@"%@条评论",self.model.comment.commentCount];
    
//    self.reviewView.goodsRank = self.model.comment.goods_rank;
//    self.reviewView.serviceRank = self.model.comment.service_rank;
//    self.reviewView.expressRank = self.model.comment.express_rank;

    [self.reviewView setQualityStarCount:self.model.comment.goods_rank.floatValue];
    [self.reviewView setServiceStarCount:self.model.comment.service_rank.floatValue];
    [self.reviewView setExpressStarCount:self.model.comment.express_rank.floatValue];
//    [self.reviewView setQualityStarCount:4.5];
//    [self.reviewView setServiceStarCount:3];
//    [self.reviewView setExpressStarCount:0.5];
    
    self.numView.fanNumLabel.text = self.model.fans;
    self.numView.refundNumLabel.text = self.model.refund_num;
    
    self.contactView.contactLabel.text = self.model.contacts_name;
    self.contactView.phoneLabel.text = self.model.user_mobile;
    
    [self setupIcons];
}

- (void)setupIcons {
    NSInteger num = self.model.shop_grade.num;
    NSString *type = self.model.shop_grade.type;
    NSString *imageName = @"";
    NSArray *images = @[self.topView.image1,self.topView.image2,self.topView.image3,self.topView.image4,self.topView.image5];
    for (UIImageView *iv in images) {
        iv.hidden = YES;
    }
    
    if(num > 5) {
        num = 5;
    }
    if ([type isEqualToString:@"G1"]) {
        imageName = @"icon_heart";
    } else if ([type isEqualToString:@"G2"]) {
        imageName = @"icon_dimon";
    } if ([type isEqualToString:@"G3"]) {
        imageName = @"icon_silvercrown";
    } if ([type isEqualToString:@"G4"]) {
        imageName = @"icon_goldcrown";
    }
    
    for (int i = 0; i < num; i++) {
        UIImageView *iv = images[i];
        iv.image = [UIImage imageNamed:imageName];
        iv.hidden = NO;
    }
    
}
#pragma mark - ---- 布局代码 ----
- (void) setSubViewsFrame{

}

- (void) setSubViewsLayout{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_offset(0);
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_equalTo(197);
        make.width.equalTo(self.scrollView.mas_width);
    }];
    
    [self.reviewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).mas_offset(5);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(132);
    }];
    
    [self.numView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.reviewView.mas_bottom).mas_offset(5);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(64);
    }];
    
    [self.contactView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numView.mas_bottom).mas_offset(5);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(80);
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

- (DZShopFileTopView *)topView {
    if(!_topView) {
        _topView = [DZShopFileTopView viewFormNib];
        [[_topView.followButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (![self checkLogin]) {
                return;
            }
            //关注店铺
            LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/UserCenterApi/collectShop" parameters:@{@"shop_id":self.shopId}];
            
            [SVProgressHUD show];
            [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
                [SVProgressHUD dismiss];
                DZShopCollectNetModel *model = [DZShopCollectNetModel objectWithKeyValues:request.responseJSONObject];
                [SVProgressHUD showInfoWithStatus:model.info];
                if (model.isSuccess) {
                    if ([model.data isEqualToString:@"1"]) {
                        self.topView.isFavoriteStr = @"1";
                    } else if ([model.data isEqualToString:@"2"]) {
                        self.topView.isFavoriteStr = @"0";
                    }
                    [self.refreshSubject sendNext:nil];
                }
            } failure:^(__kindof LCBaseRequest *request, NSError *error) {
                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:error.domain];
            }];
        }];
    }
    return _topView;
}

- (DZShopFileReviewView *)reviewView {
    if(!_reviewView) {
        _reviewView = [DZShopFileReviewView viewFormNib];
        [[_reviewView.commentButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            DZShopCommentVC *vc = [[DZShopCommentVC alloc] init];
            vc.shopId = self.shopId;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _reviewView;
}

- (DZShopFileNumView *)numView {
    if(!_numView) {
        _numView = [DZShopFileNumView viewFormNib];
    }
    return _numView;
}

- (DZShopFileContactView *)contactView {
    if(!_contactView) {
        _contactView = [DZShopFileContactView viewFormNib];
        [[_contactView.callButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if(self.model) {
                //拨打电话。
                NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.model.user_mobile];
                // NSLog(@"str======%@",str);
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                
            }
        }];
    }
    return _contactView;
}

@end
