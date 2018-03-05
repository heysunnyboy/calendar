//
//  TDCalendarView.m
//
//  Created by zhenyong on 2017/3/9.

//

#import "TDCalendarView.h"
// 根据屏幕尺寸计算比例
#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height
#define getScaleWidth(x)  x * Screen_Width / 750.0
#define getScaleHeight(x) x * Screen_Height / 1334.0
#define getAbsoluteHeight(x) x.frame.size.height + x.frame.origin.y
#define getAbsoluteWdith(v) v.frame.size.width + v.frame.origin.x

/// 防止操作频繁
static NSString *calendarOperationKey = @"calendarOperationKey";

typedef NS_ENUM(NSUInteger, CalendarPage) {
    CalendarPageLast           = 1,
    CalendarPageCurrent        = 2,
    CalendarPageNext           = 3,
};
typedef NS_ENUM(NSUInteger, ClickCalendarPage) {
    ClickCalendarPageLast        = 1,
    ClickCalendarPageNext        = 2,
};
@implementation TDCalendarView

- (instancetype)init
{
    if (self = [super init]) {
        [self setUI];
    }
    return self;
}
- (void)setUI {
    NSDate *today = [NSDate date];
    self.dateLabel.frame = CGRectMake(0, getScaleWidth(66), Screen_Width, getScaleWidth(26));
    self.dateLabel.text  = [self getYearStringByDate:today];
    /// 创建点击切换月份的按钮
    [self createClickCalendarPageButtonByTag:ClickCalendarPageLast];
    [self createClickCalendarPageButtonByTag:ClickCalendarPageNext];
    /// 创建前中后三个月
    [self createMonthViewByPage:CalendarPageLast];
    [self createMonthViewByPage:CalendarPageCurrent];
    [self createMonthViewByPage:CalendarPageNext];
    //
    [self addSubview:_dateLabel];
    [self addSubview:_scorllView];
}
- (UIView *)setOneMonthView:(NSDate *)today {
    UIView *dayOfMonthView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 0)];
    //获取今天这个月的第一天星期几
    NSDate *firstDayOfMonth = [TDCommonTool firstDayOfCurrentMonth:today];
    NSUInteger weekday      = [TDCommonTool weeklyOrdinality:firstDayOfMonth];
    //获取这个月有多少天
    NSInteger daysofMonth     = [TDCommonTool daysOfMonthFromDate:firstDayOfMonth];
    //获取上个月有多少天
    NSInteger daysofLastMonth = [TDCommonTool daysOfLastMonthFromDate:firstDayOfMonth];
    float w = Screen_Width / 7;
    float h = getScaleWidth(106);
    float calendarY = 0;
    float calendarX = 0;
    //加上上个月
    for (int i = 1; i < weekday; i++) {
        UILabel * day = [[UILabel alloc]initWithFrame:CGRectMake(w*calendarX, 0, w, h)];
        day.text = [NSString stringWithFormat:@"%lu",daysofLastMonth-(weekday-1)+i];
        day.textAlignment = NSTextAlignmentCenter;
        day.textColor = [UIColor hexColorWithString:@"#45A9FC"];
        day.alpha = 0.5;
        day.font = [UIFont systemFontOfSize:getScaleWidth(30)];
        [dayOfMonthView addSubview:day];
        calendarX++;
    }
    /// 这个月
    for (int i = 1; i <= daysofMonth; i++) {
        UILabel * day = [[UILabel alloc]initWithFrame:CGRectMake(w*calendarX, calendarY, w, h)];
        day.text = [NSString stringWithFormat:@"%d",i];
        day.textColor = [UIColor hexColorWithString:@"#45A9FC"];
        day.textAlignment = NSTextAlignmentCenter;
        day.font = [UIFont systemFontOfSize:getScaleWidth(30)];
        [dayOfMonthView addSubview:day];
        if (calendarX == 6) {
            calendarY += h;
            calendarX = 0;
        }else{
            calendarX++;
        }
    }
    /// 补充下个月
    NSInteger nextmonthDays = dayOfMonthView.subviews.count%7;
    for (int i = 1; i <= 7-nextmonthDays;i++){
        UILabel * day = [[UILabel alloc]initWithFrame:CGRectMake(w*calendarX, calendarY, w, h)];
        day.textColor = [UIColor hexColorWithString:@"#45A9FC"];
        day.alpha = 0.5;
        day.text = [NSString stringWithFormat:@"%d",i];
        day.textAlignment = NSTextAlignmentCenter;
        day.font = [UIFont systemFontOfSize:getScaleWidth(30)];
        [dayOfMonthView addSubview:day];
        calendarX++;
    }
    //添加subview
    dayOfMonthView.height = calendarY+w;
    return dayOfMonthView;
}
/// 判断用户是否操作频繁
- (BOOL)isOperatingFrequency {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *lastTime = [userDefault objectForKey:calendarOperationKey];
    [userDefault setObject:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 10] forKey:calendarOperationKey];
    if (lastTime && [[NSDate date] timeIntervalSince1970] * 10 - [lastTime integerValue] < 2) {
        return YES;
    }
    return NO;
}
/// 获取年月
- (NSString *)getYearStringByDate:(NSDate *)date {
    NSInteger curmonth = [TDCommonTool getMonthFromDate:date];
    if (curmonth < 10) {
        return [NSString stringWithFormat:@"%lu年0%lu月",[TDCommonTool getYearFromDate:date],curmonth];
    }
    return [NSString stringWithFormat:@"%lu年%lu月",[TDCommonTool getYearFromDate:date],curmonth];
}
/// 创建点击上下月的按钮
- (void)createClickCalendarPageButtonByTag:(ClickCalendarPage)tag {
    NSString *titleString = tag == ClickCalendarPageLast ? @"上个月" : @"下个月";
    float btnX = tag == ClickCalendarPageLast ? 0 : Screen_Width / 2;
    UIButton *clickMonthBtn = [[UIButton alloc]initWithFrame:CGRectMake(btnX, 20, Screen_Width / 2, 40)];
    [clickMonthBtn setTitle:titleString
                  forState:UIControlStateNormal];
    [clickMonthBtn setTitleColor:[UIColor redColor]
                       forState:UIControlStateNormal];
    clickMonthBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    clickMonthBtn.tag = tag;
    [clickMonthBtn addTarget:self action:@selector(chooseMonth:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:clickMonthBtn];
}
/// 先创建3个月的view
- (void)createMonthViewByPage:(CalendarPage)page {
    NSDate *today     = [NSDate date];
    NSDate *monthDate;
    switch (page) {
        case CalendarPageLast:
        {
            monthDate = [TDCommonTool getMonthOfDate:today isLastMonth:YES];
        }
            break;
        case CalendarPageCurrent:
        {
            monthDate = [TDCommonTool firstDayOfCurrentMonth:today];
        }
            break;
        case CalendarPageNext:
        {
            monthDate = [TDCommonTool getMonthOfDate:today isLastMonth:NO];
        }
            break;
        default:
            break;
    }
    UIView *monthView = [self setOneMonthView:monthDate];
    monthView.x   = Screen_Width *(page - 1);
    monthView.tag = page;
    [self.dateArr addObject:monthDate];
    [self.scorllView addSubview:monthView];
    /// 重置高度
    if (page == CalendarPageCurrent) {
        self.scorllView.contentSize = CGSizeMake(Screen_Width * 3, monthView.height);
        self.scorllView.height      = monthView.height;
        self.scorllView.contentOffset = CGPointMake(Screen_Width, 0);
        self.frame = CGRectMake(0, 0, Screen_Width, _scorllView.height + getScaleHeight(100));
    }
}


#pragma mark -- event
- (void)chooseMonth:(UIButton *)button {
    //防止用户过于频繁的操作
    if ([self isOperatingFrequency]) {
        return;
    }
    switch (button.tag) {
        case ClickCalendarPageLast:
        {
            _scrollX = self.scorllView.contentOffset.x-Screen_Width;
            [UIView animateWithDuration:0.2 animations:^{
                [self.scorllView setContentOffset:CGPointMake(self.scorllView.contentOffset.x-Screen_Width, 0) animated:NO];
            }];
        }
            break;
        case ClickCalendarPageNext:
        {
            _scrollX = self.scorllView.contentOffset.x+Screen_Width;
            [UIView animateWithDuration:0.2 animations:^{
                [self.scorllView setContentOffset:CGPointMake(self.scorllView.contentOffset.x+Screen_Width, 0) animated:NO];
            }];

        }
            break;
        default:
            break;
    }
    [self reloadCalendarView];
}
#pragma mark --delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //防止用户过于频繁的操作
    if ([self isOperatingFrequency]) {
        return;
    }
    _scrollX = self.scorllView.contentOffset.x;
    [self reloadCalendarView];
}
- (void)reloadCalendarView {
    for (UIView *view in self.scorllView.subviews) {
        if (view.x == _scrollX) {//获取当前的月份的页面
            NSDate *date = self.dateArr[view.tag-1];
            self.dateLabel.text = [self getYearStringByDate:date];
            
            //如果向右滑
            if (view.tag == CalendarPageNext) {
                UIView *subView = [self.scorllView viewWithTag:CalendarPageLast];
                [subView removeFromSuperview];
                UIView *subView1 = [self.scorllView viewWithTag:CalendarPageCurrent];
                //则删掉最左边日历，在右边加一页
                subView1.tag = CalendarPageLast;
                view.tag     = CalendarPageCurrent;
                NSDate *nextdate = [TDCommonTool getMonthOfDate:date isLastMonth:NO];
                UIView *nextMonthView = [self setOneMonthView:nextdate];
                nextMonthView.tag = 3;
                nextMonthView.x = view.x+Screen_Width;
                [self.scorllView addSubview:nextMonthView];
                [self.dateArr addObject:nextdate];
                [self.dateArr removeObjectAtIndex:0];
                self.scorllView.contentSize = CGSizeMake(getAbsoluteWdith(nextMonthView), self.scorllView.height);
                
            }else if(view.tag == CalendarPageLast){
                UIView *subView = [self.scorllView viewWithTag:CalendarPageCurrent];
                UIView *subView1 = [self.scorllView viewWithTag:CalendarPageNext];
                [subView1 removeFromSuperview];
                //则删掉最右边边日历，在左边加一页
                subView.tag = CalendarPageNext;
                view.tag = CalendarPageCurrent;
                NSDate *lastdate = [TDCommonTool getMonthOfDate:date isLastMonth:YES];
                UIView *lastMonthView = [self setOneMonthView:lastdate];
                lastMonthView.tag = CalendarPageLast;
                [self.scorllView addSubview:lastMonthView];
                [self.dateArr removeObjectAtIndex:2];
                [self.dateArr insertObject:lastdate atIndex:0];
                view.x = Screen_Width;
                lastMonthView.x = 0;
                subView.x = Screen_Width*2;
                [self.scorllView setContentOffset:CGPointMake(Screen_Width, 0)];
                _scrollX = Screen_Width;
            }
        }
    }

}
#pragma mark -- lazy
- (UIScrollView *)scorllView {
    if (_scorllView == nil) {
        _scorllView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, getScaleHeight(100), Screen_Width, 0)];
        _scorllView.pagingEnabled = YES;
        _scorllView.delegate = self;
    }
    return _scorllView;
}
- (NSMutableArray *)dateArr {
    if (_dateArr == nil) {
        _dateArr = [NSMutableArray array];
    }
    return _dateArr;
}
- (UILabel *)dateLabel {
    if(_dateLabel == nil){
        _dateLabel = [UILabel new];
        _dateLabel.font = [UIFont systemFontOfSize:getScaleWidth(28)];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.textColor = [UIColor hexColorWithString:@"#45A9FC"];
    }
    return _dateLabel;
}

@end
