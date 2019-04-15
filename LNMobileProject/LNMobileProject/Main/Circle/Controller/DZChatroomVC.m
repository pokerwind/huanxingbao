//
//  DZChatroomVC.m
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/8.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZChatroomVC.h"
#import "DZChatroomCell.h"
#import "DZChatroomModel.h"
#import "ChatViewController.h"

#define kChatroomCell @"DZChatroomCell"
@interface DZChatroomVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation DZChatroomVC

#pragma mark - ---- 生命周期 ----
- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tableView];
    
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
#pragma mark UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DZChatroomCell *cell = [tableView dequeueReusableCellWithIdentifier:kChatroomCell];
    DZChatroomModel *model = self.dataArray[indexPath.row];
    [cell configView:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DZChatroomModel *model = self.dataArray[indexPath.row];
    CGFloat height = 67;
    //需要根据model来计算  单元格的高度  两个label基准高度17
    //先计算人数label 和日期label的宽度
    NSString *timeStr = model.create_time;
    NSString *numStr = [NSString stringWithFormat:@"%@人",model.max_member];
    
    CGSize timeSize = [timeStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGSize numSize = [numStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat titleMaxWidth = SCREEN_WIDTH - 112 - timeSize.width - numSize.width;
    CGSize titleSize = [model.title sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(titleMaxWidth, MAXFLOAT)];
    
    CGFloat titleHeight = titleSize.height;
    if (titleHeight > 17) {
        height += (titleHeight - 17);
    }
    CGFloat contentMaxWith = SCREEN_WIDTH - 90;
    CGSize contentSize = [model.desc sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(contentMaxWith, MAXFLOAT)];
    CGFloat contentHeight = contentSize.height;
    
    if (contentHeight > 17) {
        height += (contentHeight - 17);
    }
    
    return height;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DZChatroomModel *model = self.dataArray[indexPath.row];
    [self enterChatroom:model];
}

#pragma mark - ---- Action Events 和 response手势 ----

#pragma mark - ---- 私有方法 ----
- (void)loadData {
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/IndexApi/getChatRoomList"];
    
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZChatroomNetModel *model = [DZChatroomNetModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:model.data];
            [self.tableView reloadData];
        } else {
            [SVProgressHUD showInfoWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)enterChatroom:(DZChatroomModel  *)room {
    
    if(![self checkLogin]) {
        return;
    }
    //检查是否已经登录环信，如果登录了 再进入。
    if ([DPMobileApplication sharedInstance].isLogined) {
        
        if ([EMClient sharedClient].currentUsername) {
            ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:room.room_id conversationType:EMConversationTypeChatRoom];
            chatController.navigationItem.title = room.title;
            chatController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chatController animated:YES];
        }
    }
}
//            [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
//                [SVProgressHUD dismiss];
//                DZEMChatUserNetModel *model = [DZEMChatUserNetModel objectWithKeyValues:request.responseJSONObject];
//                if (model.isSuccess) {
//                    DZEMChatUserModel *em = model.data;
//                    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:em.emchat_username conversationType:0];
//                    //                    [[ChatViewController alloc] initWithConversationChatter:@"" conversationType:EMConversationTypeChatRoom];
//                    chatController.real_name = em.nickname;
//                    chatController.imageurl = [NSString stringWithFormat:@"%@%@",DEFAULT_HTTP_IMG,em.head_pic];
//                    chatController.hidesBottomBarWhenPushed = YES;
//                    // 传递产品信息
//                    chatController.isFromProductDetail = YES;
//                    chatController.commodityID = self.model.goods_info.goods_id;// self.model.goods.goods_id;
//                    chatController.commodityName = self.model.goods_info.goods_name;
//                    chatController.commodityPrice = self.model.goods_info.shop_price;
//                    //NSString *urlString = [SPCommonUtils getThumbnailWithHost:FLEXIBLE_THUMBNAIL goodsID:Str(self.model.goods.goods_id)];
//                    NSString *urlString = FULL_URL(self.model.goods_info.goods_img);
//                    chatController.commodityImage = urlString;
//                    [self.navigationController pushViewController:chatController animated:YES];
//                } else {
//                    [SVProgressHUD showInfoWithStatus:model.info];
//
//                }
//            } failure:^(__kindof LCBaseRequest *request, NSError *error) {
//                [SVProgressHUD dismiss];
//                [SVProgressHUD showErrorWithStatus:error.domain];
//            }];


#pragma mark - ---- 布局代码 ----
- (void) setSubViewsFrame{

}

- (void) setSubViewsLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_offset(0);
    }];
}

#pragma mark - --- getters 和 setters ----
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:kChatroomCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kChatroomCell];
        _tableView.backgroundColor = BgColor;
    }
    return _tableView;
}

- (NSMutableArray *) dataArray {
    if(!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
