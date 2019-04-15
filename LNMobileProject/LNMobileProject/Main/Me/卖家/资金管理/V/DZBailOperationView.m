//
//  DZBailOperationView.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/25.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZBailOperationView.h"

@interface DZBailOperationView ()

@end

@implementation DZBailOperationView

- (IBAction)addButtonAction {
    NSInteger i = [self.moneyLabel.text integerValue];
    i = i + 1000;
    self.moneyLabel.text = [NSString stringWithFormat:@"%ld", i];
}

- (IBAction)subtractButtonAction {
    NSInteger i = [self.moneyLabel.text integerValue];
    if (i > 0) {
        i = i - 1000;
        self.moneyLabel.text = [NSString stringWithFormat:@"%ld", i];
    }
}

- (IBAction)submitButtonAction {
    
}

@end
