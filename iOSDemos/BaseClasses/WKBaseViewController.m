//
//  WKBaseViewController.m
//  iOSDemos
//
//  Created by Ke Wang on 2018/10/22.
//  Copyright © 2018年 Ke Wang. All rights reserved.
//

#import "WKBaseViewController.h"

@interface WKBaseViewController ()

@end

@implementation WKBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
}

- (void)configureUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

#pragma mark - baseConfigure


- (void)configureRightItemsWithItemNameArray:(NSArray <NSString *> *)itemNameArray actionNameArray:(NSArray <NSString *> *)actionNameArray {
    if (itemNameArray.count != actionNameArray.count) { //!< 保证名字和方法一一对应
        return;
    }
    NSMutableArray <UIBarButtonItem *>*barItems = @[].mutableCopy;
    for (NSUInteger i = 0; i < itemNameArray.count; i++) {
        NSString *itemName = itemNameArray[i];
        NSString *actionName = actionNameArray[i];
        SEL action = NSSelectorFromString(actionName);
        if (![self respondsToSelector:action]) {
            return;
        }
        UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:itemName style:UIBarButtonItemStyleDone target:self action:action];
        bar.tintColor = [UIColor blackColor];
        [barItems addObject:bar];
    }
    
    if (barItems.count > 0) {
        self.navigationItem.rightBarButtonItems = barItems;
    }
    
}


- (void)configureRightItemsWithItemImageNameArray:(NSArray <NSString *> *)itemImageNameArray actionNameArray:(NSArray <NSString *> *)actionNameArray {
    if (itemImageNameArray.count != actionNameArray.count) { //!< 保证名字和方法一一对应
        return;
    }
    NSMutableArray <UIBarButtonItem *>*barItems = @[].mutableCopy;
    for (NSUInteger i = 0; i < itemImageNameArray.count; i++) {
        NSString *imageName = itemImageNameArray[i];
        NSString *actionName = actionNameArray[i];
        SEL action = NSSelectorFromString(actionName);
        if (![self respondsToSelector:action]) {
            return;
        }
        UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:action];
        bar.tintColor = [UIColor blackColor];
        [barItems addObject:bar];
    }
    
    if (barItems.count > 0) {
        self.navigationItem.rightBarButtonItems = barItems;
    }
}

#pragma mark - get

- (void)setNavTinColor:(UIColor *)navTinColor {
    if (navTinColor == _navTinColor) {
        return;
    }
    _navTinColor = navTinColor;
    self.navigationController.navigationBar.tintColor = _navTinColor;
}

- (void)setNavBackgroundColor:(UIColor *)navBackgroundColor {
    if (navBackgroundColor == _navBackgroundColor) {
        return;
    }
    _navBackgroundColor = navBackgroundColor;
    self.navigationController.navigationBar.barTintColor = navBackgroundColor;
}

- (void)hiddenBackAction {
    self.navigationController.navigationItem.leftBarButtonItem = nil;
    
}


@end
