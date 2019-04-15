//
//  GXQKeyBoardView.m
//  链接
//
//  Created by 高盛通 on 15/12/25.
//  Copyright © 2015年 Big Nerd Ranch. All rights reserved.
//

#import "GXQKeyBoardView.h"


@implementation GXQKeyBoardView

- (instancetype)initWithFrame:(CGRect)frame andType:(int)type{
   self =  [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        _txtView=[[UITextView alloc]init];
        _txtView.frame=CGRectMake(10, 5, KScreenWidth-65, 40);
        self.txtView.layer.cornerRadius = 4;
        self.txtView.layer.masksToBounds = YES;
//        [self.txtView becomeFirstResponder];
        self.txtView.delegate = self;
        self.txtView.layer.borderWidth = 1;
        self.txtView.font=[UIFont systemFontOfSize:10];
        self.txtView.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
        self.txtView.font=[UIFont systemFontOfSize:15];
        self.txtView.backgroundColor=[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
        [self addSubview:_txtView];
        
        _btnOK=[[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-50,5, 45, 40)];
        [_btnOK setTitle:@"发送" forState:UIControlStateNormal];
        [_btnOK.layer setCornerRadius:3];
        [_btnOK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnOK.backgroundColor=[UIColor colorWithRed:250/255.0 green:119/255.0 blue:48/255.0 alpha:1];
        [_btnOK addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnOK];
        
        _placeHold = [[UILabel alloc]initWithFrame:CGRectMake(10,3,_txtView.frame.size.width, 30)];
        _placeHold.font=[UIFont systemFontOfSize:15];
        _placeHold.text = @"快来说两句吧！";
        _placeHold.textColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
        [self.txtView addSubview:_placeHold];
    }
    return self;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    _placeHold.hidden = self.txtView.text.length > 0;
}

- (void)textViewDidChange:(UITextView *)textView{
    _placeHold.hidden = textView.text.length>0;
}
-(void)btnClick:(UIButton *)btn{
    [_delegate GXQKeyBoardToReplyTag:1 andText:self.txtView.text];
}
@end
