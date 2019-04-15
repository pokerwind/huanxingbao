//
//  DateTimePickerView.h
//  CXB
//
//  Created by Tanyfi on 17/6/15.
//  Copyright © 2017年 Tanyfi. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DatePickerViewDateTimeMode,//年月日,时分
    DatePickerViewDateMode,//年月日
    DatePickerViewMonthMode,//年月
    DatePickerViewTimeMode//时分
} DatePickerViewMode;

@protocol DateTimePickerViewDelegate <NSObject>
@optional
/**
 * 确定按钮
 */
-(void)didClickFinishDateTimePickerView:(NSString*)date;
/**
 * 取消按钮
 */
-(void)didClickCancelDateTimePickerView;

@end


@interface DateTimePickerView : UIView

/**
 * 设置当前时间
 */
@property(nonatomic, strong)NSDate*currentDate;
/**
 * 设置中心标题文字
 */
@property(nonatomic, strong)UILabel *titleL;
@property(nonatomic,assign) BOOL ischaoguodangqianshijian;

@property(nonatomic, strong)id<DateTimePickerViewDelegate>delegate;
/**
 * 模式
 */
@property (nonatomic, assign) DatePickerViewMode pickerViewMode;

@property(nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,copy) void(^block) (NSString *date);

- (instancetype)initWithDateInt:(NSInteger)nian;
/**
 * 掩藏
 */
- (void)hideDateTimePickerView;
/**
 * 显示
 */
- (void)showDateTimePickerView;


@end

