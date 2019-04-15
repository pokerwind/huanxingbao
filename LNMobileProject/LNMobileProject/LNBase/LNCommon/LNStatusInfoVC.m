/**
 * Copyright (c) 山东六牛网络科技有限公司 https://liuniukeji.com
 *
 * @Description
 * @Author         yulianbo   tel:  15269966441
 * @Copyright      Copyright (c) 山东六牛网络科技有限公司 保留所有版权(https://www.liuniukeji.com)
 * @Date
 * @IDE/Editor
 * @Modified By
 */

#import "LNStatusInfoVC.h"
//#import "DoubleTitleNavigationBar.h"

@interface LNStatusInfoVC ()

@end

@implementation LNStatusInfoVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.removeIndex = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBar];
    if (self.statusInfo) {
        self.statusInfoLabel.text = self.statusInfo;
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSArray *array = self.navigationController.viewControllers;
    NSMutableArray *muArray = [NSMutableArray arrayWithArray:array];
    for (NSInteger i = self.removeIndex; i > 0; i--) {
        [muArray removeObjectAtIndex:muArray.count - 2];
    }
    
    self.navigationController.viewControllers = [muArray copy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNavigationBar{
    
//    DoubleTitleNavigationBar *navBar = [DoubleTitleNavigationBar viewFormNib];
//    navBar.navigationController = self.navigationController;
//    navBar.titleLabel.text = @"完成信息";
//    navBar.leftButton.hidden = YES;
//     [self.navigationItem setHidesBackButton:YES];
//    [navBar.rightButton setTitle:@"完成" forState:UIControlStateNormal];
//    [navBar.rightButton addTarget:self action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
//    [navBar.rightButton setImage:nil forState:UIControlStateNormal];
//    self.navigationItem.titleView = navBar;
    
}

- (void)complete {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
