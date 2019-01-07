//
//  WKDefines.h
//  Bankorus_iOS
//
//  Created by Ke Wang on 2018/9/11.
//  Copyright © 2018年 Ke Wang. All rights reserved.
//

#ifndef WKDefines_h
#define WKDefines_h

#import <UIKit/UIKit.h>
#import <pthread.h>



#pragma mark - 判断iPad
#define IsPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

#pragma mark - IOS11及以上系统
#define IOS11 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0000 ? YES : NO)

#define IOS10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0000 ? YES : NO)

#pragma mark - IOS8及以上系统
#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0000 ? YES : NO)

#pragma mark - IOS7判断
#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0000 ? YES : NO)


#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define isLargerIphone (([[UIScreen mainScreen] currentMode].size.height > 960.f) ? YES : NO)
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)\

#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1624), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)


#define JVS_SERVICE_UUID [[UIDevice currentDevice].identifierForVendor UUIDString]

#pragma mark - size


#define SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)
#define NAVIGATIONBAR_HEIGHT 44.0f
#define STATUBAR_HEIGHT 20.0f
#define TABBAR_HEIGHT 49.0f
#define BTN_REGISTER_HEIGHT 44
#define BTN_LOGIN_HEIGHT 55
#define CELL_DEFAULT_HEIGHT 50.0f * SCREEN_SCALE
#define ABNORMAL_CELL_HEIGHT_NORMAL 62.0f
#define NAVIGATIONBAR_HEIGHT_iOS7 (iPhoneX ? 88 : 64)
#define KSafeHeight  (iPhoneX ? 34.0f : 0.0f)


//比例
#define SCREEN_SCALE SCREEN_WIDTH/375.0f
#define FRAME_FLOAT(f) f * SCREEN_SCALE

#pragma mark - image

#define PLACEHOLDER_IMAGE [UIImage imageNamed:@"AActivityImage"]

#pragma mark - 颜色

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//RGB color macro with alpha
#define UIColorFromRGBWithAlpha(rgbValue, a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define NAVIGATIONBAR_YELLOWCOLOR UIColorFromRGB(0xFED854)      //!< 导航栏黄色
#define BACKGROUND_COLOR UIColorFromRGB(0xF5F5F5)
#define NAVIGATIONBAR_WHITECOLOR UIColorFromRGB(0xffffff)   // 顶部导航白色
#define TEXT_COLOR UIColorFromRGB(0x333333)                 // 主要字体颜色
#define TITLE_COLOR UIColorFromRGB(0x171717)                // 标题字体颜色
#define DETAIL_TEXT_COLOR UIColorFromRGB(0x666666)          // 描述字体颜色
#define LOGIN_LINE_COLOR UIColorFromRGB(0xCECECE)
#define PLACEHOLDER_COLOR UIColorFromRGB(0xDDDDDD)
#define MORE_BACKGROUND_COLOR UIColorFromRGB(0xE5E5E5)      // 弹出更多的collectionview的背景颜色
#define THIRD_TEXT_COLOR UIColorFromRGB(0x666666)           //!< C次级字体颜色 占位字符

#define BTN_BLUE_COLOR UIColorFromRGB(0x63ade1) //主题蓝
#define BTN_ORANGE_COLOR UIColorFromRGB(0xf8a300) //橙色
#define BTN_RED_COLOR UIColorFromRGB(0xFF0000) //红色
#define BTN_CYAN_COLOR UIColorFromRGB(0x5AC6F7)
#define BTN_GRAY_COLOR UIColorFromRGB(0xBBBBBB)
#define BTN_CANCEL_COLOR UIColorFromRGB(0x63ADE1) // 取消按钮的蓝色
#define BTN_NORMAL_BLUE_COLOR UIColorFromRGB(0x63ade1) //!< 普通蓝色按钮


#pragma mark - 字体

#define TITLE_TEXT_FONT SYSTEM_NORMAL_FONT(18.0f);      //!< 重要标题字体
#define SECONDARY_TEXT_FONT SYSTEM_NORMAL_FONT(16.0f);  //!< 分组标示性文字字体
#define THIRDLEVEL_TEXT_FONT SYSTEM_NORMAL_FONT(14.0f);  //!< 第三级 较为重要 模块名称等
#define FOURTHLEVEL_TEXT_FONT SYSTEM_NORMAL_FONT(13.0f);  //!< 第四级 辅助性说明性文字
#define FIFTHLEVEL_TEXT_FONT SYSTEM_NORMAL_FONT(12.0f);  //!< 第五级 辅助性文字描述



#define TEXT_ORANGE_COLOR UIColorFromRGB(0xFB7318)
#define ACTIONSHEET_TEXTCOLOR UIColorFromRGB(0x464646)
#define kMessageListBackgroundColor UIColorFromRGB(0xe8f8f6)

#define BOTTOM_LINE_COLOR UIColorFromRGB(0xb4b4b4)
#define BORDER_LINE_COLOR UIColorFromRGB(0xdddddd) // 边框的线的颜色
#define MAIN_BLUE_COLOR   UIColorFromRGB(0x29A1F7) // h5页面加载条

#define HEIGHT_FOR_CAR_INFO_CELL   49  // cell高度

#define STATES_COLOR_RED UIColorFromRGB(0xFF0304);   //!< 红色
#define STATES_COLOR_GREEN UIColorFromRGB(0x47D050); //!< 绿
#define STATES_COLOR_BLUE UIColorFromRGB(0x4A90E2);  //!< 蓝色


#pragma mark - 字体
//等比例的字体
#define BOLD_SCALE_FONT(num) [UIFont boldSystemFontOfSize: num * SCREEN_SCALE]
#define SYSTEM_SCALE_FONT(num) [UIFont systemFontOfSize: num * SCREEN_SCALE]

//正常的字体
#define BOLD_NORMAL_FONT(num) [UIFont boldSystemFontOfSize: num]
#define SYSTEM_NORMAL_FONT(num) [UIFont systemFontOfSize: num]
#define SYSTEM_NORMAL_NAME_FONT(name, num) [UIFont fontWithName:name size:num]
#define SYSTEM_MEDIUM_SCALE_FONT(num) [UIFont fontWithName:@".PingFangSC-Medium" size:num * SCALE_TO_IPHONE6]
#define SYSTEM_MEDIUM_FONT(num) [UIFont fontWithName:@".PingFangSC-Medium" size:num]


// 等级的 adobe caslon pro blod italic 字体
#define ADOBE_CASLONPRO_BLOD_FONT(f) [UIFont fontWithName:@"ACaslonPro-BoldItalic" size:f];

// 提示框的时间
#define ALERTVIEW_DURATION 2.0

// 图片的压缩大小150KB
#define RF_IMAGEKB 150
#define RF_IMAGEQUALITY 0.31f


#pragma mark - Documents文件夹
#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

#define GetImagePNGPath(name) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"png"]]
#define GetImageJPGPath(name) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"jpg"]]

#pragma mark - UserDefaults

#define SET_UserDefaults(value, key) \
[[NSUserDefaults standardUserDefaults] setObject:value forKey:key];\
[[NSUserDefaults standardUserDefaults] synchronize];



#define GET_UserDefaults(key)\
[[NSUserDefaults standardUserDefaults] objectForKey:key];

#define USER_DEFAULT [NSUserDefaults standardUserDefaults]


#pragma mark - other
#define NotificationCenter [NSNotificationCenter defaultCenter]
#define GCD_GLOBAL_QUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define APP_DELEGATE (AppDelegate *)[[UIApplication sharedApplication] delegate];


#pragma mark - version

#define WK_SYSTEMVERSION [[UIDevice currentDevice] systemVersion] //当前设备的系统版本号
#define WK_VERSION  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] //应用的版本号
#define WK_USER_AGENT [NSString stringWithFormat:@"renrenauto_ios_%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]] //user-agent
#define WK_SERVICE_UUID [[UIDevice currentDevice].identifierForVendor UUIDString]


#define WK_CHANNEL @"Enterprise" // AppStore  Enterprise Test

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


#pragma mark - singleton
#define WK_SINGLETON(__clazz) \
+ (__clazz *)sharedInstance;

#define WK_DEF_SINGLETON(__clazz) \
static __clazz * __singletion;\
+ (__clazz *)sharedInstance \
{\
static dispatch_once_t once; \
dispatch_once(&once,^{__singletion = [[__clazz alloc] init];});\
return __singletion;\
}\
+ (id)allocWithZone:(struct _NSZone *)zone {\
\
if (!__singletion) {\
\
return [super allocWithZone: zone];\
\
}\
\
return nil;\
\
}\
\
- (id)copy {\
\
return __singletion;\
\
}\

#endif


#ifndef IS_IPHONE
#define IS_IPHONE ( [ [ [ UIDevice currentDevice ] model] isEqualToString: @"iPhone" ] )
#endif

#ifndef IS_IPAD
#define IS_IPAD ( [ [ [ UIDevice currentDevice ] model] isEqualToString: @"iPad" ] ||  [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPad Simulator" ])
#endif


#define dispatch_async_main_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}


#pragma mark - 实用

//!< 强制内联
//优点相比于函数:
//
//1) inline函数避免了普通函数的,在汇编时必须调用call的缺点:取消了函数的参数压栈，减少了调用的开销,提高效率.所以执行速度确比一般函数的执行速度要快.
//
//2)集成了宏的优点,使用时直接用代码替换(像宏一样);
//
//优点相比于宏:
//
//1)避免了宏的缺点:需要预编译.因为inline内联函数也是函数,不需要预编译.
//
//2)编译器在调用一个内联函数时，会首先检查它的参数的类型，保证调用正确。然后进行一系列的相关检查，就像对待任何一个真正的函数一样。这样就消除了它的隐患和局限性。
//
//3)可以使用所在类的保护成员及私有成员。

#define necessary_inline __inline__ __attribute__((always_inline))


/**
 当前线程是否为主线程

 @return bool
 */
static inline bool dispath_is_mainQueue() {
    return pthread_main_np() != 0;
}

/**
 安全主线程
 @param block 回调
 */
static inline void dispatch_async_safe_mainQueue(void(^block)(void)) {
    if (pthread_main_np()) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

static inline void dispatch_sync_safe_mainQueue(void (^block)(void)) {
    if (pthread_main_np()) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_## = object
        #else
        #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif

#endif


#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
            #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
            #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif


static inline NSRange WKRangeFromCFRange(CFRange range) {
    return NSMakeRange(range.location, range.length);
}

static inline CFRange WKRangeFromNSRange(NSRange range) {
    return CFRangeMake(range.location, range.length);
}

#pragma mark - 判空断言
#define WKAssertNil(condition, description, ...) NSAssert(!(condition), (description), ##__VA_ARGS__)
#define WKCAssertNil(condition, description, ...) NSCAssert(!(condition), (description), ##__VA_ARGS__)

#define WKAssertNotNil(condition, description, ...) NSAssert((condition), (description), ##__VA_ARGS__)
#define WKCAssertNotNil(condition, description, ...) NSCAssert((condition), (description), ##__VA_ARGS__)

#pragma mark - 断言判断主线程
#define WKAssertMainThread() NSAssert([NSThread isMainThread], @"This method must be called on the main thread")
#define WKCAssertMainThread() NSCAssert([NSThread isMainThread], @"This method must be called on the main thread")


//#endif /* WKDefines_h */
