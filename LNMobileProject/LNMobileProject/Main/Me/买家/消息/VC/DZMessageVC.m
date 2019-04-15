//
//  DZMessageVC.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/10.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZMessageVC.h"
#import "DZMessageCell.h"
#import "DZMessageDetailVC.h"
#import "UserProfileManager.h"
#import "ChatViewController.h"
#import "DZHelpCenterVC.h"
#import "DZGetArticleListModel.h"
#import "DZCustomerServiceModel.h"
#import "ChatViewController.h"
#import "DZMessageDetailVC.h"

@interface DZMessageVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) NSArray *conversations;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic ,strong) DZArticleListModel *notice;
@property (nonatomic, strong) DZCustomerServiceModel *customerService;
@end

@implementation DZMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息列表";
    
    [self.view addSubview:self.tableView];
    
    
    [self loadCustomerServiceInfo];
    
    [self setSubViewsLayout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadConversations];
    
    [self loadFirstNotice];
}

- (void) setSubViewsLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (void)loadConversations {
    
    [self.dataArray removeAllObjects];
    //获取会话列表，并将会话转换为模型
    self.conversations = [[EMClient sharedClient].chatManager getAllConversations];
    
    NSArray* sorted = [self.conversations sortedArrayUsingComparator:
                       ^(EMConversation *obj1, EMConversation* obj2){
                           EMMessage *message1 = [obj1 latestMessage];
                           EMMessage *message2 = [obj2 latestMessage];
                           if(message1.timestamp > message2.timestamp) {
                               return(NSComparisonResult)NSOrderedAscending;
                           }else {
                               return(NSComparisonResult)NSOrderedDescending;
                           }
                       }];
    for (EMConversation *converstion in sorted) {
        EaseConversationModel *model = nil;
        model = [self modelFromConversation:converstion];
//        if (self.dataSource && [self.dataSource respondsToSelector:@selector(conversationListViewController:modelForConversation:)]) {
//            model = [self.dataSource conversationListViewController:self
//                                               modelForConversation:converstion];
//        }
//        else{
//            model = [[EaseConversationModel alloc] initWithConversation:converstion];
//        }
        
        if (model) {
            [self.dataArray addObject:model];
        }
    }
    [self.tableView reloadData];
    
}

- (EaseConversationModel *)modelFromConversation:(EMConversation *)converstion {
    EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:converstion];
    //model.conversation = converstion;
    if (model.conversation.type == EMConversationTypeChat) {
        NSDictionary *dic = [self getUserDetail:model.conversation.conversationId];
        if (dic && [dic isKindOfClass:NSDictionary.class]) {
            if ([dic.allKeys containsObject:@"nickname"]) {
                if (dic[@"nickname"] &&  [dic[@"nickname"] isKindOfClass:NSString.class]) {
                    model.title = [NSString stringWithFormat:@"%@",dic[@"nickname"]];
                }
            }
            
            NSString *headimage;
            if ([dic.allKeys containsObject:@"head_pic"] ) {
                if (dic[@"head_pic"] && [dic[@"head_pic"] isKindOfClass:NSString.class]) {
                    if([dic[@"head_pic"] hasPrefix:@"http"]) {
                        headimage = [NSString stringWithFormat:@"%@",dic[@"head_pic"]];
                    }else {
                        headimage = [NSString stringWithFormat:@"%@%@",DEFAULT_HTTP_IMG,dic[@"head_pic"]];
                    }
                    model.avatarURLPath = headimage;
                }

            }
        } else {
            NSLog(@"not dic :%@",dic);
        }
        model.avatarImage = [UIImage imageNamed:@"avatar_grey"];
        return model;
    }
    return nil;
}

- (NSAttributedString *)latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:@""];
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
    if (lastMessage) {
        NSString *latestMessageTitle = @"";
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = NSLocalizedString(@"message.image1", @"[image]");
            } break;
            case EMMessageBodyTypeText:{
                // 表情映射。
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
                if ([lastMessage.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
                    latestMessageTitle = @"[动画表情]";
                }
            } break;
            case EMMessageBodyTypeVoice:{
                latestMessageTitle = NSLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case EMMessageBodyTypeLocation: {
                latestMessageTitle = NSLocalizedString(@"message.location1", @"[location]");
            } break;
            case EMMessageBodyTypeVideo: {
                latestMessageTitle = NSLocalizedString(@"message.video1", @"[video]");
            } break;
            case EMMessageBodyTypeFile: {
                latestMessageTitle = NSLocalizedString(@"message.file1", @"[file]");
            } break;
            default: {
            } break;
        }
        
        if (lastMessage.direction == EMMessageDirectionReceive) {
            NSString *from = lastMessage.from;
            UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:from];
            if (profileEntity) {
                from = profileEntity.nickname == nil ? profileEntity.username : profileEntity.nickname;
            }
            latestMessageTitle = [NSString stringWithFormat:@"%@: %@", from, latestMessageTitle];
        }
        attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
//        NSDictionary *ext = conversationModel.conversation.ext;
//        if (ext && [ext[kHaveUnreadAtMessage] intValue] == kAtAllMessage) {
//            latestMessageTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"group.atAll", nil), latestMessageTitle];
//            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
//            [attributedStr setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:.0 blue:.0 alpha:0.5]} range:NSMakeRange(0, NSLocalizedString(@"group.atAll", nil).length)];
//
//        }
//        else if (ext && [ext[kHaveUnreadAtMessage] intValue] == kAtYouMessage) {
//            latestMessageTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"group.atMe", @"[Somebody @ me]"), latestMessageTitle];
//            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
//            [attributedStr setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:.0 blue:.0 alpha:0.5]} range:NSMakeRange(0, NSLocalizedString(@"group.atMe", @"[Somebody @ me]").length)];
//        }
//        else {
//
//        }
    }
    
    return attributedStr;
}

- (NSString *)latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
    if (lastMessage) {
        latestMessageTime = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    
//    NSString *format = NSEaseLocalizedString(@"NSDateCategory.text8", @"");
//    NSLog(@"8:%@",format);
//    format = NSEaseLocalizedString(@"NSDateCategory.text9", @"");
//    NSLog(@"9:%@",format);
//    format = NSEaseLocalizedString(@"NSDateCategory.text10", @"");
//    NSLog(@"10:%@",format);
//    format = NSEaseLocalizedString(@"NSDateCategory.text11", @"");
//    NSLog(@"11:%@",format);
//    format = NSEaseLocalizedString(@"NSDateCategory.text12", @"");
//    NSLog(@"12:%@",format);
//    format = NSEaseLocalizedString(@"NSDateCategory.text13", @"");
//    NSLog(@"13:%@",format);
    
    
    return latestMessageTime;
}

#pragma mark - ---- Action Events 和 response手势 ----
- (void)headerButtonAction{
    [self contactCustomerService];
}

#pragma mark - --- UITableViewDelegate ----
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        DZMessageDetailVC *vc = [DZMessageDetailVC new];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        id<IConversationModel> conversationModel = [self.dataArray objectAtIndex:indexPath.row - 1];
        EMConversation *conversation = conversationModel.conversation;
        //UIViewController *chatController = nil;
        //#ifdef REDPACKET_AVALABLE
        //                chatController = [[RedPacketChatViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
        //#else
        ChatViewController *chatController =  [[ChatViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
        chatController.real_name = conversationModel.title;
        chatController.imageurl = conversationModel.avatarURLPath;
        //#endif
        chatController.navigationItem.title = conversationModel.title;
        [self.navigationController pushViewController:chatController animated:YES];
        
    }

}

#pragma mark - --- UITableViewDataSource ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //第一个 固定为系统通知，点击后进入单独页面
    //其他为单个会话
//    DZMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:[DZMessageCell cellIdentifier] forIndexPath:indexPath];
    
    NSString *CellIdentifier = [EaseConversationCell cellIdentifierWithModel:nil];
    EaseConversationCell *cell = (EaseConversationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[EaseConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //cell.avatarView.layer.masksToBounds = YES;
    //cell.avatarView.layer.cornerRadius = 21;
    [cell.avatarView setImageCornerRadius:21];
    
    if (indexPath.row == 0) {
        //系统通知
        cell.titleLabel.text = @"系统通知";
        cell.avatarView.image = [UIImage imageNamed:@"avatar_system"];
        
        if (self.notice) {
            cell.detailLabel.text = self.notice.title;
            //cell.timeLabel.text = self.notice.addtime;
            NSDateFormatter *formater = [[NSDateFormatter alloc] init];
            //[formater setDateFormat:@"YYYY-mm-dd "];
            [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date = [formater dateFromString:self.notice.addtime];
             cell.timeLabel.text = [date formattedTime];
            //[NSDate formattedTimeFromTimeInterval:lastMessage.timestamp]
        } else {
            cell.detailLabel.text = @"暂无消息";
            cell.timeLabel.text = @"";
        }
    } else {
        //聊天会话
        id<IConversationModel> model = [self.dataArray objectAtIndex:indexPath.row - 1];
        NSString *emname = model.conversation.conversationId;
        NSLog(@"emname?: %@",emname);
        cell.model = model;
        NSMutableAttributedString *attributedText = [[self latestMessageTitleForConversationModel:model] mutableCopy];
        [attributedText addAttributes:@{NSFontAttributeName : cell.detailLabel.font} range:NSMakeRange(0, attributedText.length)];
        cell.detailLabel.attributedText =  attributedText;
        
        cell.timeLabel.text = [self latestMessageTimeForConversationModel:model];
    }
    
    return cell;

}

#pragma mark - --- 私有方法 ----
- (NSDictionary *)getUserDetail:(NSString *)emchat_username
{
    DZCustomerServiceModel *customer = [DPMobileApplication sharedInstance].customerService;
    if (customer) {
        //有系统客服信息，判断一下现在这个环信id是不是系统客服
        if ([emchat_username isEqualToString:customer.chat_username]) {
            //刚好是系统客服，好像返回头像和昵称即可
            return @{@"head_pic":customer.chat_headpic,@"nickname":customer.chat_nickname};
        }
    }
    
    NSString * params = [NSString stringWithFormat:@"emchat_username=%@",emchat_username];
    NSString *urlString = [NSString stringWithFormat:@"%@/Api/IndexApi/getUserByEchat?%@",DEFAULT_HTTP_HOST,params];
    //第一步，创建URL
    NSURL *url = [NSURL URLWithString:urlString];
    
    //第二步，通过URL创建网络请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];

    //[request setHTTPMethod:@"POST"];
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *str = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    
    if (str == NULL) {
        return nil;
    }else {
        NSError *error;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:&error];
        if ([responseObject[@"status"] integerValue] == 1) {
            return responseObject[@"data"];
        }else {
            return nil;
        }
    }
    
}

- (void)loadFirstNotice {
    
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/ArticleApi/articleList" parameters:@{@"article_cat_id":@"8"}];
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZGetArticleListModel *model = [DZGetArticleListModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            self.notice = model.data.firstObject;
            //self.dataArray = model.data;
            [self.tableView reloadData];
        }else{
            //[SVProgressHUD showErrorWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)loadCustomerServiceInfo {
    LNetWorkAPI *api = [[LNetWorkAPI alloc] initWithUrl:@"/Api/IndexApi/getServiceInfo"];
    
    [SVProgressHUD show];
    [api startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        [SVProgressHUD dismiss];
        DZCustomerServiceNetModel *model = [DZCustomerServiceNetModel objectWithKeyValues:request.responseJSONObject];
        if (model.isSuccess) {
            self.customerService = model.data;
        } else {
            [SVProgressHUD showInfoWithStatus:model.info];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.domain];
    }];
}

- (void)contactCustomerService {
    if (!self.customerService) {
        return;
    }
    if (![DPMobileApplication sharedInstance].isLogined) {
        //处理未登录情况
        return;
    }
    
    if ([EMClient sharedClient].currentUsername) {
        ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:self.customerService.chat_username conversationType:0];
        chatController.real_name = self.customerService.chat_nickname;
        chatController.imageurl = [NSString stringWithFormat:@"%@%@",DEFAULT_HTTP_IMG,self.customerService.chat_headpic];
        chatController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chatController animated:YES];
    } else {
        //没有环信用户名，重试登录？
        DZUserModel *user = [DPMobileApplication sharedInstance].loginUser;
        [[EMClient sharedClient] loginWithUsername:user.emchat_username
                                          password:user.emchat_password
                                        completion:^(NSString *aUsername, EMError *aError) {
                                            if (!aError) {
                                                ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:self.customerService.chat_username conversationType:0];
                                                chatController.real_name = self.customerService.chat_nickname;
                                                chatController.imageurl = [NSString stringWithFormat:@"%@%@",DEFAULT_HTTP_IMG,self.customerService.chat_headpic];
                                                chatController.hidesBottomBarWhenPushed = YES;
                                                [self.navigationController pushViewController:chatController animated:YES];
                                            }else {
                                                [SVProgressHUD showInfoWithStatus:@"客服正忙，请稍后尝试"];
                                            }
                                        }];
    }
    
}


#pragma mark - --- getters 和 setters ----
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[DZMessageCell class] forCellReuseIdentifier:[DZMessageCell cellIdentifier]];
        _tableView.tableHeaderView = self.header;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
    }
    return _tableView;
}

- (UIView *)header{
    if (!_header) {
        _header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 28)];
        _header.backgroundColor = HEXCOLOR(0xffe6ca);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 200, 28)];
        titleLabel.textColor = BannerCurrentDotColor;
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.text = @"遇到问题，欢迎咨询客服";
        [_header addSubview:titleLabel];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 18, 7, 14, 14)];
        imageView.image = [UIImage imageNamed:@"my_icon_arrow"];
        [_header addSubview:imageView];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 28)];
        [button addTarget:self action:@selector(headerButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_header addSubview:button];
    }
    return _header;
}

- (NSMutableArray *)dataArray {
    if(!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
