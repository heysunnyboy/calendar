//
//  ViewController.m
//  calendar
//
//  Created by zhenyong on 2017/3/14.
//  Copyright © 2017年 com.demo. All rights reserved.
//

#import "ViewController.h"
#import "TDCalendarView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    TDCalendarView *view = [[TDCalendarView alloc]init
                            ];
    [self.view addSubview:view];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
