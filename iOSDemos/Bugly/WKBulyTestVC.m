//
//  WKBulyTestVC.m
//  iOSDemos
//
//  Created by Ke Wang on 2018/9/29.
//  Copyright © 2018年 Ke Wang. All rights reserved.
//

#import "WKBulyTestVC.h"

@interface WKBulyTestVC ()

@end

@implementation WKBulyTestVC

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSArray *array = @[@"1", @"2"];
    array[5];
}


@end
