//
//  NSObject+WKBlockKVOAdd.m
//  iOSDemos
//
//  Created by Ke Wang on 2018/11/13.
//  Copyright © 2018年 Ke Wang. All rights reserved.
//

#import "NSObject+WKBlockKVOAdd.h"
#import <objc/objc.h>
#import <objc/runtime.h>




static const int blocks_key;

@interface WK_KVOTarget : NSObject //!< 自定义target对象

@property (nonatomic, copy) void (^block)(__weak id obj, id oldValue, id newValue);



@end

@implementation WK_KVOTarget

- (instancetype)initWithBlock:(void(^)(__weak id obj, id oldValue, id newValue))block {
    if (self = [super init]) {
        self.block = block;
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (!self.block) return;
    BOOL isPrior = [[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue];
    if (isPrior) return;
    
    NSKeyValueChange changeKind = [[change objectForKey:NSKeyValueChangeKindKey] integerValue];
    if (changeKind != NSKeyValueChangeSetting) return;
    
    id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
    oldValue = oldValue ? oldValue : nil;
    
    id newValue = [change objectForKey:NSKeyValueChangeNewKey];
    newValue = newValue ? newValue : nil;
    
    self.block(object, oldValue, newValue);
}

@end

@implementation NSObject (WKBlockKVOAdd)

- (void)addObserverForKeyPath:(NSString *)keyPath block:(void (^)(__weak id obj, id oldValue, id newValue))block {
    if (!keyPath || !block) {
        return;
    }
    WK_KVOTarget *target = [[WK_KVOTarget alloc] initWithBlock:block];
    NSMutableDictionary *targets = [self WK_getAllNSObjectObserverBlocks];
    NSMutableArray *arr = targets[keyPath];
    if (!arr) {
        arr = [NSMutableArray new];
        targets[keyPath] = arr;
    }
    [arr addObject:target];
    [self addObserver:target forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
}

- (void)removeObserverBlocksForKeyPath:(NSString *)keyPath {
    if (!keyPath) return;
    NSMutableDictionary *targets = [self WK_getAllNSObjectObserverBlocks];
    NSMutableArray *arr = targets[keyPath];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self removeObserver:obj forKeyPath:keyPath];
    }];
    [targets removeObjectForKey:keyPath];
}

- (void)removeAllObserverBlocks {
    NSMutableDictionary *targets = [self WK_getAllNSObjectObserverBlocks];
    [targets enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSMutableArray *arr, BOOL * _Nonnull stop) {
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self removeObserver:obj forKeyPath:key];
        }];
    }];
    [targets removeAllObjects]; 
}

//!< 获取全部targets
- (NSMutableDictionary *)WK_getAllNSObjectObserverBlocks {
    NSMutableDictionary *dic = objc_getAssociatedObject(self, &blocks_key);
    if (!dic) {
        dic = [NSMutableDictionary new];
        objc_setAssociatedObject(self, &blocks_key, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dic;
}


@end
