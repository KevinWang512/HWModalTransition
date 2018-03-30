//
//  UIDevice+Category.m
//  HWExtension
//
//  Created by houwen.wang on 2016/8/22.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import "UIDevice+Category.h"

@implementation UIDevice (Authorization)

+ (BOOL)isCameraDeviceAvailable:(UIImagePickerControllerCameraDevice)cameraDevice {
    return [UIImagePickerController isCameraDeviceAvailable:cameraDevice];
}

+ (BOOL)isFlashAvailableForCameraDevice:(UIImagePickerControllerCameraDevice)cameraDevice {
    return [UIImagePickerController isFlashAvailableForCameraDevice:cameraDevice];
}

+ (BOOL)isSourceTypeAvailable:(UIImagePickerControllerSourceType)sourceType {
    return [UIImagePickerController isSourceTypeAvailable:sourceType];
}

// 检查相机权限
+ (void)checkCameraAuthorizationStatusWithComplete:(void(^)(AVAuthorizationStatus status))complete {
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    // 用户未选择权限
    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            performBlock(complete, granted ? AVAuthorizationStatusAuthorized : AVAuthorizationStatusDenied);
        }];
    } else {
        performBlock(complete, status);
    }
}

// 检查图库权限
+ (void)checkPhotoLibraryAuthorizationStatusWithComplete:(void(^)(ALAuthorizationStatus status))complete {
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0f) {
        
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];;
        
        // 用户未选择权限
        if (status == ALAuthorizationStatusNotDetermined) {
            
            ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
            
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                performBlock(complete, ALAuthorizationStatusAuthorized);
                *stop = TRUE;
            } failureBlock:^(NSError *error) {
                performBlock(complete, ALAuthorizationStatusDenied);
            }];
        } else {
            performBlock(complete, status);
        }
    } else {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        
        // 用户未选择权限
        if (status == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                performBlock(complete, (ALAuthorizationStatus)status);
            }];
        } else {
            performBlock(complete, (ALAuthorizationStatus)status);
        }
    }
}

@end

@implementation UIDevice (SystemVersion)

+ (float)systemVersion {
    return [UIDevice currentDevice].systemVersion.floatValue;
}

@end

#if DEBUG

@implementation HWApplicationInfo;

- (NSString *)description {
    return self.keyValueDictionary.description;
}

/* replaced : original */
+ (NSDictionary <NSString *, NSString *>*)replacedPropertyNames {
    return @{@"bundleID" : @"applicationIdentifier",
             @"build"    : @"bundleVersion",
             @"version"  : @"shortVersionString"
             };
}

@end

@implementation UIDevice (Applications)

@class LSApplicationWorkspace;
@class LSApplicationProxy;

+ (NSArray <HWApplicationInfo *>*)installedApplications {
    
    Class workspaceCls = NSClassFromString(@"LSApplicationWorkspace");
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    NSObject *defaultWorkspace = [workspaceCls performSelector:@selector(defaultWorkspace)];
    NSArray <LSApplicationProxy *>*apps = [defaultWorkspace performSelector:@selector(allApplications)];
    
#pragma clang diagnostic pop
    
    NSMutableArray *appInfos = [NSMutableArray array];
    for (LSApplicationProxy *proxy in apps) {
        [appInfos addObject:[self applicationInfoWithApplicationProxy:proxy]];
    }
    return [appInfos copy];
}

#pragma mark - private

+ (HWApplicationInfo *)applicationInfoWithApplicationProxy:(LSApplicationProxy *)proxy {
    
    HWApplicationInfo *info = [[HWApplicationInfo alloc] init];
    
    NSObject *proxy_t = (NSObject *)proxy;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    for (NSString *pName in [HWApplicationInfo propertyNameList]) {
        
        NSString *opName = [[HWApplicationInfo replacedPropertyNames].allKeys containsObject:pName] ? [HWApplicationInfo replacedPropertyNames][pName] : [pName copy];
        
        id value = nil;
        
        // deviceIdentifierVendorName 是成员变量
        if ([pName isEqualToString:@"deviceIdentifierVendorName"]) {
            value = [proxy_t valueForKey:@"deviceIdentifierVendorName"];
        } else {
            value = [proxy_t performSelector:NSSelectorFromString(opName)];
        }
        
        if (value) {
            [info setValue:value forKey:pName];
        }
    }
    
#pragma clang diagnostic pop
    
    return info;
}

@end

#endif

/*!
 *  LSApplicationProxy instance methods
 
 _defaultStyleSize:,
 _iconVariantDefinitions:,
 _inapptrust_isFirstParty,
 un_applicationBundleURL,
 un_applicationBundleIdentifier,
 shortVersionString,
 dealloc,
 description,
 setAlternateIconName:withResult:,
 localizedNameForContext:,
 deviceIdentifierForVendor,
 encodeWithCoder:,
 initWithCoder:,
 uniqueIdentifier,
 appState,
 isInstalled,
 isRestricted,
 installType,
 isPlaceholder,
 applicationIdentifier,
 clearAdvertisingIdentifier,
 deviceIdentifierForAdvertising,
 isLaunchProhibited,
 installProgress,
 bundleModTime,
 plugInKitPlugins,
 _initWithBundleUnit:context:applicationIdentifier:,
 diskUsage,
 isBetaApp,
 iconDataForVariant:preferredIconName:withOptions:,
 iconUsesAssetCatalog,
 resourcesDirectoryURL,
 iconDataForVariant:withOptions:,
 supportsAlternateIconNames,
 alternateIconName,
 applicationType,
 isDeletable,
 itemID,
 supportedComplicationFamilies,
 complicationPrincipalClass,
 storeCohortMetadata,
 subgenres,
 staticShortcutItems,
 applicationDSID,
 directionsModes,
 UIBackgroundModes,
 externalAccessoryProtocols,
 staticDiskUsage,
 dynamicDiskUsage,
 ODRDiskUsage,
 VPNPlugins,
 appTags,
 requiredDeviceCapabilities,
 getBundleMetadata,
 installProgressSync,
 primaryIconDataForVariant:,
 iconIsPrerendered,
 fileSharingEnabled,
 profileValidated,
 UPPValidated,
 isAdHocCodeSigned,
 isAppUpdate,
 hasParallelPlaceholder,
 isNewsstandApp,
 supportsAudiobooks,
 supportsODR,
 supportsExternallyPlayableContent,
 supportsOpenInPlace,
 hasSettingsBundle,
 isWhitelisted,
 isAppStoreVendable,
 isPurchasedReDownload,
 isWatchKitApp,
 hasCustomNotification,
 hasComplication,
 hasGlance,
 shouldSkipWatchAppInstall,
 hasMIDBasedSINF,
 missingRequiredSINF,
 supportsPurgeableLocalStorage,
 isGameCenterEnabled,
 gameCenterEverEnabled,
 isRemoveableSystemApp,
 isRemovedSystemApp,
 signerOrganization,
 companionApplicationIdentifier,
 counterpartIdentifiers,
 registeredDate,
 itemName,
 genreID,
 minimumSystemVersion,
 maximumSystemVersion,
 preferredArchitecture,
 downloaderDSID,
 familyID,
 originalInstallType,
 deviceFamily,
 teamID,
 storeFront,
 ratingRank,
 ratingLabel,
 sourceAppIdentifier,
 applicationVariant,
 watchKitVersion,
 installFailureReason,
 userInitiatedUninstall,
 setUserInitiatedUninstall:,
 localizedNameForContext:preferredLocalizations:,
 localizedNameForContext:preferredLocalizations:useShortNameOnly:,
 localizedNameWithPreferredLocalizations:useShortNameOnly:,
 audioComponents,
 vendorName,
 genre,
 iconDataForVariant:,
 activityTypes,
 betaExternalVersionIdentifier,
 isDeviceBasedVPP,
 externalVersionIdentifier,
 purchaserDSID
 
 */

