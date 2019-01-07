//
//  WKBaseDetailViewController.m
//  iOSDemos
//
//  Created by Ke Wang on 2018/10/23.
//  Copyright © 2018年 Ke Wang. All rights reserved.
//

#import "WKBaseDetailViewController.h"

@interface WKBaseDetailViewController ()

@end

@implementation WKBaseDetailViewController


- (instancetype)init {
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNAV];
    
    // Do any additional setup after loading the view.
}

#pragma mark - method

- (void)configureNAV {
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"goBackIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(goBackAction)];
    self.navigationItem.leftBarButtonItem = bar;
    bar.tintColor = [UIColor whiteColor];
}

- (void)goBackAction {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



@end
