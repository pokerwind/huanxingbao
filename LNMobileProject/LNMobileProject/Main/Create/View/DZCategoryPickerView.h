//
//  DZCategoryPickerView.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/29.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZGetCategoryListModel.h"

@interface DZCategoryPickerView : UIView

@property (strong, nonatomic) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (strong, nonatomic) DZCategoryListModel *selectedModel;
@property (weak, nonatomic) IBOutlet UIPickerView *leftPickerView;

@end
