//
//  UIColor+Extend.h
//

//  Copyright © 2016年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extend)
+ (UIColor *)hexColorWithString:(NSString *)string;
+ (UIColor *)hexColorWithString:(NSString *)string alpha:(float) alpha;
@end
