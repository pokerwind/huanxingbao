//
//  DZCommentManagementVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/24.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZCommentManagementVC.h"

#import "DZCommentManagementHeader.h"
#import "TggStarEvaluationView.h"
#import "DZCommentCell.h"
#import "DZRepliedCommentCell.h"
#import "DZInputView.h"

#import "DZGetClientEvaluateModel.h"
#import "DZShopCommentCell.h"
#import "DZShopCommentModel.h"
#define kShopCommentCell @"DZShopCommentCell"

@interface DZCommentManagementVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) DZCommentManagementHeader *header;

@property (nonatomic) NSInteger type;//1待我回评，2全部
@property (strong, nonatomic) NSMutableArray *commentArray;
@property (nonatomic) NSInteger pageNum;

@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) DZInputView *inputTextView;
//@property(nonatomic,strong) RACSubject *imageSubject;

@end

@implementation DZCommentManagementVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"店铺评价";
    
    self.tableView.estimatedRowHeight = 144.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:kShopCommentCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kShopCommentCell];

    [self.view addSubview:self.tableView];
    
    [self setSubViewsLayout];
    
    self.type = 1;
    
    [self getData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 180);
}

#pragma mark - ---- 布局代码 ----
- (void) setSubViewsLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark - ---- Action Events 和 response手势 ----
- (void)allButtonClick{
    self.type = 2;
    [self.tableView.mj_header beginRefreshing];
}

- (void)replyButtonClick{
    self.type = 1;
    [self.tableView.mj_header beginRefreshing];
}

- (void)toReplyButtonClick:(UIButton *)btn{
    [[UIApplication sharedApplication].delegate.window addSubview:self.maskView];
    [[UIApplication sharedApplication].delegate.window addSubview:self.inputTextView];
    self.inputTextView.frame = CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50);
    self.inputTextView.textField.tag = btn.tag;
    [self.inputTextView.textField becomeFirstResponder];
}

#pragma mark - ---- 代理相关 ----
#pragma mark - ---- UITextFieldDelegate ----
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.inputTextView.textField resignFirstResponder];
    if (textField.text.length) {
        DZClientEvaluateModel *model = self.commentArray[textField.tag];
        NSDictionary *params = @{@"comment_id":model.comment_id, @"content":textField.text};
        LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ShopCenterApi/replyClientMessage" parameters:params];
        [SVProgressHUD show];
        [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
            [SVProgressHUD dismiss];
            LNNetBaseModel *models = [LNNetBaseModel objectWithKeyValues:request.responseJSONObject];
            if (models.isSuccess) {
                [SVProgressHUD showSuccessWithStatus:models.info];
                [self.tableView.mj_header beginRefreshing];
//                [self.tableView reloadData];
            }else{
                [SVProgressHUD showErrorWithStatus:models.info];
            }
        } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }];
    }
    
    return NO;
}

#pragma mark - ---- UITableViewDataSource ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DZClientEvaluateModel *model = self.commentArray[indexPath.row];
    if (model.reply_content.length == 0) {//没有回评
        CGFloat height = 106.5;
        UILabel *lbl_text = [[UILabel alloc]init];
        lbl_text.backgroundColor = [UIColor greenColor];
        lbl_text.text = model.content;
        CGSize size = [lbl_text.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName,nil]];
        CGFloat nameW = size.width;
        CGFloat nameH = size.height;
        nameH = size.height * (nameW / (SCREEN_WIDTH - 24) + 2);
        height += nameH;
        
        NSInteger imgLine = model.img_comment_array.count / 3;
        if (model.img_comment_array.count % 3 != 0) {
            imgLine++;
        }
        height += (imgLine * (SCREEN_WIDTH - 34) / 3);
        
        return height;
    }else{//有回评
        CGFloat base = 150;
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
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DZClientEvaluateModel *model = self.commentArray[indexPath.row];
    if (model.reply_content.length == 0) {
        DZCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:[DZCommentCell cellIdentifier]];
        if (!cell) {
            cell = [DZCommentCell viewFormNib];
        }
        [cell fillData:model];
        cell.replyButton.tag = indexPath.row;
        [cell.replyButton addTarget:self action:@selector(toReplyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        DZShopCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kShopCommentCell];
        DZShopCommentModel *model1 = [[DZShopCommentModel alloc]init];
        model1.comment_id = model.comment_id;
        model1.img_comment_array = model.img_comment_array;
        model1.user_id = model.user_id;
        model1.content = model.content;
        model1.rank = model.rank;
        model1.add_time = model.add_time;
        model1.head_pic = model.head_pic;
        model1.nickname = model.nickname;
        model1.reply_content = model.reply_content;
        cell.row = indexPath.row;
        [cell configView:model1];
        return cell;
    }
}

#pragma mark - ---- 私有方法 ----
- (void)getData{
    NSDictionary *params = @{@"shop_id":[DPMobileApplication sharedInstance].loginUser.shop_id};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"Api/ShopCenterApi/shopCommentData" parameters:params];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        if ([request.responseJSONObject[@"status"] boolValue]) {
            self.header.praiseLabel.text = [NSString stringWithFormat:@"%@%%", request.responseJSONObject[@"data"][@"favorableRate"]];
            self.header.allLabel.text = [NSString stringWithFormat:@"%@条评价", request.responseJSONObject[@"data"][@"all"]];
            self.header.qualityLabel.text = request.responseJSONObject[@"data"][@"goods_rank"];
            self.header.serviceLabel.text = request.responseJSONObject[@"data"][@"service_rank"];
            self.header.expressLabel.text = request.responseJSONObject[@"data"][@"express_rank"];
            [self.header setQualityStarCount:[request.responseJSONObject[@"data"][@"goods_rank"] floatValue]];
            [self.header setServiceStarCount:[request.responseJSONObject[@"data"][@"service_rank"] floatValue]];
            [self.header setExpressStarCount:[request.responseJSONObject[@"data"][@"express_rank"] floatValue]];
            self.header.replyCountLabel.text = [NSString stringWithFormat:@"(%@)", request.responseJSONObject[@"data"][@"wait_for_reply"]];
            self.header.allCountLabel.text = [NSString stringWithFormat:@"(%@)", request.responseJSONObject[@"data"][@"all"]];
            
            [self getNewComment];
        }else{
            [SVProgressHUD showErrorWithStatus:request.responseJSONObject[@"info"]];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)getNewComment{
    self.pageNum = 1;
    NSDictionary *params = @{@"type":@(self.type), @"shop_id":[DPMobileApplication sharedInstance].loginUser.shop_id};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"Api/ShopCenterApi/getClientEvaluate" parameters:params];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [self.tableView.mj_header endRefreshing];
        DZGetClientEvaluateModel *model = [DZGetClientEvaluateModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            [self.commentArray removeAllObjects];
            self.commentArray = [NSMutableArray arrayWithArray:model.data];
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)getMoreComment{
    NSDictionary *params = @{@"type":@(self.type), @"shop_id":[DPMobileApplication sharedInstance].loginUser.shop_id};
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"Api/ShopCenterApi/getClientEvaluate" parameters:params];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [self.tableView.mj_header endRefreshing];
        DZGetClientEvaluateModel *model = [DZGetClientEvaluateModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            [self.commentArray removeAllObjects];
            self.commentArray = [NSMutableArray arrayWithArray:model.data];
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)keyboardWillShown:(NSNotification*)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    //输入框位置动画加载
    [UIView animateWithDuration:duration animations:^{
        self.inputTextView.frame = CGRectMake(0, SCREEN_HEIGHT - self.inputTextView.height - keyboardSize.height, self.inputTextView.width, self.inputTextView.height);
        self.maskView.alpha = 1;
    }];
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    NSDictionary *info = [aNotification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        self.inputTextView.frame = CGRectMake(0, SCREEN_HEIGHT, self.inputTextView.width, self.inputTextView.height);
        self.maskView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.inputTextView removeFromSuperview];
        self.inputTextView = nil;
        [self.maskView removeFromSuperview];
        self.maskView = nil;
    }];
}

- (void)maskViewTap{
    [self.inputTextView.textField resignFirstResponder];
}

#pragma mark - --- getters 和 setters ----
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.header;
        _tableView.allowsSelection = NO;
        _tableView.emptyDataSetSource = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getData];
        }];
        _tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            [self getMoreComment];
        }];
    }
    return _tableView;
}

- (DZCommentManagementHeader *)header{
    if (!_header) {
        _header = [DZCommentManagementHeader viewFormNib];
        [_header.allButton addTarget:self action:@selector(allButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_header.replyButton addTarget:self action:@selector(replyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _header;
}

- (NSMutableArray *)commentArray{
    if (!_commentArray) {
        _commentArray = [NSMutableArray array];
    }
    return _commentArray;
}

- (DZInputView *)inputTextView{
    if (!_inputTextView) {
        _inputTextView = [DZInputView viewFormNib];
        _inputTextView.textField.delegate = self;
    }
    return _inputTextView;
}

- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.45];
        [_maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewTap)]];
        _maskView.alpha = 0;
    }
    return _maskView;
}

@end
