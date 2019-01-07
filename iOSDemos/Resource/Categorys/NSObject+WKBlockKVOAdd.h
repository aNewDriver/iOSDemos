//
//  NSObject+WKBlockKVOAdd.h
//  iOSDemos
//
//  Created by Ke Wang on 2018/11/13.
//  Copyright © 2018年 Ke Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (WKBlockKVOAdd)


/**
 添加观察者

 @param keyPath keyPath
 @param block 回调
 */
- (void)addObserverForKeyPath:(NSString *)keyPath block:(void (^)(_Nonnull id obj, _Nullable id oldValue, _Nullable id newValue))block;


/**
 移除观察
 @param keyPath keyPath
 */
- (void)removeObserverBlocksForKeyPath:(NSString *)keyPath;


/**
 移除所有观察者
 */
- (void)removeAllObserverBlocks;

@end

NS_ASSUME_NONNULL_END
