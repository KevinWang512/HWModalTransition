//
//  WKWebView+Category.h
//  HWExtension
//
//  Created by houwen.wang on 2016/6/13.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "NSObject+Category.h"
#import "HWEvaluateJavaScriptError.h"
#import "HWHTTPCookieRuntimeSupport.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HWWKWebViewHookDelegate;

@interface HWScriptMessageHandler : NSObject <WKScriptMessageHandler>
@property (nonatomic, copy) void(^scriptMessageHandler)(WKUserContentController *userContentController, WKScriptMessage *message);
@end

@interface WKWebView (Category)

// 注入JS 脚本
- (void)evaluateScript:(NSString *)script complete:(void (^ _Nullable)(_Nullable id returnValue, NSError * _Nullable error))complete;

// 注入JS 脚本
- (void)addUserScript:(NSString *)script injectionTime:(WKUserScriptInjectionTime)injectionTime forMainFrameOnly:(BOOL)forMainFrameOnly;

@end

@interface WKWebView (SendMessage)

// OC调用JS方法
- (void)callJSFunction:(NSString * __nonnull)functionName arguments:(NSArray *_Nullable)arguments complete:(void (^ _Nullable)(id _Nullable returnValue, NSError * _Nullable error))complete;

/*  添加接收JS消息的block
 *  web端通过 window.webkit.messageHandlers.<name>.postMessage(<messageBody>)发送消息
 *  messageBody数据类型: NSNumber, NSString, NSDate, NSArray, NSDictionary, and NSNull
 */
- (void)addScriptMessageHandlerForName:(NSString *)name handler:(void(^)(WKWebView *web, WKUserContentController *userContentController, WKScriptMessage *message))handler;

// 移除接收JS消息的对象
- (void)removeScriptMessageHandlerForName:(NSString *)name;

@end

@interface WKWebView (Hooks)

@property (nonatomic, weak) id <HWWKWebViewHookDelegate> hookDelegate;    //

@end

@interface WKWebView (HWHTTPCookieRuntimeSupport)<HWHTTPCookieRuntimeSupport>

- (void)getCookiesWithComplete:(void(^_Nullable)(NSDictionary <NSString *, NSString *>*cookies))complete;
- (void)getCookieForName:(NSString *)name complete:(void(^_Nullable)(NSString *cookie))complete;

- (void)setCookieForName:(NSString *)name value:(NSString *)value validSeconds:(NSInteger)validSeconds complete:(void(^_Nullable)(void))complete;

- (void)deleteCookieForName:(NSString *)name complete:(void(^_Nullable)(void))complete;
- (void)deleteAllCookiesWithComplete:(void(^_Nullable)(void))complete;

@end

@protocol HWWKWebViewHookDelegate

@optional

- (void)webView:(UIWebView *)webview didReceiveNewTitle:(NSString *)newTitle isMainFrame:(BOOL)isMainFrame;

@end

NS_ASSUME_NONNULL_END
