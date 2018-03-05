//
//  TDCommonTool.m

//
//  Created by zhenyong on 2017/3/7.

//

#import "TDCommonTool.h"

@implementation TDCommonTool
//获取分割线

#pragma mark--字符串nsdate时间转换
//字符串转nsdate
+(NSDate *)getDateFromString:(NSString *)time{
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];//东八区时间
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //NSString转NSDate
    NSDate *date=[formatter dateFromString:time];
    //时区转换，取得系统时区，取得格林威治时间差秒
    return date;
}
//nsdate 转字符串
+(NSString *)getStringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];//东八区时间
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    return currentDateString;
}
#pragma mark --日历数据处理
/** 某个月的第一天 */
+ (NSDate *)firstDayOfCurrentMonth:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];//东八区时间
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear=[[formatter stringFromDate:date] integerValue];
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth=[[formatter stringFromDate:date]integerValue];
    NSDate *monthDate = [TDCommonTool getDateFromString:[NSString stringWithFormat:@"%lu-%lu-01",currentYear,currentMonth]];
    //时区转换，取得系统时区，取得格林威治时间差秒
    NSTimeInterval  timeZoneOffset=[[NSTimeZone systemTimeZone] secondsFromGMT];
//    NSLog(@"%f",timeZoneOffset/60.0/60.0);
    
    monthDate = [monthDate dateByAddingTimeInterval:timeZoneOffset];
    return monthDate;
    
}
/** 获取第一天星期几 */
+ (NSUInteger)weeklyOrdinality:(NSDate *)date

{
   
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:date];
}
/** 获取一个月多少天 */
+(int)daysOfMonthFromDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];//东八区时间
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear=[[formatter stringFromDate:date] integerValue];
    [formatter setDateFormat:@"MM"];
    
    NSInteger currentMonth=[[formatter stringFromDate:date]integerValue];
    if (currentMonth == 1 || currentMonth == 3 || currentMonth == 5 || currentMonth == 7 || currentMonth == 8 || currentMonth == 10 || currentMonth == 12) {
        return 31;
    }
    if (currentMonth == 2) {
        if (currentYear % 4 == 0) {
            return 29;
        }
        return 28;
    }
    return 30;
}
/** 获取上个月多少天 */
+(int)daysOfLastMonthFromDate:(NSDate *)date{
    return [TDCommonTool daysOfMonthFromDate:[TDCommonTool getMonthOfDate:date isLastMonth:YES]];
}
/*
 *
 获取上个月或者下个月的nsdate
 */
+ (NSDate *)getMonthOfDate:(NSDate *)date isLastMonth:(BOOL)isLastMonth{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];//东八区时间
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear=[[formatter stringFromDate:date] integerValue];
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth=[[formatter stringFromDate:date]integerValue];
    NSInteger month = 0;
    NSInteger year = 0;
    if (isLastMonth) {
        if (currentMonth == 1) {
            month = 12;
            year = currentYear-1;
        }else{
            year = currentYear;
            month = currentMonth-1;
        }
    }else{
        if (currentMonth == 12) {
            month = 1;
            year = currentYear+1;
        }else{
            year = currentYear;
            month = currentMonth+1;
        }

    }
    NSDate *monthDate = [TDCommonTool getDateFromString:[NSString stringWithFormat:@"%lu-%lu-01",year,month]];
    //时区转换，取得系统时区，取得格林威治时间差秒
    NSTimeInterval  timeZoneOffset=[[NSTimeZone systemTimeZone] secondsFromGMT];
//    NSLog(@"%f",timeZoneOffset/60.0/60.0);
    
    monthDate = [monthDate dateByAddingTimeInterval:timeZoneOffset];
    return monthDate;
}
+ (NSInteger )getYearFromDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];//东八区时间
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear = [[formatter stringFromDate:date] integerValue];
    return currentYear;
    
}
+ (NSInteger )getMonthFromDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];//东八区时间
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth=[[formatter stringFromDate:date]integerValue];
    return currentMonth;
    
}
@end
