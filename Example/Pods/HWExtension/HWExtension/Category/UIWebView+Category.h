//
//  UIWebView+Category.h
//  HWExtension
//
//  Created by houwen.wang on 2016/6/12.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "NSObject+Category.h"
#import "HWEvaluateJavaScriptError.h"
#import "HWHTTPCookieRuntimeSupport.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HWUIWebViewHookDelegate;

@interface UIWebView (Category)

// JS执行环境
@property (nonatomic, strong, readonly) JSContext *jsContext;  //

// 注入JS 脚本
- (void)evaluateScript:(NSString *)script withSourceURL:(NSURL *_Nullable)sourceURL complete:(void (^ _Nullable)(JSValue * _Nullable returnValue, NSError * _Nullable error))complete;

@end

#pragma mark - JSExport

@interface UIWebView (SendMessage)

// OC调用JS方法
- (void)callJSFunction:(NSString * __nonnull)functionName arguments:(NSArray *_Nullable)arguments complete:(void (^ _Nullable)(JSValue * _Nullable returnValue, NSError * _Nullable error))complete;

// 替换JS方法的实现, functionName: 方法名, implementationBlock:新的实现, args:JS传递的参数, currentThis:js's this
// 如果JS未定义此方法， 此方法将会被添加
- (void)replaceJSFunction:(NSString * __nonnull)functionName implementationBlock:(id (^)(NSArray <JSValue *>* _Nullable args, JSValue *currentThis))block;

// 输出OC对象的方法供JS调用
- (void)exportObjectCMethodsForObject:(NSObject <JSExport>*)obj jsObjectName:(NSString *)jsObjectName;

// 移除OC输出的供JS调用的方法
- (void)unExportObjectCMethodsForJsObjectName:(NSString *)jsObjectName;

@end

@interface UIWebView (Hooks)

@property (nonatomic, weak) id <HWUIWebViewHookDelegate> hookDelegate;    //

@end

@interface UIWebView (HWHTTPCookieRuntimeSupport)<HWHTTPCookieRuntimeSupport>

- (void)getCookiesWithComplete:(void(^_Nullable)(NSDictionary <NSString *, NSString *>*cookies))complete;
- (void)getCookieForName:(NSString *)name complete:(void(^_Nullable)(NSString *cookie))complete;

- (void)setCookieForName:(NSString *)name value:(NSString *)value validSeconds:(NSInteger)validSeconds complete:(void(^_Nullable)(void))complete;

- (void)deleteCookieForName:(NSString *)name complete:(void(^_Nullable)(void))complete;
- (void)deleteAllCookiesWithComplete:(void(^_Nullable)(void))complete;

@end

@protocol HWUIWebViewHookDelegate

@optional

- (void)webView:(UIWebView *)webview javaScriptContextDidChanged:(JSContext *)newJSContext isMainFrame:(BOOL)isMainFrame;
- (void)webView:(UIWebView *)webview didReceiveNewTitle:(NSString *)newTitle isMainFrame:(BOOL)isMainFrame;

@end

NS_ASSUME_NONNULL_END

