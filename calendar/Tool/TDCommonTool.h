//
//  TDCommonTool.h
//
//  Created by zhenyong on 2017/3/7.

//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TDCommonTool : NSObject
ine(float y);

#pragma mark-- 时间转换
//字符串转nsdate
+(NSDate *)getDateFromString:(NSString *)time;
//nsdate 转字符串
+(NSString *)getStringFromDate:(NSDate *)date;
#pragma mark--日历
/** 某个月的第一天 */
+ (NSDate *)firstDayOfCurrentMonth:(NSDate *)date;
/** 获取第一天星期几 */
+ (NSUInteger)weeklyOrdinality:(NSDate *)date;
/** 获取一个月多少天 */
+(int)daysOfMonthFromDate:(NSDate *)date;
/** 获取上个月多少天 */
+(int)daysOfLastMonthFromDate:(NSDate *)date;
/*
 *
 获取上个月或者下个月的nsdate
 */
+(NSDate *)getMonthOfDate:(NSDate *)date isLastMonth:(BOOL)isLastMonth;
/** 获取年 */
+(NSInteger )getYearFromDate:(NSDate *)date;
/** 获取月 */
+(NSInteger )getMonthFromDate:(NSDate *)date;
@end
