//
//  UIDevice+Category.h
//  HWExtension
//
//  Created by houwen.wang on 2016/8/22.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "NSObject+Category.h"

#if __IPHONE_8_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED
#import <Photos/Photos.h>
#endif

@class HWApplicationInfo;

@interface UIDevice (Authorization)

+ (BOOL)isCameraDeviceAvailable:(UIImagePickerControllerCameraDevice)cameraDevice;

+ (BOOL)isFlashAvailableForCameraDevice:(UIImagePickerControllerCameraDevice)cameraDevice;

+ (BOOL)isSourceTypeAvailable:(UIImagePickerControllerSourceType)sourceType;

// 检查相机权限
+ (void)checkCameraAuthorizationStatusWithComplete:(void(^)(AVAuthorizationStatus status))complete;

// 检查图库权限
+ (void)checkPhotoLibraryAuthorizationStatusWithComplete:(void(^)(ALAuthorizationStatus status))complete;

@end

@interface UIDevice (SystemVersion)

@property (class, nonatomic, assign, readonly) float systemVersion;  //

@end

#if DEBUG

@interface UIDevice (Applications)

+ (NSArray <HWApplicationInfo *>*)installedApplications;    //

@end

@interface HWApplicationInfo : NSObject

@property (nonatomic, copy) NSString *bundleID;                     //
@property (nonatomic, copy) NSString *build;                        //
@property (nonatomic, copy) NSString *version;                      //
@property (nonatomic, copy) NSString *uniqueIdentifier;             // 唯一标识符
@property (nonatomic, copy) NSString *deviceIdentifierVendorName;   // 厂商名
@property (nonatomic, copy) NSString *deviceIdentifierForVendor;    //

@property (nonatomic, copy) NSString *vendorName;               //
@property (nonatomic, copy) NSString *itemName;                 //

@property (nonatomic, copy) NSString *teamID;                   //
@property (nonatomic, strong) NSNumber *familyID;               //
@property (nonatomic, copy) NSArray <NSNumber *>*deviceFamily;  //
@property (nonatomic, copy) NSString *applicationIdentifier;    //
@property (nonatomic, copy) NSString *minimumSystemVersion;     //
@property (nonatomic, copy) NSString *maximumSystemVersion;     //

@property (nonatomic, copy) NSString *installType;              //
@property (nonatomic, assign) BOOL isBetaApp;                   //
@property (nonatomic, assign) BOOL isAdHocCodeSigned;           //
@property (nonatomic, assign) BOOL isAppStoreVendable;          //

@end

#endif
