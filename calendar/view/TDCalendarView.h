//
//  TDCalendarView.h
//
//  Created by zhenyong on 2017/3/9.

//
#import "TDCommonTool.h"
#import <UIKit/UIKit.h>
#import "UIView+Frame.h"
#import "UIColor+Extend.h"
@interface TDCalendarView : UIView<UIScrollViewDelegate>
/** 日历 - 列表 */
@property (strong , nonatomic) UIScrollView *scorllView;
/** 日历 - date数组 */
@property (strong , nonatomic) NSMutableArray *dateArr;
/** 日历 - 月份 */
@property (strong , nonatomic) UILabel *dateLabel;
/** 日历 - 滑动x坐标*/
@property (assign , nonatomic) float scrollX;
@end
