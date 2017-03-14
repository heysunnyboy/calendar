//
//  TDCalendarView.m
//
//  Created by zhenyong on 2017/3/9.

//

#import "TDCalendarView.h"
// 根据屏幕尺寸计算比例
#define getScaleWidth(x)  x * Screen_Width / 750.0
#define getScaleHeight(x) x * Screen_Height / 1334.0
#define getAbsoluteHeight(x) x.frame.size.height + x.frame.origin.y
#define getAbsoluteWdith(v) v.frame.size.width + v.frame.origin.x
#define Screen_Width [UIScreen mainScreen].bounds.size.width
@implementation TDCalendarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init
{
    self = [super init];
    [self setUI];
    return self;
}
-(void)setUI{
    float y = getScaleWidth(100);
    NSDate *today = [NSDate date];
    self.dateLabel.frame = CGRectMake(0, getScaleWidth(66), Screen_Width, getScaleWidth(26));
    NSInteger curmonth = [TDCommonTool getMonthFromDate:today];
    if (curmonth < 10) {
        self.dateLabel.text = [NSString stringWithFormat:@"%lu年0%lu月",[TDCommonTool getYearFromDate:today],curmonth];
    }else{
        self.dateLabel.text = [NSString stringWithFormat:@"%lu年%lu月",[TDCommonTool getYearFromDate:today],curmonth];
    }
    
    UIButton *lastMonthBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, Screen_Width/2, 40)];
    [lastMonthBtn setTitle:@"上个月" forState:UIControlStateNormal];
    [lastMonthBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    lastMonthBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    lastMonthBtn.tag = 1;
    [lastMonthBtn addTarget:self action:@selector(chooseMonth:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:lastMonthBtn];
   

    UIButton *nextMonthBtn = [[UIButton alloc]initWithFrame:CGRectMake(Screen_Width/2, 20, Screen_Width/2, 40)];
    [nextMonthBtn setTitle:@"下个月" forState:UIControlStateNormal];
    nextMonthBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [nextMonthBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [nextMonthBtn addTarget:self action:@selector(chooseMonth:) forControlEvents:UIControlEventTouchUpInside];
    nextMonthBtn.tag = 2;
    [self addSubview:nextMonthBtn];

    self.scorllView.frame = CGRectMake(0, y, Screen_Width, 0);
    //上个月
    
    UIView *lastMonthView = [self setOneMonthView:[TDCommonTool getMonthOfDate:today isLastMonth:YES]];
    lastMonthView.x = 0;
    lastMonthView.tag = 1;
    [self.dateArr addObject:[TDCommonTool getMonthOfDate:today isLastMonth:YES]];
    [_scorllView addSubview:lastMonthView];
    UIView *curMonthView = [self setOneMonthView:today];
    curMonthView.x = Screen_Width;
    curMonthView.tag = 2;
    [self.dateArr addObject:[TDCommonTool firstDayOfCurrentMonth:today]];
    [_scorllView addSubview:curMonthView];
    UIView *nextMonthView = [self setOneMonthView:[TDCommonTool getMonthOfDate:today isLastMonth:NO]];
    nextMonthView.tag = 3;
    nextMonthView.x = Screen_Width*2;
    [self.dateArr addObject:[TDCommonTool getMonthOfDate:today isLastMonth:NO]];
    [_scorllView addSubview:nextMonthView];
    _scorllView.contentSize = CGSizeMake(Screen_Width*3, curMonthView.height);
    _scorllView.height = curMonthView.height;
    _scorllView.contentOffset = CGPointMake(Screen_Width, 0);
    self.frame = CGRectMake(0, 0, Screen_Width, _scorllView.height+y);
    
    [self addSubview:_dateLabel];
    [self addSubview:_scorllView];
}
-(UIView *)setOneMonthView:(NSDate *)today{
    UIView *dayOfMonthView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 0)];
    //获取今天这个月的第一天星期几
    NSDate *firstDayOfMonth = [TDCommonTool firstDayOfCurrentMonth:today];
    NSUInteger weekday = [TDCommonTool weeklyOrdinality:firstDayOfMonth];
    //获取这个月有多少天
    int daysofMonth = [TDCommonTool daysOfMonthFromDate:firstDayOfMonth];
    //获取上个月有多少天
    int daysofLastMonth = [TDCommonTool daysOfLastMonthFromDate:firstDayOfMonth];
    float w = Screen_Width/7;
    float h = getScaleWidth(106);
    float calendarY = 0;
    int calendarX = 0;
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
    //这个月
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
    //补充下个月
    int nextmonthDays = dayOfMonthView.subviews.count%7;
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
#pragma mark -- event
-(void)chooseMonth:(UIButton *)button{
    //左滑
    //防止用户过于频繁的操作
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *lastTime = [userDefault objectForKey:@"Calendar"];
    if (lastTime&&[[NSDate date] timeIntervalSince1970]*10 - [lastTime integerValue] < 2) {
        return;
    }
    [userDefault setObject:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]*10] forKey:@"Calendar"];
    if (button.tag == 1) {
        _scrollX = self.scorllView.contentOffset.x-Screen_Width;
        [UIView animateWithDuration:0.2 animations:^{
            [self.scorllView setContentOffset:CGPointMake(self.scorllView.contentOffset.x-Screen_Width, 0) animated:NO];
        }];
        
    }else{
        _scrollX = self.scorllView.contentOffset.x+Screen_Width;
        [UIView animateWithDuration:0.2 animations:^{
            [self.scorllView setContentOffset:CGPointMake(self.scorllView.contentOffset.x+Screen_Width, 0) animated:NO];
        }];

    }
    [self reloadCalendarView];
}
#pragma mark --delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //防止用户过于频繁的操作
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *lastTime = [userDefault objectForKey:@"Calendar"];
    if (lastTime&&[[NSDate date] timeIntervalSince1970]*10 - [lastTime integerValue] < 5) {
        return;
    }
    [userDefault setObject:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]*10] forKey:@"Calendar"];
    _scrollX = self.scorllView.contentOffset.x;
    [self reloadCalendarView];
}
-(void)reloadCalendarView{
    for (UIView *view in self.scorllView.subviews) {
        if (view.x == _scrollX) {//获取当前的月份的页面
            NSDate *date = self.dateArr[view.tag-1];
            NSInteger curmonth = [TDCommonTool getMonthFromDate:date];
            if (curmonth < 10) {
                self.dateLabel.text = [NSString stringWithFormat:@"%lu年0%lu月",[TDCommonTool getYearFromDate:date],curmonth];
            }else{
                self.dateLabel.text = [NSString stringWithFormat:@"%lu年%lu月",[TDCommonTool getYearFromDate:date],curmonth];
            }
            
            
            //如果向右滑
            if (view.tag == 3) {
                UIView *subView = [self.scorllView viewWithTag:1];
                [subView removeFromSuperview];
                UIView *subView1 = [self.scorllView viewWithTag:2];
                //则删掉最左边日历，在右边加一页
                subView1.tag = 1;
                view.tag = 2;
                NSDate *nextdate = [TDCommonTool getMonthOfDate:date isLastMonth:NO];
                UIView *nextMonthView = [self setOneMonthView:nextdate];
                nextMonthView.tag = 3;
                nextMonthView.x = view.x+Screen_Width;
                [self.scorllView addSubview:nextMonthView];
                [self.dateArr addObject:nextdate];
                [self.dateArr removeObjectAtIndex:0];
                self.scorllView.contentSize = CGSizeMake(getAbsoluteWdith(nextMonthView), self.scorllView.height);
                
            }else if(view.tag == 1){
                UIView *subView = [self.scorllView viewWithTag:2];
                UIView *subView1 = [self.scorllView viewWithTag:3];
                [subView1 removeFromSuperview];
                //则删掉最右边边日历，在左边加一页
                subView.tag = 3;
                view.tag = 2;
                NSDate *lastdate = [TDCommonTool getMonthOfDate:date isLastMonth:YES];
                UIView *lastMonthView = [self setOneMonthView:lastdate];
                lastMonthView.tag = 1;
                
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
-(UIScrollView *)scorllView{
    if (_scorllView == nil) {
        _scorllView = [UIScrollView new];
        _scorllView.pagingEnabled = YES;
        _scorllView.delegate = self;
    }
    return _scorllView;
}
-(NSMutableArray *)dateArr{
    if (_dateArr == nil) {
        _dateArr = [NSMutableArray array];
    }
    return _dateArr;
}
-(UILabel *)dateLabel{
    if(_dateLabel == nil){
        _dateLabel = [UILabel new];
        _dateLabel.font = [UIFont systemFontOfSize:getScaleWidth(28)];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.textColor = [UIColor hexColorWithString:@"#45A9FC"];
    }
    return _dateLabel;
}

@end
