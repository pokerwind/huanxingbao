//
//  DZPropertyPickerView.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/30.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZPropertyPickerView : UIView

@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSString *selectedResults;

@end
