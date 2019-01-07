//
//  PermissionControlManager.h
//  iOSDemos
//
//  Created by Ke Wang on 2018/10/19.
//  Copyright © 2018年 Ke Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    AlbumPermission_NotDetermined_shouldShowAlert, //!< 用户还未决定, 应该show alert
    AlbumPermission_Authorized, //!< 已允许 可读写
    AlbumPermission_Denied, //!< 被拒绝
    AlbumPermission_Restricted //!< 受限制 只读
} AlbumPermission;


typedef enum : NSUInteger {
    CamreaPermission_NotDetermined_shouldShowAlert, //!< 用户未决定
    CamreaPermission_Authorized, //!< 允许
    CamreaPermission_Denied, //!< 拒绝
    CamreaPermission_Restricted //!< 受限制
    
} CamreaPermission;

typedef enum : NSUInteger {
    MicrophonePermission_NotDetermined_shouldShowAlert, //!< 用户未决定
    MicrophonePermission_Authorized, //!< 允许
    MicrophonePermission_Denied, //!< 拒绝
    MicrophonePermission_Restricted //!< 受限制
}MicrophonePermission;

typedef enum : NSUInteger {
    LocationPermission_NotConfigured, //!< 权限未配置(info.plist中)
    LocationPermission_NotDetermined, //!< 用户未操作
    LocationPermission_AuthorizedAlways, //!< 允许,并且一直允许
    LocationPermission_AuthorizedWhenInUse, //!< 允许但只在使用期间
    LocationPermission_Denied, //!< 拒绝
    LocationPermission_Restricted //!< 受限制
}LocationPermission;

typedef enum : NSUInteger {
    PushPermission_None, //!< 没有
    PushPermission_Alert, //!< 有alert通知
    PushPermission_Badge, //!< 有角标
    PushPermission_Sound //!< 有声音
}PushPermission;


typedef enum : NSUInteger {
    AddressBookPermission_NotDetermined, //!< 用户没有选择
    AddressBookPermission_Authorized, //!< 允许
    AddressBookPermission_Denied, //!< 拒绝
    AddressBookPermission_Restricted //!< 受限
} AddressBookPermission;

typedef enum : NSUInteger {
    CalendarMemorandumPermission_NotDetermined, //!< 未选择
    CalendarMemorandumPermission_Authorized, //!< 允许
    CalendarMemorandumPermission_Denied, //!< 拒绝
    CalendarMemorandumPermission_Restricted //!< 受限制
}CalendarMemorandumPermission;


@interface PermissionControlManager : NSObject


/**
 初始化

 @return 单例
 */
+ (instancetype)sharedManager;

/**
 网络权限判断

 @param networkStatBlock 回调 
 */
- (void)networkPermissionJude:(void (^)(NSUInteger networkStat))networkStatBlock;


/**
 系统相册权限判断

 @param callBack 回调
 */
- (void)systemAlbumPermissionJude:(void (^) (AlbumPermission albumPermission))callBack;


/**
 相机权限

 @param callBack 回调
 */
- (void)cameraPermission:(void (^)(CamreaPermission camreaPermission))callBack;


/**
 麦克风权限

 @param callBack 回调
 */
- (void)microphonePermission:(void (^) (MicrophonePermission microphonePermission))callBack;


/**
 定位权限

 @param callBack 回调
 */
- (void)locationPermission:(void (^) (LocationPermission locationPermission))callBack;



/**
 通讯录权限

 @param callBack 回调
 */
- (void)addressBookPermisssion:(void(^)(AddressBookPermission addressBookPermission))callBack;


/**
 日历权限

 @param callBack 回调
 */
- (void)calendarPermission:(void (^) (CalendarMemorandumPermission calendarMemorandumPermission))callBack;


/**
 备忘录权限

 @param callBack 回调
 */
- (void)memorandumPermission:(void(^)(CalendarMemorandumPermission calendarMemorandumPermission))callBack;


@end
