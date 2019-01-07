//
//  ExceptionDealManager.m
//  TestNSException
//
//  Created by Ke Wang on 2018/9/28.
//  Copyright © 2018年 Ke Wang. All rights reserved.
//

#import "ExceptionDealManager.h"
#import <Bugly/Bugly.h>
#import "AvoidCrash.h"


static NSString *BuglyAppId = @"2a01e5c71d";
static NSString *BuglyAppKey = @"032e9689-10d6-4737-9e3d-a60bdf91b675";

@interface ExceptionDealManager ()<BuglyDelegate>


@end

@implementation ExceptionDealManager

static ExceptionDealManager *_instance = nil;

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}


- (void)openExceptionDeal {
    [self openBugly];
    [self openAvoid];
}

- (void)openBugly {
    BuglyConfig *config = [[BuglyConfig alloc] init];
    config.reportLogLevel = BuglyLogLevelWarn;
    config.delegate = self;
    [Bugly startWithAppId:BuglyAppId config:config];
}

- (void)openAvoid {
    [AvoidCrash becomeEffective];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealWithCrashMessage:) name:AvoidCrashNotification object:nil];
}
#pragma mark - BuglyDElegate

- (NSString *)attachmentForException:(NSException *)exception {

    NSLog(@"Bugly检测到崩溃信息");
    return @"";
}

#pragma mark - AvoidCrash Method

- (void)dealWithCrashMessage:(NSNotification *)noti {
    
    NSLog(@"检测到崩溃信息, 已由Avoid处理");
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"AvoidCrash" message:@"检测到崩溃信息, 已由Avoid处理" preferredStyle:UIAlertControllerStyleAlert];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController
         presentViewController:alert animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alert dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        
    });
    
    NSDictionary *dict = noti.userInfo;
    NSException *exception = [NSException exceptionWithName:@"AvoidCrash" reason:dict[@"errorName"] userInfo:dict];
    
    [Bugly reportException:exception]; //!< 上传自定义异常
    
}



@end
