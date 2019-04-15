//
//  ConversationListControllerViewController.m
//  HBuilder-Integrate
//
//  Created by 云网通 on 2017/3/20.
//  Copyright © 2017年 DCloud. All rights reserved.
//

#import "ConversationListControllerViewController.h"
#import "ChatViewController.h"
#import "AppDelegate.h"

@interface ConversationListControllerViewController ()<EaseConversationListViewControllerDelegate, EaseConversationListViewControllerDataSource>

@property (nonatomic, strong) UIView *networkStateView;
@end

@implementation ConversationListControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    
    [self tableViewDidTriggerHeaderRefresh];
    
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 0);
    [self networkStateView];
    [self removeEmptyConversationsFromDB];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [btn addTarget:self action:@selector(login_out) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"退出" forState:0];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:HEXCOLOR(0xE7CC95) forState:0];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage) name:@"ReceiveMessage" object:nil];
}

- (void)login_out {
    
    [[[LGAlertView alloc] initWithTitle:@"" message:@"确定要退出登录?" style:LGAlertViewStyleAlert buttonTitles:@[@"确定"] cancelButtonTitle:@"取消" destructiveButtonTitle:@"" actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
        [[SPMobileApplication sharedInstance] logout];        
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.mainTabBarController = [[MainTabBarController alloc] init];
        delegate.window.rootViewController = delegate.mainTabBarController;
    } cancelHandler:^(LGAlertView *alertView) {
    } destructiveHandler:^(LGAlertView *alertView) {
    }] showAnimated:YES completionHandler:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refresh];
    [self refreshDataSource];
    
    // UINavagationBar 配置
    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [[UINavigationBar appearance] setTitleTextAttributes:dict];
    [[UINavigationBar appearance] setBarTintColor:HEXCOLOR(0x333949)];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)removeEmptyConversationsFromDB
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSMutableArray *needRemoveConversations = nil;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage || (conversation.type == 2)) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            [needRemoveConversations addObject:conversation];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
//        [[EMClient sharedClient].chatManager deleteConversations:needRemoveConversations deleteMessages:YES];
        [[EMClient sharedClient].chatManager deleteConversations:needRemoveConversations isDeleteMessages:YES completion:nil];
    }
}

- (void)receiveMessage {
    [self tableViewDidTriggerHeaderRefresh];
}

- (void)conversationListDidUpdate:(NSArray *)aConversationList {
    NSLog(@"+++++");
}
#pragma mark - getter
- (UIView *)networkStateView
{
    if (_networkStateView == nil) {
        _networkStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        _networkStateView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:0.5];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_networkStateView.frame.size.height - 20) / 2, 20, 20)];
        imageView.image = [UIImage imageNamed:@"messageSendFail"];
        [_networkStateView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, _networkStateView.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), _networkStateView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = NSLocalizedString(@"network.disconnection", @"Network disconnection");
        [_networkStateView addSubview:label];
    }
    
    return _networkStateView;
}

#pragma mark - EaseConversationListViewControllerDelegate

- (void)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
            didSelectConversationModel:(id<IConversationModel>)conversationModel
{
    if (conversationModel) {
        EMConversation *conversation = conversationModel.conversation;
        if (conversation) {
            ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
            NSDictionary *dic = [self getUserDetail:conversation.conversationId];
            if (dic) {
                chatController.title = dic[@"nickname"];
                chatController.real_name = dic[@"nickname"];
                NSString *headimage;
                if ([dic[@"head_pic"] hasPrefix:@"http"]) {
                    headimage = [NSString stringWithFormat:@"%@",dic[@"head_pic"]];
                }else {
                    headimage = [NSString stringWithFormat:@"%@%@",DEFAULT_HTTP_HOST,dic[@"head_pic"]];
                }
                chatController.imageurl = headimage;
            }
            chatController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chatController animated:YES];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
        [self.tableView reloadData];
    }
}

#pragma mark - EaseConversationListViewControllerDataSource
- (id<IConversationModel>)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                                    modelForConversation:(EMConversation *)conversation
{
    EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:conversation];
    if (model.conversation.type == 0) {
        NSDictionary *dic = [self getUserDetail:conversation.conversationId];
        if (dic) {
            
            if ([dic[@"nickname"] length] > 0) {
                model.title = [NSString stringWithFormat:@"%@",dic[@"nickname"]];
            }else {
                model.title = [NSString stringWithFormat:@"%@",dic[@"mobile"]];
            }
            NSString *headimage;
            if ([dic[@"head_pic"] hasPrefix:@"http"]) {
                headimage = [NSString stringWithFormat:@"%@",dic[@"head_pic"]];
            }else {
                headimage = [NSString stringWithFormat:@"%@%@",DEFAULT_HTTP_HOST,dic[@"head_pic"]];
            }
            model.avatarURLPath = headimage;
            model.avatarImage = [UIImage imageNamed:@"default_avatar"];
        }else {
            model.avatarImage = [UIImage imageNamed:@"default_avatar"];
        }
        
    } else if (model.conversation.type == 1) {
        NSString *imageName = @"groupPublicHeader";
        if (![conversation.ext objectForKey:@"subject"])
        {
            NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:conversation.conversationId]) {
                    NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:conversation.ext];
                    [ext setObject:group.subject forKey:@"subject"];
                    [ext setObject:[NSNumber numberWithBool:group.isPublic] forKey:@"isPublic"];
                    conversation.ext = ext;
                    break;
                }
            }
        }
        model.title = [conversation.ext objectForKey:@"subject"];
        imageName = [[conversation.ext objectForKey:@"isPublic"] boolValue] ? @"group_chat_group" : @"group_chat_group";
        model.avatarImage = [UIImage imageNamed:imageName];
        
        NSString *imageurl = [self getgroupHeader:model.conversation.conversationId];
        if (imageurl) {
            NSString *headimage;
            if ([imageurl hasPrefix:@"http"]) {
                headimage= [NSString stringWithFormat:@"%@",imageurl];
            }else
            {
                headimage = [NSString stringWithFormat:@"%@%@",DEFAULT_HTTP_HOST,imageurl];
            }
            model.avatarURLPath = headimage;
        }
        
        
    }
    return model;
}

- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
      latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTitle = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
    if (lastMessage) {
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case 2:{
                latestMessageTitle = NSLocalizedString(@"message.image1", @"[image]");
            } break;
            case 1:{
                // 表情映射。
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
                if ([lastMessage.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
                    latestMessageTitle = @"[动画表情]";
                }
            } break;
            case 5:{
                latestMessageTitle = NSLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case 4: {
                latestMessageTitle = NSLocalizedString(@"message.location1", @"[location]");
            } break;
            case 3: {
                latestMessageTitle = NSLocalizedString(@"message.video1", @"[video]");
            } break;
            case 6: {
                latestMessageTitle = NSLocalizedString(@"message.file1", @"[file]");
            } break;
            default: {
            } break;
        }
    }
    
    return latestMessageTitle;
}

- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
       latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
    if (lastMessage) {
        latestMessageTime = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    
    return latestMessageTime;
}

#pragma mark - UISearchBarDelegate

#pragma mark - public

-(void)refresh
{
    [self refreshAndSortView];
}

-(void)refreshDataSource
{
    [self tableViewDidTriggerHeaderRefresh];
}

- (void)isConnect:(BOOL)isConnect{
    if (!isConnect) {
        self.tableView.tableHeaderView = _networkStateView;
    }
    else{
        self.tableView.tableHeaderView = nil;
    }
    
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    if (connectionState == 1) {
        self.tableView.tableHeaderView = _networkStateView;
    }
    else{
        self.tableView.tableHeaderView = nil;
    }
}

- (NSDictionary *)getUserDetail:(NSString *)emchat_username
{
    NSString * params = [NSString stringWithFormat:@"emchat_username=%@",emchat_username];
    NSString *urlString = [NSString stringWithFormat:@"%@index.php?m=Api&c=User&a=getUserInfoByEmchatUsername&%@",DEFAULT_HTTP_HOST,params];
    //第一步，创建URL
    NSURL *url = [NSURL URLWithString:urlString];
    
    //第二步，通过URL创建网络请求
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *str = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    
    if (str == NULL) {
        return nil;
    }else {
        NSError *error;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:&error];
        if ([responseObject[@"status"] integerValue] == 1) {
            return responseObject[@"result"];
        }else {
            return nil;
        }
    }
    
}

- (NSString *)getgroupHeader:(NSString *)groupid
{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginInfo"];
    NSString * params = [NSString stringWithFormat:@"group_emchat_id=%@&token=%@",groupid,dic[@"token"]];
    NSString *urlString = [NSString stringWithFormat:@"%@/index.php/Group/Group/get_group_info?%@",DEFAULT_HTTP_HOST,params];
    
    //第一步，创建URL
    NSURL *url = [NSURL URLWithString:urlString];
    
    //第二步，通过URL创建网络请求
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *str = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    
    if (str==NULL) {
        return @"";
    }else {
        NSError *error;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:&error];
        
        return responseObject[@"group_logo"];
    }
    
}




@end
