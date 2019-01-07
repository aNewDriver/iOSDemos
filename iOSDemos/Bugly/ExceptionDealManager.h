//
//  ExceptionDealManager.h
//  TestNSException
//
//  Created by Ke Wang on 2018/9/28.
//  Copyright © 2018年 Ke Wang. All rights reserved.
//

//!< 异常处理

#import <Foundation/Foundation.h>

@interface ExceptionDealManager : NSObject

+ (instancetype)shareManager;

- (void)openExceptionDeal;

@end
