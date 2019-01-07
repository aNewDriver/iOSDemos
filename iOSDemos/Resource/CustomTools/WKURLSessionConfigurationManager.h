//
//  WKURLSessionConfigurationManager.h
//  iOSDemos
//
//  Created by Ke Wang on 2019/1/7.
//  Copyright © 2019年 Ke Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKURLSessionConfigurationManager : NSURLSessionConfiguration

+ (WKURLSessionConfigurationManager *)defaultConfiguration;

+ (void)startToMonitor;

+ (void)stopMonitor;


@end

NS_ASSUME_NONNULL_END
