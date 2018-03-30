//
//  HWHTTPCookieRuntimeSupport
//  HWExtension
//
//  Created by wanghouwen on 2017/12/20.
//  Copyright © 2017年 wanghouwen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HWHTTPCookieRuntimeSupport <NSObject>

@required

- (void)getCookiesWithComplete:(void(^_Nullable)(NSDictionary <NSString *, NSString *>*cookies))complete;
- (void)getCookieForName:(NSString *)name complete:(void(^_Nullable)(NSString *cookie))complete;

- (void)setCookieForName:(NSString *)name value:(NSString *)value validSeconds:(NSInteger)validSeconds complete:(void(^_Nullable)(void))complete;

- (void)deleteCookieForName:(NSString *)name complete:(void(^_Nullable)(void))complete;
- (void)deleteAllCookiesWithComplete:(void(^_Nullable)(void))complete;

@end

NS_ASSUME_NONNULL_END
