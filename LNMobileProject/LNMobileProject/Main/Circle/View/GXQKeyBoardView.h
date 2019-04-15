//
//  GXQKeyBoardView.h
//  链接
//
//  Created by 高盛通 on 15/12/25.
//  Copyright © 2015年 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GXQKeyBoardDelegate <NSObject>

-(void)GXQKeyBoardToReplyTag:(int)tag andText:(NSString *)text;

@end
@interface GXQKeyBoardView : UIView<UITextViewDelegate>
@property (nonatomic, strong) UIView *toolView;
@property (nonatomic, strong) UITextView *txtView;
@property(nonatomic,strong) UIButton *btnOK;
@property(nonatomic,strong)    UILabel *placeHold;
@property (nonatomic,weak)id<GXQKeyBoardDelegate>delegate;

- (id)initWithFrame:(CGRect)frame andType:(int)type;
@end
