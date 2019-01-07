//
//  WKBaseWebViewController.h
//  iOSDemos
//
//  Created by Ke Wang on 2018/10/24.
//  Copyright © 2018年 Ke Wang. All rights reserved.
//

#import "WKBaseDetailViewController.h"

@interface WKBaseWebViewController :WKBaseDetailViewController


@property (nonatomic, copy) NSString *urlString; //!< url
@property (nonatomic, copy) NSString *HTMLString; //!< HTML

- (instancetype)init __attribute__((unavailable("请调用下面的初始化方法")));


/**
 用url来初始化

 @param urlString url
 @return self
 */
- (instancetype)initWithUrlString:(NSString *)urlString;


/**
 用HTML来初始化

 @param HTMLString HTML
 @return self
 */
- (instancetype)initWithHTMLString:(NSString *)HTMLString;

@end
