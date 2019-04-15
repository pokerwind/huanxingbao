/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "ChatViewController.h"
#import "TitleIconAndLeftNavigationBar.h"
#import "IQKeyboardManager.h"

@interface ChatViewController ()<UIAlertViewDelegate, EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource,EMClientDelegate>
{
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    UIMenuItem *_transpondMenuItem;
    UIMenuItem *_forwardingMenuItem;
    NSMutableArray *_localContant;
}

@property (nonatomic) BOOL isPlayingAudio;

@property (nonatomic) NSMutableDictionary *emotionDic;
@property (nonatomic, copy) EaseSelectAtTargetCallback selectedCallback;


@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[ChatViewController class]];
//    [[EaseBaseMessageCell appearance] setSendBubbleBackgroundImage:[[UIImage imageNamed:@"chat_sender_bg"] stretchableImageWithLeftCapWidth:5 topCapHeight:35]];
//    [[EaseBaseMessageCell appearance] setRecvBubbleBackgroundImage:[[UIImage imageNamed:@"chat_receiver_bg"] stretchableImageWithLeftCapWidth:35 topCapHeight:35]];
//    
//    [[EaseBaseMessageCell appearance] setSendMessageVoiceAnimationImages:@[[UIImage imageNamed:@"chat_sender_audio_playing_full"], [UIImage imageNamed:@"chat_sender_audio_playing_000"], [UIImage imageNamed:@"chat_sender_audio_playing_001"], [UIImage imageNamed:@"chat_sender_audio_playing_002"], [UIImage imageNamed:@"chat_sender_audio_playing_003"]]];
//    [[EaseBaseMessageCell appearance] setRecvMessageVoiceAnimationImages:@[[UIImage imageNamed:@"chat_receiver_audio_playing_full"],[UIImage imageNamed:@"chat_receiver_audio_playing000"], [UIImage imageNamed:@"chat_receiver_audio_playing001"], [UIImage imageNamed:@"chat_receiver_audio_playing002"], [UIImage imageNamed:@"chat_receiver_audio_playing003"]]];
    [[EaseBaseMessageCell appearance] setAvatarSize:40.f];
    [[EaseBaseMessageCell appearance] setAvatarCornerRadius:0.f];
    
    [[EaseChatBarMoreView appearance] setMoreViewBackgroundColor:[UIColor colorWithRed:240 / 255.0 green:242 / 255.0 blue:247 / 255.0 alpha:1.0]];
    

    [self _setupBarButtonItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteAllMessages:) name:KNOTIFICATIONNAME_DELETEALLMESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitGroup) name:@"ExitGroup" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertCallMessage:) name:@"insertCallMessage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCallNotification:) name:@"callOutWithChatter" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCallNotification:) name:@"callControllerClose" object:nil];
    
    [self initNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = self.real_name;
    // UINavagationBar 配置
//    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
//    [[UINavigationBar appearance] setTitleTextAttributes:dict];
//    [[UINavigationBar appearance] setBarTintColor:HEXCOLOR(0x333949)];
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

- (void)viewDidAppear:(BOOL)animated {
    [SPMobileApplication sharedInstance].isShowing = NO;
    [SPMobileApplication sharedInstance].hasNewChatMessage = NO;
}

-(void)initNavigationBar{
    
//    TitleIconAndLeftNavigationBar *navBar = [TitleIconAndLeftNavigationBar viewFormNib];
//    navBar.navigationController = self.navigationController;
//    navBar.titleLabel.text = self.real_name.length > 0 ? self.real_name:@"客服";
//    navBar.rightButton.hidden = YES;
//    self.navigationItem.titleView = navBar;
    self.navigationItem.title = @"客服";
}

-(void)freshenData{

}
#pragma mark - EaseChatBarMoreViewDelegate
- (void)moreView:(EaseChatBarMoreView *)moreView removeAfterRead:(BOOL)isRemove
{
    
    [self showHint:@"功能开发中，敬请期待" yOffset:-200];
    
    [self.chatToolbar endEditing:YES];
}
- (void)dealloc
{
    if (self.conversation.type == 2)
    {
        //退出聊天室，删除会话
        NSString *chatter = [self.conversation.conversationId copy];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            EMError *error = nil;
            [[EMClient sharedClient].roomManager leaveChatroom:chatter error:&error];
//            // 3.1.5
//            [[EMClient sharedClient].roomManager leaveChatroom:chatter completion:^(EMChatroom *aChatroom, EMError *aError) {
                if (error !=nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Leave chatroom '%@' failed [%@]", chatter, error.errorDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alertView show];
                    });
                }
//            }];
        });
    }
    [[EMClient sharedClient] removeDelegate:self];
}

#pragma mark - setup subviews
- (void)_setupBarButtonItem
{
    //单聊
    if (self.conversation.type == 0) {
//        UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//        [clearButton setImage:[UIImage imageNamed:@"me0"] forState:UIControlStateNormal];
//        [clearButton addTarget:self action:@selector(enterUserInfo:) forControlEvents:UIControlEventTouchUpInside];
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:clearButton];
    }
    else {//群聊
        UIButton *detailButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        [detailButton setImage:[UIImage imageNamed:@"me0"] forState:UIControlStateNormal];
        [detailButton addTarget:self action:@selector(showGroupDetailAction) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:detailButton];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex != buttonIndex) {
        self.messageTimeIntervalTag = -1;
        [self.conversation deleteAllMessages:nil];
        // 3.1.5
//        [self.conversation deleteAllMessages:nil];
        [self.dataArray removeAllObjects];
        [self.messsagesSource removeAllObjects];
        [self.tableView reloadData];
    }
}

#pragma mark - EaseMessageViewControllerDelegate
- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   canLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   didLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    id object = [self.dataArray objectAtIndex:indexPath.row];
    id<IMessageModel> model = object;
    EMMessage *message = model.message;
    NSLog(@"%@",message.ext);
    if (message.ext) {
        return NO;
    }
    if (![object isKindOfClass:[NSString class]]) {
        EaseMessageCell *cell = (EaseMessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell becomeFirstResponder];
        self.menuIndexPath = indexPath;
        [self _showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.model.bodyType];
    }
    return YES;
}

- (void)messageViewController:(EaseMessageViewController *)viewController
   didSelectAvatarMessageModel:(id<IMessageModel>)messageModel
{
   
}

// 长按用户头像
- (void)messageViewController:(EaseMessageViewController *)viewController didLongPressAvatarMessageModel:(id<IMessageModel>)messageModel {
    
    EaseAtTarget *target = [[EaseAtTarget alloc] init];
    target.nickname = messageModel.nickname;
    if (_selectedCallback) {
        _selectedCallback(target);
    }
}
// 获取@对象
- (void)messageViewController:(EaseMessageViewController *)viewController
               selectAtTarget:(EaseSelectAtTargetCallback)selectedCallback {
//    _selectedCallback = selectedCallback;
//    EMGroup *chatGroup = nil;
////    NSArray *groupArray = [[EMClient sharedClient].groupManager getAllGroups];
//    // 3.1.5
//    NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
//    for (EMGroup *group in groupArray) {
//        if ([group.groupId isEqualToString:self.conversation.conversationId]) {
//            chatGroup = group;
//            break;
//        }
//    }
//    
//    if (chatGroup == nil) {
//        chatGroup = [EMGroup groupWithId:self.conversation.conversationId];
//    }
//    
//    if (chatGroup) {
//        if (!chatGroup.occupants) {
//            __unsafe_unretained ChatViewController* weakSelf = self;
//            [self showHudInView:self.view hint:@"Fetching group members..."];
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                EMError *error = nil;
//                EMGroup *group = [[EMClient sharedClient].groupManager fetchGroupInfo:chatGroup.groupId includeMembersList:YES error:&error];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    __strong ChatViewController *strongSelf = weakSelf;
//                    if (strongSelf) {
//                        [strongSelf hideHud];
//                        if (error) {
//                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Fetching group members failed [%@]", error.errorDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                            [alertView show];
//                        }
//                        else {
//                            NSMutableArray *members = [group.occupants mutableCopy];
//                            NSString *loginUser = [EMClient sharedClient].currentUsername;
//                            if (loginUser) {
//                                [members removeObject:loginUser];
//                            }
//                            if (![members count]) {
//                                if (strongSelf.selectedCallback) {
//                                    strongSelf.selectedCallback(nil);
//                                }
//                                return;
//                            }
////                            ContactSelectionViewController *selectController = [[ContactSelectionViewController alloc] initWithContacts:members];
////                            selectController.mulChoice = YES;
////                            selectController.delegate = self;
////                            [self.navigationController pushViewController:selectController animated:YES];
//                        }
//                    }
//                });
//            });
//        }
//        else {
//            NSMutableArray *members = [chatGroup.occupants mutableCopy];
//            NSString *loginUser = [EMClient sharedClient].currentUsername;
//            if (loginUser) {
//                [members removeObject:loginUser];
//            }
//            if (![members count]) {
//                if (_selectedCallback) {
//                    _selectedCallback(nil);
//                }
//                return;
//            }
////            ContactSelectionViewController *selectController = [[ContactSelectionViewController alloc] initWithContacts:members];
////            selectController.mulChoice = YES;
////            selectController.delegate = self;
////            self.navigationItem.title = @"返回";
////            [self.navigationController pushViewController:selectController animated:YES];
//        }
//    }
}

#pragma mark - EaseMessageViewControllerDataSource
- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController
                           modelForMessage:(EMMessage *)message
{
    id<IMessageModel> model = nil;
    model = [[EaseMessageModel alloc] initWithMessage:message];
    model.avatarImage = [UIImage imageNamed:@"person_default_head"];
    if (model.message.direction == 0) {

        GGUserModel *user = [SPMobileApplication sharedInstance].loginUser;
        model.nickname = user.nickname;
        model.avatarImage = [UIImage imageNamed:@"person_default_head"];
        if ([user.headPic hasPrefix:@"http"]) {
            model.avatarURLPath = user.headPic;
        }else{
            model.avatarURLPath = [NSString stringWithFormat:@"%@%@",DEFAULT_HTTP_HOST,user.headPic];
        }
        model.failImageName = @"imageDownloadFail";
        return model;
    }
    // 群组联系人
    if (model.message.chatType == 0) {
        model.nickname = _real_name;
        NSString *headimage;
        if ([_imageurl hasPrefix:@"http"]) {
            headimage= [NSString stringWithFormat:@"%@",_imageurl];
        }else {
            headimage = [NSString stringWithFormat:@"%@%@",DEFAULT_HTTP_HOST,_imageurl];
        }
        model.avatarURLPath = headimage;
        model.avatarImage = [UIImage imageNamed:@"person_default_head"];
        model.failImageName = @"imageDownloadFail";
    }
   
    // 单聊
    else if (model.message.chatType == 0) {
        
        model.nickname = _real_name;
        model.avatarURLPath = _imageurl;
        model.avatarImage = [UIImage imageNamed:@"person_default_head"];
        model.failImageName = @"imageDownloadFail";
    }
    
    
    return model;
}

- (NSArray*)emotionFormessageViewController:(EaseMessageViewController *)viewController
{
    NSMutableArray *emotions = [NSMutableArray array];
    for (NSString *name in [EaseEmoji allEmoji]) {
        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:name emotionThumbnail:name emotionOriginal:name emotionOriginalURL:@"" emotionType:EMEmotionDefault];
        [emotions addObject:emotion];
    }
    EaseEmotion *temp = [emotions objectAtIndex:0];
    EaseEmotionManager *managerDefault = [[EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:7 emotions:emotions tagImage:[UIImage imageNamed:temp.emotionId]];
    
    NSMutableArray *emotionGifs = [NSMutableArray array];
    _emotionDic = [NSMutableDictionary dictionary];
    NSArray *names = @[@"icon_002",@"icon_007",@"icon_010",@"icon_012",@"icon_013",@"icon_018",@"icon_019",@"icon_020",@"icon_021",@"icon_022",@"icon_024",@"icon_027",@"icon_029",@"icon_030",@"icon_035",@"icon_040"];
    
    int index = 0;
    for (NSString *name in names) {
        index++;
        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:[NSString stringWithFormat:@"[示例%d]",index] emotionId:[NSString stringWithFormat:@"em%d",(1000 + index)] emotionThumbnail:[NSString stringWithFormat:@"%@_cover",name] emotionOriginal:[NSString stringWithFormat:@"%@",name] emotionOriginalURL:@"" emotionType:EMEmotionGif];
        [emotionGifs addObject:emotion];
        [_emotionDic setObject:emotion forKey:[NSString stringWithFormat:@"em%d",(1000 + index)]];
    }
    EaseEmotionManager *managerGif= [[EaseEmotionManager alloc] initWithType:EMEmotionGif emotionRow:2 emotionCol:4 emotions:emotionGifs tagImage:[UIImage imageNamed:@"icon_002_cover"]];
    
    
    NSMutableArray *emotionmy = [NSMutableArray array];
    //    _emotionDic = [NSMutableDictionary dictionary];
    NSArray *namess = @[@"icon_yunyue_001",@"icon_yunyue_009",@"icon_yunyue_002",@"icon_yunyue_005",@"icon_yunyue_003",@"icon_yunyue_0011",@"icon_yunyue_004",@"icon_yunyue_006",@"icon_yunyue_007",@"icon_yunyue_008"];
    NSArray *names_title = @[@"大笑",@"怒",@"困",@"撇嘴",@"流汗",@"微笑",@"流泪",@"疑问",@"晕",@"再见"];
    NSArray *code_title = @[@"ln1001",@"ln1005",@"ln1002",@"ln1006",@"ln1003",@"ln1007",@"ln1004",@"ln1008",@"ln1009",@"ln1010"];
    int indexx = 0;
    for (NSString *namee in namess) {
        indexx++;
        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:[NSString stringWithFormat:@"%@",names_title[indexx-1]] emotionId:[NSString stringWithFormat:@"%@",code_title[indexx-1]] emotionThumbnail:[NSString stringWithFormat:@"%@",namee] emotionOriginal:[NSString stringWithFormat:@"%@",namee] emotionOriginalURL:@"" emotionType:EMEmotionGif];
        [emotionmy addObject:emotion];
        [_emotionDic setObject:emotion forKey:[NSString stringWithFormat:@"%@",code_title[indexx-1]]];
    }
    EaseEmotionManager *managermy= [[EaseEmotionManager alloc] initWithType:EMEmotionGif emotionRow:2 emotionCol:4 emotions:emotionmy tagImage:[UIImage imageNamed:@"icon_yunyue_0011"]];

    return @[managerDefault];
    //return @[managerDefault,managermy,managerGif];
}

- (BOOL)isEmotionMessageFormessageViewController:(EaseMessageViewController *)viewController
                                    messageModel:(id<IMessageModel>)messageModel
{
    BOOL flag = NO;
    if ([messageModel.message.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
        return YES;
    }
    return flag;
}

- (EaseEmotion*)emotionURLFormessageViewController:(EaseMessageViewController *)viewController
                                      messageModel:(id<IMessageModel>)messageModel
{
    NSString *emotionId = [messageModel.message.ext objectForKey:MESSAGE_ATTR_EXPRESSION_ID];
    EaseEmotion *emotion = [_emotionDic objectForKey:emotionId];
    if (emotion == nil) {
        emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:emotionId emotionThumbnail:@"" emotionOriginal:@"" emotionOriginalURL:@"" emotionType:EMEmotionGif];
    }
    return emotion;
}

- (NSDictionary*)emotionExtFormessageViewController:(EaseMessageViewController *)viewController
                                        easeEmotion:(EaseEmotion*)easeEmotion
{
    return @{MESSAGE_ATTR_EXPRESSION_ID:easeEmotion.emotionId,MESSAGE_ATTR_IS_BIG_EXPRESSION:@(YES)};
}

#pragma mark - EaseMob

#pragma mark - EMClientDelegate

- (void)didLoginFromOtherDevice
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

- (void)didRemovedFromServer
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

#pragma mark - action
// 群组详情
- (void)showGroupDetailAction
{
    [self.view endEditing:YES];
    if (self.conversation.type == 0) {
       
    }
    else if (self.conversation.type == 2)
    {
//        ChatroomDetailViewController *detailController = [[ChatroomDetailViewController alloc] initWithChatroomId:self.conversation.conversationId];
//        [self.navigationController pushViewController:detailController animated:YES];
    }
}



- (void)deleteAllMessages:(id)sender {
    
    if (self.dataArray.count == 0) {
        [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        return;
    }
    
    if ([sender isKindOfClass:[NSNotification class]]) {
        NSString *groupId = (NSString *)[(NSNotification *)sender object];
        BOOL isDelete = [groupId isEqualToString:self.conversation.conversationId];
        if (self.conversation.type != 0 && isDelete) {
            self.messageTimeIntervalTag = -1;
            [self.conversation deleteAllMessages];
            [self.messsagesSource removeAllObjects];
            [self.dataArray removeAllObjects];
            
            [self.tableView reloadData];
            [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        }
    }
    else if ([sender isKindOfClass:[UIButton class]]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:@"是否清空所有聊天记录" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
        [alertView show];
    }
}
/**
 *  转发图片
 *
 *  @param sender sender description
 */
- (void)transpondMenuAction:(id)sender
{
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
       
    }
    self.menuIndexPath = nil;
}
/**
 *  转发视频
 *
 *  @param sender sender description
 */
-(void)forwardingMenuItem:(id)sender{
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        
    }
    self.menuIndexPath = nil;
}
- (void)copyMenuAction:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        pasteboard.string = model.text;
    }
    
    self.menuIndexPath = nil;
}

- (void)deleteMenuAction:(id)sender
{
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        NSMutableIndexSet *indexs = [NSMutableIndexSet indexSetWithIndex:self.menuIndexPath.row];
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObjects:self.menuIndexPath, nil];
        
        [self.conversation deleteMessageWithId:model.message.messageId];
        [self.messsagesSource removeObject:model.message];
        
        if (self.menuIndexPath.row - 1 >= 0) {
            id nextMessage = nil;
            id prevMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row - 1)];
            if (self.menuIndexPath.row + 1 < [self.dataArray count]) {
                nextMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row + 1)];
            }
            if ((!nextMessage || [nextMessage isKindOfClass:[NSString class]]) && [prevMessage isKindOfClass:[NSString class]]) {
                [indexs addIndex:self.menuIndexPath.row - 1];
                [indexPaths addObject:[NSIndexPath indexPathForRow:(self.menuIndexPath.row - 1) inSection:0]];
            }
        }
        
        [self.dataArray removeObjectsAtIndexes:indexs];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
        if ([self.dataArray count] == 0) {
            self.messageTimeIntervalTag = -1;
        }
    }
    
    self.menuIndexPath = nil;
}

#pragma mark - notification
- (void)exitGroup
{
    [self.navigationController popToViewController:self animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)insertCallMessage:(NSNotification *)notification
{
    id object = notification.object;
    if (object) {
        EMMessage *message = (EMMessage *)object;
        [self addMessageToDataSource:message progress:nil];
        [[EMClient sharedClient].chatManager importMessages:@[message]];
    }
}

- (void)handleCallNotification:(NSNotification *)notification
{
    id object = notification.object;
    if ([object isKindOfClass:[NSDictionary class]]) {
        //开始call
        self.isViewDidAppear = NO;
    } else {
        //结束call
        self.isViewDidAppear = YES;
    }
}

#pragma mark - private
- (void)_showMenuViewController:(UIView *)showInView
                   andIndexPath:(NSIndexPath *)indexPath
                    messageType:(EMMessageBodyType)messageType
{
    if (self.menuController == nil) {
        self.menuController = [UIMenuController sharedMenuController];
    }
    
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"delete", @"Delete") action:@selector(deleteMenuAction:)];
    }
    
    if (_copyMenuItem == nil) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"copy", @"Copy") action:@selector(copyMenuAction:)];
    }
    
    if (_transpondMenuItem == nil) {
        _transpondMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"transpond", @"Transpond") action:@selector(transpondMenuAction:)];
    }
    
    if(_forwardingMenuItem==nil){
        _forwardingMenuItem=[[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(forwardingMenuItem:)];
    }
    if (messageType == 1) {
        [self.menuController setMenuItems:@[_copyMenuItem, _deleteMenuItem]];
    } else if (messageType == 2){
        [self.menuController setMenuItems:@[_deleteMenuItem]];
    } else if(messageType == 3){
        [self.menuController setMenuItems:@[_deleteMenuItem]];
    } else {
        [self.menuController setMenuItems:@[_deleteMenuItem]];
    }
    [self.menuController setTargetRect:showInView.frame inView:showInView.superview];
    [self.menuController setMenuVisible:YES animated:YES];

}



- (BOOL)navigationShouldPopOnBackButton {
    return YES;
//    if (self.conversation.type == 0) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    return NO;
}

@end


// UIViewController+BackButtonHandler.m
@implementation UIViewController (BackButtonHandler)

@end

@implementation UINavigationController (ShouldPopOnBackButton)

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    
    if([self.viewControllers count] < [navigationBar.items count]) {
        return YES;
    }
    BOOL shouldPop = YES;
    UIViewController* vc = [self topViewController];
    if([vc respondsToSelector:@selector(navigationShouldPopOnBackButton)]) {
        shouldPop = [vc navigationShouldPopOnBackButton];
    }
    
    if(shouldPop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    } else {
        // 取消 pop 后，复原返回按钮的状态
        for(UIView *subview in [navigationBar subviews]) {
            if(0. < subview.alpha && subview.alpha < 1.) {
                [UIView animateWithDuration:.25 animations:^{
                    subview.alpha = 1.;
                }];
            }
        }
    }
    return NO;
}

@end

