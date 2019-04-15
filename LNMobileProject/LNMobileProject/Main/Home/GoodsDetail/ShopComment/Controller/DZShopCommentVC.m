//
//  DZShopCommentVC.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/7.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZShopCommentVC.h"
#import "DZShopFileReviewView.h"
#import "HMSegmentedControl.h"
#import "DZShopCommentCell.h"
#import "DZShopRateModel.h"
#import "DZShopCommentModel.h"
//#import "EmptyDataSource.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "IDMPhotoBrowser.h"

#define kShopCommentCell @"DZShopCommentCell"

@interface DZShopCommentVC ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,IDMPhotoBrowserDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) DZShopFileReviewView *reviewView;
@property (nonatomic, strong) UIView *segmentControlContainer;
@property (strong, nonatomic) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat oldHeight;

@property (nonatomic, strong) DZShopRateModel *rateModel;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *level;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) RACSubject *imageSubject;
//@property (strong, nonatomic) EmptyDataSource *emptyDataSource;
@end

@implementation DZShopCommentVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isShangpinPingjia.length == 0) {
        self.navigationItem.title = @"店铺评价";
    }else {
        self.navigationItem.title = @"商品评价";
    }

    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.reviewView];
    [self.scrollView addSubview:self.segmentControlContainer];
    [self.segmentControlContainer addSubview:self.segmentedControl];
    
    [self.scrollView addSubview:self.tableView];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    //self.tableView.emptyDataSetSource = self.emptyDataSource;
    
    
    @weakify(self);
    [RACObserve(self.tableView, contentSize) subscribeNext:^(NSValue *value) {
        @strongify(self);
        CGFloat height = value.CGSizeValue.height;
        if (height < (SCREEN_HEIGHT - 235)) {
            return;
        }
        if (height != self.oldHeight) {
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(height);
            }];
            self.oldHeight = height;
        }
    }];
    
    self.page = 1;
    self.level = @"all";
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
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"me_null"];
}

//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
//    NSString *title = @"狮子王";
//    NSDictionary *attributes = @{
//                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
//                                 NSForegroundColorAttributeName:[UIColor darkGrayColor]
//                                 };
//    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
//}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"没有数据";
    
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


#pragma mark UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    
    static BOOL isOver = NO;
    
    if (offsetY > 132) {
        if(!isOver) {
            NSLog(@"over");
            isOver = YES;
            [self.segmentedControl removeFromSuperview];
            [self.view addSubview:self.segmentedControl];
            
            [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.mas_equalTo(0);
                make.height.mas_equalTo(40);
            }];
        }
        
    } else {
        if(isOver) {
            NSLog(@"below");
            isOver = NO;
            [self.segmentedControl removeFromSuperview];
            [self.segmentControlContainer addSubview:self.segmentedControl];
            [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.bottom.mas_offset(0);
            }];
        }
    }
}

#pragma mark UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DZShopCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kShopCommentCell];
    DZShopCommentModel *model = self.dataArray[indexPath.row];
    cell.row = indexPath.row;
    cell.imageSubject = self.imageSubject;
    [cell configView:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //高度基准值，无评论80有评论145
    CGFloat base = 80;
    DZShopCommentModel *model = self.dataArray[indexPath.row];
    if ([model.reply_content notBlank]) {
        base = 144;
    }
    
    NSString *comment = model.content;
    CGSize cSize = [comment sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 28, MAXFLOAT)];
    if (cSize.height > 15) {
        base += (cSize.height - 15);
    }
    
    //根据有没有图，有多少图计算额外高度
    if (model.img_comment_array && model.img_comment_array.count > 0) {
        //没图不变高度，有图加上
        NSInteger line = (model.img_comment_array.count + 2)/3;
        CGFloat height = (SCREEN_WIDTH - 24)/3;
        CGFloat total = height * line + (line - 1) * 4;
        if(!model.review) {
            total -= 12;
        }
        //
        base += total;
    }
    
    
    if ([model.reply_content notBlank]) {
        NSString *reply = model.reply_content;
        CGSize rSize = [reply sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 28 -16, MAXFLOAT)];
        if (rSize.height > 15) {
            base += (rSize.height - 15);
        }
    }
    base += 18;

    return base;
}

#pragma mark - ---- Action Events 和 response手势 ----

#pragma mark - ---- 私有方法 ----

- (void)loadData {
//    Api/IndexApi/get_goods_comment_base_info
    if (self.isShangpinPingjia.length == 0) {
        LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopApi/getCommentCount" parameters:@{@"shop_id":self.shopId,@"noAES":@"yes"}];
        
        [SVProgressHUD show];
        [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            [SVProgressHUD dismiss];
            DZShopRateNetModel *model = [DZShopRateNetModel objectWithKeyValues:request.responseJSONObject];
            if (model.isSuccess) {
                self.rateModel = model.data;
                [self setupView];
            } else {
                [SVProgressHUD showInfoWithStatus:model.info];
            }
        } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }];

    }else {
        LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"Api/IndexApi/get_goods_comment_base_info" parameters:@{@"goods_id":self.shopId}];
        
        [SVProgressHUD show];
        [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            [SVProgressHUD dismiss];
            DZShopRateNetModel *model = [DZShopRateNetModel objectWithKeyValues:request.responseJSONObject];
            if (model.isSuccess) {
                self.rateModel = model.data;
                [self setupView];
            } else {
                [SVProgressHUD showInfoWithStatus:model.info];
            }
        } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }];
    }
    
    
//    [self loadComments];
    
    
    [self loadComments];
    
}

- (void)loadComments {
    if (self.isShangpinPingjia.length == 0) {
        LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopApi/getShopComment" parameters:@{@"shop_id":self.shopId,@"level":self.level,@"p":@(self.page)}];
        
        [SVProgressHUD show];
        [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            [SVProgressHUD dismiss];
            DZShopCommentNetModel *model = [DZShopCommentNetModel objectWithKeyValues:request.responseJSONObject];
            if (model.isSuccess) {
                if (self.page == 1) {
                    [self.dataArray removeAllObjects];
                } else {
                    
                }
                [self.dataArray addObjectsFromArray:model.data];
                if (self.dataArray.count == 0) {
                    //                self.tableView.emptyDataType = EmptyDataTypeList;
                    //                [self.tableView reloadEmptyDataSet];
                    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(SCREEN_HEIGHT - 235);
                    }];
                }
                [self.tableView reloadData];
            } else {
                [SVProgressHUD showInfoWithStatus:model.info];
                
            }
        } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }];
        
    }else {
        self.page = 1;
        NSString *types = @"1";
        if ([self.level isEqualToString:@"all"]) {
            types = @"1";
        }
        if ([self.level isEqualToString:@"like"]) {
            types = @"2";
        }
        if ([self.level isEqualToString:@"med"]) {
            types = @"3";
        }
        if ([self.level isEqualToString:@"low"]) {
            types = @"4";
        }
        if ([self.level isEqualToString:@"img"]) {
            types = @"5";
        }
        LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"Api/IndexApi/commentList" parameters:@{@"goods_id":self.shopId,@"type":types}];
        [SVProgressHUD show];
        [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            [SVProgressHUD dismiss];
            DZShopCommentNetModel *model = [DZShopCommentNetModel objectWithKeyValues:request.responseJSONObject];
            if (model.isSuccess) {
                if (self.page == 1) {
                    [self.dataArray removeAllObjects];
                } else {
                    
                }
                [self.dataArray addObjectsFromArray:model.data];
                if (self.dataArray.count == 0) {
                    //                self.tableView.emptyDataType = EmptyDataTypeList;
                    //                [self.tableView reloadEmptyDataSet];
                    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(SCREEN_HEIGHT - 235);
                    }];
                }
                [self.tableView reloadData];
            } else {
                [SVProgressHUD showInfoWithStatus:model.info];
                
            }
        } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }];
    }
    
}

- (void)setupView {
//    self.reviewView.goodsRank = self.rateModel.goods_rank;
//    self.reviewView.serviceRank = self.rateModel.service_rank;
//    self.reviewView.expressRank = self.rateModel.express_rank;
    
    [self.reviewView setQualityStarCount:self.rateModel.goods_rank.floatValue];
    [self.reviewView setServiceStarCount:self.rateModel.service_rank.floatValue];
    [self.reviewView setExpressStarCount:self.rateModel.express_rank.floatValue];
    
    self.reviewView.arrorImageView.hidden = YES;
    self.reviewView.goodRateLabel.text = [NSString stringWithFormat:@"%@%%",self.rateModel.favorableRate];
    self.reviewView.commentNumLabel.text = [NSString stringWithFormat:@"%@条评论",self.rateModel.commentCount];
    
    NSString *allStr = [NSString stringWithFormat:@"全部\n(%@)",self.rateModel.commentCount];
    NSString *goodStr =  [NSString stringWithFormat:@"好评\n(%@)",self.rateModel.likeCount];
    NSString *medStr =  [NSString stringWithFormat:@"中评\n(%@)",self.rateModel.medCount];
    NSString *lowStr =  [NSString stringWithFormat:@"差评\n(%@)",self.rateModel.lowCount];
    NSString *picStr =  [NSString stringWithFormat:@"晒图\n(%@)",self.rateModel.imgCount];
    
    [self.segmentedControl setSectionTitles:@[allStr,goodStr,medStr,lowStr,picStr]];
}

- (void)commentSelectedIndex:(NSInteger)index images:(NSArray *)images {
    
    NSMutableArray *fullImages = [NSMutableArray array];
    
    for (NSString *str in images) {
        [fullImages addObject:[NSString stringWithFormat:@"%@%@",DEFAULT_HTTP_IMG,str]];
    }
    
    NSArray *photosWithURL = [IDMPhoto photosWithURLs:fullImages];
    NSMutableArray* urls = [NSMutableArray arrayWithArray:photosWithURL];
    
    // Create and setup browser
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:urls];
    browser.displayCounterLabel     = YES;
    browser.displayActionButton      = NO;
    browser.useWhiteBackgroundColor = YES;
    browser.leftArrowImage          = [UIImage imageNamed:@"IDMPhotoBrowser_customArrowLeft.png"];
    browser.rightArrowImage         = [UIImage imageNamed:@"IDMPhotoBrowser_customArrowRight.png"];
    browser.leftArrowSelectedImage  = [UIImage imageNamed:@"IDMPhotoBrowser_customArrowLeftSelected.png"];
    browser.rightArrowSelectedImage = [UIImage imageNamed:@"IDMPhotoBrowser_customArrowRightSelected.png"];
    browser.doneButtonImage         = [UIImage imageNamed:@"IDMPhotoBrowser_customDoneButton.png"];
    browser.view.tintColor          = [UIColor orangeColor];
    browser.progressTintColor       = [UIColor orangeColor];
    browser.trackTintColor          = [UIColor colorWithWhite:0.8 alpha:1];
    
    browser.delegate = self;
    [browser setInitialPageIndex:index];
    // Show
    [self presentViewController:browser animated:YES completion:nil];
}

#pragma mark - ---- 布局代码 ----
- (void) setSubViewsFrame{

}

- (void) setSubViewsLayout{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_offset(0);
    }];
    
    [self.reviewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.right.mas_offset(0);
        make.width.equalTo(self.scrollView.mas_width);
        make.height.mas_equalTo(132);

    }];
    
    [self.segmentControlContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.reviewView.mas_bottom);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(40);
    }];
    
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_offset(0);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentControlContainer.mas_bottom);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(SCREEN_HEIGHT - 235);
        make.bottom.mas_offset(0);
    }];
}

#pragma mark - --- getters 和 setters ----
- (UIScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (DZShopFileReviewView *)reviewView {
    if(!_reviewView) {
        _reviewView = [DZShopFileReviewView viewFormNib];
    }
    return _reviewView;
}

- (UIView *)segmentControlContainer {
    if(!_segmentControlContainer) {
        _segmentControlContainer = [[UIView alloc] init];
    }
    return _segmentControlContainer;
}

- (HMSegmentedControl *)segmentedControl{
    if (!_segmentedControl) {
        _segmentedControl=[[HMSegmentedControl alloc] initWithSectionTitles:@[@"全部\n(0)",@"好评\n(0)",@"中评\n(0)",@"差评\n(0)",@"晒图\n(0)"]];
        
        _segmentedControl.backgroundColor = [UIColor whiteColor];
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleArrow;
        _segmentedControl.selectionIndicatorColor=OrangeColor;
        _segmentedControl.selectionIndicatorHeight=0;
        _segmentedControl.borderWidth=1;
        _segmentedControl.borderColor=[UIColor colorWithRed:0.965f green:0.965f blue:0.965f alpha:1.00f];
        
        NSDictionary *selectdefaults = @{
                                         NSFontAttributeName : [UIFont systemFontOfSize:10.0f],
                                         NSForegroundColorAttributeName : OrangeColor,
                                         };
        NSMutableDictionary *selectresultingAttrs = [NSMutableDictionary dictionaryWithDictionary:selectdefaults];
        
        NSDictionary *defaults = @{
                                   NSFontAttributeName : [UIFont systemFontOfSize:10.0f],
                                   NSForegroundColorAttributeName : TextBlackColor,
                                   };
        NSMutableDictionary *resultingAttrs = [NSMutableDictionary dictionaryWithDictionary:defaults];
        _segmentedControl.selectedTitleTextAttributes=selectresultingAttrs;
        _segmentedControl.titleTextAttributes=resultingAttrs;
        //_segmentedControl.selectedSegmentIndex=0;
        _segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
        @weakify(self);
        _segmentedControl.indexChangeBlock = ^(NSInteger index) {
            @strongify(self);
            self.page = 1;
            if (index == 0) {
                self.level = @"all";
            } else if(index == 1) {
                self.level = @"like";
            } else if(index == 2) {
                self.level = @"med";
            } else if(index == 3) {
                self.level = @"low";
            } else if(index == 4) {
                self.level = @"img";
            }
            [self loadComments];
            //[self loadDiscovery:index];
        };
        _segmentedControl.backgroundColor = HEXCOLOR(0xf9f9fc);
    }
    return _segmentedControl;
}


- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:kShopCommentCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kShopCommentCell];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if(!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (RACSubject *)imageSubject {
    if(!_imageSubject)  {
        _imageSubject = [RACSubject subject];
        @weakify(self);
        [_imageSubject subscribeNext:^(RACTuple *tuple) {
            @strongify(self);
            RACTupleUnpack(NSNumber *rowNum,NSNumber *indexNum) = tuple;
            NSInteger row = rowNum.integerValue;
            NSInteger index = indexNum.integerValue;
            DZShopCommentModel *model = self.dataArray[row];
            NSMutableArray *images = [NSMutableArray array];
            for(NSString *img in model.img_comment_array) {
                [images addObject:img];
            }
            
            [self commentSelectedIndex:index images:images];
            
        }];
    }
    return _imageSubject;
}

//- (EmptyDataSource *)emptyDataSource{
//    if (!_emptyDataSource) {
//        _emptyDataSource = [[EmptyDataSource alloc] init];
//    }
//    return _emptyDataSource;
//}

@end
