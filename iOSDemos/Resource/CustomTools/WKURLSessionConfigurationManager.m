//
//  WKURLSessionConfigurationManager.m
//  iOSDemos
//
//  Created by Ke Wang on 2019/1/7.
//  Copyright © 2019年 Ke Wang. All rights reserved.
//

#import "WKURLSessionConfigurationManager.h"
#import <objc/objc.h>
#import <objc/runtime.h>
#import "WKMakerUrlProtocol.h" //!< 自定义protocol去监听所有的网络请求和返回信息

@interface NSURLSessionConfiguration ()

@property (nonatomic, assign) BOOL hasSwizzle; //!< 标记是否已经混编

@end

@implementation WKURLSessionConfigurationManager

//!< single
+ (WKURLSessionConfigurationManager *)defaultConfiguration {
    static WKURLSessionConfigurationManager *sessionConfiguration = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sessionConfiguration = [[WKURLSessionConfigurationManager alloc] init];
    });
    return sessionConfiguration;
}

- (instancetype)init {
    if (self = [super init]) {
        self.hasSwizzle = NO;
    }
    return self;
}

- (void)load {
    self.hasSwizzle = YES;
    Class clazz = NSClassFromString(@"__NSURLSessionConfiguration") ?:NSClassFromString(@"NSURLSessionConfiguration");
    //!< hook 将方法实现进行交换
    [self swizzleSelector:@selector(protocolClasses) fromClass:clazz toClass:[self class]];
    
}

- (void)unload {
    self.hasSwizzle = NO;
    Class clazz = NSClassFromString(@"__NSURLSessionConfiguration") ?: NSClassFromString(@"NSURLSessionConfiguration");
    [self swizzleSelector:@selector(protocolClasses) fromClass:clazz toClass:[self class]];
}

- (void)swizzleSelector:(SEL)selector fromClass:(Class)fromClass toClass:(Class)toClass {
    Method originalMethod = class_getInstanceMethod(fromClass, selector);
    Method swizzleMethod = class_getInstanceMethod(toClass, selector);
    if (!originalMethod || !swizzleMethod) {
        [NSException raise:NSInternalInconsistencyException format:@"Couldn't load NEURLSessionConfiguration."];
    }
    method_exchangeImplementations(originalMethod, swizzleMethod);
}

- (NSArray *)protocolClasses {
    //!< 将本类返回, 意味着将只能找到返回的URLSessionConfiguration, AFN会再protocolClasses中拿到第一个class去遵循这个configuration 所以将自定义的放在item0位置
    
    //!< 将系统的也返回回去
    return @[[WKURLSessionConfigurationManager class], [NSURLSessionConfiguration class]];
}

+ (void)startToMonitor {
    WKURLSessionConfigurationManager *manager = [WKURLSessionConfigurationManager defaultConfiguration];
    [NSURLProtocol registerClass:[WKMakerUrlProtocol class]];
    if (![manager hasSwizzle]) {
        [manager load];
    }
}

+ (void)stopMonitor {
    WKURLSessionConfigurationManager *manager = [WKURLSessionConfigurationManager defaultConfiguration];
    [NSURLProtocol unregisterClass:[WKMakerUrlProtocol class]];
    if (manager.hasSwizzle) {
        [manager unload];
    }
}


@end
