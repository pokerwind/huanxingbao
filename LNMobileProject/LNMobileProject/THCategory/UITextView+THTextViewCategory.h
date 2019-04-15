//
//  UITextView+THTextViewCategory.h
//  TadpoleYun
//
//  Created by iOSMac on 2018/5/16.
//  Copyright © 2018年 iOSMac. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT double UITextView_PlaceholderVersionNumber;
FOUNDATION_EXPORT const unsigned char UITextView_PlaceholderVersionString[];

@interface UITextView (THTextViewCategory)
@property (nonatomic, readonly) UILabel *placeholderLabel;
@property (nonatomic, strong) IBInspectable NSString *placeholder;
@property (nonatomic, strong) NSAttributedString *attributedPlaceholder;
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;
//@property (nonatomic, strong) IBInspectable UIFont *placeholderFont;
+ (UIColor *)defaultPlaceholderColor;

@end
