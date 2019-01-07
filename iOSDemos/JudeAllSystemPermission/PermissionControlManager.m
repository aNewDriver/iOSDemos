//
//  PermissionControlManager.m
//  iOSDemos
//
//  Created by Ke Wang on 2018/10/19.
//  Copyright © 2018年 Ke Wang. All rights reserved.
//


#import "PermissionControlManager.h"
@import CoreTelephony; //!< 网络权限
#import <Photos/Photos.h> //!< 相册权限
#import <AVFoundation/AVFoundation.h> //!< 相机和麦克风权限
#import <CoreLocation/CoreLocation.h> //!< 定位权限
#import <AddressBook/AddressBook.h> //!< 通讯录
#import <Contacts/Contacts.h> //!< 通讯录9.0后
#import <EventKit/EventKit.h> //!< 日历 备忘录权限



static PermissionControlManager *_sharedManager = nil;

@implementation PermissionControlManager


+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[PermissionControlManager alloc] init];
    });
    return _sharedManager;
}

//!< 网络权限
- (void)networkPermissionJude:(void (^)(NSUInteger networkStat))networkStatBlock {
    CTCellularData *cellularData = [[CTCellularData alloc] init];
    [cellularData setCellularDataRestrictionDidUpdateNotifier:^(CTCellularDataRestrictedState state) {
        
        switch (state) {
            case kCTCellularDataRestrictedStateUnknown:
                
                break;
            case kCTCellularDataRestricted:
                
                break;
            case kCTCellularDataNotRestricted:
                
                break;
                
            default:
                break;
        }
        
        if (networkStatBlock) {
            networkStatBlock(state);
        }
    }];
}

//!< 系统相册权限
- (void)systemAlbumPermissionJude:(void (^) (AlbumPermission albumPermission))callBack {
    
    PHAuthorizationStatus photoState = [PHPhotoLibrary authorizationStatus];
    AlbumPermission AP = AlbumPermission_NotDetermined_shouldShowAlert;
    switch (photoState) {
        case PHAuthorizationStatusAuthorized:
            AP = AlbumPermission_Authorized;
            
            break;
        case PHAuthorizationStatusDenied:
            AP = AlbumPermission_Denied;

            break;
        case PHAuthorizationStatusNotDetermined:{
            AP = AlbumPermission_NotDetermined_shouldShowAlert;
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                [self systemAlbumPermissionJude:callBack];
            }];
        }
            break;
        case PHAuthorizationStatusRestricted:
            AP = AlbumPermission_Restricted;
            break;
            
        default:
            break;
    }
    
    if (callBack && AP != AlbumPermission_NotDetermined_shouldShowAlert) {
        callBack(AP);
    }
    
}
//!< 相机权限

- (void)cameraPermission:(void (^)(CamreaPermission camreaPermission))callBack {
    AVAuthorizationStatus AVState = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    CamreaPermission CP = CamreaPermission_NotDetermined_shouldShowAlert;
    
    switch (AVState) {
        case AVAuthorizationStatusAuthorized:
            CP = CamreaPermission_Authorized;
            
            break;
        case AVAuthorizationStatusDenied:
            CP = CamreaPermission_Denied;
            
            break;
        case AVAuthorizationStatusNotDetermined: {
            CP = CamreaPermission_NotDetermined_shouldShowAlert;
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {//相机权限
                [self cameraPermission:callBack];
            }];
        }
            break;
        case AVAuthorizationStatusRestricted:
            CP = CamreaPermission_Restricted;
            
            break;
        default:
            break;
    }
    if (callBack && CP != CamreaPermission_NotDetermined_shouldShowAlert) {
        callBack(CP);
    }
}

//!< 麦克风权限
- (void)microphonePermission:(void (^) (MicrophonePermission microphonePermission))callBack {
    AVAuthorizationStatus AVState = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    MicrophonePermission MP = MicrophonePermission_NotDetermined_shouldShowAlert;
    
    switch (AVState) {
        case AVAuthorizationStatusAuthorized:
            MP = MicrophonePermission_Authorized;
            break;
        case AVAuthorizationStatusDenied:
            MP = MicrophonePermission_Denied;
            
            break;
        case AVAuthorizationStatusNotDetermined: {
            MP = MicrophonePermission_NotDetermined_shouldShowAlert;
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {//相机权限
                [self microphonePermission:callBack];
            }];
        }
            break;
        case AVAuthorizationStatusRestricted:
            MP = MicrophonePermission_Restricted;
            
            break;
        default:
            break;
    }
    if (callBack && MP != MicrophonePermission_NotDetermined_shouldShowAlert) {
        callBack(MP);
    }
}

- (void)locationPermission:(void (^) (LocationPermission locationPermission))callBack {
    BOOL isLocation = [CLLocationManager locationServicesEnabled];
    LocationPermission LP = LocationPermission_NotConfigured;
    if (!isLocation) {
        if (callBack) {
            callBack(LP);
            return;
        }
    }
    
    CLAuthorizationStatus CLstatus = [CLLocationManager authorizationStatus];
    switch (CLstatus) {
        case kCLAuthorizationStatusAuthorizedAlways:
            LP = LocationPermission_AuthorizedAlways;
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            LP = LocationPermission_AuthorizedWhenInUse;
            break;
        case kCLAuthorizationStatusDenied:
            LP = LocationPermission_Denied;
            break;
        case kCLAuthorizationStatusNotDetermined: {
            LP = LocationPermission_NotDetermined;
            CLLocationManager *manager = [[CLLocationManager alloc] init];
            [manager requestWhenInUseAuthorization];//使用的时候获取定位信息
            [self locationPermission:callBack];
        }
            break;
        case kCLAuthorizationStatusRestricted:
            LP = LocationPermission_Restricted;
            break;
        default:
            break;
    }
    if (callBack && LP != LocationPermission_NotDetermined) {
        callBack(LP);
    }
    
}

//!< 推送权限

- (void)notificationPermission:(void (^) (PushPermission pushPermission))callBack {
    UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    PushPermission PP = PushPermission_None;
    switch (settings.types) {
        case UIUserNotificationTypeNone: {
            UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
            [self notificationPermission:callBack];
        }
            break;
        case UIUserNotificationTypeAlert:
            PP = PushPermission_Alert;
            break;
        case UIUserNotificationTypeBadge:
            PP = PushPermission_Badge;
            break;
        case UIUserNotificationTypeSound:
            PP = PushPermission_Sound;
            break;
            
        default:
            break;
    }
    if (callBack && PP != PushPermission_None) {
        callBack(PP);
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
//!< 通讯录权限
- (void)addressBookPermisssion:(void(^)(AddressBookPermission addressBookPermission))callBack {
    
    AddressBookPermission ADP = AddressBookPermission_NotDetermined;
    
    if (@available(iOS 9.0, *)) {
        //!< iOS 9.0 及以后的版本
        
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        switch (status) {
            case CNAuthorizationStatusAuthorized:
            {
                ADP = AddressBookPermission_Authorized;
            }
                break;
            case CNAuthorizationStatusDenied:{
                ADP = AddressBookPermission_Denied;
            }
                break;
            case CNAuthorizationStatusRestricted:{
                ADP = AddressBookPermission_Restricted;
            }
                break;
            case CNAuthorizationStatusNotDetermined:{
                CNContactStore *contactStore = [[CNContactStore alloc] init];
                [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    [self addressBookPermisssion:callBack];
                }];
            }
                break;
        }
        
    } else {
        //!< iOS 9.0 之前
        ABAuthorizationStatus ABstatus = ABAddressBookGetAuthorizationStatus();
        
        switch (ABstatus) {
            case kABAuthorizationStatusAuthorized:
                ADP = AddressBookPermission_Authorized;
                break;
            case kABAuthorizationStatusDenied:
                ADP = AddressBookPermission_Denied;
                break;
            case kABAuthorizationStatusNotDetermined: {
                ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
                ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                    [self addressBookPermisssion:callBack];
                });
            }
                break;
            case kABAuthorizationStatusRestricted:
                ADP = AddressBookPermission_Restricted;
                break;
            default:
                break;
        }
    }
    if (callBack && ADP != AddressBookPermission_NotDetermined) {
        callBack(ADP);
    }
}
#pragma clang diagnostic pop

//EKEntityTypeEvent,  //!< 日历
//EKEntityTypeReminder //!< 备忘录

//!< 日历权限
- (void)calendarPermission:(void (^) (CalendarMemorandumPermission calendarMemorandumPermission))callBack {
    EKAuthorizationStatus EKstatus = [EKEventStore  authorizationStatusForEntityType:EKEntityTypeEvent];
    CalendarMemorandumPermission CMP = CalendarMemorandumPermission_NotDetermined;
    switch (EKstatus) {
        case EKAuthorizationStatusAuthorized:
            CMP = CalendarMemorandumPermission_Authorized;
            break;
        case EKAuthorizationStatusDenied:
            CMP = CalendarMemorandumPermission_Denied;
            break;
        case EKAuthorizationStatusNotDetermined:
        {
            EKEventStore *store = [[EKEventStore alloc]init];
            [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
                [self calendarPermission:callBack];
            }];
        }
            break;
        case EKAuthorizationStatusRestricted:
            CMP = CalendarMemorandumPermission_Restricted;
            break;
        default:
            break;
    }
    
    if (callBack && CMP != CalendarMemorandumPermission_NotDetermined) {
        callBack(CMP);
    }
}

//!< 备忘录权限
- (void)memorandumPermission:(void(^)(CalendarMemorandumPermission calendarMemorandumPermission))callBack {
    EKAuthorizationStatus EKstatus = [EKEventStore  authorizationStatusForEntityType:EKEntityTypeReminder];
    CalendarMemorandumPermission CMP = CalendarMemorandumPermission_NotDetermined;
    switch (EKstatus) {
        case EKAuthorizationStatusAuthorized:
            CMP = CalendarMemorandumPermission_Authorized;
            break;
        case EKAuthorizationStatusDenied:
            CMP = CalendarMemorandumPermission_Denied;
            break;
        case EKAuthorizationStatusNotDetermined:
        {
            EKEventStore *store = [[EKEventStore alloc]init];
            [store requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError * _Nullable error) {
                [self calendarPermission:callBack];
            }];
        }
            break;
        case EKAuthorizationStatusRestricted:
            CMP = CalendarMemorandumPermission_Restricted;
            break;
        default:
            break;
    }
    if (callBack && CMP != CalendarMemorandumPermission_NotDetermined) {
        callBack(CMP);
    }
}




@end
