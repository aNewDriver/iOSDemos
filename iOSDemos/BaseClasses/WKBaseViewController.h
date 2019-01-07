//
//  WKBaseViewController.h
//  iOSDemos
//
//  Created by Ke Wang on 2018/10/22.
//  Copyright © 2018年 Ke Wang. All rights reserved.
//

//-----------------------------------  iOS11适配  ------------------------------------
#define  adjustsScrollViewInsets(scrollView)\
do {\
_Pragma("clang diagnostic push")\
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
if ([scrollView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
NSInteger argument = 2;\
invocation.target = scrollView;\
invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
[invocation setArgument:&argument atIndex:2];\
[invocation retainArguments];\
[invocation invoke];\
}\
_Pragma("clang diagnostic pop")\
} while (0)


#import <UIKit/UIKit.h>

@interface WKBaseViewController : UIViewController

@property (nonatomic, strong) UIColor *navTinColor;
@property (nonatomic, strong) UIColor *navBackgroundColor;



/**
 隐藏返回按钮
 */
- (void)hiddenBackAction;


/**
 导航栏右边按钮

 @param itemNameArray 名字合集
 @param actionNameArray 方法合集
 */
- (void)configureRightItemsWithItemNameArray:(NSArray <NSString *> *)itemNameArray actionNameArray:(NSArray <NSString *> *)actionNameArray;


/**
 导航栏右边按钮

 @param itemImageNameArray 图片名合集
 @param actionNameArray 方法合集
 */
- (void)configureRightItemsWithItemImageNameArray:(NSArray <NSString *> *)itemImageNameArray actionNameArray:(NSArray <NSString *> *)actionNameArray;

@end
