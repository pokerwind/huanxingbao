//
//  DateTimePickerView.m
//  CXB
//
//  Created by Tanyfi on 17/6/15.
//  Copyright © 2017年 Tanyfi. All rights reserved.
//

#import "DateTimePickerView.h"
#define k_timerss 0.25
#define screenWith  [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
@interface DateTimePickerView()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSInteger yearRange;
    NSInteger dayRange;
    NSInteger startYear;
    NSInteger selectedYear;
    NSInteger selectedMonth;
    NSInteger selectedDay;
    NSInteger selectedHour;
    NSInteger selectedMinute;
    NSInteger selectedSecond;
    
    NSCalendar *calendar;
    //左边退出按钮
    UIButton *cancelButton;
    //右边的确定按钮
    UIButton *chooseButton;
    NSInteger selectedYear1;
    NSInteger selectedMonth1;
    NSInteger selectedDay1;
    NSInteger selectedHour1;
    NSInteger selectedMinute1;
    NSInteger selectedSecond1;
    
}

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic,strong) NSString *string;
@property (nonatomic, strong) UIView *contentV;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic,assign)BOOL is_gundong;

@end

@implementation DateTimePickerView
- (void)andTimeAction {
    [_timer invalidate];
    _timer = nil;
    self.is_gundong = YES;
}
- (void)setIs_gundong:(BOOL)is_gundong {
    _is_gundong = is_gundong;
    if (_is_gundong) {
        chooseButton.userInteractionEnabled = YES;
        [chooseButton setTitleColor:UIColorFromRGB(0xffffff)
                           forState:UIControlStateNormal];
        chooseButton.backgroundColor = k_THUIColorFromHex(0x81665d);
    }else {
        chooseButton.userInteractionEnabled = NO;
        [chooseButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        chooseButton.backgroundColor = RGBA(224, 218, 215,1);
    }
}
- (void)contentVAction {
    
}
- (instancetype)initWithDateInt:(NSInteger)nian {
    self = [self initWithFrame:CGRectMake(0, 0, k_mainSize.width, k_mainSize.height)];
    if (self) {
        NSCalendar *calendar0 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
        comps = [calendar0 components:unitFlags fromDate:[NSDate date]];
        NSInteger year=[comps year];
        
        startYear = nian;
        yearRange=(year - nian) + 1;
        [self setCurrentDate:[NSDate date]];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.ischaoguodangqianshijian = YES;
        UITapGestureRecognizer *positivetapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideDateTimePickerView)];
        [self addGestureRecognizer:positivetapGesture];
        _timer = [NSTimer scheduledTimerWithTimeInterval:k_timerss target:self selector:@selector(andTimeAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        self.is_gundong = YES;
        
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
//        self.alpha = 0;
        UIView *contentV = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight, screenWith, 520 * k_OnePx + 150 * k_OnePx+ HOME_INDICATOR_HEIGHT)];
        contentV.userInteractionEnabled = YES;
        UITapGestureRecognizer *contentVtapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentVAction)];
        [contentV addGestureRecognizer:contentVtapGesture];
        contentV.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentV];
        self.contentV = contentV;
        
        self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 100 * k_OnePx, [UIScreen mainScreen].bounds.size.width, 440 * k_OnePx)];
        self.pickerView.backgroundColor = [UIColor whiteColor]
        ;
        self.pickerView.dataSource=self;
        self.pickerView.delegate=self;
        
        [contentV addSubview:self.pickerView];
        //盛放按钮的View
        UIView *upVeiw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100 * k_OnePx)];
        [contentV addSubview:upVeiw];
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, k_mainSize.width, 100 * k_OnePx)];
        [self.titleLabel setLabelTextColor:k_THUIColorFromHex(0x333333) font:k_THFont(16)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.text = @"选择日期";
        [upVeiw addSubview:self.titleLabel];
//        //左边的取消按钮
//        cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        cancelButton.frame = CGRectMake(12, 0, 40, 40);
//        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
//        cancelButton.backgroundColor = [UIColor clearColor];
//        cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
//        [cancelButton setTitleColor:UIColorFromRGB(0x9c9c9c) forState:UIControlStateNormal];
//        [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
//        [upVeiw addSubview:cancelButton];
        //右边的确定按钮
        chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        chooseButton.frame = CGRectMake(10, 520 * k_OnePx + 40 * k_OnePx, k_mainSize.width - 20, 90 * k_OnePx);
        [chooseButton setBorderCornerRadius:45 * k_OnePx andBorderWidth:0 andBorderColor:nil];
        [chooseButton setTitle:@"确定" forState:UIControlStateNormal];
        chooseButton.backgroundColor = k_THUIColorFromHex(0x81665d);
        chooseButton.titleLabel.font = k_THFont(15);
        [chooseButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [chooseButton addTarget:self action:@selector(configButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [contentV addSubview:chooseButton];
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cancelButton.frame), 0, screenWith-104, 40)];
        [upVeiw addSubview:_titleL];
        _titleL.textColor = UIColorFromRGB(0x3f4548);
        _titleL.font = [UIFont systemFontOfSize:13];
        _titleL.textAlignment = NSTextAlignmentCenter;
        
        //分割线
//        UIView *splitView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 0.5)];
//        splitView.backgroundColor = RGBA(247, 247, 247, 1);
//        [upVeiw addSubview:splitView];
        
        NSCalendar *calendar0 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
        comps = [calendar0 components:unitFlags fromDate:[NSDate date]];
        NSInteger year=[comps year];
        
        startYear=1920;
        yearRange=(year - startYear) + 1 + 10;

    }
    return self;
}
- (void)setPickerViewMode:(DatePickerViewMode)pickerViewMode {
    _pickerViewMode = pickerViewMode;
}

#pragma mark -- UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.pickerViewMode == DatePickerViewDateTimeMode) {
        return 5;
    }else if (self.pickerViewMode == DatePickerViewDateMode){
        return 3;
    }else if (self.pickerViewMode == DatePickerViewMonthMode){
        return 2;
    }else if (self.pickerViewMode == DatePickerViewTimeMode){
        return 2;
    }
    return 0;
}


//确定每一列返回的东西
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    
    /*
     selectedYear=year;
     selectedMonth=month;
     selectedDay=day;
     selectedHour=hour;
     selectedMinute=minute;
     */
    
    if (self.pickerViewMode == DatePickerViewDateTimeMode) {
        switch (component) {
            case 0:
            {
                if (_ischaoguodangqianshijian == NO) {
                    return yearRange - 10;
                }
                return yearRange;
            }
                break;
            case 1:
            {
                
                if (selectedYear == selectedYear1 && _ischaoguodangqianshijian == NO) {
                    return selectedMonth1;
                }
                return 12;
            }
                break;
            case 2:
            {
                if (selectedYear == selectedYear1 && selectedMonth == selectedMonth1 && _ischaoguodangqianshijian == NO) {
                    return selectedDay1;
                }
                return dayRange;
            }
                break;
            case 3:
            {
                if (selectedYear == selectedYear1 && selectedMonth == selectedMonth1 &&selectedDay == selectedDay1 && _ischaoguodangqianshijian == NO) {
                    return selectedHour1 + 1;
                }
                return 24;
            }
                break;
            case 4:
            {
                if (selectedYear == selectedYear1 && selectedMonth == selectedMonth1 &&selectedDay == selectedDay1&&selectedHour == selectedHour1 && _ischaoguodangqianshijian == NO) {
                    return selectedMinute1 + 1;
                }
                return 60;
            }
                break;
                
            default:
                break;
        }
    }else if (self.pickerViewMode == DatePickerViewDateMode){
        switch (component) {
            case 0:
            {
                if (_ischaoguodangqianshijian == NO) {
                    return yearRange - 10;
                }
                return yearRange;
            }
                break;
            case 1:
            {
                if (selectedYear == selectedYear1 && _ischaoguodangqianshijian == NO) {
                    return selectedMonth1;
                }
                return 12;
            }
                break;
            case 2:
            {
                if (selectedYear == selectedYear1 && selectedMonth == selectedMonth1 && _ischaoguodangqianshijian == NO) {
                    return selectedDay1;
                }
                return dayRange;
            }
                break;
    
            default:
                break;
        }
    }else if (self.pickerViewMode == DatePickerViewMonthMode) {
        switch (component) {
            case 0:
            {
                if (_ischaoguodangqianshijian == NO) {
                    return yearRange - 10;
                }
                return yearRange;
            }
                break;
            case 1:
            {
                if (selectedYear == selectedYear1 && _ischaoguodangqianshijian == NO) {
                    return selectedMonth1;
                }
                return 12;
            }
                break;
            default:
                break;
        }
    }else if (self.pickerViewMode == DatePickerViewTimeMode){
        switch (component) {
            
            case 0:
            {
                return 24;
            }
                break;
            case 1:
            {
                return 60;
            }
                break;
                
            default:
                break;
        }
    }
    
    return 0;
}

#pragma mark -- UIPickerViewDelegate
//默认时间的处理
-(void)setCurrentDate:(NSDate *)currentDate
{
    //获取当前时间
    NSCalendar *calendar0 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    comps = [calendar0 components:unitFlags fromDate:currentDate];
    NSInteger year=[comps year];
    NSInteger month=[comps month];
    NSInteger day=[comps day];
    NSInteger hour=[comps hour];
    NSInteger minute=[comps minute];
    
    selectedYear1=year;
    selectedMonth1=month;
    selectedDay1=day;
    selectedHour1=hour;
    selectedMinute1=minute;
    
    
    selectedYear=year;
    selectedMonth=month;
    selectedDay=day;
    selectedHour=hour;
    selectedMinute=minute;
    
    dayRange=[self isAllDay:year andMonth:month];
    
    if (self.pickerViewMode == DatePickerViewDateTimeMode) {
        [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
        [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
        [self.pickerView selectRow:day-1 inComponent:2 animated:NO];
        [self.pickerView selectRow:hour inComponent:3 animated:NO];
        [self.pickerView selectRow:minute inComponent:4 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
        [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
        [self pickerView:self.pickerView didSelectRow:day-1 inComponent:2];
        [self pickerView:self.pickerView didSelectRow:hour inComponent:3];
        [self pickerView:self.pickerView didSelectRow:minute inComponent:4];
        
        
    }else if (self.pickerViewMode == DatePickerViewDateMode){
        [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
        [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
        [self.pickerView selectRow:day-1 inComponent:2 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
        [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
        [self pickerView:self.pickerView didSelectRow:day-1 inComponent:2];
    }else if (self.pickerViewMode == DatePickerViewMonthMode){
        
        [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
        [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
        [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
        
        
    }else if (self.pickerViewMode == DatePickerViewTimeMode){
        [self.pickerView selectRow:hour inComponent:0 animated:NO];
        [self.pickerView selectRow:minute inComponent:1 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:hour inComponent:0];
        [self pickerView:self.pickerView didSelectRow:minute inComponent:1];
    }

    [self.pickerView reloadAllComponents];
}


-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
//    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(screenWith*component/6.0, 0,screenWith/6.0, 30)];
//    label.font=[UIFont systemFontOfSize:15.0];
//    label.tag=component*100+row;
//    label.textAlignment=NSTextAlignmentCenter;
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:k_timerss target:self selector:@selector(andTimeAction) userInfo:nil repeats:YES];
    }else {
        [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:k_timerss]];
    }
    if (self.is_gundong) {
        self.is_gundong = NO;
    }
    UILabel* label = (UILabel*)view;
    if (!label){
        label = [[UILabel alloc] init];
        label.adjustsFontSizeToFitWidth = YES;
        label.textAlignment = NSTextAlignmentCenter;
        [label setBackgroundColor:[UIColor clearColor]];
//        [label setFont:k_THBoldFont(20)];
        label.textColor = k_THUIColorFromHex(0x81665D);
    }
    if (self.pickerViewMode == DatePickerViewDateTimeMode) {
        switch (component) {
            case 0:
            {
                label.text=[NSString stringWithFormat:@"%02ld年",(long)(startYear + row)];
            }
                break;
            case 1:
            {
                label.text=[NSString stringWithFormat:@"%02ld月",(long)row+1];
            }
                break;
            case 2:
            {

                label.text=[NSString stringWithFormat:@"%02ld日",(long)row+1];
            }
                break;
            case 3:
            {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%02ld时",(long)row];
            }
                break;
            case 4:
            {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%02ld分",(long)row];
            }
                break;
            case 5:
            {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%02ld秒",(long)row];
            }
                break;
                
            default:
                break;
        }
    }else if (self.pickerViewMode == DatePickerViewDateMode){
        switch (component) {
            case 0:
            {
                label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
            }
                break;
            case 1:
            {
                label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
            }
                break;
            case 2:
            {
                label.text=[NSString stringWithFormat:@"%ld日",(long)row+1];
            }
                break;
                
            default:
                break;
        }
    }else if (self.pickerViewMode == DatePickerViewMonthMode){
        switch (component) {
            case 0:
            {
                label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
            }
                break;
            case 1:
            {
                label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
            }
                break;
                
            default:
                break;
        }
    }else if (self.pickerViewMode == DatePickerViewTimeMode){
        switch (component) {
            case 0:
            {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld时",(long)row];
            }
                break;
            case 1:
            {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld分",(long)row];
            }
                break;
                
            default:
                break;
        }
    }
    
    return label;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (self.pickerViewMode == DatePickerViewDateTimeMode) {
        return ([UIScreen mainScreen].bounds.size.width-40)/5;
    }else if (self.pickerViewMode == DatePickerViewDateMode){
        return ([UIScreen mainScreen].bounds.size.width-40)/3;
    }else if (self.pickerViewMode == DatePickerViewMonthMode) {
        return ([UIScreen mainScreen].bounds.size.width-40)/2;
    }else if (self.pickerViewMode == DatePickerViewTimeMode){
        return ([UIScreen mainScreen].bounds.size.width-40)/2;
    }
    return 0;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}
// 监听picker的滑动
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.pickerViewMode == DatePickerViewDateTimeMode) {
        switch (component) {
            case 0:
            {
                selectedYear=startYear + row;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 1:
            {
                selectedMonth=row+1;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 2:
            {
                selectedDay=row+1;
            }
                break;
            case 3:
            {
                selectedHour=row;
            }
                break;
            case 4:
            {
                selectedMinute=row;
            }
                break;
                
            default:
                break;
        }
        [self.pickerView reloadAllComponents];
        _string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld",selectedYear,selectedMonth,selectedDay,selectedHour,selectedMinute];
    }else if (self.pickerViewMode == DatePickerViewDateMode){
        switch (component) {
            case 0:
            {
                selectedYear=startYear + row;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:1];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 1:
            {
                selectedMonth=row+1;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 2:
            {
                selectedDay=row+1;
            }
                break;
                
            default:
                break;
        }
        
        _string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld",selectedYear,selectedMonth,selectedDay];
    }else if (self.pickerViewMode == DatePickerViewMonthMode) {
        switch (component) {
            case 0:
            {
                selectedYear=startYear + row;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:1];
            }
                break;
            case 1:
            {
                selectedMonth=row+1;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:1];
            }
                break;
            default:
                break;
        }
        _string =[NSString stringWithFormat:@"%ld-%.2ld",selectedYear,selectedMonth];
    }
    else if (self.pickerViewMode == DatePickerViewTimeMode){
        switch (component) {
            case 0:
            {
                selectedHour=row;
            }
                break;
            case 1:
            {
                selectedMinute=row;
            }
                break;
                
            default:
                break;
        }
        
        _string =[NSString stringWithFormat:@"%.2ld:%.2ld",selectedHour,selectedMinute];
    }
    
    
}



#pragma mark -- show and hidden
- (void)showDateTimePickerView{
//    [self setCurrentDate:[NSDate date]];
    self.frame = CGRectMake(0, 0, screenWith, screenHeight);
    [UIView animateWithDuration:0.4f animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
        self.contentV.frame = CGRectMake(0, screenHeight-(520 * k_OnePx + 150 * k_OnePx+ HOME_INDICATOR_HEIGHT), screenWith, 520 * k_OnePx + 150 * k_OnePx + HOME_INDICATOR_HEIGHT);

    } completion:^(BOOL finished) {

    }];
}
- (void)hideDateTimePickerView{
    
    [UIView animateWithDuration:0.4f animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0.0);
        self.contentV.frame = CGRectMake(0, screenHeight, screenWith, 520 * k_OnePx + 150 * k_OnePx+ HOME_INDICATOR_HEIGHT);
    } completion:^(BOOL finished) {

        self.frame = CGRectMake(0, screenHeight, screenWith, screenHeight);
    }];

}
#pragma mark - private
//取消的隐藏
- (void)cancelButtonClick
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didClickCancelDateTimePickerView)]) {
        [self.delegate didClickCancelDateTimePickerView];
    }
    
    [self hideDateTimePickerView];
    
}

//确认的隐藏
-(void)configButtonClick
{
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didClickFinishDateTimePickerView:)]) {
        [self.delegate didClickFinishDateTimePickerView:_string];
    }
    if (self.block) {
        self.block(_string);
    }
    [self hideDateTimePickerView];
}

-(NSInteger)isAllDay:(NSInteger)year andMonth:(NSInteger)month
{
    int day=0;
    switch(month)
    {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            day=31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            day=30;
            break;
        case 2:
        {
            if(((year%4==0)&&(year%100!=0))||(year%400==0))
            {
                day=29;
                break;
            }
            else
            {
                day=28;
                break;
            }
        }
        default:
            break;
    }
    return day;
}


//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self hideDateTimePickerView];
//}

@end
