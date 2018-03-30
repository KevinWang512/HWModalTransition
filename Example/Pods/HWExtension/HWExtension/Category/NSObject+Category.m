//
//  NSObject+Category.m
//  HWExtension
//
//  Created by houwen.wang on 2016/11/8.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import "NSObject+Category.h"

static NSMutableSet *swizzledClasses() {
    static dispatch_once_t onceToken;
    static NSMutableSet *swizzledClasses = nil;
    dispatch_once(&onceToken, ^{
        swizzledClasses = [[NSMutableSet alloc] init];
    });
    
    return swizzledClasses;
}

static void swizzleDeallocIfNeeded(Class classToSwizzle) {
    @synchronized (swizzledClasses()) {
        NSString *className = NSStringFromClass(classToSwizzle);
        if ([swizzledClasses() containsObject:className]) return;
        
        SEL deallocSelector = sel_registerName("dealloc");
        __block void (*originalDealloc)(__unsafe_unretained id, SEL) = NULL;
        
        id newDealloc = ^(__unsafe_unretained NSObject *self) {
            
            if (self.willDeallocBlock) {
                self.willDeallocBlock(self);
            }
            
            if (originalDealloc == NULL) {
                struct objc_super superInfo = {
                    .receiver = self,
                    .super_class = class_getSuperclass(classToSwizzle)
                };
                
                void (*msgSend)(struct objc_super *, SEL) = (__typeof__(msgSend))objc_msgSendSuper;
                msgSend(&superInfo, deallocSelector);
            } else {
                originalDealloc(self, deallocSelector);
            }
        };
        
        IMP newDeallocIMP = imp_implementationWithBlock(newDealloc);
        
        if (!class_addMethod(classToSwizzle, deallocSelector, newDeallocIMP, "v@:")) {
            Method deallocMethod = class_getInstanceMethod(classToSwizzle, deallocSelector);
            originalDealloc = (__typeof__(originalDealloc))method_getImplementation(deallocMethod);
            originalDealloc = (__typeof__(originalDealloc))method_setImplementation(deallocMethod, newDeallocIMP);
        }
        
        [swizzledClasses() addObject:className];
    }
}

NS_INLINE HWPropertyDataType propertyType(const char *cType) {
    static NSDictionary <NSString *, NSNumber *>*propertyTypeMap;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        propertyTypeMap = @{@"" : @(HWPropertyDataTypeUnknown),
                            @"B" : @(HWPropertyDataTypeBool),
                            @"c" : @(HWPropertyDataTypeChar),
                            @"C" : @(HWPropertyDataTypeUChar),
                            @"*" : @(HWPropertyDataTypeCharPointer),
                            @"s" : @(HWPropertyDataTypeShort),
                            @"S" : @(HWPropertyDataTypeUShort),
                            @"i" : @(HWPropertyDataTypeInt),
                            @"I" : @(HWPropertyDataTypeUInt),
                            @"f" : @(HWPropertyDataTypeFloat),
                            @"d" : @(HWPropertyDataTypeDouble),
                            @"l" : @(HWPropertyDataTypeLong),
                            @"L" : @(HWPropertyDataTypeULong),
                            @"q" : @(HWPropertyDataTypeLongLong),
                            @"Q" : @(HWPropertyDataTypeULongLong),
                            @"v" : @(HWPropertyDataTypeVoid),
                            @"@" : @(HWPropertyDataTypeId),
                            @"\"" : @(HWPropertyDataTypeObject),
                            @"#" : @(HWPropertyDataTypeClass),
                            @":" : @(HWPropertyDataTypeSEL),
                            @"?" : @(HWPropertyDataTypeIMP),
                            @"}" : @(HWPropertyDataTypeStruct),
                            };
    });
    
    HWPropertyDataType pType = HWPropertyDataTypeUnknown;
    NSString *type = [NSString stringWithUTF8String:cType];
    
    if (type.length) {
        
        NSString *lastKey = [type substringFromIndex:type.length - 1];
        
        if ([propertyTypeMap.allKeys containsObject:lastKey]) {
            pType = propertyTypeMap[lastKey].integerValue;
        }
        
        if (pType == HWPropertyDataTypeVoid && [type hasPrefix:@"^"]) {
            pType = HWPropertyDataTypeVoidPointer;
        } else if (pType == HWPropertyDataTypeStruct && [type hasPrefix:@"^"]) {
            pType = HWPropertyDataTypeStructPointer;
        }
    }
    
    return pType;
}

@implementation NSObject (Category)

- (id)valueForUndefinedKey:(NSString *)key {
    NSLog(@"\n \"%@\" class hasn't \"%@\" key!!!\n",self.class,key);
    return [NSNull null];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"\n \"%@\" class hasn't \"%@\" key!!!\n",self.class,key);
}

- (void)setNilValueForKey:(NSString *)key {
}

// 递归遍历superclass
+ (void)recursionSuperclass:(Class)cls usingBlock:(void(NS_NOESCAPE ^)(Class cls , BOOL *stop))block {
    
    if (block) {
        BOOL stop = NO;
        Class cls_t = cls;
        do {
            block(cls_t, &stop);
            if (stop) break;
            cls_t = class_getSuperclass(cls_t);
        } while (cls_t);
    }
}

- (void (^)(__unsafe_unretained id))willDeallocBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setWillDeallocBlock:(void (^)(__unsafe_unretained id))willDeallocBlock {
    if (self.willDeallocBlock != willDeallocBlock) {
        
        swizzleDeallocIfNeeded(self.class);
        
        objc_setAssociatedObject(self, @selector(willDeallocBlock), willDeallocBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

- (id)performSelector:(SEL)aSelector withObjects:(id)object,... {
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:aSelector];
    if (signature == nil) {
        NSLog(@"找不到 %@ 方法",NSStringFromSelector(aSelector));
        return nil;
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = aSelector;
    
    va_list params;
    va_start(params, object);
    
    NSInteger paramsCount = signature.numberOfArguments - 2;
    
    for (int i=0; i<paramsCount; i++) {
        id arg;
        if (i==0) {
            arg = object;
            [invocation setArgument:&arg atIndex:2];
        } else {
            arg = va_arg(params, id);
            [invocation setArgument:&arg atIndex:i + 2];
        }
    }
    
    va_end(params);
    [invocation invoke];
    
    id returnValue = nil;
    if (![[NSString stringWithUTF8String:signature.methodReturnType] isEqual: @"v"]) {
        [invocation getReturnValue:&returnValue];
    }
    return returnValue;
}

@end

@class HWKeyValueObserver;

typedef void(^KeyValueChangedHandlerBlock)(HWKeyValueObserver *observer, NSString *keyPath ,id object, NSDictionary<NSKeyValueChangeKey,id> *change, void *context);

@interface HWKeyValueObserver : NSObject

@property (nonatomic, weak) id obj;                                           //
@property (nonatomic, strong) NSMutableSet <NSString *>*observerPaths;        //
@property (nonatomic, copy) KeyValueChangedHandlerBlock changedHandlerBlock;  //

@end

@implementation HWKeyValueObserver

+ (instancetype)keyValueObserverWithChangedHandler:(KeyValueChangedHandlerBlock)handler {
    HWKeyValueObserver *observer = [[[HWKeyValueObserver class] alloc] init];
    observer.changedHandlerBlock = handler;
    return observer;
}

- (void)observeValueForObject:(id)obj
                   forKeyPath:(NSString *)keyPath
                      options:(NSKeyValueObservingOptions)options
                      context:(nullable NSString *)context {
    
    if (obj && keyPath && keyPath.length) {
        NSString *path = [NSString stringWithFormat:@"%@:%@", keyPath, context];
        if (![self.observerPaths containsObject:path]) {
            self.obj = obj;
            [self.observerPaths addObject:[NSString stringWithFormat:@"%@:%@", keyPath, context]];
            [obj addObserver:self forKeyPath:keyPath options:options context:(__bridge void * _Nullable)(context)];
        }
    }
}

- (void)removeObserveValueForKeyPath:(NSString *)keyPath
                             context:(nullable NSString *)context {
    
    NSString *path = [NSString stringWithFormat:@"%@:%@", keyPath, context];
    if ([self.observerPaths containsObject:path]) {
        [self.observerPaths removeObject:path];
        [self.obj removeObserver:self forKeyPath:keyPath context:(__bridge void * _Nullable)(context)];
    }
}

- (NSMutableSet<NSString *> *)observerPaths {
    if (_observerPaths == nil) {
        _observerPaths = [NSMutableSet set];
    }
    return _observerPaths;
}

#pragma mark - KVO callback

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (self.changedHandlerBlock) {
        self.changedHandlerBlock(self, keyPath, object, change, context);
    }
}

- (void)dealloc {
    for (NSString *path in self.observerPaths) {
        NSArray <NSString *>*path_t = [path componentsSeparatedByString:@":"];
        [self.obj removeObserver:self forKeyPath:path_t[0] context:(__bridge void * _Nullable)(path_t[1])];
    }
}

@end

const void * _Nonnull HWKeyValueObserversKey = &HWKeyValueObserversKey;

@implementation NSObject (NSKeyValueObserverRegistrationBlock)

- (void)observeValueForKeyPath:(NSString *)keyPath
                       options:(NSKeyValueObservingOptions)options
                       context:(nullable NSString *)context
                   changeBlock:(nonnull KeyValueObserverChangedBlock)block {
    
    @synchronized (self) {
        
        if (keyPath && keyPath.length && block) {
            
            NSMutableDictionary <KeyValueObserverChangedBlock, HWKeyValueObserver *>*observers = objc_getAssociatedObject(self, HWKeyValueObserversKey);
            
            if (observers == nil) {
                observers = [NSMutableDictionary dictionary];
                objc_setAssociatedObject(self, HWKeyValueObserversKey, observers, OBJC_ASSOCIATION_RETAIN);
            }
            
            HWKeyValueObserver *observer = observers[(id)block];
            if (observer == nil) {
                
                observer = [HWKeyValueObserver keyValueObserverWithChangedHandler:^(HWKeyValueObserver *observer_t, NSString *keyPath, id object, NSDictionary<NSKeyValueChangeKey,id> *change, void *context) {
                    
                    NSDictionary <KeyValueObserverChangedBlock, HWKeyValueObserver *>*observers_t = objc_getAssociatedObject(object, HWKeyValueObserversKey);
                    
                    [observers_t enumerateKeysAndObjectsUsingBlock:^(KeyValueObserverChangedBlock _Nonnull key, HWKeyValueObserver * _Nonnull obj, BOOL * _Nonnull stop) {
                        
                        if ([obj isEqual:observer_t]) {
                            key(keyPath, object, change, context);
                            *stop = YES;
                        }
                    }];
                }];
                observers[(id)block] = observer;
            }
            [observer observeValueForObject:self forKeyPath:keyPath options:options context:context];
        }
    }
}

- (void)observeValueForKeyPaths:(NSArray <NSString *>*)keyPaths
                        options:(NSKeyValueObservingOptions)options
                        context:(nullable NSString *)context
                    changeBlock:(nonnull KeyValueObserverChangedBlock)block {
    
    if (block) {
        for (NSString *keyPath in keyPaths) {
            [self observeValueForKeyPath:keyPath options:options context:context changeBlock:block];
        }
    }
}

// block移除监听, 如果block == nil, 所有相同keyPath & 相同context的block将移除监听
- (void)removeObserveValueForBlock:(nullable KeyValueObserverChangedBlock)block
                           keyPath:(NSString *)keyPath
                           context:(nullable NSString *)context {
    
    @synchronized (self) {
        
        NSMutableDictionary <KeyValueObserverChangedBlock, HWKeyValueObserver *>*observers = objc_getAssociatedObject(self, HWKeyValueObserversKey);
        
        if (observers && observers.count) {
            if (block) {
                HWKeyValueObserver *observer = observers[(id)block];
                if (observer) {
                    [observer removeObserveValueForKeyPath:keyPath context:context];
                }
            } else {
                [observers enumerateKeysAndObjectsUsingBlock:^(KeyValueObserverChangedBlock _Nonnull key, HWKeyValueObserver * _Nonnull obj, BOOL * _Nonnull stop) {
                    [obj removeObserveValueForKeyPath:keyPath context:context];
                }];
            }
            
            // remove none keyPath & context observer
            
            __block NSMutableArray <KeyValueObserverChangedBlock>*shouldRemovedObservers = [NSMutableArray array];
            [observers enumerateKeysAndObjectsUsingBlock:^(KeyValueObserverChangedBlock _Nonnull key, HWKeyValueObserver * _Nonnull obj, BOOL * _Nonnull stop) {
                if (obj.observerPaths.count == 0) {
                    [shouldRemovedObservers addObject:key];
                }
            }];
            [observers removeObjectsForKeys:shouldRemovedObservers];
        }
    }
}

@end

@implementation NSObject (KeyValues)

- (NSDictionary<NSString *,id> *)keyValueDictionary {
    __block NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    __weak typeof(self) ws = self;
    [[self class] recursionSuperclass:[self class] usingBlock:^(__unsafe_unretained Class cls, BOOL *stop) {
        if (cls != [NSObject class]) {
            [[cls propertyList] enumerateObjectsUsingBlock:^(HWPropertyInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                __strong typeof(ws) ss = ws;
                id value = [ss valueForKey:obj.name];
                if (value) {
                    dic[obj.name] = value;
                }
            }];
        }
    }];
    return [dic copy];
}

@end

@implementation NSObject (ExchangeMethod)

+ (void)exchangeImplementations:(SEL)selfSEL1 otherMethod:(SEL)selfSEL2 isInstance:(BOOL)isInstance {
    if (!sel_isEqual(selfSEL1, selfSEL2)) {
        Method method1, method2;
        if (isInstance) {
            method1 = class_getInstanceMethod(self, selfSEL1);
            method2 = class_getInstanceMethod(self, selfSEL2);
        } else {
            method1 = class_getClassMethod(self, selfSEL1);
            method2 = class_getClassMethod(self, selfSEL2);
        }
        [self exchangeImplementations:method1 otherMethod:method2];
    }
}

+ (void)exchangeImplementations:(Method)method otherMethod:(Method)otherMethod {
    method_exchangeImplementations(method, otherMethod);
}

@end

@implementation NSObject (ClassInfo)

#pragma mark - class

+ (NSArray <HWClassInfo *>*)registeredClassList {
    unsigned int count = 0;
    Class *list = objc_copyClassList(&count);
    NSMutableArray <HWClassInfo *>*infos = [NSMutableArray array];
    for (int i=0; i<count; i++) {
        Class s = list[i];
        [infos addObject:[self classInfoWithClass:s]];
    }
    free(list);
    return [infos copy];
}

+ (NSArray <NSString *>*)registeredClassNameList {
    __block NSMutableArray <NSString *>*list = [NSMutableArray array];
    [[self registeredClassList] enumerateObjectsUsingBlock:^(HWClassInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [list addObject:obj.name];
    }];
    return [list copy];
}

#pragma mark - protocol

+ (NSArray <HWProtocolInfo *>*)protocolList {
    unsigned int count = 0;
    Protocol * __unsafe_unretained _Nonnull * _Nullable list = class_copyProtocolList(self, &count);
    NSMutableArray <HWProtocolInfo *>*result = [NSMutableArray array];
    for (int i=0; i<count; i++) {
        Protocol *p = list[i];
        [result addObject:[self protocolInfoWithProtocol:p]];
    }
    free(list);
    return [result copy];
}

+ (NSArray <HWProtocolInfo *>*)allProtocolListEndOfClass:(Class)endOfClass {
    __block NSMutableArray <HWProtocolInfo *>*result = [NSMutableArray array];
    [self recursionSuperclass:self usingBlock:^(__unsafe_unretained Class cls, BOOL *stop) {
        if (![cls isEqual:endOfClass]) {
            [result addObjectsFromArray:[cls protocolList]];
        } else {
            *stop = YES;
        }
    }];
    return [result copy];
}

+ (NSArray <NSString *>*)protocolNameList {
    __block NSMutableArray <NSString *>*list = [NSMutableArray array];
    [[self protocolList] enumerateObjectsUsingBlock:^(HWProtocolInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [list addObject:obj.name];
    }];
    return [list copy];
}

+ (NSArray <NSString *>*)allProtocolNameListEndOfClass:(Class)endOfClass {
    __block NSMutableArray <NSString *>*result = [NSMutableArray array];
    [self recursionSuperclass:self usingBlock:^(__unsafe_unretained Class cls, BOOL *stop) {
        if (![cls isEqual:endOfClass]) {
            [result addObjectsFromArray:[cls protocolNameList]];
        } else {
            *stop = YES;
        }
    }];
    return [result copy];
}

#pragma mark - property

+ (NSArray <HWPropertyInfo *>*)propertyList {
    unsigned int count = 0;
    objc_property_t *list = class_copyPropertyList(self, &count);
    NSMutableArray <HWPropertyInfo *>*result = [NSMutableArray array];
    for (int i=0; i<count; i++) {
        objc_property_t p = list[i];
        [result addObject:[self propertyInfoWithProperty:p]];
    }
    free(list);
    return [result copy];
}

+ (NSArray <HWPropertyInfo *>*)allPropertyListEndOfClass:(Class)endOfClass {
    __block NSMutableArray <HWPropertyInfo *>*result = [NSMutableArray array];
    [self recursionSuperclass:self usingBlock:^(__unsafe_unretained Class cls, BOOL *stop) {
        if (![cls isEqual:endOfClass]) {
            [result addObjectsFromArray:[cls propertyList]];
        } else {
            *stop = YES;
        }
    }];
    return [result copy];
}

+ (NSArray <NSString *>*)propertyNameList {
    __block NSMutableArray <NSString *>*list = [NSMutableArray array];
    [[self propertyList] enumerateObjectsUsingBlock:^(HWPropertyInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [list addObject:obj.name];
    }];
    return [list copy];
}

+ (NSArray <NSString *>*)allPropertyNameListEndOfClass:(Class)endOfClass {
    __block NSMutableArray <NSString *>*result = [NSMutableArray array];
    [self recursionSuperclass:self usingBlock:^(__unsafe_unretained Class cls, BOOL *stop) {
        if (![cls isEqual:endOfClass]) {
            [result addObjectsFromArray:[cls propertyNameList]];
        } else {
            *stop = YES;
        }
    }];
    return [result copy];
}

#pragma mark - ivar

+ (NSArray <HWIvarInfo *>*)ivarList {
    unsigned int count = 0;
    Ivar *list = class_copyIvarList(self, &count);
    NSMutableArray <HWIvarInfo *>*result = [NSMutableArray array];
    for (int i=0; i<count; i++) {
        Ivar v = list[i];
        [result addObject:[self ivarInfoWithIvar:v]];
    }
    free(list);
    return [result copy];
}

+ (NSArray <HWIvarInfo *>*)allIvarListEndOfClass:(Class)endOfClass {
    __block NSMutableArray <HWIvarInfo *>*result = [NSMutableArray array];
    [self recursionSuperclass:self usingBlock:^(__unsafe_unretained Class cls, BOOL *stop) {
        if (![cls isEqual:endOfClass]) {
            [result addObjectsFromArray:[cls ivarList]];
        } else {
            *stop = YES;
        }
    }];
    return [result copy];
}

+ (NSArray <NSString *>*)ivarNameList {
    __block NSMutableArray <NSString *>*list = [NSMutableArray array];
    [[self ivarList] enumerateObjectsUsingBlock:^(HWIvarInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [list addObject:obj.name];
    }];
    return [list copy];
}

+ (NSArray <NSString *>*)allIvarListNameEndOfClass:(Class)endOfClass {
    __block NSMutableArray <NSString *>*result = [NSMutableArray array];
    [self recursionSuperclass:self usingBlock:^(__unsafe_unretained Class cls, BOOL *stop) {
        if (![cls isEqual:endOfClass]) {
            [result addObjectsFromArray:[cls ivarNameList]];
        } else {
            *stop = YES;
        }
    }];
    return [result copy];
}

#pragma mark - method

+ (NSArray <HWMethodInfo *>*)instanceMethodList {
    return [self methodList:self];
}

+ (NSArray <HWMethodInfo *>*)allInstanceMethodListEndOfClass:(Class)endOfClass {
    __block NSMutableArray <HWMethodInfo *>*result = [NSMutableArray array];
    [self recursionSuperclass:self usingBlock:^(__unsafe_unretained Class cls, BOOL *stop) {
        if (![cls isEqual:endOfClass]) {
            [result addObjectsFromArray:[cls instanceMethodList]];
        } else {
            *stop = YES;
        }
    }];
    return [result copy];
}

+ (NSArray <NSString *>*)instanceMethodNameList {
    return [self methodNameList:[self instanceMethodList]];
}

+ (NSArray <NSString *>*)allInstanceMethodNameListEndOfClass:(Class)endOfClass {
    __block NSMutableArray <NSString *>*result = [NSMutableArray array];
    [self recursionSuperclass:self usingBlock:^(__unsafe_unretained Class cls, BOOL *stop) {
        if (![cls isEqual:endOfClass]) {
            [result addObjectsFromArray:[cls instanceMethodNameList]];
        } else {
            *stop = YES;
        }
    }];
    return [result copy];
}

+ (NSArray <HWMethodInfo *>*)classMethodList {
    return [self methodList:object_getClass(self)];
}

+ (NSArray <HWMethodInfo *>*)allClassMethodListEndOfClass:(Class)endOfClass {
    __block NSMutableArray <HWMethodInfo *>*result = [NSMutableArray array];
    [self recursionSuperclass:self usingBlock:^(__unsafe_unretained Class cls, BOOL *stop) {
        if (![cls isEqual:endOfClass]) {
            [result addObjectsFromArray:[cls classMethodList]];
        } else {
            *stop = YES;
        }
    }];
    return [result copy];
}

+ (NSArray <NSString *>*)classMethodNameList {
    return [self methodNameList:[self classMethodList]];
}

+ (NSArray <NSString *>*)allClassMethodNameListEndOfClass:(Class)endOfClass {
    __block NSMutableArray <NSString *>*result = [NSMutableArray array];
    [self recursionSuperclass:self usingBlock:^(__unsafe_unretained Class cls, BOOL *stop) {
        if (![cls isEqual:endOfClass]) {
            [result addObjectsFromArray:[cls classMethodNameList]];
        } else {
            *stop = YES;
        }
    }];
    return [result copy];
}

#pragma mark -

+ (NSArray <HWMethodInfo *>*)methodList:(Class)cls {
    unsigned int count = 0;
    Method *list = class_copyMethodList(cls, &count);
    NSMutableArray <HWMethodInfo *>*result = [NSMutableArray array];
    for (int i=0; i<count; i++) {
        Method m = list[i];
        [result addObject:[self methodInfoWithMethod:m]];
    }
    free(list);
    return [result copy];
}

+ (NSArray <NSString *>*)methodNameList:(NSArray <HWMethodInfo *>*)methodList {
    __block NSMutableArray <NSString *>*list = [NSMutableArray array];
    [methodList enumerateObjectsUsingBlock:^(HWMethodInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [list addObject:obj.name];
    }];
    return [list copy];
}

#pragma mark - private methods

+ (HWClassInfo *)classInfoWithClass:(Class)cls {
    if (cls != NULL) {
        HWClassInfo *classInfo  = [[HWClassInfo alloc] init];
        
        classInfo.name          = [NSString stringWithUTF8String:class_getName(cls)];
        classInfo.isMetaClass   = class_isMetaClass(cls);
        classInfo.superCls      = class_getSuperclass(cls);
        classInfo.version       = class_getVersion(cls);
        classInfo.instanceSize  = class_getInstanceSize(cls);
        
        classInfo.ivarList      = [cls ivarList];
        classInfo.propertyList  = [cls propertyList];
        classInfo.protocolList  = [cls protocolList];
        
        classInfo.classMethodList    = [cls classMethodList];
        classInfo.instanceMethodList = [cls instanceMethodList];
        
        return classInfo;
    }
    return nil;
}

+ (HWProtocolInfo *)protocolInfoWithProtocol:(Protocol *)protocol {
    if (protocol != NULL) {
        HWProtocolInfo *info = [[HWProtocolInfo alloc] init];
        info.name = [NSString stringWithUTF8String:protocol_getName(protocol)];
        return info;
    }
    return nil;
}

+ (HWPropertyAttributeInfo *)propertyAttributeInfoWithPropertyAttribute:(objc_property_attribute_t)att {
    HWPropertyAttributeInfo *info = [[HWPropertyAttributeInfo alloc] init];
    info.name = [NSString stringWithUTF8String:att.name];
    info.value = [NSString stringWithUTF8String:att.value];
    return info;
}

+ (HWPropertyInfo *)propertyInfoWithProperty:(objc_property_t)property {
    if (property != NULL) {
        
        __block HWPropertyInfo *info = [[HWPropertyInfo alloc] init];
        info.dataType                = HWPropertyDataTypeUnknown;
        info.refType                 = HWPropertyRefTypeAssign;
        
        /* name */
        info.name = [NSString stringWithUTF8String:property_getName(property)];
        info.getterMethod = [info.name copy];
        info.setterMethod = [info.name copy];
        
        info.attributes = [NSString stringWithUTF8String:property_getAttributes(property)];
        
        unsigned int count;
        objc_property_attribute_t *attList = property_copyAttributeList(property, &count);
        NSMutableArray *attInfoList = [NSMutableArray array];
        for (int i=0; i<count; i++) {
            objc_property_attribute_t att = attList[i];
            [attInfoList addObject:[self propertyAttributeInfoWithPropertyAttribute:att]];
        }
        info.attributeList = [attInfoList copy];
        
        [info.attributeList enumerateObjectsUsingBlock:^(HWPropertyAttributeInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            /* type */
            if ([obj.name isEqualToString:@"T"]) {
                
                info.dataType = propertyType(obj.value.UTF8String);
                
                if (info.dataType == HWPropertyDataTypeObject) {
                    info.cls = NSClassFromString([[obj.value substringToIndex:obj.value.length - 1] substringFromIndex:2]);
                } else if (info.dataType != HWPropertyDataTypeClass &&
                           info.dataType != HWPropertyDataTypeSEL &&
                           info.dataType != HWPropertyDataTypeIMP ) {
                    info.isBasicPointer = ([obj.value hasPrefix:@"^"] || [obj.value hasPrefix:@"*"]);
                }
            }
            /* refType */
            else if ([obj.name isEqualToString:@"&"]) {
                info.refType = HWPropertyRefTypeStrong;
            } else if ([obj.name isEqualToString:@"C"]) {
                info.refType = HWPropertyRefTypeCopy;
            } else if ([obj.name isEqualToString:@"W"]) {
                info.refType = HWPropertyRefTypeWeak;
            }
            /* other */
            else if ([obj.name isEqualToString:@"R"]) {
                info.readonly = YES;
            } else if ([obj.name isEqualToString:@"N"]) {
                info.isNonatomic = YES;
            } else if ([obj.name isEqualToString:@"V"]) {
                info.ivarName = obj.value;
            } else if ([obj.name isEqualToString:@"G"]) {
                info.getterMethod = obj.value;
            } else if ([obj.name isEqualToString:@"S"]) {
                info.setterMethod = obj.value;
            }
        }];
        
        return info;
    }
    return nil;
}

+ (HWMethodInfo *)methodInfoWithMethod:(Method)method {
    if (method != NULL) {
        HWMethodInfo *info = [[HWMethodInfo alloc] init];
        info.name = NSStringFromSelector(method_getName(method));
        info.returnType = [NSString stringWithUTF8String:method_copyReturnType(method)];
        info.numberOfArguments = method_getNumberOfArguments(method);
        info.typeEncoding = [NSString stringWithUTF8String:method_getTypeEncoding(method)];
        info.implementation = method_getImplementation(method);
        
        NSMutableArray *types = [NSMutableArray array];
        for (int i=0; i<info.numberOfArguments; i++) {
            NSString *type = [NSString stringWithUTF8String:method_copyArgumentType(method, i)];
            [types addObject:type];
        }
        info.argumentTypes = types;
        return info;
    }
    return nil;
}

+ (HWIvarInfo *)ivarInfoWithIvar:(Ivar)ivar {
    if (ivar != NULL) {
        HWIvarInfo *info = [[HWIvarInfo alloc] init];
        info.name = [NSString stringWithUTF8String:ivar_getName(ivar)];
        info.typeEncoding = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        return info;
    }
    return nil;
}

@end

@implementation HWClassInfo

- (NSString *)description {
    return self.keyValueDictionary.description;
}

@end

@implementation HWProtocolInfo

- (NSString *)description {
    return self.keyValueDictionary.description;
}

@end

@implementation HWPropertyAttributeInfo

- (NSString *)description {
    return self.keyValueDictionary.description;
}

@end

@implementation HWPropertyInfo

- (NSString *)description {
    return self.keyValueDictionary.description;
}

@end

@implementation HWIvarInfo

- (NSString *)description {
    return self.keyValueDictionary.description;
}

@end

@implementation HWMethodInfo

- (NSString *)description {
    return self.keyValueDictionary.description;
}

@end
